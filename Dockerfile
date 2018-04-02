# vim:set ft=dockerfile:
# Pull ubuntu image
FROM ubuntu:latest

# Install Oracle Java
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common python-software-properties curl &&\
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/oracle-jdk8-installer

# Define working directory.
# WORKDIR /data

# Define commonly used JAVA_HOME variable.
# ENV JAVA_HOME /usr/lib/jvm/java8-oracle

# Define default command.
# CMD ["bash"]

# Install Apache Spark
ENV spark_ver 2.2.1

# Download Apache Spark from US Apache mirror.
RUN mkdir -p /opt && \
    cd /opt && \
    curl http://www.us.apache.org/dist/spark/spark-${spark_ver}/spark-${spark_ver}-bin-hadoop2.7.tgz | \
        tar -zx && \
    ln -s spark-${spark_ver}-bin-hadoop2.7 spark && \
    echo Spark ${spark_ver} installed in /opt

# Configure Apache Spark as standalone mode
ADD start-common.sh start-worker.sh start-master.sh /
RUN chmod +x /start-common.sh /start-master.sh /start-worker.sh
ENV PATH $PATH:/opt/spark/bin 


       
