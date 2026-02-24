#!/bin/bash

set -eux

name=$1
version=$2

gem fetch --platform=ruby ${name}:${version}
gem_build_binary_options=()
gem_build_options=(--)
case "${name}" in
  psych)
      gem_build_binary_options+=(--add-requirement)
      gem_build_binary_options+=("system: yaml-1.0: ubuntu: libyaml-dev")
      ;;
  ruby_rpg)
      gem_build_binary_options+=(--add-requirement)
      gem_build_binary_options+=("system: gl: ubuntu: libgl-dev")
      ;;
  ruby_tree_sitter)
      gem_build_binary_options+=(--add-requirement)
      gem_build_binary_options+=("system: tree-sitter: ubuntu: libtree-sitter-dev")
      gem_build_options+=(--enable-sys-libs)
      ;;
esac
gem sources \
  --prepend https://dl.cloudsmith.io/public/rubygems-precompiled-gems/ruby-4-0-amd64-ubuntu-24-04/ruby/
gem build_binary \
  "${gem_build_binary_options[@]}" \
  ${name}-${version}.gem \
  "${gem_build_options[@]}"
cp ${name}-${version}-*.gem /host/
