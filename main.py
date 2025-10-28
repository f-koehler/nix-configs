import typer
from typing import Annotated
import subprocess
import tempfile
from pathlib import Path
import logging
import rich.logging
from ruamel.yaml import YAML
import ruamel.yaml.comments
import os

app = typer.Typer()
logger = logging.getLogger()


@app.command()
def deploy(
    host: Annotated[str, typer.Argument(help="IP or hostname to deploy to")],
    config: Annotated[str, typer.Argument(help="NixOS configuration to use")],
    extra_files: Annotated[
        list[Path], typer.Option(help="Extra files to pass to nixos-anywhere")
    ] = [],
):
    cmd = [
        "nixos-anywhere",
        "--generate-hardware-config",
        "nixos-facter",
        f"./os/hardware/{config}.json",
        "--flake",
        f".#{config}",
        "--target-host",
        f"root@${host}",
    ]
    for path in extra_files:
        cmd += ["--extra-files", str(path)]
    logger.info("Deploy config %s to host %s", config, host)
    logger.debug("Command: %s", " ".join(cmd))
    subprocess.run(cmd)


@app.command()
def setup(
    host: Annotated[str, typer.Argument(help="IP or hostname to deploy to")],
    config: Annotated[str, typer.Argument(help="NixOS configuration to use")],
):
    sops_config_file = Path() / ".sops.yaml"
    with tempfile.TemporaryDirectory() as tmpdir:
        key_path = Path(tmpdir) / "etc" / "ssh" / "ssh_host_ed25519_key"
        key_path.parent.mkdir(parents=True)
        cmd = [
            "ssh-keygen",
            "-t",
            "ed25519",
            "-C",
            f"{host}-{config}",
            "-f",
            str(key_path),
            "-q",
            "-N",
            "",
        ]
        logger.info("Generate new ssh key")
        logger.debug("Command: %s", " ".join(cmd))
        subprocess.check_output(cmd)

        cmd = ["ssh-to-age", "-i", str(key_path.with_suffix(".pub")), "-o", "-"]
        logger.info("Generate age key from ssh key")
        logger.debug("Command: %s", " ".join(cmd))
        age_key = subprocess.check_output(cmd, text=True).strip()

        logger.info("Update permissions of SSH key")
        os.chmod(key_path, 0o600)

        logger.info("Remove public key file")
        key_path.with_suffix(".pub").unlink()

        logger.info("Register new age key in sops config")
        yaml = YAML()
        sops_config = yaml.load(sops_config_file.read_text())
        for key_group in sops_config["creation_rules"][0]["key_groups"]:
            if "age" in key_group:
                key_group = ruamel.yaml.comments.CommentedMap(key_group)
                break
        else:
            raise RuntimeError("Please add an age key group manually")
        key_group["age"].append(age_key)
        key_group["age"].yaml_add_eol_comment(
            f"host: {host}, config: {config}", len(key_group["age"]) - 1
        )
        with open(sops_config_file, "w") as file:
            yaml.dump(sops_config, file)

        cmd = ["sops", "updatekeys", "--yes", ".secrets.yaml"]
        logger.info("Re-encrypt secrets")
        logger.debug("Command: %s", " ".join(cmd))
        subprocess.check_output(cmd)

        deploy(host, config, extra_files=list[Path(tmpdir)])


if __name__ == "__main__":
    logging.basicConfig(
        level="NOTSET",
        format="%(message)s",
        datefmt="[%X]",
        handlers=[rich.logging.RichHandler()],
    )
    app()
