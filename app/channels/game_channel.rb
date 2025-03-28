require_relative "game_state"

class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from "events"
  end

  def receive(data)
    case data["type"]
    when "hello"
      gs = GameState.instance
      x, y = gs.beacon
      transmit({
                 type: "hello",
                 ticks: gs.ticks_elapsed,
                 id: connection.id,
                 beacon: { x:, y: } })
    when "event"
      data[:id] = connection.id
      ActionCable.server.broadcast("events", data)
    when "beacon"
      x, y = GameState.instance.next_beacon
      ActionCable.server.broadcast("events", {
        type: 'beacon',
        id: connection.id,
        beacon: { x:, y: } })
    else
      Rails.logger.info "Unknown message type: #{data["type"]}"
    end
  end

  def unsubscribed

  end
end
