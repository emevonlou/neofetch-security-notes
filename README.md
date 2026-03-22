# System Metadata Exposure & Defensive Sanitization Toolkit

![License](https://img.shields.io/badge/license-MIT-green)
![Shell](https://img.shields.io/badge/language-bash-blue)
![Security Focus](https://img.shields.io/badge/focus-metadata%20security-purple)
![Status](https://img.shields.io/badge/status-active-success)
![CI](https://github.com/emevonlou/neofetch-security-notes/actions/workflows/redflag-scan.yml/badge.svg)


This project started from a simple realization:
Even small pieces of technical output can unintentionally expose details about a system.
What looks harmless at first glance can, over time, reveal patterns, environments, and identifiers.
The goal of this repository is to provide simple, local, and defensive tools to help reduce that risk.

---

## Quick Start

Sanitize system output before sharing:

```bash
neofetch | ./tools/sanitize-neofetch.sh --strict
```

Scan for potential red flags:

```bash
neofetch | ./tools/sanitize-neofetch.sh --strict | ./tools/redflag-scan.sh
```

---

## Demo

![Quick demo](docs/demo/quickstart.gif)

Example workflow showing sanitization and optional disclosure scanning before sharing technical output.

---

## Tools

| Tool | Description |
|-----|-------------|
| `tools/sanitize-neofetch.sh` | Sanitizes system metadata before sharing |
| `tools/redflag-scan.sh` | Detects potentially sensitive patterns in text |
| `tools/safe-share.sh` | Wrapper that combines sanitization and scanning workflows |

### Example workflow

```bash
neofetch | ./tools/safe-share.sh sanitize | tee sanitized.txt | ./tools/safe-share.sh scan
```

---

## What problem does this solve?

Technical output can unintentionally expose environment details such as:

- hostnames  
- local filesystem paths  
- internal IP addresses  
- environment fingerprints  
- API keys, tokens, and other secrets  

Even small pieces of metadata can reveal useful information about a system when combined.

---

## Detection Coverage

This toolkit provides best-effort detection for:

- system metadata red flags  
- filesystem paths  
- IP and MAC addresses  
- UUID and machine identifiers  
- API keys and tokens  
- private key headers  

---

## Security Model

This toolkit operates with a strict local-only philosophy.
All processing happens on the user's machine.  
No data is collected, transmitted, or stored externally.
The purpose is to reduce accidental exposure when sharing:

- terminal output  
- logs  
- debugging information  
- configuration snippets  

Detection is best-effort and does not guarantee complete sanitization.  
Manual review is always recommended.

---

## Security by Design Principles

- data minimization  
- secure defaults  
- defense in depth  
- fail-safe behavior  
- user control and transparency  

---

## Project Structure

```text
.
├── .github/workflows/     # CI automation
├── docs/                  # extended documentation
├── examples/              # test fixtures and examples
├── hooks/                 # portable git hooks
├── tools/                 # defensive scripts
│   ├── patterns/
│   ├── redflag-scan.sh
│   ├── sanitize-neofetch.sh
│   ├── safe-share.sh
│   └── run-checks.sh
├── CONTRIBUTING.md
├── SECURITY.md
├── Makefile
└── README.md
```

---

## Automation

This project includes lightweight automation:

- pre-commit protection  
- repository scanning for red flags  
- GitHub Actions CI  
- local checks via `make check`  

Run locally:

```bash
make check
make test
```

---

## Documentation

Additional material is available in:

- `docs/metadata-exposure.md`
- `docs/fingerprinting-risk.md`

---

## Final Note

This project is not about hiding everything.

It is about being intentional with what we expose.

Reducing unnecessary metadata today can prevent unintended disclosure tomorrow.
