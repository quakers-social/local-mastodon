# Releases: https://github.com/mastodon/mastodon/pkgs/container/mastodon
FROM ghcr.io/mastodon/mastodon:v4.2.7

USER root

RUN apt-get install -y vim
RUN sed -i '/^  config.force_ssl.*$/s/^/#/' config/environments/production.rb
