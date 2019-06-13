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

100.times do
  person = people.sample
  message = { name: person.name }.to_json
  kafka.deliver_message(message, topic: "my-topic", partition_key: "user##{person.id}")
end
