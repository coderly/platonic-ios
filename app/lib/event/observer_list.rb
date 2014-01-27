module Event

  class ObserverList

    attr_reader :name

    def initialize(name)
      @name = name
      @observers = []
      @one_time_observers = []
    end

    def subscribe(observer = nil, &block)
      observer = coerce_observer(observer, &block)
      self.observers << observer unless observers.include?(observer)
      observer
    end

    def subscribe_once(observer = nil, &block)
      observer = coerce_observer(observer, &block)
      self.one_time_observers << observer unless one_time_observers.include?(observer)
      observer
    end

    def unsubscribe(observer)
      observers.delete observer
      one_time_observers.delete observer
    end

    def publish(*args)
      each_observer { |observer| observer.call *args }
      clear_one_time_observers
    end
    
    private

    attr_reader :observers, :one_time_observers

    def coerce_observer(observer, &block)
      return Proc.new(&block) if block_given?
      raise TypeError, "Event observer must respond to call. Alternatively you can provide a block." unless observer.respond_to?(:call)
      observer
    end
    
    def each_observer(&block)
      observers.each(&block)
      one_time_observers.each(&block)
    end
    
    def clear_one_time_observers
      one_time_observers.clear
    end

  end

end
