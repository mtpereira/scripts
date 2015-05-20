#!/bin/bash

set -eu

split() {
    local file="${1}"
    local filename="$(basename ${file/\.yml/})"
    local match=""

    # Initialize files with the correct name and with YAML header.
    # $filename has each unique non-blank non-header line that begins with a word.
    # This will be the filename for storing variables of the corresponding role.
    for filename in $(grep -v -E "^$" ${file} | grep -v -E -- "^---\s*$" | grep -E -o '^[a-z0-9]+' | uniq); do
        [ -f ${filename} ] || echo '---' > ${filename}.yml
    done

    # Perform the actual split.
    # Get each non-header file into $line.
    # Store current state in $match, for knowing where to write.
    # Update it when we hit a non-blank line different then the current match.
    grep -v -E -- '^---\s*$' ${file} | while IFS= read -r line; do
        set +e
        current_match=$(echo "${line}" | grep -o -E '^#?[a-z0-9]+')
        # remove '#' if present
        current_match=${current_match/\#/}
        set -e
        if [ "${current_match}" != "" ] && [ "${current_match}" != "${match}" ]; then
            match="${current_match}"
        fi
        if [ "${match}" != "" ]; then
            echo "${line}" >> "${match}".yml
        fi
    done
}

main() {
    local file="${1}"
    local dir="$(basename $(dirname ${file}))"
    local filename="$(basename ${file/\.yml/})"
    # file is in a dir with the same name as itself, eg, prolinkedcare/prolinkedcare.yml
    if [ "${dir}" = "${filename}" ]; then
        cd "${dir}"
        split "${filename}.yml"
        cd -
        # file has no dir
    elif [ "${dir}" = "." ]; then
        mkdir -p "${filename}"
        cp "${file}" "${filename}"
        cd "${filename}"
        split "${file}"
        rm "${file}"
        cd -
    fi
}

main "${1}"

