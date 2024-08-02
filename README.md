# s6-overlay base image
This repo fills a small gap by providing a s6-overlay base image.

## Usage

```Dockerfile
FROM hakindazz/s6-overlay-base AS s6-overlay
FROM alpine3

COPY --from=s6-overlay /s6/root /

ENTRYPOINT ["/init"]
```