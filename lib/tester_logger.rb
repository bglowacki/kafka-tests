require "check_event_order"

$received_events = Hash.new { |h, k| h[k] = [] }

def every( time )
  Thread.new {
    loop do
      sleep(time)
      yield
    end
  }
end

every(15) { CheckEventOrder.call($received_events.values.flatten) }
