#!/bin/bash

set -eux

name=$1
version=$2

gem fetch ${name}:${version}
gem build_binary ${name}-${version}.gem
cp ${name}-${version}-*.gem /host/
