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

RUN apk update && \
    apk add alpine-sdk openssl-dev ruby-dev openssl-dev sqlite-dev imagemagick-dev \
            ruby ruby-bundler ruby-io-console sqlite-libs imagemagick \
            ttf-dejavu && \
    bundle install --without development test && \
    apk -U --purge del alpine-sdk openssl-dev ruby-dev openssl-dev sqlite-dev imagemagick-dev && \
    rm -rf /var/cache/apk/*

ADD http://www.imagemagick.org/Usage/scripts/imagick_type_gen /opt/app/imagick_type_gen

RUN apk update && \
    apk add findutils perl && \
    updatedb && \
    perl imagick_type_gen > /usr/lib/ImageMagick-6.9.1/config-Q16/type.xml && \
    apk -U --purge del findutils perl && \
    rm -rf /var/cache/apk/*

COPY lib /opt/app/lib

CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "config.ru"]
