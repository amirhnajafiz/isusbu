import requests
import time

URL = "http://backend:5000/set"
KEY_PREFIX = "foo"
LOAD_RPS = 5  # 5 requests per second

def main():
    count = 0
    while True:
        ts = int(time.time())
        key = f"{KEY_PREFIX}{count % 100}"
        resp = requests.post(URL, json={'key': key, 'value': ts})
        print(resp.json())
        count += 1
        time.sleep(1 / LOAD_RPS)

if __name__ == "__main__":
    main()