#!/bin/sh

NG_PATTERN='(XXX|TODO)'

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

    ng=$(git diff $range | grep -E '^\+' | grep -E $NG_PATTERN)
    if [ -n "$ng" ]; then
        echo "--- NG Pattern Found ---"
        git diff $range | grep -E '^\+' | grep -E $NG_PATTERN

        exec < /dev/tty
        read -p 'Push these changes? (Y/n)' yn
        if [ "$yn" = '' ]; then
            yn='n'
        fi
        exec <&-

        case $yn in
            [Yy] )
                continue
                ;;
            * )
                exit 1
                ;;
        esac
    fi
done

exit 0
