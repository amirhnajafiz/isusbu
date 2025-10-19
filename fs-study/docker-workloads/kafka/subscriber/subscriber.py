import os, time
from kafka import KafkaConsumer

BOOTSTRAP_SERVERS = os.environ.get("KAFKA_BOOTSTRAP_SERVERS")
TOPIC = os.environ.get("KAFKA_TOPIC", "demo")

# Wait for Kafka to become available
while True:
    try:
        consumer = KafkaConsumer(
            TOPIC,
            bootstrap_servers=BOOTSTRAP_SERVERS,
            auto_offset_reset='earliest',
            group_id="demo-group",
        )
        break
    except Exception as e:
        print("Waiting for Kafka...", e)
        time.sleep(2)

print("Connection established")

for message in consumer:
    print(f"Received: {message.value.decode()}")