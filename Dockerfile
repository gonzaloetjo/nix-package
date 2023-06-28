# Use Python 3.9 as the base image
FROM python:3.9

# Install necessary packages
RUN echo "krb5-config krb5-config/default_realm string" | debconf-set-selections && \
    echo "krb5-config krb5-config/kerberos_servers string" | debconf-set-selections && \
    echo "krb5-config krb5-config/admin_server string" | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y \
        tar \
        krb5-user \
        libkrb5-dev \
        gcc \
        graphviz \
        graphviz-dev \
        curl \
        libpq-dev \
        libffi-dev \
        make \
        libsasl2-dev \
        libbz2-dev \
        libsqlite3-dev \
        xz-utils \
        libssl-dev \
        unixodbc-dev \
        libldap2-dev \
        python3-ldap \
        unzip \
        jq && \
    apt-get clean
WORKDIR /app

COPY constraints-3.9.txt .
COPY docker-context-files/check_dependencies.py /app/check_dependencies.py

RUN python3.9 -m venv /venv
ENV PATH="/venv/bin:$PATH"

RUN python3.9 -m pip install --upgrade pip wheel --no-cache-dir
RUN python3.9 -m pip download wheel

RUN python3.9 -m pip install --no-cache-dir \
    setuptools-rust \
    Cython \
    opsgenie-sdk \
    psutil \
    psycopg2-binary \
    pyarrow \
    wheel

RUN python3.9 -m pip install pipdeptree

RUN python3.9 -m pip download -r constraints-3.9.txt \
    --find-links=. \
    "apache-airflow==2.6.1"

RUN python3.9 -m pip install --no-cache-dir --no-binary=:all: gssapi krb5 pykerberos pyodbc python-ldap sasl

RUN python3.9 -m pip install -r constraints-3.9.txt \
    --no-index \
    --find-links=. \
    "apache-airflow[celery,hive,redis]==2.6.1"

RUN python3.9 -m pip install \
    kerberos \
    flower \
    apache-airflow-providers-apache-hdfs \
    apache-airflow-providers-apache-spark
