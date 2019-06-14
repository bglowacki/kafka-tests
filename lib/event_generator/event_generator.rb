module EventGenerator
  User = Struct.new(:id)
  Event = Struct.new(:user_id, :event_id)
  
  class EventGenerator
    attr_reader :number_of_events, :number_of_users
  
    def initialize(number_of_events: ENV["NUMBER_OF_EVENTS"].to_i || 10, number_of_users: ENV["NUMBER_OF_USERS"].to_i || 10)
      @number_of_events = number_of_events
      @number_of_users = number_of_users
    end
    
    def call
      events
    end
    
    private

    def events
      @events ||= users.map do |user|
        number_of_events.times.map do |i|
          Event.new(user.id, i)
        end
      end.shuffle.flatten
    end

    def users
      @users ||= number_of_users.times.map do |i|
        User.new(i)
      end
    end
  end
end
