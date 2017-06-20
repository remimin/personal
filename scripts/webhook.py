import sys
import string
import SimpleHTTPServer
import SocketServer

addr = len(sys.argv) < 2 and "localhost" or sys.argv[1]
port = len(sys.argv) < 3 and 80 or string.atoi(sys.argv[2])

handler = SimpleHTTPServer.SimpleHTTPRequestHandler
httpd = SocketServer.TCPServer((addr, port), handler)
print "HTTP server is at: http://%s:%d/" % (addr, port)
httpd.serve_forever()
