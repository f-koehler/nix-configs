#!/usr/bin/env -S uv run
import logging
from pathlib import Path
from typing import Annotated
from rich.logging import RichHandler
from enum import Enum
import typer


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


if __name__ == "__main__":
    main()
