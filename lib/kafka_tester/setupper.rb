require "kafka"

module KafkaTester
  class Setupper
    attr_reader :kafka
  
    def initialize(kafka: Kafka.new(["kafka:9092"]))
      @kafka = kafka
    end
    
    def call
      begin
        kafka.delete_topic("my-topic")
      rescue Kafka::UnknownTopicOrPartition
      end
      sleep 5
      begin
        kafka.create_topic("my-topic", num_partitions: 10)
        sleep 5
      rescue Kafka::TopicAlreadyExists
      end

      pp kafka.topics
    end
  end
end

sleep 10
KafkaTester::Setupper.new.call
