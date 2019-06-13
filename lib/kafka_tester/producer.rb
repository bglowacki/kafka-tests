require "json"
require "kafka"

module KafkaTester
  class Producer
    attr_reader :kafka, :events
  
    def initialize(kafka: Kafka.new(["kafka:9092"]))
      @kafka = kafka
    end
    
    def call(events: )
      events.each do |event|
        message = event.to_h.to_json
        kafka.deliver_message(message, topic: "my-topic", partition_key: "user##{event.user_id}")
      end
    end
  end
end
