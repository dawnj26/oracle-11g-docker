FROM oraclelinux:7-slim

LABEL maintainer="Donn Jayson Quinto <jaysonquinto1@outlook.com>"

RUN groupadd -f dba && \
    useradd -m -g dba oracle || true

# Set up environment variables required by Oracle
ENV ORACLE_PATH=/u01/app/oracle
ENV ORACLE_HOME=$ORACLE_PATH/product/11.2.0/xe
ENV ORACLE_SID=XE
ENV SCRIPT_PATH=$ORACLE_PATH/scripts
ENV PATH=$ORACLE_HOME/bin:$SCRIPT_PATH:$PATH
ENV STARTUP_DIR=$SCRIPT_PATH/startup
ENV IMPORT_DIR=$SCRIPT_PATH/imports

# Install necessary legacy dependencies required by Oracle 11g XE
RUN yum install -y unzip libaio bc net-tools initscripts && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN mkdir -p $STARTUP_DIR
RUN mkdir -p $IMPORT_DIR
RUN mkdir -p $SCRIPT_PATH

# Create directory for installation files
WORKDIR /tmp

COPY ./assets/oracle-xe-11.2.0-1.0.x86_64.rpm.zip /tmp

# Unzip and extract the RPM package
RUN unzip oracle-xe-11.2.0-1.0.x86_64.rpm.zip

# Copy the silent installation response file into the container
COPY ./assets/oracle-xe.rsp $ORACLE_PATH

# Copy the startup/entrypoint script
COPY ./install $STARTUP_DIR

RUN touch /etc/sysconfig/network

# Create the Oracle data directory and set permissions
RUN mkdir $ORACLE_PATH/oradata
RUN chown -R oracle:dba $ORACLE_PATH

# Install the Oracle XE RPM package silently
RUN rpm -ivh /tmp/Disk1/oracle-xe-11.2.0-1.0.x86_64.rpm

# Clean up installation files
RUN rm -rf /tmp/*

COPY ./scripts $SCRIPT_PATH

RUN chmod ug+x $SCRIPT_PATH/* && \
    chmod ug+x $STARTUP_DIR/*

# Copy the startup/entrypoint script
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

EXPOSE 1521
EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
