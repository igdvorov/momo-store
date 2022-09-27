FROM golang:1.18.5-alpine3.15
ARG VERSION={VERSION}
WORKDIR /app
RUN addgroup --system gouser \
	&& adduser -S -s /bin/bash -G gouser gouser -D -H
COPY --chown=gouser:gouser \
    ./momo-store-${VERSION}/momo-store-backend-${VERSION} ./momo-backend
USER gouser
EXPOSE 8081
ENTRYPOINT ["./momo-backend"]