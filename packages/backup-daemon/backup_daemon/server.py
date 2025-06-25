#!/usr/bin/env -S uv run
import logging
from pathlib import Path
from typing import Annotated
from rich.logging import RichHandler
from enum import Enum
import typer
from .request_handler import BackupDaemonRequestHandler
import logging
import socketserver
from .coordinator import BackupCoordinator

LOGGER = logging.getLogger(__name__)


class ServerState(Enum):
    Idle = "idle"
    PreHook = "pre_hook"
    BackupHook = "backup_hook"
    PostHook = "post_hook"
    Error = "error"


def main(
    socket: Annotated[Path, typer.Argument(help="socket to listen on")],
    lock: Annotated[Path, typer.Argument(help="lock file to prevent multiple jobs")],
):
    logging.basicConfig(
        level="NOTSET", format="%(message)s", datefmt="[%X]", handlers=[RichHandler()]
    )
    BackupCoordinator.init(lock)

    socket.parent.mkdir(exist_ok=True, parents=True)

    try:
        with socketserver.UnixStreamServer(
            str(socket), BackupDaemonRequestHandler
        ) as server:
            LOGGER.info("Backup daemon running, waiting for requests...")
            server.serve_forever()
    except KeyboardInterrupt:
        LOGGER.info("Daemon stopped by user")
    except Exception as e:
        LOGGER.error("Daemon error: %s", str(e))


if __name__ == "__main__":
    typer.run(main)
