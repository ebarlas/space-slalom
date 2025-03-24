require_relative "game_state"

class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from "events"
  end

  def receive(data)
    case data["type"]
    when "hello"
      transmit({ type: "hello", ticks: GameState.instance.ticks_elapsed, id: connection.id })
    when "event"
      Rails.logger.info "Received event: #{data}"
      data[:id] = connection.id
      ActionCable.server.broadcast("events", data)
    else
      Rails.logger.info "Unknown message type: #{data["type"]}"
    end
  end

  def unsubscribed

  end
end
