FROM nginx:alpine

ENV NODE_ENV=production
COPY dist/ /usr/share/nginx/html

RUN rm /etc/nginx/conf.d/default.conf && \
    apk add --update curl && \
    rm -rf /var/cache/apk/* && \
    curl -sLo /usr/local/bin/ep https://github.com/kreuzwerker/envplate/releases/download/v0.0.8/ep-linux && chmod +x /usr/local/bin/ep

COPY nginx.conf /etc/nginx/nginx.conf

COPY build/entrypoint.sh /

COPY healthcheck.json /usr/share/nginx/html/healthcheck.json
RUN  ep /usr/share/nginx/html/healthcheck.json

HEALTHCHECK --interval=30s --timeout=3s CMD curl -f http://localhost/healthcheck || exit 1

CMD ["/bin/sh", "entrypoint.sh"]
