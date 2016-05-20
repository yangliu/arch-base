FROM base/archlinux:2015.06.01
MAINTAINER yangliu <i@yangliu.name>

# add setup scripts
ADD setup/init.sh /root/

# initilize
RUN chmod +x /root/init.sh && \
    /bin/bash /root/init.sh

# Set Environment Varibles
ENV TERM xterm
ENV LANG en_US.UTF-8

ENV HOME /home/nobody