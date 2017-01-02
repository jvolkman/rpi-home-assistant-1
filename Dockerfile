FROM blakeblackshear/rpi-python:3.5
MAINTAINER Blake Blackshear <blakeb@blakeshome.com>

# Base layer
ENV ARCH=arm
ENV CROSS_COMPILE=/usr/bin/
ENV HA_VERSION=0.35.3

# add repo for telldus
RUN echo "deb http://download.telldus.com/debian/ stable main" >> /etc/apt/sources.list.d/telldus.list && \
    wget -qO - http://download.telldus.se/debian/telldus-public.key | apt-key add -

# Install some packages
RUN apt-get install -y --no-install-recommends wget nmap net-tools cython3 libudev-dev \
            sudo libglib2.0-dev bluetooth libbluetooth-dev git \
            libtelldus-core2 libffi-dev libjpeg-dev libmysqlclient-dev

# Install openzwave
RUN pip3 install cython==0.24.1
ADD https://raw.githubusercontent.com/home-assistant/home-assistant/${HA_VERSION}/script/build_python_openzwave script/build_python_openzwave
RUN chmod +x script/build_python_openzwave && \
    script/build_python_openzwave
RUN mkdir -p /usr/local/share/python-openzwave && \
    ln -sf /usr/src/app/build/python-openzwave/openzwave/config /usr/local/share/python-openzwave/config

# Install home assistant requirements
ADD https://raw.githubusercontent.com/home-assistant/home-assistant/${HA_VERSION}/requirements_all.txt requirements_all.txt
RUN pip3 install -r requirements_all.txt && \
    pip3 install mysqlclient psycopg2 uvloop colorlog

# Install Home Assistant
RUN pip3 install homeassistant==${HA_VERSION}

# cleanup
RUN rm -rf ~/.cache/pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Start Home Assistant
CMD [ "python3", "-m", "homeassistant", "--config", "/config" ]
