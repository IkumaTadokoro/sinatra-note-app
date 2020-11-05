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
  Memo.create(params[:title], params[:content])
  redirect '/memos'
end

get '/memos/:id' do
  @memo = Memo.show(params[:id])
  erb :show
end

get '/memos/:id/edit' do
  @memo = Memo.show(params[:id])
  erb :edit
end

patch '/memos/:id' do
  Memo.new.update(params[:id], params[:title], params[:content])
  redirect '/memos'
end

delete '/memos/:id' do
  Memo.new.destroy(params[:id])
  redirect '/memos'
end
