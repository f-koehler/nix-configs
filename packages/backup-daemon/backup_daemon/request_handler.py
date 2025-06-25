import socketserver
import json
import logging
import datetime
import enum
from .coordinator import BackupCoordinator

LOGGER = logging.getLogger(__name__)


class RequestType(enum.Enum):
    Backup = "backup"
    Status = "status"
    Ping = "ping"


class ResponseType(enum.Enum):
    Pong = "pong"
    Error = "error"
    BackupCompleted = "backup_completed"
    BackupFailed = "backup_failed"
    Busy = "busy"


class BackupDaemonRequestHandler(socketserver.StreamRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    def handle(self):
        try:
            payload = json.loads(self.rfile.read(8192).decode("utf-8"))
            if not payload:
                return

            request = json.loads(payload)
            type_ = RequestType(request["type"].lower())
            LOGGER.info(
                "Received request: %s",
            )

            match type_:
                case RequestType.Backup:
                    self._handle_backup_request()
                case RequestType.Status:
                    self._handle_status_request()
                case RequestType.Ping:
                    self._send_response(
                        ResponseType.Pong,
                        f"server is alive ({datetime.datetime.now().isoformat()})",
                    )
        except Exception as e:
            self._send_response(ResponseType.Error, str(e))

    def _send_response(self, type: ResponseType, message: str):
        self.wfile.write(
            json.dumps(dict(status=str(ResponseType), message=message)).encode("utf-8")
        )

    def _handle_backup_request(self):
        BackupCoordinator.get().run()

    def _handle_status_request(self):
        pass
