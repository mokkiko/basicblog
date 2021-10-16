#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
  @db = SQLite3::Database.new 'blog.db'
  @db.results_as_hash
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
end


get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
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
  erb "you tiped #{@content}"

end

