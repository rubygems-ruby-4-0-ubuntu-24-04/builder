FROM rubylang/ruby:4.0.0-noble

RUN \
  echo "debconf debconf/frontend select Noninteractive" | \
    debconf-set-selections

RUN \
  apt-get update && \
  apt-get install -y \
    clang \
    cmake \
    g++ \
    gcc \
    llvm \
    make \
    meson \
    ninja \
    rust-1.89-all \
    rustup && \
  gem install \
    rb_sys \
    rubygems-build-binary \
    rubygems-requirements-system && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*
