# frozen_string_literal: true

require 'json'
require 'securerandom'

class Memo

  MEMO_DIR = './memos'

  def self.index
    Dir.glob("#{MEMO_DIR}/*").map { |file| JSON.parse(File.read(file), symbolize_names: true) }
  end

  def self.show(id)
    JSON.parse(File.read("#{MEMO_DIR}/#{id}.json"), symbolize_names: true)
  end

  def self.create(title, content)
    id = SecureRandom.uuid
    memo = { 'id' => id, 'title' => title, 'content' => content }
    File.open("#{MEMO_DIR}/#{id}.json", 'w') { |file| file.puts(JSON.pretty_generate(memo)) }
  end

  def update(id, title, content)
    memo = { 'id' => id, 'title' => title, 'content' => content }
    File.open("#{MEMO_DIR}/#{id}.json", 'w') { |file| file.puts(JSON.pretty_generate(memo)) }
  end

  def destroy

  end
end
