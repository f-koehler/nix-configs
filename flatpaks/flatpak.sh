#!/bin/bash
set -euf -o pipefail

FLATPAK_COMMAND=/usr/bin/flatpak

packages=""
for file in "$@"; do
    if [ -e "${file}" ]; then
        while IFS= read -r package; do
            packages="${packages} ${package}"
        done < "${file}"
    else
        echo "File not found: ${file}" >&2
        exit 1
    fi
done

installed=$(${FLATPAK_COMMAND} list --app --columns=application | tail -n+1)

to_remove=""
for package in ${installed}; do
    if ! echo "${packages}" | grep -wq "${package}"; then
        echo "${package}"
    fi
done

if [ -n "${to_remove}" ]; then
    echo "Removing: ${to_remove}"
    ${FLATPAK_COMMAND} --user uninstall -y ${to_remove}
    ${FLATPAK_COMMAND} --user uninstall --unused -y
fi

echo "Installing: ${packages}"
if [ -n "${packages}" ]; then
    ${FLATPAK_COMMAND} --user install -y ${packages}
fi
