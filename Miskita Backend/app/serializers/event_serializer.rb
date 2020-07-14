class EventSerializer < ActiveModel::Serializer
  attributes :id, :title, :access_code, :client_email, :client_name, :start_time, :end_time, :server
  def server
    object.server.try(:title)
  end
end
