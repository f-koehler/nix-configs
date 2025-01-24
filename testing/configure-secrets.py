#!/usr/bin/env -S uv run
import logging
from rich.logging import RichHandler
from pathlib import Path
import subprocess
import jinja2
import uuid
import random
import string


def random_key() -> str:
    return str(uuid.uuid4())


def random_email() -> str:
    return (
        "".join(random.choices(string.ascii_lowercase, k=8))
        + "@"
        + "".join(random.choices(string.ascii_lowercase, k=5))
        + "."
        + "".join(random.choices(string.ascii_lowercase, k=3))
    )


JINJA_FUNCTIONS = dict(random_key=random_key, random_email=random_email)


def main():
    logging.basicConfig(
        level="NOTSET", format="%(message)s", datefmt="[%X]", handlers=[RichHandler()]
    )

    logging.info("Loading templating engine")
    env = jinja2.Environment(
        loader=jinja2.FileSystemLoader(searchpath=Path(__file__).parent)
    )

    dir_age_key = Path.home() / ".config" / "sops" / "age"
    if not dir_age_key.exists():
        dir_age_key.mkdir(parents=True)
    logging.info("Create age key dir: %s", str(dir_age_key))

    path_age_key = dir_age_key / "keys.txt"
    if not path_age_key.exists():
        logging.info("Generate new age key in: %s", str(path_age_key))
        subprocess.check_output(["age-keygen", "-o", str(path_age_key)])

    logging.info("Fetching public age key")
    public_age_key = subprocess.check_output(
        ["age-keygen", "-y", str(path_age_key)], text=True
    )

    logging.info("Generating .sops.yaml")
    path_sops_yaml = Path.cwd() / ".sops.yaml"
    path_sops_yaml.write_text(
        env.get_template("sops.yaml.j2").render(public_age_key=public_age_key)
    )

    dir_secret_templates = Path(__file__).parent / "secrets"
    dir_rendered_secrets = Path.cwd() / "secrets"
    for path in dir_secret_templates.iterdir():
        if not path.is_file():
            continue
        if not path.name.endswith(".yaml.j2"):
            continue
        target = dir_rendered_secrets / path.with_suffix("").name
        logging.info("Rendering secret: %s", str(target))
        target.write_text(
            env.get_template("secrets/" + path.name).render(**JINJA_FUNCTIONS)
        )

        logging.info("Encrypting secret: %s", str(target))
        subprocess.check_output(["sops", "-i", "-e", str(target)])


if __name__ == "__main__":
    main()
