#!/usr/bin/env python3

from http.server import HTTPServer, BaseHTTPRequestHandler
import os

form = 'Hello {}'.format(os.environ['FROM_CMapp_name'])

class SimpleWebServer(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/plain; charset=utf-8')
        self.end_headers()
        self.wfile.write(form.encode())

if __name__ == '__main__':
    server_address = ('', 8080)
    httpd = HTTPServer(server_address, SimpleWebServer)
    httpd.serve_forever()
