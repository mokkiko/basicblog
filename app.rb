#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
  @db = SQLite3::Database.new 'blog.db'
  @db.results_as_hash = true
end

before do
  init_db
end

configure do
  init_db
  @db.execute 'CREATE TABLE if not exists "posts"
  (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      create_date DATE,
      content	TEXT
  )'
  @db.execute 'CREATE TABLE if not exists Comments
  (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      create_date DATE,
      comment_for_content	TEXT,
      article_id INTEGER
  )'
end


get '/' do
	erb "Hello! "
end

get '/new_post' do
  erb :new_post
end

post '/new_post' do
  @content = params[:content]

  if @content.length <=0
    @error = 'Type your text'
    return erb :new_post
  end

  @db.execute 'insert into posts (content, create_date) values (?, datetime())', [@content]
  erb "you typed #{@content}"

end

get '/posts_list' do
  @results = @db.execute 'select * FROM posts ORDER BY id DESC'
  erb :posts_list
end

get '/articles/:art_id' do
  art_id = params[:art_id]
  results = @db.execute 'select * from posts where id = ?', [art_id]
  @row = results[0]
  erb :articles
end


post '/articles/:art_id' do
  art_id = params[:art_id]
  comment_for_content = params[:comment_for_content]
  erb "you typed #{comment_for_content}"
  @db.execute 'insert into Comments
    (
      comment_for_content,
      create_date,
      article_id
    )
      values
    (
      ?,
      datetime(),
      ?
    )', [comment_for_content, art_id]
  redirect to ('/articles/' + art_id)
end

