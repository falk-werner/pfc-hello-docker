FROM scratch as image
ADD build/root.tgz /

FROM scratch
COPY --from=image / /

LABEL maintainer="Falk Werner"
LABEL version="1.0.0"
LABEL description="PFC Hello"

ENTRYPOINT ["/usr/bin/hello", "--"]
