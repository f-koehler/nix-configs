#!/usr/bin/env -S uv run
from typing import Annotated
import typer
from pathlib import Path
import time
import subprocess
import logging
from enum import Enum

LOGGER = logging.getLogger(__name__)


class Mode(str, Enum):
    Full = "full"
    Pre = "pre"
    Post = "post"


app = typer.Typer()


@app.command()
def main(
    lockfile: Annotated[Path, typer.Option("-l", "--lockfile")],
    command: Annotated[str | None, typer.Option("-c", "--command")] = None,
    args: Annotated[list[str] | None, typer.Option("-a", "--arg")] = None,
    mode: Annotated[Mode, typer.Option("-m", "--mode")] = Mode.Full,
    timeout: Annotated[float, typer.Option("-t", "--timeout")] = 60.0,
    interval: Annotated[float, typer.Option("-i--interval")] = 5.0,
):
    logging.basicConfig(level=logging.INFO)
    if (mode == Mode.Full) or (stager == Mode.Pre):
        elapsed = 0.0
        if lockfile.exists():
            LOGGER.info("Waiting for lock file to be released")

        while lockfile.exists():
            LOGGER.info("Waiting %.2fs seconds", interval)
            time.sleep(timeout)
            elapsed += timeout
            if elapsed > timeout:
                LOGGER.error(
                    "Timeout after %.2fs while waiting for lock file %s",
                    timeout,
                    str(lockfile),
                )
                exit(1)

        lockfile.touch()
        LOGGER.info("Creating lock file")

    if mode == Mode.Full:
        if not cmd:
            raise ValueError("No command provided")
        cmd = [str(command)] + (args if args else [])
        LOGGER.info("Run command: %s", " ".join(cmd))
        subprocess.run(cmd).check_returncode()

    if (mode == Mode.Full) or (mode == Mode.Post):
        LOGGER.info("Releasing lock file")
        lockfile.unlink()


if __name__ == "__main__":
    app()
