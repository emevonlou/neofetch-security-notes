## Why I Care About This

In security, we often focus on big vulnerabilities.
But exposure is sometimes quieter.
It happens slowly. It happens through aggregation. It happens through details we did not think mattered.
A single field is rarely dangerous.
Aggregation is.
This repository explores that boundary between convenience and caution.

## What You Will Find Here

A defensive threat model for system metadata exposure
Practical guidelines for responsible disclosure
Lightweight sanitization tools
Pattern detection helpers to flag potentially sensitive information
A mindset focused on reducing correlation surface
The tools included here are intentionally simple.
They are not designed to hide everything. They are designed to encourage pause and awareness before publishing technical output.

- They can be used to sanitize:

Neofetch output
Terminal captures
Debug logs
Configuration snippets
Any text containing system metadata

## Core Principle

Share only what is necessary.
Generalize when possible.
Redact identifiable elements.
Reduce long-term correlation risk.

Security is not only about defense against attacks.
It is also about mindful disclosure.

