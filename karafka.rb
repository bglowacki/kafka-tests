require "karafka"

$gathered_info = Hash.new { |h, k| h[k] = [] }
$index = 0

class MyConsumer < Karafka::BaseConsumer
  def consume
    $gathered_info[params["partition"]] << params["name"]
    $index += 1
    if $index % 10 == 0
      pp $gathered_info
    end
  end
end

class App < Karafka::App
  setup do |config|
    config.kafka.seed_brokers = ["kafka://kafka:9092"]
    config.client_id = "test"
    config.logger = Logger.new(STDOUT)
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
