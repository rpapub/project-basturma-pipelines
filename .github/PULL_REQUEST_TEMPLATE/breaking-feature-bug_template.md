---
name: Pull Request
about: Create a new pull request
title: "[bug] Your default PR title"
labels:
assignees:
---

## Description

Please provide a brief summary of the changes. If it's a new feature or bugfix, include the motivation behind it and any insights into the implementation.

## Semantic Versioning

Prefix your PR title with one of the following, indicating the type of change:

- `[breaking]` for major incompatible changes
- `[feature]` for added functionality in a backwards compatible manner
- `[bug]` for backwards compatible bug fixes

For example:

- `[bug]` Resolve Email Trigger Delays: Addresses an issue where an RPA process that should be triggered by an incoming email is delayed or not firing at all.
- `[feature]` Integrate Chatbot with Support Ticketing: Automates the process of a chatbot gathering preliminary information and then creating a ticket in a support system.
- `[breaking]` Transition to Unattended Robots: Refers to a shift from attended to unattended robots, which can run without human intervention.

## Checklist

- [ ] I have run tests (if applicable)
- [ ] I have added or updated documentation (if applicable)
- [ ] I have followed the [coding standards](LINK_TO_YOUR_CODING_STANDARDS)
