require "kafka_tester/setupper"
require "kafka_tester/producer"
require "benchmark"

class ProducerTester
  attr_reader :producer, :event_generator, :setupper
  
  def initialize(
      setupper: KafkaTester::Setupper.new,
      producer: KafkaTester::Producer.new
  )
    @producer = producer
    setupper.call
  end
  
  def call(run_no:, events:)
    Benchmark.bm(20) do |bm|
      bm.report("Producer run: #{run_no}") do
        producer.call(events: events)
      end
    end
  end
end
