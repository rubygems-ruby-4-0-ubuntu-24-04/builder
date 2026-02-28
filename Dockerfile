FROM rubylang/ruby:4.0.0-noble

RUN \
  echo "debconf debconf/frontend select Noninteractive" | \
    debconf-set-selections

RUN \
  apt-get update && \
  apt-get install -y \
    cargo \
    clang \
    cmake \
    g++ \
    gcc \
    llvm \
    make \
    meson \
    ninja-build \
    rust-1.89-all && \
  gem install \
    rb_sys \
    rubygems-build-binary \
    rubygems-requirements-system && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*
