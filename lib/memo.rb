# frozen_string_literal: true

require 'pg'

class Memo

  attr_reader :id, :title, :content

  def initialize(id:, title:, content:)
    @id = id
    @title = title
    @content = content
  end

  def self.exec_sql(&block)
    @@connection = PG.connect({
                                dbname: ENV['PGDATABASE'],
                                host: ENV['PG_HOST'],
                                password: ENV['PGPASSWORD'],
                                port: ENV['PG_PORT'],
                                user: ENV['PG_USER']
                              })
    result = yield block
    @@connection.close
    result
  end

  def self.index
    results = exec_sql { @@connection.exec('SELECT * FROM memo') }
    results.map { |result| new(id: result['id'], title: result['title'], content: result['content']) }
  end

  def self.show(id:)
    result = exec_sql { @@connection.exec_params('SELECT * FROM memo WHERE id = $1', [id]).first }
    new(id: result['id'], title: result['title'], content: result['content'])
  end

  def self.create(title:, content:)
    exec_sql { @@connection.exec_params('INSERT INTO memo (title, content) VALUES ($1, $2)', [title, content]) }
  end

  def update(title:, content:)
    Memo.exec_sql { @@connection.exec_params('UPDATE memo SET title = $1, content = $2 WHERE id = $3', [title, content, @id]) }
  end

  def destroy
    Memo.exec_sql { @@connection.exec_params('DELETE FROM memo WHERE id = $1', [@id]) }
  end
end
