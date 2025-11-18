# Build stage - for compiling Phalcon extension
FROM php:8.4.14-fpm-bookworm AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    autoconf \
    && cd /tmp \
    && git clone --depth=1 --branch v5.9.3 https://github.com/phalcon/cphalcon.git \
    && cd cphalcon/build \
    && ./install \
    && find /usr/local/lib/php/extensions -name "phalcon.so" \
    && rm -rf /tmp/cphalcon \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Production stage - final image without git and build tools
FROM php:8.4-fpm-bookworm

LABEL org.opencontainers.image.title="PHP Phalcon Nginx Debian Stack"
LABEL org.opencontainers.image.version="php8.4.14-phc5.9.3-ng1.22.1-deb12.12"
LABEL org.opencontainers.image.authors="András Szabácsik <https://github.com/szabacsik>"

ENV DEBIAN_FRONTEND=noninteractive

# Install only runtime dependencies
RUN apt-get update && apt-get install -y \
    nginx \
    && mkdir -p /var/www/html \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy compiled Phalcon extension from builder stage
COPY --from=builder /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/
RUN echo "extension=phalcon.so" > /usr/local/etc/php/conf.d/50-phalcon.ini

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy configuration and public files
COPY ./configs/nginx.conf /etc/nginx/nginx.conf
COPY ./configs/php.ini /usr/local/etc/php/php.ini

COPY public/ /var/www/html/

COPY scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080

CMD ["/entrypoint.sh"]
