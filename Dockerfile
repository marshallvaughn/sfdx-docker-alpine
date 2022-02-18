# TITLE: alpine/build
# Container image that runs your code
FROM alpine:latest

ARG SALESFORCE_CLI_VERSION=latest-rc

RUN apk add --update --no-cache git openssh ca-certificates openssl
RUN apk add --no-cache bash
RUN apk add --no-cache curl vim
RUN apk add --update nodejs npm jq

# Set XDG environment variables explicitly so that GitHub Actions does not apply
# default paths that do not point to the plugins directory
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
ENV XDG_DATA_HOME=/sfdx_plugins/.local/share
ENV XDG_CONFIG_HOME=/sfdx_plugins/.config
ENV XDG_CACHE_HOME=/sfdx_plugins/.cache

RUN export XDG_DATA_HOME && \
  export XDG_CONFIG_HOME && \
  export XDG_CACHE_HOME

# Install sfdx
RUN npm install --global sfdx-cli@${SALESFORCE_CLI_VERSION} --ignore-scripts

RUN echo 'y' | sfdx plugins:install sfdmu
RUN echo 'y' | sfdx plugins:install sfpowerkit
RUN echo 'y' | sfdx plugins:install @dxatscale/sfpowerscripts

ENV SFDX_DISABLE_AUTOUPDATE=true
ENV SFDX_USE_PROGRESS_BAR=false

SHELL [ "/bin/bash" ]
ENTRYPOINT /bin/bash
