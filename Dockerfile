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

SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Install Azure PowerShell modules and EnterprisePolicyAsCode module
RUN Set-PSResourceRepository -Name "PSGallery" -Trusted

ARG AZ_ACCOUNTS_VERSION=*
RUN Install-PSResource -Name "Az.Accounts" -Version $env:AZ_ACCOUNTS_VERSION -Scope AllUsers -TrustRepository

ARG AZ_POLICYINSIGHTS_VERSION=*
RUN Install-PSResource -Name "Az.PolicyInsights" -Version $env:AZ_POLICYINSIGHTS_VERSION -Scope AllUsers -TrustRepository

ARG EPAC_VERSION=*
RUN Install-PSResource -Name "EnterprisePolicyAsCode" -Version $env:EPAC_VERSION -Scope AllUsers -TrustRepository

RUN Import-Module Az.Accounts, Az.PolicyInsights, EnterprisePolicyAsCode

WORKDIR /github/workspace

COPY initialize.ps1 /initialize.ps1
RUN chmod +x /initialize.ps1