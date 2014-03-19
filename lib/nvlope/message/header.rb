class Nvlope::Message::Header < Nvlope::Model

  keys %w{
    content-type
    date
    dkim-signature
    domainkey-signature
    from
    reply-to
    in-reply-to
    message-id
    mime-version
    received
    sender
    subject
    to
  }

  def message_id
    raw['message-id'].first
  end

  def mime_version
    raw['mime-version'].first
  end

  def content_type
    raw['content-type'].first
  end

end
