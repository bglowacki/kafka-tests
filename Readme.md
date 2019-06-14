## Set up the infrastructure if needed

```docker-compose -f docker-compose-infra.yaml up```

This will run Kafka, Kinesis, SNS and SQS. 
- It will also create `my-topic` topic in Kafka 

Wait few seconds for the setup to complete.

When you see 
```
kafka_setupper_1  | ["my-topic"]
kafka-tests_kafka_setupper_1 exited with code 0
```
it means that the setup has finished. You  can now run consumers.

## Running kafka consumers

Open new terminal window and run:

```
docker-compose -f docker-compose-tester.yaml up --scale publisher=0 --scale kafka_consumer=3
```

This will run 3 consumers. You need to wait for a while to let Kafka rebalance consumer assignments.
If you start publishing before rebalancing is finished one of the consumers might start working on the messages and handle all workload.

Kafka consumer has also logger that will output some statistics every 15 seconds.
It is in the form of a table:
```
kafka_consumer_2  | "---------------- NUMBER OF USERS ----------------"
kafka_consumer_2  | 36
kafka_consumer_2  | "-------------------------------------------------"
kafka_consumer_2  | +---------+--------------+--------------+
kafka_consumer_2  | | User ID | All in order | All received |
kafka_consumer_2  | +---------+--------------+--------------+
kafka_consumer_2  | | 51      | true         | true         |
kafka_consumer_2  | | 85      | true         | true         |
kafka_consumer_2  | | 98      | true         | true         |
kafka_consumer_2  | | 31      | true         | true         |
kafka_consumer_2  | | 92      | true         | true         |
kafka_consumer_2  | | 1       | true         | false        |
kafka_consumer_2  | | 78      | true         | false        |
kafka_consumer_2  | | 64      | true         | false        |
kafka_consumer_2  | | 19      | true         | true         |
kafka_consumer_2  | | 47      | true         | true         |
kafka_consumer_2  | | 90      | true         | true         |
kafka_consumer_2  | | 38      | true         | true         |
kafka_consumer_2  | | 91      | true         | true         |
kafka_consumer_2  | | 86      | true         | true         |
```

`kafka_consumer_2` is an exemplary consumer identifier.

The stats that are reoprted:
- How many users are handled by the consumer
- are all orders in order per user
- are all events received

You can check how it is calculated in `lib/report_stats.rb`

## Running publisher

This will generate a number of events and push them to Kafka's `my-topic` topic.
You can set how many `runs`, `events` and `users` to generate.
This is all adjustable in `.env` file. 

You can define producers to other messaging platforms and add them to the list of producers in `bin/producer_tester_runner`

This has hooked up Benchmarking and will report some stats after each run.
 
## To remove all

`docker-compose  -f docker-compose-tester.yaml down -v --remove-orphans` 
