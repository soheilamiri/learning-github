#how to run, 
#1-cd to location of this file "Dockerfile"
#2- run docker build command "docker build -t Reponame/Imagename:version-description ."

FROM repo.abris.cloud/ubuntu:resolute-20260707
ENV DEBIAN_FRONTEND=noninteractive

# copy internal CA certificates
COPY dockerfile/ubuntu-baseimage/*.crt /tmp/certs/

# bootstrap ssl trust store manually
#RUN mkdir -p /etc/ssl/certs && \
COPY dockerfile/ubuntu-baseimage/*.crt /usr/local/share/ca-certificates/


# remove default ubuntu repos (since you can't reach them)
RUN rm -f /etc/apt/sources.list.d/ubuntu.sources || true

# add internal repo
COPY dockerfile/ubuntu-baseimage/101-cloud.list /etc/apt/sources.list.d/101-cloud.list

# now apt can connect to your internal repo
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates && \
    update-ca-certificates
# install packages from internal repo
RUN apt-get update \
&& apt-get install -y --no-install-recommends \
ca-certificates \
vim \
curl \
wget \
nginx \
bash-completion \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

CMD ["nginx", "-g", "daemon off;"]