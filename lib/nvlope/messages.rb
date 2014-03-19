class Nvlope::Messages

  def initialize nvlope
    @nvlope = nvlope
  end
  attr_reader :nvlope

  def query params={}, headers={}
    params[:include] ||= 'all'
    raw = nvlope.request(:get, '/messages', params, headers)
    Nvlope::MessageCollection.new(nvlope, raw)
  end

  def bulk_get message_ids, params={}, headers={}
    params["message_ids"] = message_ids
    raw = nvlope.request(:post, '/messages', params, headers)
    Nvlope::MessageCollection.new(nvlope, raw)
  end

  def delete message_ids, params={}, headers={}
    params["message_ids"] = message_ids
    nvlope.request(:delete, '/messages', params, headers)
    self
  end

  def unread

  end

  def update_labels

  end

  def get_labels
    nvlope.request(:delete, '/messages/labels')['labels']
  end

end
