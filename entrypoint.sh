#!/bin/sh

set -e

if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "Set the GITHUB_TOKEN environment variable."
  exit 1
fi

if [[ ! -z "$SSH_PRIVATE_KEY" ]]; then
  echo "Saving SSH_PRIVATE_KEY"

  mkdir --parents /root/.ssh
  echo "$SSH_PRIVATE_KEY" > /root/.ssh/id_rsa
  chmod 600 /root/.ssh/id_rsa

  # Github action changes $HOME to /github at runtime
  # therefore we always copy the SSH key to $HOME (aka. ~)
  mkdir --parents ~/.ssh
  cp /root/.ssh/* ~/.ssh/ 2> /dev/null || true 
fi

apk --no-cache add openssl git curl \
    && curl -sLO https://github.com/github/git-lfs/releases/download/v2.0.1/git-lfs-linux-amd64-2.0.1.tar.gz \
    && tar zxvf git-lfs-linux-amd64-2.0.1.tar.gz \
    && mv git-lfs-2.0.1/git-lfs /usr/bin/ \
    && rm -rf git-lfs-2.0.1 \
    && rm -rf git-lfs-linux-amd64-2.0.1.tar.gz

git lfs install

sh -c "/github-sync.sh $*"
