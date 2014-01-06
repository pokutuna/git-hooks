#!/bin/sh

# 確認するブランチ名
SPECIAL_BRANCHES=("master" "staging")
function is_special_branch {
    br_name=${1}
    for sp_branch in ${SPECIAL_BRANCHES[@]}; do
        if [ $br_name = $sp_branch ]; then
            return 0
        fi
    done
    return 1
}

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
is_special_branch ${CURRENT_BRANCH} && echo "REJECTED commit to '${CURRENT_BRANCH}' branch. Skip this check to use '--no-verify' option" && exit 1
exit 0
