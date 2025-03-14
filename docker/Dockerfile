FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y -q dialog apt-utils
RUN apt-get install -y locales locales-all
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8

ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get install -y tzdata openssh-server sudo bash-completion tree curl libguestfs-tools nano ifenslave ntp unzip zip mc screen gcc make wget curl telnet traceroute tcptraceroute sudo ntpdate psmisc autoconf libtool m4 automake bc netcat iputils-ping software-properties-common apt-transport-https
RUN apt-get install -y python3-distutils python3-apt
RUN curl https://bootstrap.pypa.io/get-pip.py | python3


RUN wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
RUN apt-get install -y code
RUN apt-get clean

RUN echo 'root:root123' | chpasswd

RUN mkdir /opt/jcollect/
ADD ../collect.py /opt/jcollect/collect.py
COPY /mnt/github/jcollect-sh/config.yaml /opt/jcollect/
COPY /mnt/github/jcollect-sh/jcollect-sh /opt/jcollect/

RUN /usr/bin/sed -i -e 's/PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN /usr/bin/sed -i -e 's/.*PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN service ssh start
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]



