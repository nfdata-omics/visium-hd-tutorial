FROM mcr.microsoft.com/devcontainers/python:3.12-bookworm

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1=1.6* \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /tmp/requirements.txt

RUN pip install --no-cache-dir -r /tmp/requirements.txt

RUN curl -fsSL \
    https://github.com/hadolint/hadolint/releases/download/v2.14.0/hadolint-linux-x86_64 \
    -o /usr/local/bin/hadolint \
    && chmod +x /usr/local/bin/hadolint

RUN python -m ipykernel install \
    --name spatial-tutorial \
    --display-name "Python (spatial-tutorial)" \
    --sys-prefix

USER vscode
