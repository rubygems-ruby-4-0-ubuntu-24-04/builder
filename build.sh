#!/bin/bash

set -eux

name=$1
version=$2

gem fetch ${name}:${version}
gem_build_binary_options=()
case "${name}" in
  psych)
      gem_build_binary_options+=(--add-requirement)
      gem_build_binary_options+=("system: yaml-1.0: ubuntu: libyaml-dev")
      ;;
esac
gem sources \
  --add https://dl.cloudsmith.io/public/rubygems-precompiled-gems/ruby-4-0-amd64-ubuntu-24-04/ruby/
gem build_binary "${gen_build_binary_options[@]}" ${name}-${version}.gem
cp ${name}-${version}-*.gem /host/
