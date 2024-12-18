json.extract! route, :id, :name, :start_location, :end_location, :distatnce, :created_at, :updated_at
json.url route_url(route, format: :json)
