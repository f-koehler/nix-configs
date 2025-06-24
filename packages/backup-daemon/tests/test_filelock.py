from pyfakefs.fake_filesystem import FakeFilesystem
from pathlib import Path
from backup_daemon import lockfile
import json
import datetime
import os


def get_valid_lock_contents(
    pid: int | None = None, timestamp: datetime.datetime | None = None
) -> str:
    if pid is None:
        pid = os.getpid()
    if timestamp is None:
        timestamp = datetime.datetime.now()
    return json.dumps(dict(pid=pid, timestamp=timestamp.isoformat()))


def find_non_existent_pid() -> int:
    for i in reversed(range(1, 32768, 1)):
        try:
            os.kill(i, 0)
            continue
        except OSError:
            return i
    raise RuntimeError("Failed to find a free process ID")


def test_is_existing_lock(fs: FakeFilesystem):
    assert not lockfile.is_existing_lock(Path("/nonexistent.lock"))

    fs.create_file("/empty.lock", contents="")
    assert not lockfile.is_existing_lock(Path("/empty.lock"))

    fs.create_file(
        "/missing_pid.lock",
        contents=json.dumps(dict(timestamp=datetime.datetime.now().isoformat())),
    )
    assert not lockfile.is_existing_lock(Path("/missing_pid.lock"))

    fs.create_file(
        "/missing_timestamp.lock",
        contents=json.dumps(dict(pid=os.getpid())),
    )
    assert not lockfile.is_existing_lock(Path("/missing_timestamp.lock"))

    fs.create_file(
        "/valid.lock",
        contents=get_valid_lock_contents(),
    )
    assert lockfile.is_existing_lock(Path("/valid.lock"))


def test_is_process_still_running(fs: FakeFilesystem):
    fs.create_file(
        "/currentprocess.lock",
        contents=json.dumps(
            dict(pid=os.getpid(), timestamp=datetime.datetime.now().isoformat())
        ),
    )
    assert lockfile.is_existing_lock(Path("/currentprocess.lock"))
    assert lockfile.is_process_still_running(Path("/currentprocess.lock"))

    fs.create_file(
        "/non_existent_pid.lock",
        contents=get_valid_lock_contents(pid=find_non_existent_pid()),
    )
    assert lockfile.is_existing_lock(Path("/non_existent_pid.lock"))
    assert not lockfile.is_process_still_running(Path("/non_existent_pid.lock"))


def test_get_lock_age_in_seconds(fs: FakeFilesystem):
    fs.create_file(
        "now.lock",
        contents=get_valid_lock_contents(),
    )
    assert lockfile.is_existing_lock(Path("now.lock"))
    age_in_seconds = lockfile.get_lock_age_in_seconds(Path("now.lock"))
    assert age_in_seconds < 0.5
    assert age_in_seconds >= 0.0


def test_is_stale_lock(fs: FakeFilesystem):
    fs.create_file(
        "current_process.lock",
        contents=get_valid_lock_contents(
            timestamp=(
                datetime.datetime.now()
                - datetime.timedelta(seconds=2 * lockfile.LOCKFILE_STALE_TIMEOUT)
            )
        ),
    )
    assert lockfile.is_existing_lock(Path("current_process.lock"))
    assert not lockfile.is_stale_lock(Path("current_process.lock"))

    fs.create_file(
        "stale.lock",
        contents=get_valid_lock_contents(
            pid=find_non_existent_pid(),
            timestamp=(
                datetime.datetime.now()
                - datetime.timedelta(seconds=2 * lockfile.LOCKFILE_STALE_TIMEOUT)
            ),
        ),
    )
    assert lockfile.is_existing_lock(Path("stale.lock"))
    assert lockfile.is_stale_lock(Path("stale.lock"))

    assert lockfile.LOCKFILE_STALE_TIMEOUT > 2.0
    fs.create_file(
        "fresh.lock",
        contents=get_valid_lock_contents(
            pid=find_non_existent_pid(),
            timestamp=(datetime.datetime.now() - datetime.timedelta(seconds=1)),
        ),
    )
    assert lockfile.is_existing_lock(Path("fresh.lock"))
    assert not lockfile.is_stale_lock(Path("fresh.lock"))
