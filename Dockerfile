# Docker image for the badges app
#
#     docker build --rm=true -t jmccann/badges .

FROM gliderlabs/alpine:3.2
EXPOSE 9292

RUN apk-install ca-certificates
RUN echo 'gem: --no-rdoc --no-ri' > ~/.gemrc

COPY config.ru /opt/app/config.ru
COPY Gemfile /opt/app/Gemfile

WORKDIR /opt/app

# Install packages we keep
RUN apk update && \
    apk add ruby ruby-bundler ruby-io-console sqlite-libs imagemagick ttf-dejavu && \
    rm -rf /var/cache/apk/*

# Install gems
#   1. Install packages needed to install gems
#   2. Install gems
#   3. Remove packages as they are no longer needed
RUN apk update && \
    apk add alpine-sdk openssl-dev ruby-dev openssl-dev sqlite-dev imagemagick-dev && \
    bundle install --without development test && \
    apk -U --purge del alpine-sdk openssl-dev ruby-dev openssl-dev sqlite-dev imagemagick-dev && \
    rm -rf /var/cache/apk/*

# Configure ImageMagick to find installed fonts
#   1. Download helper script
#   2. Install packages required for script to function
#   3. Run script to generate the config
#   4. Remove packages required for the script as they are no longer needed
ADD http://www.imagemagick.org/Usage/scripts/imagick_type_gen /opt/app/imagick_type_gen
RUN apk update && \
    apk add findutils perl && \
    updatedb && \
    perl imagick_type_gen > /usr/lib/ImageMagick-6.9.1/config-Q16/type.xml && \
    apk -U --purge del findutils perl && \
    rm -rf /var/cache/apk/*

# Copy app
COPY lib /opt/app/lib

# Run the app
CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "config.ru"]
