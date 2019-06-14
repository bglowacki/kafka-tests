require 'terminal-table'


class ReportStats
  attr_reader :events, :grouped_events
  
  def initialize(events:)
    @events = events
    @grouped_events = events.group_by(&:user_id)
                          .map { |k, v| [k, v.map(&:event_id)] }
                          .to_h
  end
  
  def self.call(events)
    checker = new(events: events)
    checker.check_number_of_users
    checker.check_events
  end
  
  def check_number_of_users
    pp "---------------- NUMBER OF USERS ----------------"
    pp grouped_events.keys.count
    pp "-------------------------------------------------"
  end
  
  def check_events
    events =  grouped_events.map do |k, v|
      [k, all_in_order?(v), all_received?(v)]
    end
    table = Terminal::Table.new rows: events, headings: ["User ID", "All in order", "All received"]
    puts table
  end
  
  private
  
  def all_in_order?(event_ids)
    number_of_runs = ENV["NUMBER_OF_RUNS"].to_i
    
    event_ids.each_slice(number_of_runs).all? do |a|
      a == a.sort
    end
  end
  
  def all_received?(event_ids)
    expected_number_of_events = ENV["NUMBER_OF_EVENTS"].to_i * ENV["NUMBER_OF_RUNS"].to_i
    event_ids.count == expected_number_of_events
  end
end
