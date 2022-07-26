FROM debian:bullseye-slim as builder

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install --no-install-recommends -y \
  ca-certificates \
  curl \
  unzip && \
  rm -rf /var/lib/apt/lists/*

ARG TERRAFORM_VERSION=1.2.5
RUN curl "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o /tmp/terraform.zip && \
    unzip -q /tmp/terraform.zip -d /usr/local/bin && \
    chmod +x /usr/local/bin/terraform && \
    rm -f /tmp/terraform.zip

ARG AWS_VERSION=2.7.18
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_VERSION}.zip" -o "/tmp/awscliv2.zip" && \
    unzip -q /tmp/awscliv2.zip -d /tmp && \
    /tmp/aws/install && \
    rm -rf /tmp/aws /tmp/awscliv2.zip

ARG KUBE_VERSION=1.22.12
RUN curl -LO "https://dl.k8s.io/release/v${KUBE_VERSION}/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin

FROM python:3-slim-bullseye

ARG DEBIAN_FRONTEND=noninteractive

COPY --from=builder /usr/local/bin/terraform /usr/local/bin/terraform
COPY --from=builder /usr/local/aws-cli /usr/local/aws-cli
COPY --from=builder /usr/local/bin/kubectl /usr/local/bin/kubectl

RUN ln -s /usr/local/aws-cli/v2/current/dist/aws /usr/local/bin/aws && \
    apt-get update && \
    apt-get install --no-install-recommends -y \
    curl \
    openssh-client \
    git && \
    rm -rf /var/lib/apt/lists/*

RUN ssh-keyscan github.com 2>/dev/null > /etc/ssh/ssh_known_hosts

WORKDIR /app

ENTRYPOINT ["terraform"]
