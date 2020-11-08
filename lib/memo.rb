# frozen_string_literal: true

require 'json'
require 'securerandom'
require 'pg'

class Memo
  MEMO_DIR = './memos'
  @@connection = PG.connect({ host: 'localhost', user: 'sinatra', password: 'sinatra', dbname: 'sinatra' })

  attr_reader :id, :title, :content

  def initialize(id:, title:, content:)
    @id = id
    @title = title
    @content = content
  end

  def self.index
    @@connection.exec('SELECT * FROM memo ORDER BY updated_at')
                .map { |result| result.transform_keys(&:to_sym) }
                .map { |json_data| new(id: json_data[:id], title: json_data[:title], content: json_data[:content]) }
  end

  def self.show(id:)
    json_data = @@connection.exec('SELECT * FROM memo WHERE id = $1', [id]).first.transform_keys(&:to_sym)
    new(id: json_data[:id], title: json_data[:title], content: json_data[:content])
  end

  def self.create(title:, content:)
    @@connection.exec('INSERT INTO memo (title, content) VALUES ($1, $2)', [title, content])
  end

  def update(title:, content:)
    @@connection.exec('UPDATE memo SET title = $1, content = $2 WHERE id = $3', [title, content, id])
  end

  def destroy(id:)
    @@connection.exec('DELETE FROM memo WHERE id = $1', [id])
  end
end
