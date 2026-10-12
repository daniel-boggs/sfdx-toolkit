# SFDX Toolkit

A growing collection of reusable Salesforce Apex utilities, Lightning Web Components, and development tools.

Each project is organized independently, making it easy to explore, understand, and deploy individual solutions without importing the entire repository.

## Projects

| Project | Description | Technology |
|---|---|---|
| [Apex Logger](projects/logger/) | Lightweight logging utility featuring structured messages, interpolation, execution context, and governor-limit monitoring. | Apex |

More projects will be added as they become available.

## Getting Started

### Requirements

- Visual Studio Code with Salesforce extensions (recommended)
- Salesforce CLI
- Access to a Salesforce org with Apex support

### Clone the Repository

```bash
git clone https://github.com/d-boggs/sfdx-toolkit.git
cd sfdx-toolkit
```

### Authenticate with Salesforce

```bash
sf org login web --set-default
```

### Deploy a Project

Each project can be deployed individually.

For example, deploy Apex Logger:

```bash
sf project deploy start --source-dir projects/logger/main/default/classes
```

Refer to the individual project documentation for features, usage examples, and requirements.

## Repository Structure

```text
sfdx-toolkit/
├── projects/
│   └── logger/
│       ├── README.md
│       └── main/
│           └── default/
│               └── classes/
├── README.md
└── sfdx-project.json
```

Projects follow Salesforce DX source conventions while remaining independently organized.

## About

This is my personal collection of Salesforce projects, utilities, and components I've built. Most started because I needed something, couldn't find a solution I liked, or figured I could build a better one.

I've decided to clean them up, organize them, and share them with other developers who might find them useful.

This repository is independent of Salesforce, any company, or Salesforce Partner. It's simply my work, shared with the developer community.

New projects and improvements will be added over time.