class GameState
  attr_reader :beacon

  @instance = nil

  def initialize(tps, width, height)
    @tps = tps
    @width = width
    @height = height
    @beacon = rand_beacon
    @ms_per_tick = 1000.0 / tps
    @epoch_time = self.class.now
    @counter = 0
  end

  def rand_beacon
    [rand(0...@width), rand(0...@height)]
  end

  def next_beacon
    @beacon = rand_beacon
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
    @instance ||= new(30, 800, 600)
  end
end