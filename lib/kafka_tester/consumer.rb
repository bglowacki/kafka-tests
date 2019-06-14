$stdout.sync = true
$:.unshift File.join(File.dirname(__FILE__), "../../lib")

require "karafka"
require "received_event"
require "tester_logger"

class MyConsumer < Karafka::BaseConsumer
  def consume
    consumer_key = "Consumer##{Process.pid}:Partition##{params["partition"]}"
    $received_events[consumer_key] << ReceivedEvent.new(params["user_id"], params["event_id"])
  end
end

class App < Karafka::App
  setup do |config|
    config.kafka.seed_brokers = ["kafka://kafka:9092"]
    config.client_id = "test"
    config.logger = Logger.new(STDOUT, level: 1)
    config.kafka.fetcher_max_queue_size = 1000
  end
  
  consumer_groups.draw do
    topic :"my-topic" do
      consumer MyConsumer
      backend :inline
      start_from_beginning true
    end
  end
end

App.boot!
