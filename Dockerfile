FROM ubuntu:rolling

ENV USER=code
ENV UID=1000
ENV GID=1000

ENV TZ=Europe/Vienna
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN mkdir /run/sshd
COPY entrypoint.sh /

RUN apt-get update && apt-get install -y curl
RUN curl https://apt.releases.teleport.dev/gpg \
  -o /usr/share/keyrings/teleport-archive-keyring.asc

RUN export VERSION_CODENAME=jammy && echo "deb [signed-by=/usr/share/keyrings/teleport-archive-keyring.asc] \
  https://apt.releases.teleport.dev/ubuntu ${VERSION_CODENAME?} stable/v15" \
  | tee /etc/apt/sources.list.d/teleport.list > /dev/null

RUN apt-get update && apt-get upgrade -y && apt-get install -y git wget python3 python3-pip sudo teleport openssh-server
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10

EXPOSE 22
EXPOSE 8080

VOLUME ["/data"]
VOLUME ["/home"]
CMD ["/entrypoint.sh"]
