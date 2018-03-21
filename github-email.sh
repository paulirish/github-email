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
clear='\033[0m'

fade() {
    faded='\033[30m'
    printf "%b$1%b\n" "$faded" "$clear"
}

header() {
    pink='\033[1;35m'
    printf "\n%b$1%b\n" "$pink" "$clear"
}

user="$1"
repo="$2"


header 'Email on GitHub'
curl "https://api.github.com/users/$user" -s \
    | sed -nE 's#^.*"email": "([^"]+)",.*$#\1#p'

header 'Email on npm'
if hash jq 2>/dev/null; then
    curl "https://registry.npmjs.org/-/user/org.couchdb.user:$user" -s | jq -r '.email'
else
    echo " … skipping …. Please: brew install jq"
fi


header 'Emails from recent commits'
curl "https://api.github.com/users/$user/events" -s \
    | sed -nE 's#^.*"(email)": "([^"]+)",.*$#\2#p' \
    | sort -u


header 'Emails from owned-repo recent activity'
if [[ -z $repo ]]; then
    # get all owned repos
    repo="$(curl "https://api.github.com/users/$user/repos?type=owner&sort=updated" -s \
        | sed -nE 's#^.*"name": "([^"]+)",.*$#\1#p' \
        | head -n1)"
fi

curl "https://api.github.com/repos/$user/$repo/commits" -s \
    | sed -nE 's#^.*"(email|name)": "([^"]+)",.*$#\2#p'  \
    | pr -2 -at \
    | sort -u
