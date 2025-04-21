ARG CRYSTAL_VERSION=1.16
FROM ghcr.io/luislavena/hydrofoil-crystal:${CRYSTAL_VERSION} AS base

# install tools
RUN --mount=type=cache,target=/var/cache/apk \
    --mount=type=tmpfs,target=/tmp \
    set -eux; \
    cd /tmp; \
    # bun
    { \
        export BUN_VERSION=1.2.9; \
        case "$(arch)" in \
        x86_64) \
            export \
                BUN_ARCH=x64 \
                BUN_SHA256=0e5aab0cd5f38a37ff9f331d22e0193e02bdd6c0f2bb9396fd55ae1827f4b3f5 \
            ; \
            ;; \
        aarch64) \
            export \
                BUN_ARCH=aarch64 \
                BUN_SHA256=165e982e86c6357e705550883a9dd9b059ece6bceacc1c064c8fad95e2350614 \
            ; \
            ;; \
        esac; \
        curl --fail -Lo bun.zip https://github.com/oven-sh/bun/releases/download/bun-v${BUN_VERSION}/bun-linux-${BUN_ARCH}-musl.zip; \
        echo "${BUN_SHA256} *bun.zip" | sha256sum -c - >/dev/null 2>&1; \
        unzip -j bun.zip; \
        mv bun /usr/local/bin/; \
        ln -s bun /usr/local/bin/bunx; \
        rm bun.zip; \
    }; \
    # drift
    { \
        export DRIFT_VERSION=0.3.6; \
        case "$(arch)" in \
        x86_64) \
            export \
                DRIFT_ARCH=x86_64 \
                DRIFT_SHA256=c6d50026a9c49209a5226b065bec676ec47f5be479a357c136df8085735a0e9e \
            ; \
            ;; \
        aarch64) \
            export \
                DRIFT_ARCH=aarch64 \
                DRIFT_SHA256=c767b9e02b86467ef881e8908f0fbce5bc5b45688541dfe365bbdcce5bc08421 \
            ; \
            ;; \
        esac; \
        curl --fail -Lo drift.tar.gz https://github.com/luislavena/drift/releases/download/v${DRIFT_VERSION}/drift-${DRIFT_VERSION}-${DRIFT_ARCH}-linux-musl.tar.gz; \
        echo "${DRIFT_SHA256} *drift.tar.gz" | sha256sum -c - >/dev/null 2>&1; \
        tar -xzf drift.tar.gz; \
        mv drift /usr/local/bin/; \
        rm drift.tar.gz; \
    }; \
    # smoke tests
    [ "$(command -v bun)" = '/usr/local/bin/bun' ]; \
    [ "$(command -v bunx)" = '/usr/local/bin/bunx' ]; \
    [ "$(command -v drift)" = '/usr/local/bin/drift' ]; \
    bun --version; \
    bunx --version; \
    drift version
