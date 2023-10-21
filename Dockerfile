FROM xinchar/debian:latest


ENV DEBIAN_FRONTEND=noninteractive

RUN apt update -y \
    && apt install -y bash python3 python3-pip python3-setuptools git

RUN pip install wheel --break-system-packages \
    && pip install supervisor --break-system-packages \
    && pip install git+https://github.com/coderanger/supervisor-stdout --break-system-packages


COPY ./requirements.txt /root/

RUN cd /root && pip install -r requirements.txt --break-system-packages
    

# Clean up 
RUN apt clean \
    && apt autoremove \
    && rm -rf /var/lib/apt/lists/*

# Supervisor config
RUN mkdir -p /etc/supervisord.d
COPY ./supervisord.conf /etc/supervisord.conf


CMD ["/usr/local/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]