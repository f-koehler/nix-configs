from typing import Any
from pathlib import Path
import logging
import os
import json
import datetime
import time
from math import ceil

LOGGER = logging.getLogger(__name__)
LOCKFILE_STALE_TIMEOUT = 3600.0
LOCKFILE_DEFAULT_TIMEOUT = 300.0
LOCKFILE_DEFAULT_INTERVAL = 5.0


class WaitingForLockTimeout(Exception):
    def __init__(self, path: Path):
        super().__init__(f"Timeout while waiting for lock file: {path}")


def is_existing_lock(path: Path) -> bool:
    if not path.exists():
        return False
    try:
        data = json.loads(path.read_text())
        return ("pid" in data) and ("timestamp" in data)
    except json.JSONDecodeError:
        return False


def is_process_still_running(path: Path) -> bool:
    try:
        os.kill(json.loads(path.read_text())["pid"], 0)
        return True
    except OSError:
        return False


def get_lock_age_in_seconds(path: Path) -> float:
    current_timestamp = datetime.datetime.now()
    lock_timestamp = datetime.datetime.fromisoformat(
        json.loads(path.read_text())["timestamp"]
    )
    return (current_timestamp - lock_timestamp).total_seconds()


def is_stale_lock(path: Path) -> bool:
    if is_process_still_running(path):
        LOGGER.info("Lockfile %s is not stale, process is still running", str(path))
        return False

    age = get_lock_age_in_seconds(path)
    if age > LOCKFILE_STALE_TIMEOUT:
        LOGGER.info("Lockfile %s is stale, its age is %.2fs", str(path), age)
        return True

    LOGGER.info("Lockfile %s is not stale, its age is %.2fs", str(path), age)
    return False


def wait_for_lock(path: Path, timeout: float, interval: float) -> None:
    if is_existing_lock(path):
        LOGGER.info("Lockfile already exists: %s", str(path))
        if is_stale_lock(path):
            LOGGER.info("Remove stale lockfile: %s", str(path))
            path.unlink()
        else:
            start = datetime.datetime.now()
            intervals = ceil(timeout / interval)
            for iteration in range(intervals):
                if not is_existing_lock(path):
                    break
                time.sleep(interval)
                LOGGER.info(
                    "Waiting for lockfile %s to be released (%.2fs / %.2fs)",
                    str(path),
                    iteration * interval,
                    timeout,
                )

            if is_existing_lock(path):
                logging.error("Time-out while waiting for lockfile: %s", str(path))
                raise WaitingForLockTimeout(path)


class LockFile:
    def __init__(
        self,
        path: Path,
        timeout: float = LOCKFILE_DEFAULT_TIMEOUT,
        interval: float = LOCKFILE_DEFAULT_INTERVAL,
    ):
        self.path = path
        self.pid = os.getpid()

        LOGGER.info("wait for lockfile: %s", str(path))
        wait_for_lock(path, timeout, interval)

        self.timestamp = datetime.datetime.now()
        path.write_text(self.to_json())
        LOGGER.info("acquired lockfile: %s", str(path))

    def to_dict(self) -> dict[str, Any]:
        return dict(path=self.path, pid=self.pid, timestamp=self.timestamp.isoformat())

    def to_json(self) -> str:
        data = self.to_dict()
        del data["path"]
        return json.dumps(data)

    @staticmethod
    def acquire(
        path: Path,
        timeout: float = LOCKFILE_DEFAULT_TIMEOUT,
        interval: float = LOCKFILE_DEFAULT_INTERVAL,
    ) -> "LockFile":
        return LockFile(path, timeout, interval)

    def release(self) -> None:
        LOGGER.info("Release lockfile: %s", str(self.path))
        self.path.unlink()

    def __enter__(self) -> dict[str, Any]:
        return self.to_dict()

    def __exit__(self) -> None:
        self.release()
