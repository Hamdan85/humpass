module Humpass
  class << self
    attr_accessor :configuration
  end

  def self.initial_setup(master_password = nil)
    set_database(configuration.database_path)
    set_data_structure
    self
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
    initial_setup(configuration.master_password)
  end

  # Configuration
  class Configuration
    attr_accessor :master_password, :database_path
  end
end