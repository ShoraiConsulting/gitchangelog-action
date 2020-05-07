#!/bin/bash

set -e
set -o pipefail

# Ensure that the GITHUB_TOKEN secret is included
if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "Set the GITHUB_TOKEN env variable."
  exit 1
fi

PREVIOUS_TAG=`git tag --sort=committerdate | tail -2 | head -1`
echo $PREVIOUS_TAG

# Save only last version's changelog
gitchangelog $PREVIOUS_TAG..$TAG_NAME > CHANGELOG.md
# GH requires empty lines
sed -e 's/$/\\n/' -i CHANGELOG.md

# Prepare the headers
AUTH_HEADER="Authorization: token ${GITHUB_TOKEN}"
CONTENT_TYPE_HEADER="Content-Type: application/json"
RELEASE_URL="https://api.github.com/repos/${GITHUB_REPOSITORY}/releases"

# Write JSON to file to safely read it in curl
tee temp <<EOF
{
  "tag_name": "$TAG_NAME",
  "target_commitish": "master",
  "name": "${TAG_NAME}",
  "body": "$(cat CHANGELOG.md)",
  "draft": false,
  "prerelease": false
}
EOF

# Upload the file
curl \
  -XPOST \
  -H "$AUTH_HEADER" \
  -H "$CONTENT_TYPE_HEADER" \
  -d @temp \
  "$RELEASE_URL"
