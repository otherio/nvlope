require 'mail'

class Nvlope::EmailAddress

  def initialize name, address
    @name, @address = name, address
  end

  def mail_address
    @mail_address ||= begin
      mail_address = Mail::Address.new
      mail_address.display_name = @name
      mail_address.address = @address
      mail_address
    end
  end
  alias_method :to_mail_address, :mail_address

  def method_missing method, *args, &block
    return super unless mail_address.respond_to?(method)
    mail_address.send(method, *args, &block)
  end

  def to_s
    mail_address.to_s
  end
  alias_method :to_str, :to_s

  def inspect
    %(#<#{self.class} #{to_s}>)
  end

end


