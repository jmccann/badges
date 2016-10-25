# Docker image for the badges app
#
#     docker build --rm=true -t jmccann/badges .

FROM phusion/passenger-ruby23:0.9.19

CMD ["/sbin/my_init"]
WORKDIR /opt/app

# Enable nginx/passenger
RUN rm -f /etc/service/nginx/down

# Copy over nginx config
RUN rm /etc/nginx/sites-enabled/default
ADD webapp.conf /etc/nginx/sites-enabled/webapp.conf

# Install permanent packages
RUN apt update && \
    apt install -y imagemagick libpq-dev && \
    apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install and remove packages required for gem installation and install gems
RUN echo 'gem: --no-rdoc --no-ri' > ~/.gemrc
COPY Gemfile /opt/app/Gemfile
RUN apt update && \
    apt install -y libmagick++-dev postgresql-server-dev-all && \
    bundle install --without development test && \
    apt purge -y libmagick++-dev postgresql-server-dev-all && \
    apt autoremove -y && \
    apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Generate font list for ImageMagick
ADD http://www.imagemagick.org/Usage/scripts/imagick_type_gen /root/imagick_type_gen
RUN apt update && \
    apt install -y mlocate && \
    updatedb && \
    perl /root/imagick_type_gen > /etc/ImageMagick-6/type.xml && \
    apt purge -y mlocate && \
    apt autoremove -y && \
    apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy over app
ADD app-env.conf /etc/nginx/main.d/app-env.conf
COPY config.ru /opt/app/config.ru
COPY lib /opt/app/lib
RUN chown -R app /opt/app
