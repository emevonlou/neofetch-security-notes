# System Metadata Exposure & Defensive Sanitization Toolkit

![License](https://img.shields.io/badge/license-MIT-green)
![Shell](https://img.shields.io/badge/language-bash-blue)
![Security Focus](https://img.shields.io/badge/focus-metadata%20security-purple)
![Status](https://img.shields.io/badge/status-active-success)

This project started with a simple moment of curiosity.

While using **Neofetch**, I realized something that stayed with me.

Neofetch displays system information in a beautiful, almost aesthetic way.  
It feels harmless. Just specs. Just details.

But I began to wonder:

What happens when those details are shared publicly?

What happens when small pieces of metadata...a hostname, a kernel version, a shell, a memory footprint...start accumulating across posts, platforms, and conversations?

Individually, they seem insignificant.

Together, they can form a fingerprint.

This repository was born from that reflection.

The name includes “neofetch” because that is where the idea began.  
But this project is not about a single tool.

It is about awareness.  
It is about understanding metadata exposure.  
It is about thinking before sharing.

The principles and tools here apply to any situation where system information, logs, terminal output, or diagnostic reports are shared publicly.

## Quick Start

Generate sanitized output before sharing system information:

```bash
neofetch | ./tools/sanitize-neofetch.sh --strict
```

- Optional: scan the output for potential sensitive patterns.

```bash
neofetch | ./tools/sanitize-neofetch.sh --strict | ./tools/redflag-scan.sh
```

This helps reduce accidental exposure of system metadata such as hostnames, paths, or identifiers.

## Tools

- `tools/sanitize-neofetch.sh` — best-effort sanitizer (supports `--strict`)
- `tools/redflag-scan.sh` — flags common sensitive patterns (best-effort)
- `hooks/pre-commit` — portable pre-commit hook you can install locally
- `.github/workflows/` — CI checks to help prevent accidental sensitive-data commits
- `tools/safe-share.sh` — simple wrapper that combines sanitization and scanning workflows

### Example workflow

```bash
neofetch | ./tools/safe-share.sh sanitize | tee sanitized.txt | ./tools/safe-share.sh scan
```
This workflow sanitizes system output and immediately scans it for
potentially sensitive metadata before sharing.

## Optional: Install pre-commit hook

```bash
ln -sf ../../hooks/pre-commit .git/hooks/pre-commit
```

## Security Model

This toolkit operates with a strict local-only philosophy.

All analysis and sanitization happen directly on the user's machine.
The tools do not collect, transmit, or store system data externally.

The repository focuses on reducing **accidental metadata exposure** when developers share:

- terminal output
- system diagnostics
- debugging logs
- configuration snippets

Pattern detection and sanitization provided here are **best-effort heuristics**.

They are designed to highlight potentially sensitive elements such as identifiers,
paths, addresses, or unique system metadata that may contribute to fingerprinting.

However, no automated tool can guarantee complete sanitization.

Users should always manually review output before publishing or sharing it publicly.

## Security by Design Principles

This toolkit is intentionally defensive and built around security-by-design ideas:

- **Data minimization:** sanitize and generalize metadata before sharing. If a detail is not needed, it should not be disclosed.
- **Secure defaults:** the safer workflow should be the easiest one (e.g., strict sanitization and explicit reminders to review output).
- **Defense in depth:** combine multiple layers (sanitization + red-flag scanning + commit-time guardrails) rather than relying on a single step.
- **Fail-safe behavior:** prefer blocking unsafe actions (e.g., preventing commits that appear to contain sensitive patterns) over silently allowing them.
- **User control and transparency:** tools operate locally, do not auto-upload, and keep the user in control of what gets shared.
- **Practical usability:** mitigation is only effective if people actually use it...so the tools are small, simple, and easy to integrate into daily workflows.

The goal is not to “hide everything”, but to reduce unnecessary exposure and long-term correlation risk.


## Final Note

This repository exists to promote defensive thinking and responsible sharing.

Do not perform fingerprinting or reconnaissance against systems without explicit authorization.
