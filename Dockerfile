FROM openjdk:latest

# possible maven versions 
# 3.0.5
# 3.1.1
# 3.2.5
# 3.3.9
# 3.5.2
ARG MVN_VER
RUN test -n "$MVN_VER"
ENV VERSION=${MVN_VER}

COPY inception.sh /tmp/

RUN mkdir /opt/maven && cd /opt/maven && wget -q http://apache.mirror.amaze.com.au/maven/maven-3/$VERSION/binaries/apache-maven-$VERSION-bin.tar.gz && gunzip * && tar xvpf *;rm -f *.tar;cat /tmp/inception.sh >> /root/.bashrc;rm /tmp/inception.sh
