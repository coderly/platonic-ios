module Event

  module Observable

    def on(event_name, handler = nil, &block)
      events[event_name].subscribe(handler, &block)
    end

    def when(event_name, handler = nil, &block)
      events[event_name].subscribe_once(handler, &block)
    end

    def off(event_name, handler)
      events[event_name].unsubscribe(handler)
    end

    def trigger(event_name, *args)
      events[event_name].publish(*args)
    end

    private

    def events
      @__events ||= Hash.new do |h, k|
        h[k] = ObserverList.new(h.to_s)
      end
    end

  end

end