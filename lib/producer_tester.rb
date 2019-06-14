require "kafka_tester/producer"
require "benchmark"
require "producer"

class ProducerTester
  attr_reader :producers
  
  def initialize(producers: [])
    @producers = producers
  end
  
  def call(run_no:, events:)
    Benchmark.bm(20) do |bm|
      producers.each do |producer|
        bm.report("#{producer.name} Producer run: #{run_no}") do
          producer.call(events: events)
        end
      end
    end
  end
end
