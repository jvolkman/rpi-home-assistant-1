FROM blakeblackshear/rpi-python:3.5
MAINTAINER Blake Blackshear <blakeb@blakeshome.com>

# Base layer
ENV ARCH=arm
ENV CROSS_COMPILE=/usr/bin/
ENV HA_VERSION=0.36.1

VOLUME /config

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install some packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget sudo git libpq-dev \
            libffi-dev libjpeg-dev libmysqlclient-dev

ADD https://raw.githubusercontent.com/home-assistant/home-assistant/${HA_VERSION}/script/setup_docker_prereqs script/setup_docker_prereqs
ADD https://raw.githubusercontent.com/home-assistant/home-assistant/${HA_VERSION}/script/build_python_openzwave script/build_python_openzwave
ADD https://raw.githubusercontent.com/home-assistant/home-assistant/${HA_VERSION}/script/build_libcec script/build_libcec

RUN chmod +x script/setup_docker_prereqs && \
    script/setup_docker_prereqs

RUN mkdir -p /usr/local/share/python-openzwave && \
    ln -sf /usr/src/app/build/python-openzwave/openzwave/config /usr/local/share/python-openzwave/config

# Install home assistant requirements
ADD https://raw.githubusercontent.com/home-assistant/home-assistant/${HA_VERSION}/requirements_all.txt requirements_all.txt
RUN pip3 install --no-cache-dir -r requirements_all.txt && \
    pip3 install --no-cache-dir mysqlclient psycopg2 uvloop colorlog

# Install Home Assistant
RUN pip3 install homeassistant==${HA_VERSION}

# cleanup
RUN rm -rf ~/.cache/pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* build/

# Start Home Assistant
CMD [ "python3", "-m", "homeassistant", "--config", "/config" ]
