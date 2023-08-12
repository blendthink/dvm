#!/usr/bin/env bash

curl --location --silent --request DELETE \
  --url "${GITHUB_API_URL}/installation/token" \
  --header "Accept: application/vnd.github+json" \
  --header "X-GitHub-Api-Version: 2022-11-28" \
  --header "Authorization: Bearer ${GITHUB_TOKEN}"
