FROM rockylinux:8.5

# Variables
ARG ANSIBLE_VERSION=2.10
ARG GOTASK_VERSION=3.10.0
ARG TERRAFORM_VERSION=1.1.3

## Install Ansible
RUN yum groupinstall -y "Development Tools"
RUN yum install -y python3 python3-devel
RUN pip3 install --upgrade pip
RUN pip3 install --no-cache-dir --user ansible==${ANSIBLE_VERSION}

## Install Ansible python requirements
ADD .devcontainer/requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir --user -r /tmp/requirements.txt

## Install Terraform
ADD https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip /tmp/
RUN unzip /tmp/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && mv terraform /usr/local/bin/terraform \
    && chmod +x /usr/local/bin/terraform \
    && rm /tmp/terraform_${TERRAFORM_VERSION}_linux_amd64.zip

## Install go-task
ADD https://github.com/go-task/task/releases/download/v${GOTASK_VERSION}/task_linux_amd64.tar.gz /tmp/
RUN tar -xzf /tmp/task_linux_amd64.tar.gz \
    && mv task /usr/local/bin/task \
    && chmod +x /usr/local/bin/task \
    && rm /tmp/task_linux_amd64.tar.gz

## Install zsh & oh-my-zsh
RUN yum install -y wget zsh
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh


## Install AWS tools
RUN pip3 install --no-cache-dir --user awscli awsume
ENV PATH="/root/.local/bin:${PATH}"

ENTRYPOINT ["/bin/zsh"]
