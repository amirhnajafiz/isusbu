# Installation

Installation commands on Ubuntu:

```bash
sudo apt update
sudo apt install apache2-utils -y
```

## Mock Server

It's a minimal Python API for accepting `GET`, `POST`, and `stream` requests.

```bash
python3 mock_server.py # starts the api on port 8080 (nginx proxies the requests to it)
```
