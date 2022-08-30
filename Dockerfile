FROM debian:bullseye-slim as builder

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install --no-install-recommends -y \
  ca-certificates \
  curl \
  unzip && \
  rm -rf /var/lib/apt/lists/*

ARG TERRAFORM=1.2.5
RUN curl "https://releases.hashicorp.com/terraform/${TERRAFORM}/terraform_${TERRAFORM}_linux_amd64.zip" -o /tmp/terraform.zip && \
    unzip -q /tmp/terraform.zip -d /usr/local/bin && \
    chmod +x /usr/local/bin/terraform && \
    rm -f /tmp/terraform.zip

ARG AWS=2.7.18
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS}.zip" -o "/tmp/awscliv2.zip" && \
    unzip -q /tmp/awscliv2.zip -d /tmp && \
    /tmp/aws/install && \
    rm -rf /tmp/aws /tmp/awscliv2.zip

ARG KUBE=1.22.12
RUN curl -LO "https://dl.k8s.io/release/v${KUBE}/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin

FROM python:3-slim-bullseye

ARG DEBIAN_FRONTEND=noninteractive

COPY --from=builder /usr/local/bin/terraform /usr/local/bin/terraform
COPY --from=builder /usr/local/aws-cli /usr/local/aws-cli
COPY --from=builder /usr/local/bin/kubectl /usr/local/bin/kubectl
COPY scripts/awskube.sh /usr/local/bin/awskube

RUN ln -s /usr/local/aws-cli/v2/current/dist/aws /usr/local/bin/aws && \
    apt-get update && \
    apt-get install --no-install-recommends -y \
    openssh-client \
    git && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

ENTRYPOINT ["terraform"]
