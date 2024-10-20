# Nefarious Development Container Templates

[![Release Devcontainer Templates](https://github.com/The-Nefarious-Developer/devcontainer-templates/actions/workflows/release.yaml/badge.svg)](https://github.com/The-Nefarious-Developer/devcontainer-templates/actions/workflows/release.yaml)
[![Update Documentation](https://github.com/The-Nefarious-Developer/devcontainer-templates/actions/workflows/update-documentation.yaml/badge.svg)](https://github.com/The-Nefarious-Developer/devcontainer-templates/actions/workflows/update-documentation.yaml)
[![Test Latest Updated Templates](https://github.com/The-Nefarious-Developer/devcontainer-templates/actions/workflows/test-pr.yaml/badge.svg)](https://github.com/The-Nefarious-Developer/devcontainer-templates/actions/workflows/test-pr.yaml)
[![semantic-release: angular](https://img.shields.io/badge/semantic--release-angular-e10079?logo=semantic-release)](https://github.com/semantic-release/semantic-release)

 This repository provides a set of ready-to-use devcontainer templates that you can integrate directly into your Visual Studio Code environment. These templates are particularly useful for SAP developers who want to set up a consistent development environment across different projects without hassle.

> The devcontainer templates created from this project make use of the Docker container images provided through the [`devcontainer-images`](https://github.com/The-Nefarious-Developer/devcontainer-images) repository. 

If you have any question, suggestion or request regarding what this repository can offer, you can use this [discussion area](https://github.com/orgs/The-Nefarious-Developer/discussions).

## Available Templates

Ths repository generates the following devcontainer templates:

| Template                  | Image                                                                                                                                                                            |
|---------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| sap-cap-javascript-node   | [ghcr.io/the-nefarious-developer/sap-cap-javascript-node:{VERSION}](https://github.com/The-Nefarious-Developer/devcontainer-images/pkgs/container/sap-cap-javascript-node)   |

## Content

- [`src`](src) - Contains reusable dev container templates.
- [`test`](test) - Contains the test suite for each provided template.

## Prerequisites

To use the devcontainer templates provided in this repository, you will need:

- [Docker](https://www.docker.com/get-started) installed on your system.
- [Visual Studio Code](https://code.visualstudio.com/) with the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers).

## How it works

The directories inside the [`src`](src) folder will contain the files that will compose the templates to be created. 

Each template folder will have the following structure:
- **.devcontainer**: Folder which is going to contain the `devcontainer.json` with properties, dependencies and the container image to be referenced by the template. 
- **devcontainer-template.json** Configuration file that define key metadata and attributes for the container environment.

Whenever a change in the template happens, the `update-documentation.yaml` pipeline will be triggered and a new pull request will be created to update the `README.md` file inside each template directory. This new document will be composed by metadata defined in the `devcontainer-template.json` and the content described in the `NOTES.md` file. 

## Testing

Each template needs to have a test implementation. The testing operations in this project follows the harness test strategy applied at their own [container images](https://github.com/The-Nefarious-Developer/devcontainer-images), which can be leveraged in case of new template implementations.

> **Note:** The lack of test implementation might cause the CI/CD pipeline to fail.

### Testing locally

To test the templates locally, the environment variable `VARIANT` need to be set prior to the bash file execution.

Template for command to run the test locally:

```
VARIANT=<upstream version> test/<template>/test.sh
```

The [`package.json`](package.json) file contains an example of local testing through the script `test:local`.

## How can I contribute?

Contributions are welcome! Here's how you can get involved:

1. **Report Issues:** Found a bug or have a feature request? [Open an issue](https://github.com/The-Nefarious-Developer/devcontainer-templates/issues). <br />
2. **Submit Pull Requests:** Fork the repository, create a new branch, make your changes, and submit a PR. <br />
3. **Improve Documentation:** Help us improve the README or add examples to make setup easier. <br />
4. **Test & Feedback:** Try the devcontainer template and give us feedback to improve them.

Please follow the [contribution guidelines](CONTRIBUTING.md) for more details.

## References

The development container images used by these templates can be found at [devcontainer-images](https://github.com/The-Nefarious-Developer/devcontainer-images) repository.

These templates were created following the guidelines provided through the [devcontainers/template-starter](https://github.com/devcontainers/template-starter) and [devcontainers/templates](https://github.com/devcontainers/templates).

## License
Copyright (c) 2024 The Nefarious Developer <br />
Licensed under the MIT License. See [LICENSE](LICENSE).