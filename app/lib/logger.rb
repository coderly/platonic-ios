class Logger
  attr_accessor :nslog, :level

  DEFAULT_NSLOG = lambda { |*args| NSLog(*args) }

  def self.shared
    @shared ||= new
  end

  def self.empty
    @none ||= Logger::Empty.new
  end

  def initialize(level = :none)
    self.nslog = DEFAULT_NSLOG
    self.level = level
  end

  def info(v, level = :normal)
    nslog.call(v) if enabled?
  end

  def enabled?
    level == :verbose
  end

  class Empty
    def info(*args) end
  end

end