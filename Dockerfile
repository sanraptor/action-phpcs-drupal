FROM php:7.4-alpine

# tools
ENV REVIEWDOG_VERSION=v0.11.0
ENV PHPCS_VERSION=3.5.6

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

# rulesets
# https://www.drupal.org/project/coder
ENV RULESET_DRUPAL_CODER_VERSION=8.3.11

# hadolint ignore=DL3006
RUN apk --no-cache add git

# tools
RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}
RUN wget -P /usr/local/bin -q https://github.com/squizlabs/PHP_CodeSniffer/releases/download/${PHPCS_VERSION}/phpcs.phar
RUN chmod +x /usr/local/bin/phpcs.phar

# rulesets
RUN mkdir -p /tmp/rulesets
RUN wget -O - -q https://ftp.drupal.org/files/projects/coder-${RULESET_DRUPAL_CODER_VERSION}.tar.gz | tar zxv -C /tmp/rulesets --strip-components 2 --wildcards-match-slash --wildcards '*/Drupal*'

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
