# EPAC Docker Image

This repository (https://github.com/LasseSkogland/epac-docker) builds a minimal Docker image for running Enterprise Policy as Code (EPAC) in GitHub Actions workflows. The image automatically detects and builds with the latest version of the EnterprisePolicyAsCode PowerShell module.

## What's inside

- Debian bookworm-slim base
- PowerShell (stable)
- Azure PowerShell modules: `Az.Accounts`, `Az.PolicyInsights`
- EPAC module: `EnterprisePolicyAsCode`

## Published image

Images are pushed to GHCR using the repository name:

- ghcr.io/lasseskogland/epac-docker

Tags include:
- `latest` - Updated weekly and on Dockerfile changes
- Full version (e.g., `11.1.1`)
- Major.minor version (e.g., `11.1`)
- Major version (e.g., `11`)

## Use in GitHub Actions

Reference the image in a job container or run it directly with Docker. Ensure your workflow has permissions to pull from GHCR if the repo is private.

## Build locally

Build the image from the repository root with Docker.

## License

See the repository license (if present).
