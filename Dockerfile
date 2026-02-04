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
RUN pwsh -Command "Set-PSRepository -Name 'PSGallery' -InstallationPolicy 'Trusted'; \
    Install-Module -Name 'Az.Accounts' -Scope AllUsers -Force; \
    Install-Module -Name 'Az.PolicyInsights' -Scope AllUsers -Force; \
    Install-Module -Name 'EnterprisePolicyAsCode' -Scope AllUsers -Force;"

WORKDIR /github/workspace