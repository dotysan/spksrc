FROM debian:bookworm

LABEL description="Framework for maintaining and compiling native community packages for Synology devices"
LABEL maintainer="SynoCommunity <https://github.com/SynoCommunity/spksrc/graphs/contributors>"
LABEL url="https://synocommunity.com"
LABEL vcs-url="https://github.com/SynoCommunity/spksrc"

ENV LANG C.UTF-8

# Manage i386 arch
RUN dpkg --add-architecture i386

# Install required packages (in sync with README.rst instructions)
# ATTENTION: the total length of the following RUN command must not exceed 1024 characters
RUN apt-get update && apt-get install --no-install-recommends -y \
	autoconf-archive \
	autogen \
	automake \
	autopoint \
	bash \
	bc \
	bison \
	build-essential \
	check \
	cmake \
	curl \
	cython3 \
	debootstrap \
	ed \
	expect \
	fakeroot \
	flex \
	g++-multilib \
	gawk \
	gettext \
	git \
	gperf \
	imagemagick \
	intltool \
	jq \
	libbz2-dev \
	libc6-i386 \
	libcppunit-dev \
	libffi-dev \
	libgc-dev \
	libgmp3-dev \
	libltdl-dev \
	libmount-dev \
	libncurses-dev \
	libpcre3-dev \
	libssl-dev \
	libtool \
	libunistring-dev \
	lzip \
	mercurial \
	moreutils \
	ninja-build \
	patchelf \
	php \
	pkg-config \
	python3-pip \
	python3-distutils \
	rename \
	rsync \
	ruby-mustache \
	scons \
	subversion \
	sudo \
	swig \
	texinfo \
	unzip \
	xmlto \
	zip \
	zlib1g-dev && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	adduser --disabled-password --gecos '' user && \
	adduser user sudo && \
	echo "%user ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/users

ARG PIP_NO_CACHE_DIR=1
ARG PIP_ROOT_USER_ACTION=ignore

# Install setuptools, wheel and pip for Python3
# Install meson cross-platform build system
RUN pip install --break-system-packages meson==1.4.*

# dotysan crutches
ARG DEBIAN_FRONTEND=noninteractive
#	libarchive-dev \
#	libcrypto++-dev \
RUN apt-get update && apt-get upgrade --yes && \
	apt-get install --yes --no-install-recommends \
	libiconv-hook-dev \
	mc
ARG UID
ARG USER
RUN useradd --uid $UID $USER --create-home

# Volume pointing to spksrc sources
VOLUME /spksrc
WORKDIR /spksrc
