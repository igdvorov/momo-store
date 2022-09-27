FROM nginx:1.23.1-alpine
ARG VERSION=${VERSION}
COPY momo-store-${VERSION}/dist/ /usr/share/nginx/html/
EXPOSE 80
