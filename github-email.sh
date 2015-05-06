#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# Name    : github-email
# Purpose : Retrieve a GitHub user's email even though it's not public
#
#
# Based on: https://gist.github.com/sindresorhus/4512621
# Revised here: https://gist.github.com/cryptostrophe/11234026
# Now maintained in this repo.
# -----------------------------------------------------------------------------

if [[ $# -eq 0 ]]; then
    printf "Usage: %s username [repository]\n" "$(basename "$0")" >&2
    exit 1
fi

log() {
    faded='\033[1;30m'
    clear='\033[0m'
    printf "\n${faded}$1${clear}\n"
}


user="$1"
repo="$2"

log 'Email on GitHub'
curl "https://api.github.com/users/$user" -s \
    | sed -nE 's#^.*"email": "([^"]+)",.*$#\1#p'


log 'Email on npm'
if [ command -v get-email-address-from-npm-username >/dev/null 2>&1 ]; then
	npm install get-email-address-from-npm-username --global
fi
get-email-address-from-npm-username $user


log 'Emails from recent commits'
curl "https://api.github.com/users/$user/events" -s \
    | sed -nE 's#^.*"(email)": "([^"]+)",.*$#\2#p' \
    | sort -u


log 'Emails from owned-repo recent activity'
if [[ -z $repo ]]; then
    # get all owned repos
    repo="$(curl "https://api.github.com/users/$user/repos?type=owner&sort=updated" -s \
        | sed -nE 's#^.*"name": "([^"]+)",.*$#\1#p' \
        | head -n1)"
fi

curl "https://api.github.com/repos/$user/$repo/commits" -s \
    | sed -nE 's#^.*"(email|name)": "([^"]+)",.*$#\2#p' \
    | paste - - \
    | sort -u
