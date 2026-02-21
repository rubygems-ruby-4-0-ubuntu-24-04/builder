#!/bin/bash

set -eux

name=$1
version=$2

gem fetch ${name}:${version}
system_dependencies=()
case "${name}" in
  psych) system_dependencies+=(libyaml-dev);;
esac
if [ ${#system_dependencies[@]} -gt 0 ]; then
  apt update
  apt install -y -V "${system_dependencies[@]}"
fi
gem sources \
  --add https://dl.cloudsmith.io/public/rubygems-precompiled-gems/ruby-4-0-amd64-ubuntu-24-04/ruby/
gem build_binary ${name}-${version}.gem
cp ${name}-${version}-*.gem /host/
