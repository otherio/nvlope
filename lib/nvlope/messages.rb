class Nvlope::Messages

  def initialize nvlope
    @nvlope = nvlope
  end
  attr_reader :nvlope

  def query query={}
    query[:include] ||= 'all'
    raw = nvlope.authenticated_request(:get, '/messages', query: query)
    Nvlope::MessageCollection.new(nvlope, raw)
  end

  def bulk_get message_ids, query={}
    query["message_ids"] = message_ids
    raw = nvlope.authenticated_request(:post, '/messages', query: query)
    Nvlope::MessageCollection.new(nvlope, raw)
  end

  def delete message_ids, query={}
    query["message_ids"] = message_ids
    headers = {'Content-Type' => 'application/json'}
    nvlope.authenticated_request(:delete, '/messages', body: query.to_json, headers: headers)
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
