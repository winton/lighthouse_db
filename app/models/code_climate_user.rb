class CodeClimateUser < ActiveRecord::Base

  class <<self
    def password_user
      where("password IS NOT NULL").first
    end
  end

  def password=(str)
    str = AESCrypt.encrypt(str, secret)
    write_attribute(:password, str)
  end

  def decrypted_password
    str = read_attribute(:password)
    AESCrypt.decrypt(str, secret) if str
  end

  private

  def secret
    LighthouseDb::Application.config.secret_key_base
  end
end
