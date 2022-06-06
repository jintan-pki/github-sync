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

ENV GITLFS_VERSION="3.2.0"

RUN apk --no-cache add openssl wget \
	&&　RUN wget -O git-lfs-linux-amd64-${GITLFS_VERSION}.tar.gz https://github.com/github/git-lfs/releases/download/v${GITLFS_VERSION}/git-lfs-linux-amd64-${GITLFS_VERSION}.tar.gz \
    && tar zxvf git-lfs-linux-amd64-${GITLFS_VERSION}.tar.gz \
    && mv git-lfs-${GITLFS_VERSION}/git-lfs /usr/bin/ \
    && rm -rf git-lfs-${GITLFS_VERSION} \
    && rm -rf git-lfs-linux-amd64-${GITLFS_VERSION}.tar.gz \
    && git lfs install --skip-smudge

ADD *.sh /

ENTRYPOINT ["/entrypoint.sh"]
