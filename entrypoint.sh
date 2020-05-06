#!/bin/bash

set -e
set -o pipefail

# Ensure that the GITHUB_TOKEN secret is included
if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "Set the GITHUB_TOKEN env variable."
  exit 1
fi

gitchangelog ${TAG_NAME} > CHANGELOG.md

# Prepare the headers
AUTH_HEADER="Authorization: token ${GITHUB_TOKEN}"
CONTENT_LENGTH_HEADER="Content-Length: $(stat -c%s CHANGELOG.md)"

if [[ -z "$2" ]]; then
  CONTENT_TYPE_HEADER="Content-Type: ${2}"
else
  CONTENT_TYPE_HEADER="Content-Type: application/zip"
fi

RELEASE_URL="https://api.github.com/repos/${GITHUB_REPOSITORY}/releases"

echo $RELEASE_URL

BODY=$(cat <<EOF
{
  "tag_name": "${TAG_NAME}",
  "target_commitish": "master",
  "name": "${TAG_NAME}",
  "body": "$()",
  "draft": false,
  "prerelease": false
}
EOF
)

echo $BODY

# Upload the file
curl \
  -f \
  -sSL \
  -XPOST \
  -H "${AUTH_HEADER}" \
  -H "${CONTENT_LENGTH_HEADER}" \
  -H "${CONTENT_TYPE_HEADER}" \
  --data "${BODY}" \
  "${RELEASE_URL}"
