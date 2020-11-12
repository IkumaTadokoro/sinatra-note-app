# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require_relative './lib/memo'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/memos' do
  @title = 'Top'
  @memos = Memo.index
  erb :top
end

get '/memos/new' do
  @title = 'New'
  erb :new
end

post '/memos/new' do
  Memo.create(title: params[:title], content: params[:content])
  redirect '/memos'
end

get '/memos/:id' do
  @title = 'Show'
  @memo = Memo.show(id: params[:id])
  erb :show
end

get '/memos/:id/edit' do
  @title = 'Edit'
  @memo = Memo.show(id: params[:id])
  erb :edit
end

patch '/memos/:id' do
  Memo.new(id: params[:id], title: params[:title], content: params[:content]).update(id: params[:id], title: params[:title], content: params[:content])
  redirect '/memos'
end

delete '/memos/:id' do
  Memo.new(id: params[:id], title: params[:title], content: params[:content]).destroy(id: params[:id])
  redirect '/memos'
end
