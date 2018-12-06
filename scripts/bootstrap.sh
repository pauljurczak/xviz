#!/bin/sh
# Script to bootstrap repo for development

echo 'Bootstrapping xviz, installing in all directories'

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# install dependencies
yarn

ROOT_NODE_MODULES_DIR=`pwd`/node_modules

cd modules
for D in *; do (
  if [ -d $D ] ; then
    cd $D

    # create symlink to dev dependencies at root
    # this is a bug of yarn: https://github.com/yarnpkg/yarn/issues/4964
    # TODO - remove when fixed
    mkdir -p node_modules
    rm -rf ./node_modules/.bin
    ln -sf $ROOT_NODE_MODULES_DIR/.bin ./node_modules
  fi
); done

# build the submodules
npm run build

# Setup KITTI converter JS dependencies
(cd "${SCRIPT_DIR}/../examples/converters/kitti" && yarn --check-files)

# Setup XVIZ server JS dependencies
(cd "${SCRIPT_DIR}/../examples/server" && yarn --check-files)
