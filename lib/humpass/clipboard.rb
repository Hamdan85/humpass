module Clipboard
  def self.copy this
    IO.popen 'pbcopy', 'w' do |io|
      io.print this
    end
  end

  def self.paste
    `pbpaste`
  end
end
