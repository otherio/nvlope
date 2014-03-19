require 'mail'

class Nvlope::Message < Nvlope::Model

  autoload :Header, 'nvlope/message/header'

  keys %w{
    id
    created
    labels
    files
    header
    text
    html
    abstract
    references
    sender
    recipients
    subject
  }

  def created_at
    @created_at ||= Time.at(created)
  end

  def header
    @header ||= Nvlope::Message::Header.new(nvlope, raw['header'])
  end

  def sender
    @sender ||= Nvlope::EmailAddress.new(raw['sender']['name'], raw['sender']['address'])
  end

  def recipients
    @recipients ||= Array(raw['recipients']).map do |recipient|
      Nvlope::EmailAddress.new(recipient['name'], recipient['address'])
    end
  end

  def files
    @files ||= Array(raw['files']).map do |raw|
      Nvlope::File.new(nvlope, raw)
    end
  end

  Nvlope::Message::Header.keys.each do |key|
    key = Nvlope::Model.key_to_method_name(key)
    define_method(key){ header.send(key) }
  end

  def mail_message
    mail_message = Mail::Message.new
    mail_message.date         = header.date
    mail_message.from         = header.from
    mail_message.reply_to     = header.reply_to
    mail_message.to           = header.to
    mail_message.message_id   = header.message_id
    mail_message.in_reply_to  = header.in_reply_to
    mail_message.references   = references
    mail_message.subject      = subject
    mail_message.mime_version = header.mime_version
    mail_message.content_type = header.content_type
    mail_message.body         = text
    html = self.html
    mail_message.html_part do
      content_type "text/html; charset=#{html.encoding.to_s}"
      body html
    end unless html.nil?
    # files.each add attachment
    mail_message
  end

end
