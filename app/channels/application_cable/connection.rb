module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :id

    def connect
      self.id = GameState.instance.next_id
      Rails.logger.info "WebSocket connected: #{id}"
    end
  end
end
