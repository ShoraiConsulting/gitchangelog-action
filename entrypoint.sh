#!/bin/bash

set -e
set -o pipefail

# Ensure that the GITHUB_TOKEN secret is included
if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "Set the GITHUB_TOKEN env variable."
  exit 1
fi

TAG=${TAG_NAME/refs\/tags\//}
PREVIOUS_TAG=`git tag --sort=committerdate | tail -2 | head -1`

echo $PREVIOUS_TAG

gitchangelog $PREVIOUS_TAG..$TAG > CHANGELOG.md
# GH requires empty lines for parsing/rendering
sed -e 's/$/\\n/' -i CHANGELOG.md

cat CHANGELOG.md

# Prepare the headers
AUTH_HEADER="Authorization: token ${GITHUB_TOKEN}"
CONTENT_TYPE_HEADER="Content-Type: application/json"
RELEASE_URL="https://api.github.com/repos/${GITHUB_REPOSITORY}/releases"

# Write JSON to file to safely read it in curl
tee temp <<EOF
{
  "tag_name": "$TAG",
  "target_commitish": "master",
  "name": "$TAG",
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
