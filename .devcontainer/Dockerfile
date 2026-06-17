FROM mcr.microsoft.com/devcontainers/python:3.11-bookworm

USER root

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
