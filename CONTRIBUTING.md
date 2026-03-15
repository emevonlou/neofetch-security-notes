# Contributing

Thank you for your interest in contributing to **neofetch-security-notes**.

This project focuses on preventing accidental metadata disclosure when developers share system information publicly.

Small improvements are welcome and appreciated.

---

## Development setup

- Clone the repository:

```bash
git clone https://github.com/emevonlou/neofetch-security-notes.git
cd neofetch-security-notes
```

- Run the local checks:

```bash
make check
```

- Install the pre-commit hooks:

```bash
make hooks
```

## Code guidelines

- Keep contributions:

small
focused
readable
well explained
Prefer simple shell scripts over complex logic.
The goal of the project is clarity and defensive tooling, not heavy frameworks.

## Areas where contributions are welcome

Pattern improvements
Improve the detection patterns used by redflag-scan.sh.

Examples:
better detection of sensitive tokens
reducing false positives
detecting additional metadata exposure patterns

## JSON output improvements

Enhance the --json mode:

Examples:
include line numbers as structured fields
add severity levels
add pattern identifiers

## Ignore system

Improve .redflagignore behavior:

Examples:
support glob patterns
support negation rules
better directory handling

## Reporting features

Extend the repository reporting functionality.

Examples:
JSON reports
CSV output
summary statistics

## Documentation

Documentation improvements are very valuable.

Examples:
new examples of metadata exposure
safe sharing workflows
additional security notes

## Submitting changes

1. Create a new branch:
```bash
git checkout -b my-feature
```
2. Run checks before committing:
```bash
make check
```
3. Commit with a clear message:
```bash
git commit -m "improve pattern detection"
```
4. Push your branch and open a pull request.

## Security considerations

This project aims to reduce accidental disclosure, not to replace full secret-scanning solutions.

Contributions should focus on:
practical detection
low false positives
developer-friendly workflows

## Code of conduct

Be respectful and constructive.
Security discussions should focus on improving defensive practices.
