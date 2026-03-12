# Security notes

## Goal
Reduce accidental disclosure in public development workflows.

## What this project tries to prevent
This project focuses on obvious accidental leaks in developer-facing content, such as:
- local paths
- host-specific details
- terminal output that may reveal environment information
- repository text content containing risky disclosure patterns

## Design choices
- local hooks catch issues before commit
- CI provides repository-level enforcement after push
- sanitization is preferred over manual editing when possible
- test fixtures should avoid realistic sensitive-looking values when not strictly necessary

## Why sanitization matters
Developers often share terminal output, reports, screenshots, or repository notes without realizing how much environment-specific information is exposed. This project tries to reduce that risk through lightweight guardrails.

## Trade-offs
Broader pattern matching improves catch rate, but can increase false positives. Narrower matching reduces noise, but may miss risky patterns. This project favors simple, explainable checks with lightweight local and CI enforcement.

## Scope
This project is designed to reduce accidental disclosure, not to replace full secret scanning, threat modeling, or security review.
