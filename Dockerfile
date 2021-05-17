FROM alpine

LABEL \
  org.opencontainers.image.title="GitHub Repo Sync" \
  org.opencontainers.image.description="⤵️ A GitHub Action for syncing current repository with remote" \
  org.opencontainers.image.url="https://github.com/repo-sync/github-sync" \
  org.opencontainers.image.documentation="https://github.com/marketplace/actions/github-sync" \
  org.opencontainers.image.source="https://github.com/repo-sync/github-sync" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.authors="Wei He <github@weispot.com>" \
  maintainer="Wei He <github@weispot.com>"

RUN apk add --no-cache git openssh-client && \
  echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

RUN apk --no-cache add openssl curl \
    && curl -sLO https://github.com/github/git-lfs/releases/download/v2.0.1/git-lfs-linux-amd64-2.0.1.tar.gz \
    && tar zxvf git-lfs-linux-amd64-2.0.1.tar.gz \
    && mv git-lfs-2.0.1/git-lfs /usr/bin/ \
    && rm -rf git-lfs-2.0.1 \
    && rm -rf git-lfs-linux-amd64-2.0.1.tar.gz \
    && git lfs install --skip-smudge

ADD *.sh /

ENTRYPOINT ["/entrypoint.sh"]
