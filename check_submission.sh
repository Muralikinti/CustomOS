#!/bin/bash

branch=$(git branch | sed -n '/^\* /{s/^* *//p}')
#branch=$(git branch --show-current)  #not introduced until git 2.22
if [[ ( -z "$branch" ) || (  "$branch" != lab* ) ]]; then
    echo "Must be on lab1, lab2, lab3, or lab4 branch"
    exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
    echo "NOT SUBMITTED: You have uncommited changes! Try 'git status'/'git add'/'git commit'"
    exit 1
fi

head=$(git rev-parse HEAD)
origin=$(git rev-parse origin/$branch)

if ! tag=$(git rev-parse refs/tags/$branch-final 2>/dev/null); then
    echo "NOT SUBMITTED: You have not created the $branch-final tag! Try 'git tag'"
    exit 1
fi

if [[ "$tag" != "$head" ]]; then
    echo "NOT SUBMITTED: Your $branch-final tag points to an old commit! Try 'git tag -f'"
    exit 1
fi

if [[ "$head" != "$origin" ]]; then
    echo "NOT SUBMITTED: It looks like you haven't pushed your changes! Try 'git push'"
    exit 1
fi

# fetch remote tags to rtags
if ! git fetch origin +refs/tags/*:refs/rtags/origin/* > /dev/null 2>&1; then
    echo "Could not fetch origin tags!"
    exit 1
fi
if ! origin_tag=$(git rev-parse refs/rtags/origin/$branch-final 2>/dev/null); then
    echo "NOT SUBMITTED: You have not pushed the $branch-final tag! Try 'git push origin $branch-final'"
    exit 1
fi

if [[ "$origin_tag" != "$head" ]]; then
    echo "NOT SUBMITTED: It looks like the $branch-final tag on the remote repository points to an old commit! Try 'git push -f origin $branch-final'"
    exit 1
fi

url="$(git config --get remote.origin.url)"
#url="$(git remote get-url origin)" #note: 'get-url' is not available
url="${url/#git@github.com:/https://github.com/}"
url=$(echo "$url" | sed 's/\.git$//')
echo "It looks like you've submitted successfully! Go to $url/releases/tag/$branch-final and make sure all your code is there."
