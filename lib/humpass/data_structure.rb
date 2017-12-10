module Humpass

  class << self
    attr_accessor :data_structure
  end

  def self.set_data_structure
    self.data_structure = DataStructure.new
  end

  class DataStructure
    attr_accessor :structure

    def initialize
      if database.read.empty?
        new_database_initialize
        get_structure_from_database
      else
        get_structure_from_database
      end
      Humpass.set_lock_words(self.lock_words)
    end

    def new_database_initialize
      @structure = init_structure
      update_database
    end

    def init_structure
      {
        master_password: nil,
        lock_words: nil,
        passwords: nil
      }.to_json
    end

    def current_structure
      {
        master_password: master_password,
        lock_words: lock_words,
        passwords: passwords
      }.to_json
    end

    def master_password=(master_password)
      @structure["master_password"] = Digest::SHA2.new(256).hexdigest(master_password)
      update_database
    end

    def master_password
      @structure["master_password"]
    end

    def lock_words=(lock_words)
      @structure["lock_words"] = lock_words
      update_database
    end

    def lock_words
      @structure["lock_words"]
    end

    def passwords=(passwords)
      @structure["passwords"] = passwords
      update_database
    end

    def passwords
      @structure["passwords"]
    end

    def add_password(place, password)
      if self.passwords.select { |password| password.first.eql?(place) }.empty?
        self.passwords << [place, password.encrypt(self.master_password)]
        update_database
      else
        if authorize_replacement?
          remove_place(place)
          add_password(place, password)
        else
          abort('OK!')
        end
      end
    end

    def get_password(place)
      place = self.passwords.detect { |password| password.first.eql?(place) }
      if place
        place.last.decrypt(self.master_password)
      else
        "Place Not Found!"
      end
    end

    def get_structure_from_database
      database_read = database.read
      @structure = database_read.empty? ? '' : JSON.parse(database.read)
    end

    def remove_place(place)
      self.passwords.delete_if { |password| password.first.eql?(place) }
      update_database
    end

    def update_database
      database.write(current_structure)
    end

    def database
      Humpass.database
    end

    def authorize_replacement?
      puts "This place seems to be already registered. Overwrite?[Y/n]"
      overwrite = gets.chomp
      authorize_replacement? unless %w[Y n].include?(overwrite)
      overwrite.eql?('Y') ? true : false
    end
  end
end