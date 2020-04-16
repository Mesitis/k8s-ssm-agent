FROM amazonlinux:2

ARG KUBERNETES_VERSION=1.15.10
ARG DOCKER_VERSION=18.09.9

RUN yum update -y && \
    yum install -y systemd curl tar sudo iptables unzip nano git procps htop dnsutils && \
    yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    mkdir staging && \
    cd staging && \
    curl -L https://dl.k8s.io/v${KUBERNETES_VERSION}/kubernetes-client-linux-amd64.tar.gz -o temp.tgz && \
    tar zxvf temp.tgz && \
    mv kubernetes/client/bin/kubectl /usr/bin/kubectl && \
    curl -L https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz -o docker.tgz && \
    tar zxvf docker.tgz && \
    mv docker/{docker,runc} /usr/bin/ && \
    cd .. && \
    rm -rf staging

WORKDIR /opt/amazon/ssm/
CMD ["amazon-ssm-agent", "start"]
