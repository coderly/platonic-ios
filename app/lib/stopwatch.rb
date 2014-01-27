class Stopwatch

  def start
    @time_start = Time.now
  end

  def stop
    @time_end = Time.now
  end

  def seconds_elapsed
    (time_end.to_f - time_start.to_f).round(2) if time_end
  end

  private

  attr_reader :time_start, :time_end

end
