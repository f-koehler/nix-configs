import socketserver
import json


class BackupDaemonRequestHandler(socketserver.StreamRequestHandler):
    def handle(self):
        payload = json.loads(self.rfile.readline(8192).rstrip())
        if not payload:
            return
