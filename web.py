#!/usr/bin/env python3

from http.server import HTTPServer, BaseHTTPRequestHandler

form = '''Flama App'''

class MessageHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/plain; charset=utf-8')
        self.end_headers()
        self.wfile.write(form.encode())

if __name__ == '__main__':
    server_address = ('', 8080)
    httpd = HTTPServer(server_address, MessageHandler)
    httpd.serve_forever()
    
