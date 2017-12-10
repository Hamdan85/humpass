require 'openssl'

class String
  def encrypt(key)
    cipher = OpenSSL::Cipher::AES.new(128, :CBC).encrypt
    cipher.key = Digest::SHA2.hexdigest(key)[0..15]
    s = cipher.update(self) + cipher.final

    s.unpack('H*')[0].upcase
  end

  def decrypt(key)
    cipher = OpenSSL::Cipher::AES.new(128, :CBC).decrypt
    cipher.key = Digest::SHA2.hexdigest(key)[0..15]
    s = [self].pack("H*").unpack("C*").pack("c*")

    cipher.update(s) + cipher.final
  end
end