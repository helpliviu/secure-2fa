json.extract! channel, :id, :client_id, :title, :created_at, :updated_at
json.url channel_url(channel, format: :json)
