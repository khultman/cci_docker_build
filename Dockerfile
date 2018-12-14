FROM alpine:latest
LABEL maintainer="khultman@gmail.com"


# Runtime arguments
ARG BUILD_DATE

# Container Labels
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.name="khultman/cci-terraform"
LABEL org.label-schema.version=$BUILD_VERSION


RUN apk add --no-cache --update \
		ca-certificates git bash openssh go tar gzip python3 curl

ADD --chown=root:root https://github.com/gruntwork-io/terragrunt/releases/download/v0.17.3/terragrunt_linux_amd64 /usr/bin/terragrunt

RUN chmod 755 /usr/bin/terragrunt

ADD https://releases.hashicorp.com/terraform/0.11.10/terraform_0.11.10_linux_amd64.zip /tmp/terraform_0.11.10_linux_amd64.zip
RUN cd /tmp && unzip terraform_0.11.10_linux_amd64.zip && mv terraform /usr/bin/terraform && rm -f terraform_0.11.10_linux_amd64.zip

RUN curl -s -L https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl -o /usr/bin/kubectl \
    && chmod 755 /usr/bin/kubectl

RUN mkdir /terraform
