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
COPY db2jcc.jar /tmp/db2jcc.jar
COPY id_rsa /root/.ssh/id_rsa
COPY id_rsa.pub /root/.ssh/id_rsa.pub
COPY config /root/.ssh/config

RUN apt-get update && apt-get install -y --no-install-recommends apt-transport-https vim \
&& mkdir /opt/maven /opt/gradle && cd /opt/maven \
&& wget -q http://apache.mirror.amaze.com.au/maven/maven-3/$VERSION/binaries/apache-maven-$VERSION-bin.tar.gz \
&& gunzip * && tar xvpf *;rm -f *.tar;cat /tmp/inception.sh >> /root/.bashrc;rm /tmp/inception.sh;\
ln -sf /tmp/db2jcc.jar /tmp/db2jcc_license_cisuz-10.1.0.jar \
&& /opt/maven/apache-maven-$VERSION/bin/mvn install:install-file -Dfile=/tmp/db2jcc_license_cisuz-10.1.0.jar -DgroupId=com.ibm.db2.jcc -DartifactId=db2jcc_license_cisuz -Dversion=10.1.0 -Dpackaging=jar \
&& /opt/maven/apache-maven-$VERSION/bin/mvn install:install-file -Dfile=/tmp/db2jcc.jar -DgroupId=com.ibm.db2.jcc -DartifactId=db2jcc -Dversion=10.1.0 -Dpackaging=jar \
&& rm -f /tmp/db2jcc* \
&& chmod 700 /root/.ssh && chmod 644 /root/.ssh/id_rsa.pub && chmod 600 /root/.ssh/id_rsa \
&& cd /opt/gradle \
&& wget -q https://services.gradle.org/distributions/gradle-4.3.1-bin.zip \
&& unzip gradle-4.3.1-bin.zip && rm -f *.zip

WORKDIR /root
