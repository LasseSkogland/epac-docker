FROM debian:bookworm-slim
ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

# Install dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install PowerShell
RUN source /etc/os-release \
    && wget -q https://packages.microsoft.com/config/debian/$VERSION_ID/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y --no-install-recommends powershell \
    && rm -rf /var/lib/apt/lists/*

# Install Azure PowerShell modules and EnterprisePolicyAsCode module
RUN pwsh -Command 'Set-PSResourceRepository -Name "PSGallery" -Trusted'

ARG AZ_ACCOUNTS_VERSION=*
RUN pwsh -Command 'Install-PSResource -Name "Az.Accounts" -Version $env:AZ_ACCOUNTS_VERSION -Scope AllUsers -TrustRepository'

ARG AZ_POLICYINSIGHTS_VERSION=*
RUN pwsh -Command 'Install-PSResource -Name "Az.PolicyInsights" -Version $env:AZ_POLICYINSIGHTS_VERSION -Scope AllUsers -TrustRepository'

ARG EPAC_VERSION=*
RUN pwsh -Command 'Install-PSResource -Name "EnterprisePolicyAsCode" -Version $env:EPAC_VERSION -Scope AllUsers -TrustRepository'

WORKDIR /github/workspace