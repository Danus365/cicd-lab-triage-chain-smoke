# cicd-lab-triage-chain-smoke

Minimal reproduction lab for the T7-CHAIN path:

```
attacker obtains actions:write GITHUB_TOKEN
  (e.g. via prompt injection in a triage workflow)
      │
      ▼
POST /actions/workflows/smoke-test.yml/dispatches { inputs.ref: <attacker SHA> }
      │
      ▼
smoke-test job checks out attacker ref with contents: write
      │
      ▼
npm ci / npm run build / npm test run attacker-controlled code
```

Only workflow present: `.github/workflows/smoke-test.yml` (verbatim copy from
`pillar-labs/gemini-triage-poc`).
