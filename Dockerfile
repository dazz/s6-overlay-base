FROM alpine:3 AS s6

ARG TARGETARCH
ARG TARGETVARIANT
ARG S6_RELEASE

RUN apk add --no-cache curl jq \
    && if [ -z ${S6_RELEASE} ]; then \
         S6_RELEASE=$(curl -s https://api.github.com/repos/just-containers/s6-overlay/releases/latest | jq -r '.tag_name' | cut -c2-); \
       fi \
    && S6_PLATFORM=$(case "${TARGETARCH}/${TARGETVARIANT}" in \
         "arm/v7")   echo "armhf";; \
         "arm64/")   echo "aarch64";; \
         *)          echo "x86_64";; \
       esac) \
    && echo "Using s6 release ${S6_RELEASE} platform ${S6_PLATFORM}" \
    && curl -sSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_RELEASE}/s6-overlay-noarch.tar.xz" -o "/tmp/s6-overlay-noarch.tar.xz" \
    && curl -sSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_RELEASE}/s6-overlay-${S6_PLATFORM}.tar.xz" -o "/tmp/s6-overlay-${S6_PLATFORM}.tar.xz" \
    && curl -sSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_RELEASE}/s6-overlay-noarch.tar.xz.sha256" -o "/tmp/s6-overlay-noarch.tar.xz.sha256" \
    && curl -sSL "https://github.com/just-containers/s6-overlay/releases/download/v${S6_RELEASE}/s6-overlay-${S6_PLATFORM}.tar.xz.sha256" -o "/tmp/s6-overlay-${S6_PLATFORM}.tar.xz.sha256" \
    && cd /tmp \
    && sha256sum -c s6-overlay-noarch.tar.xz.sha256 \
    && sha256sum -c s6-overlay-${S6_PLATFORM}.tar.xz.sha256 \
    && mkdir -p /s6/root \
    && tar -C /s6/root -Jxpf /tmp/s6-overlay-noarch.tar.xz \
    && tar -C /s6/root -Jxpf /tmp/s6-overlay-${S6_PLATFORM}.tar.xz

FROM scratch
COPY --from=s6 /s6/root /s6/root