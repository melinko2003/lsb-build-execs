# docker buildx build -t lsb-build-exec:latest -f Dockerfile.init .
# syntax=docker/dockerfile:1
FROM alpine:latest AS build

ADD entrypoint.sh /opt/entrypoint.sh

RUN chmod +x /opt/entrypoint.sh

FROM ubuntu:latest
COPY --from=build /opt /opt

ENV GIT_DISCOVERY_ACROSS_FILESYSTEM=1
# docker run -it -v ./lsb/ffxi:/opt/ffxi lsb-build-exec:latest
CMD [ "/opt/entrypoint.sh" ]