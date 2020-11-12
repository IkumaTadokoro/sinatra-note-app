# frozen_string_literal: true

require 'json'
require 'securerandom'

class Memo
  MEMO_DIR = './memos'

  def initialize(id:, title:, content:)
    @id = id
    @title = title
    @content = content
  end

  def self.index
    Dir.glob("#{MEMO_DIR}/*")
       .map { |file| JSON.parse(File.read(file), symbolize_names: true) }
  end

  def self.show(id:)
    JSON.parse(File.read("#{MEMO_DIR}/#{id}.json"), symbolize_names: true)
  end

  def self.create(title:, content:)
    Dir.mkdir(MEMO_DIR) unless Dir.exist?(MEMO_DIR)
    id = SecureRandom.uuid
    memo = { id: id, title: title, content: content }
    File.open("#{MEMO_DIR}/#{id}.json", 'w') { |file| file.puts(JSON.pretty_generate(memo)) }
  end

  def update
    memo = { id: @id, title: @title, content: @content }
    File.open("#{MEMO_DIR}/#{@id}.json", 'w') { |file| file.puts(JSON.pretty_generate(memo)) }
  end

  def destroy
    File.delete("#{MEMO_DIR}/#{@id}.json")
  end
end
