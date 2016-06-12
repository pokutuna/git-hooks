#!/bin/sh

remote="$1"
url="$2"
empty='0000000000000000000000000000000000000000'

IFS=' '
while read local_ref local_sha1 remote_ref remote_sha1; do

    # delete branch
    if [ $local_sha1 = $empty ]; then
        continue
    fi

    if [ $remote_sha1 = $empty ]; then
        range="$(git log -n 1 --remotes --pretty='%H')..${local_sha1}"
    else
        range="${remote_sha1}..${local_sha1}"
    fi

    commit=$(git reg-list -n 1 --grep='^fixup!' $range)
    if [ -n $commit ]; then
        echo "[REJECT] fixup commit found ${commit}\n"
        exit 1
    fi
done

exit 0
