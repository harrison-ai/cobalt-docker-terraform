# harrison-ai-terraform-docker
Lightweight Docker image including Terraform CLI and AWS CLI

## 💡 Motivation
Our goal is to create a **minimalist** and **lightweight** Docker image with the tools listed below in order to reduce network and storage impact.

## 🔧 What's inside ?

The image is based on the [official Python 3 Docker image](https://hub.docker.com/_/python), with the following additional tools included:

* [Terraform CLI](https://www.terraform.io/docs/commands/index.html)
* [AWS CLI](https://aws.amazon.com/cli/)
* [Git](https://git-scm.com/)

## 🚀 Usage

To launch the Terraform CLI:

```bash
docker run -it -v ${PWD}:/workspace harrisonai/terraform:latest
```

## 📖 License
This project is licensed under [Apache License 2.0](https://raw.githubusercontent.com/harrison-ai/harrison-ai-terraform-docker/master/LICENSE)
