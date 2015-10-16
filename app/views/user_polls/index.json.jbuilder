json.array!(@user_polls) do |user_poll|
  json.extract! user_poll, :id, :title, :description, :create_date
  json.url user_poll_url(user_poll, format: :json)
end
