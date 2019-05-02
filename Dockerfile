FROM ubuntu:16.04 as build

RUN apt-get update && apt-get install -y \
    wget \
    unzip \
  && rm -rf /var/lib/apt/lists/*

RUN wget --quiet https://releases.hashicorp.com/terraform/0.11.3/terraform_0.11.3_linux_amd64.zip \
  && unzip terraform_0.11.3_linux_amd64.zip \
  && mv terraform /usr/bin \
  && rm terraform_0.11.3_linux_amd64.zip

ENTRYPOINT ["tail", "-f", "/dev/null"]

CMD ["/bin/bash"]

FROM build

RUN wget --quiet https://releases.hashicorp.com/packer/1.4.0/packer_1.4.0_linux_amd64.zip \
  && unzip packer_1.4.0_linux_amd64.zip \
  && mv packer /usr/bin \
  && rm packer_1.4.0_linux_amd64.zip