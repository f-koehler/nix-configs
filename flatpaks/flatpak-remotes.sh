#!/usr/bin/env bash
set -euf -o pipefail

FLATPAK_COMMAND="/usr/bin/flatpak"

remotes_json="$1"
remote_names="$(cat ${remotes_json} | jq -r 'keys[]')"
remote_names_installed="$($FLATPAK_COMMAND remotes --user --columns=name | tail -n +1)"

for remote in ${remote_names_installed}; do
    if ! echo "${remote_names}" | grep -wq "${remote}"; then
        echo "Removing remote: $remote"
        ${FLATPAK_COMMAND} remote-delete --user --force "${remote}"
    fi
done

for remote in ${remote_names}; do
    url="$(cat ${remotes_json} | jq -r ".\"${remote}\"")"
    echo "Adding/modifying remote: ${remote} (${url})"
    ${FLATPAK_COMMAND} remote-add --user --if-not-exists "${remote}" "${url}"
    ${FLATPAK_COMMAND} remote-modify --user "${remote}" --url "${url}"
done