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
    Dir.glob("#{MEMO_DIR}/*")
       .map { |file| JSON.parse(File.read(file), symbolize_names: true) }
       .map { |json_data| new(id: json_data[:id], title: json_data[:title], content: json_data[:content]) }
  end

  def self.show(id:)
    json_data = JSON.parse(File.read("#{MEMO_DIR}/#{id}.json"), symbolize_names: true)
    new(id: json_data[:id], title: json_data[:title], content: json_data[:content])
  end

  def self.create(title:, content:)
    Dir.mkdir(MEMO_DIR) unless Dir.exist?(MEMO_DIR)
    id = SecureRandom.uuid
    memo = { id: id, title: title, content: content }
    File.open("#{MEMO_DIR}/#{id}.json", 'w') { |file| file.puts(JSON.pretty_generate(memo)) }
    new(id: id, title: title, content: content)
  end

  def update(title:, content:)
    memo = { id: @id, title: title, content: content }
    File.open("#{MEMO_DIR}/#{@id}.json", 'w') { |file| file.puts(JSON.pretty_generate(memo)) }
  end

  def destroy
    File.delete("#{MEMO_DIR}/#{@id}.json")
  end
end
