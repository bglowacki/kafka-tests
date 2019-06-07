require "kafka"
require "water_drop"
require "json"
require "logger"

sleep 10

Person = Struct.new(:id, :name)

people = []

10.times do |i|
  people << Person.new(i, "User #{i}")
end

kafka = Kafka.new(["kafka:9092"])
pp kafka.topics

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

partitions = kafka.partitions_for("my-topic")
pp partitions

100.times do
  person = people.sample
  message = { name: person.name }.to_json
  kafka.deliver_message(message, topic: "my-topic", partition_key: "user##{person.id}")
end
