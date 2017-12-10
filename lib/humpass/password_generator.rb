require 'securerandom'
module Humpass
  module PasswordGenerator
    def self.generate_password
      SecureRandom.base64(15)
    end
  end
end
