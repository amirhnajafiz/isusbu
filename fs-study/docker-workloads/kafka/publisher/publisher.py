import os, time
from kafka import KafkaProducer
import json

BOOTSTRAP_SERVERS = os.environ.get("KAFKA_BOOTSTRAP_SERVERS")
TOPIC = os.environ.get("KAFKA_TOPIC", "demo")

# Wait for Kafka to become available
while True:
    try:
        producer = KafkaProducer(bootstrap_servers=BOOTSTRAP_SERVERS)
        break
    except Exception as e:
        print("Waiting for Kafka...", e)
        time.sleep(2)

print("Connection established")

count = 0
while True:
    event = {"id": count, "msg": f"Event {count}"}
    print(f"Trying to send")
    future = producer.send(TOPIC, value=json.dumps(event).encode())
    print(f"Published: {event}")
    count += 1
    time.sleep(1)  # 1 event/sec
