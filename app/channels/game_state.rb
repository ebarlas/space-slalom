class GameState
  @instance = nil

  def initialize(tps)
    @tps = tps
    @ms_per_tick = 1000.0 / tps
    @epoch_time = self.class.now
    @counter = 0
  end

  def self.now
    Process.clock_gettime(Process::CLOCK_MONOTONIC, :millisecond)
  end

  def ticks_elapsed
    (self.class.now - @epoch_time) / @ms_per_tick
  end

  def next_id
    @counter += 1
  end

  def self.instance
    @instance ||= new(30)
  end
end