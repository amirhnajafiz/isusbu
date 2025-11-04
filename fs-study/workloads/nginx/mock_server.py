#!/usr/bin/env python3
from http.server import BaseHTTPRequestHandler, HTTPServer
import time



class MockHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/api/stream":
            self.send_response(200)
            self.send_header("Content-Type", "text/plain")
            self.send_header("Transfer-Encoding", "chunked")
            self.end_headers()
            # Stream 10 chunks
            for i in range(10):
                chunk = f"chunk {i}\n".encode()
                size = f"{len(chunk):X}\r\n".encode()  # chunk size in hex
                self.wfile.write(size + chunk + b"\r\n")
                self.wfile.flush()
                time.sleep(0.5)
            self.wfile.write(b"0\r\n\r\n")  # end of chunks
        else:
            self.send_response(200)
            self.end_headers()
            self.wfile.write(b"Hello from mock GET\n")

    def do_POST(self):
        length = int(self.headers.get('Content-Length', 0))
        body = self.rfile.read(length)
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"Got POST data: " + body)

if __name__ == "__main__":
    server = HTTPServer(('0.0.0.0', 8080), MockHandler)
    print("Mock server running on port 8080...")
    server.serve_forever()
