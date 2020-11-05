class Memo

  MEMO_DIR = './memos'

  def self.index
    Dir.glob("#{MEMO_DIR}/*").map { |file| JSON.parse(File.read(file), symbolize_names: true) }
  end

  def self.create

  end

  def show

  end

  def update

  end

  def destroy

  end
end
