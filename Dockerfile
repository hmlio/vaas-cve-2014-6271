FROM debian:buster
MAINTAINER Emre Bastuz <info@hml.io>

# Environment
ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
ENV LANGUAGE C.UTF-8
ENV LC_ALL C.UTF-8

# Get current
RUN apt-get update -y && apt-get dist-upgrade -y

# Install packages
RUN apt-get install -y wget apache2 libtinfo5

# Install vulnerable bash version from wayback/snapshot archive
RUN wget http://snapshot.debian.org/archive/debian/20130101T091755Z/pool/main/b/bash/bash_4.2%2Bdfsg-0.1_amd64.deb -O /tmp/bash_4.2+dfsg-0.1_amd64.deb && \
 dpkg -i /tmp/bash_4.2+dfsg-0.1_amd64.deb


# Setup vulnerable web content
ADD index.html /var/www/html/
ADD stats /usr/lib/cgi-bin/
RUN cd /etc/apache2/mods-enabled && ln -s ../mods-available/cgi.load
RUN chown www-data:www-data /usr/lib/cgi-bin/stats && \
 chmod u+x /usr/lib/cgi-bin/stats

# Clean up
RUN apt-get autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose the port for usage with the docker -P switch
EXPOSE 80

# Run Apache 2
CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]

#
# Dockerfile for vulnerability as a service - CVE-2014-6271
# Vulnerable web application derived from Sokar - a VulnHub machine by rasta_mouse
#
