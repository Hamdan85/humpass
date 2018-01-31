require "base64"
require "json"

module Humpass

  class << self
    attr_accessor :database
  end

  def self.set_database(file_path = nil)
    self.database ||= Database.new(file_path)
  end

  class Database
    attr_accessor :file_path
    def initialize(file_path = __dir__ + '/humpass.dat')
      raise 'Configuration not sat!' if Humpass.configuration.nil?
      @file_path = file_path
    end

    def write(data)
      File.open(file_path, 'w+') { |file|
        file.write(encrypt(database_password, Base64.encode64(data)))
      }
    end

    def read
      begin
        Base64.decode64(decrypt(database_password, File.open(file_path, 'r').read))
      rescue
        ''
      end
    end

    def database_password
      Humpass.configuration.master_password = gets.chomp if Humpass.configuration.master_password.nil?
      Humpass.configuration.master_password
    end

    def encrypt(key, data)
      cipher = OpenSSL::Cipher::AES.new(128, :CBC).encrypt
      cipher.key = Digest::SHA2.hexdigest(key)[0..15]
      cipher.update(data) + cipher.final
    end

    def decrypt(key, data)
      cipher = OpenSSL::Cipher::AES.new(128, :CBC).decrypt
      cipher.key = Digest::SHA2.hexdigest(key)[0..15]
      s = data.unpack("C*").pack("c*")

      begin
        s.empty? ? "" : cipher.update(s) + cipher.final
      rescue
        abort("Wrong Master Password!")
      end
    end
  end
end