# frozen_string_literal: true

require 'pg'

class Memo
  @@connection = PG.connect(
    {
      host: ENV['PG_HOST'],
      port: ENV['PG_PORT'],
      user: ENV['PG_USER'],
      password: ENV['PGPASSWORD'],
      dbname: ENV['PGDATABASE']
    }
  )

  attr_reader :id, :title, :content

  def initialize(id:, title:, content:)
    @id = id
    @title = title
    @content = content
  end

  def self.index
    @@connection.exec('SELECT * FROM memo')
                .map { |result| new(id: result['id'], title: result['title'], content: result['content']) }
  end

  def self.show(id:)
    result = @@connection.exec('SELECT * FROM memo WHERE id = $1', [id]).first.transform_keys(&:to_sym)
    new(id: result[:id], title: result[:title], content: result[:content])
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
