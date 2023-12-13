# PowerShell Scripts for Project Basturma - CI/CD Pipelines for UiPath RPA

[![Run Tests on PowerShell Sample Scripts with Pester](https://github.com/rpapub/project-basturma-pipelines/actions/workflows/powershell-sample-scripts-test.yml/badge.svg)](https://github.com/rpapub/project-basturma-pipelines/actions/workflows/powershell-sample-scripts-test.yml)

## Introduction

Welcome to the PowerShell scripts section of the Project Basturma repository! This directory is focused on providing PowerShell tools and scripts that support the development and deployment of UiPath Robotic Process Automation (RPA) within CI/CD pipelines. Our aim is to facilitate the automation processes within UiPath RPA projects, ensuring that they are efficient, consistent, and seamlessly integrated into the broader CI/CD pipeline.

## Table of Contents

1. [Introduction](#introduction)
2. [Getting Started](#getting-started)
3. [PowerShell Modules](#powershell-modules)
   - [SemVerTools](#semvertools)
   - [Other Modules](#other-modules)
4. [Usage](#usage)
   - [Using SemVerTools](#using-semvertools)
   - [Using Other Modules](#using-other-modules)
5. [Contributing](#contributing)
6. [Reporting Issues and Requesting Changes](#reporting-issues-and-requesting-changes)
7. [Running Tests](#running-tests)
8. [CI/CD Integration](#cicd-integration)
9. [Versioning](#versioning)
10. [License](#license)
11. [Authors](#authors)
12. [Acknowledgments](#acknowledgments)

## Getting Started

To get started with Project Basturma, clone this repository to your local machine. Ensure you have PowerShell installed, as the scripts in this folder are primarily written in PowerShell for automation.

```bash
git clone https://github.com/rpapub/project-basturma-pipelines.git
cd project-basturma-pipelines/powershell
```

## PowerShell Modules

This repository includes various PowerShell modules to aid in automating deployment tasks.

### SemVerTools

A module designed for handling Semantic Versioning. It's crucial for version control in automation deployment.

### Other Modules

to be determined

## Usage

### Using SemVerTools

To use the SemVerTools module, import it into your PowerShell session:

```powershell
Import-Module ./src/SemVerTools/SemVerTools.psm1
```

### Using Other Modules

to be determined

## Contributing

Contributions are welcome!! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on the code of conduct and the process for submitting pull requests.

## Reporting Issues and Requesting Changes

### Bug Reports and Incidents

If you encounter any bugs or issues while using these scripts, please report them using the [GitHub Issues](https://github.com/rpapub/project-basturma-pipelines/issues) feature in this repository. When creating an issue, please provide:

- A clear and descriptive title.
- A detailed description of the problem, including steps to reproduce the issue.
- Any relevant logs or error messages.

### Feature Requests and Change Proposals

Suggestions for improvements or requests for new features are welcome. To propose a change or new feature, please use the [GitHub Issues](https://github.com/rpapub/project-basturma-pipelines/issues) feature:

- Provide a clear and descriptive title.
- Describe the feature or changes you propose, and how they would benefit the project.
- Include any additional context or screenshots if applicable.

## Running Tests

The tests are written using Pester.

To install Pester, you need to run PowerShell with administrative privileges. This is because installing modules system-wide requires admin permissions. Open PowerShell as an administrator and run the following command:

```powershell
Install-Module -Name Pester -Force -SkipPublisherCheck.
```

If you don't have administrative permissions or prefer not to install Pester system-wide, you can install it for the current user by adding the -Scope CurrentUser parameter:

```powershell
Install-Module -Name Pester -Force -SkipPublisherCheck -Scope CurrentUser
```

This will install Pester in your user profile, avoiding the need for administrative rights.

Run the tests with the following command:

```powershell
cd path\to\project-basturma-pipelines\scripts\powershell
Invoke-Pester .\tests\
```

## CI/CD Integration

to do

## Versioning

This repo uses Semantic Versioning for the modules. For more information, see [semver.org](https://semver.org/).

## License

This project is licensed under the Creative Commons Attribution 4.0 International License (CC BY 4.0). For more details, see the [LICENSE.md](../../LICENSE.md) file in the root directory of this repository.

## Authors

List of [contributors](https://github.com/rpapub/project-basturma-pipelines/graphs/contributors) who participated in this project.

## Acknowledgments

- todo

---

For more information or inquiries, please open an issue in the repository.
