# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require_relative './lib/memo'

get '/memos' do
  @memos = Memo.index
  erb :top
end

get '/memos/new' do
  erb :new
end

post '/memos/new' do
  Memo.create(title: params[:title], content: params[:content])
  redirect '/memos'
end

get '/memos/:id' do
  @memo = Memo.show(id: params[:id])
  erb :show
end

get '/memos/:id/edit' do
  @memo = Memo.show(id: params[:id])
  erb :edit
end

patch '/memos/:id' do
  Memo.new.update(id: params[:id], title: params[:title], content: params[:content])
  redirect '/memos'
end

delete '/memos/:id' do
  Memo.new.destroy(id: params[:id])
  redirect '/memos'
end
