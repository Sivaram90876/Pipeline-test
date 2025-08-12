FROM debian:stable-slim

# Install dependencies & clean up in one layer
# This includes the docker client (docker.io) and other tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    curl \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    conntrack \
    iptables \
    socat \
    git \
    docker.io \
    unzip \
    tar \
    bash \
 && rm -rf /var/lib/apt/lists/*

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
 && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
 && rm kubectl

# Install Minikube
RUN curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
 && install minikube-linux-amd64 /usr/local/bin/minikube \
 && rm minikube-linux-amd64

# Install CNI plugins (for --driver=none)
RUN curl -LO https://github.com/containernetworking/plugins/releases/download/v1.5.0/cni-plugins-linux-amd64-v1.5.0.tgz \
 && mkdir -p /opt/cni/bin \
 && tar -xzvf cni-plugins-linux-amd64-v1.5.0.tgz -C /opt/cni/bin \
 && rm cni-plugins-linux-amd64-v1.5.0.tgz

# Install Helm
RUN curl -fsSL https://get.helm.sh/helm-v3.15.3-linux-amd64.tar.gz -o helm.tar.gz \
 && tar -zxvf helm.tar.gz \
 && mv linux-amd64/helm /usr/local/bin/helm \
 && rm -rf linux-amd64 helm.tar.gz

# Create Jenkins user & give Docker permissions
RUN (getent group docker || groupadd -g 999 docker) && \
    useradd -m -u 1000 -g docker jenkins && \
    echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    usermod -aG docker jenkins

# Explicitly add /usr/bin to the PATH. This is essential for the `docker` command to be found.
ENV PATH="/usr/bin:${PATH}"

USER jenkins
WORKDIR /home/jenkins
