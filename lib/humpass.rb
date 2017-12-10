require "humpass/version"

module Humpass
  require "humpass/configuration"
  require "humpass/encrypter"
  require "humpass/password_generator"
  require "humpass/lock_word"
  require "humpass/database"
  require "humpass/data_structure"

  def self.generate_password(place)
    password = Humpass::PasswordGenerator.generate_password
    Humpass.data_structure.add_password(place, password)
    password
  end

  def self.get_password(place)
    Humpass.data_structure.get_password(place)
  end
end