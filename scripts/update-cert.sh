#!/bin/bash

SSL_DOMAIN=${SSL_DOMAIN:-ambientum.local}

CAROOT=${CAROOT:-/app/.mkcert}

SSL_LAST_DOMAIN=$(cat "${CAROOT}/last-domain" 2>/dev/null)

mkdir -p "${CAROOT}"
mkcert -install
mkcert -cert-file=/app/.mkcert/ssl_key.pem -key-file=/app/.mkcert/ssl_key.key "${SSL_DOMAIN}"

echo "${SSL_DOMAIN}" > "${CAROOT}/last-domain"