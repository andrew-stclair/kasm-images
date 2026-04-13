#!/bin/bash
set -e

# Fetch the latest ZAP release tag from GitHub API
LATEST_TAG=$(curl -fsSL "https://api.github.com/repos/zaproxy/zaproxy/releases/latest" \
  | grep '"tag_name"' \
  | sed 's/.*"tag_name": *"\([^"]*\)".*/\1/')

if [ -z "$LATEST_TAG" ]; then
  echo "ERROR: Could not determine the latest ZAP release tag." >&2
  exit 1
fi

# Convert tag (e.g. v2.17.0) to filename format (e.g. ZAP_2_17_0_unix.sh)
VERSION="${LATEST_TAG#v}"                        # strip leading 'v'
VERSION_UNDERSCORED="${VERSION//./_}"            # replace dots with underscores
FILENAME="ZAP_${VERSION_UNDERSCORED}_unix.sh"
URL="https://github.com/zaproxy/zaproxy/releases/download/${LATEST_TAG}/${FILENAME}"

echo "Latest ZAP release : ${LATEST_TAG}"
echo "Downloading        : ${FILENAME}"
echo "From               : ${URL}"

curl -fsSL -o "${FILENAME}" "${URL}"

echo "Download complete  : ${FILENAME}"

#Finally, make it executable and run it to install ZAP
chmod +x "${FILENAME}"
./"${FILENAME}" -q -dir /opt/zap
rm -f "${FILENAME}"
