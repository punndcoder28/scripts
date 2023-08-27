#!/bin/bash

# Log function for displaying messages
log() {
    echo "[LOG] $1"
}

log "Starting branch cleanup..."

log "Checking out master branch"
git checkout main

log "Pulling latest changes from remote master branch"
git pull --rebase

# Fetch the latest changes from the remote repository and prune references
log "Fetching the latest changes from the remote repository and pruning references"
git fetch --prune

# Loop through each local branch
for local_branch in $(git for-each-ref --format='%(refname:short)' refs/heads/); do
    # Check if the local branch has an associated upstream (remote tracking branch)
    if ! git rev-parse --abbrev-ref "$local_branch"@{upstream} >/dev/null 2>&1; then
        log "Deleting local branch: $local_branch"
        git branch -D "$local_branch"
    fi
done
