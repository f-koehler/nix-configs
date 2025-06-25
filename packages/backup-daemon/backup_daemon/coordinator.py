from pathlib import Path
from .lockfile import LockFile
import logging
import enum

logger = logging.getLogger(__name__)


class BackupCoordinatorUnitialized(Exception):
    def __init__(self):
        super().__init__(f"Trying to access unitialized BackupCoordinator")


class BackupStatus(enum.Enum):
    Idle = "idle"
    PreHook = "pre_hook"
    BackupHook = "backup_hook"
    PostHook = "post_hook"


class BackupCoordinator:
    def __init__(self, lockfile: Path):
        logger.info("Creating backup coordinator with lock file: %s", str(lockfile))
        self.lockfile_path = lockfile
        self.status = BackupStatus.Idle

    @staticmethod
    def get() -> "BackupCoordinator":
        if _instance is None:
            raise BackupCoordinatorUnitialized()
        return _instance

    @staticmethod
    def init(lockfile: Path):
        _backup_coordinator = BackupCoordinator(lockfile)

    def run(self):
        self.lockfile = LockFile(self.lockfile_path)
        self._run_pre_hook()
        self._run_backup_hook()
        self._run_post_hook()
        self.status = BackupStatus.Idle

    def _run_pre_hook(self):
        self.status = BackupStatus.PreHook
        logger.info("Run pre-hook")
        logger.info("Pre-hook complete")

    def _run_backup_hook(self):
        self.status = BackupStatus.BackupHook
        logger.info("Run backup-hook")
        logger.info("Backup-hook complete")

    def _run_post_hook(self):
        self.status = BackupStatus.PostHook
        logger.info("Run post-hook")
        logger.info("Post-hook complete")


_instance: BackupCoordinator | None = None
