# Base Dockerfile for using pycarl
###################################
# The Docker image can be built by executing:
# docker build -t yourusername/pycarl .
# A different base image can be set from the commandline with:
# --build-arg BASE_IMAGE=<new_base_image>

# Set base image
ARG BASE_IMAGE=movesrwth/storm-basesystem:latest
FROM $BASE_IMAGE
MAINTAINER Matthias Volk <m.volk@utwente.nl>


# Configuration arguments
#########################
# The arguments can be set from the commandline with:
# --build-arg <arg_name>=<value>

# CMake build type
ARG build_type=Release
# Additional arguments for compiling pycarl
ARG setup_args=""
# Additional CMake arguments for carl
ARG carl_cmake_args=""
# Number of threads to use for parallel compilation
ARG no_threads=2
# Carl-storm version
ARG carl_version=master


# Install dependencies
######################
# Uncomment to update packages beforehand
RUN apt-get update -qq
RUN apt-get install -y --no-install-recommends \
    maven \
    uuid-dev \
    python3 \
    python3-venv
# Packages maven and uuid-dev are required for carl-parser


# Build carl
############
WORKDIR /opt/

# Obtain carl from public repository
RUN git clone -b $carl_version https://github.com/moves-rwth/carl-storm.git carl

# Switch to build directory
RUN mkdir -p /opt/carl/build
WORKDIR /opt/carl/build

# Configure carl
RUN cmake .. $carl_cmake_args -DCMAKE_BUILD_TYPE=$build_type

# Build carl
RUN make lib_carl -j $no_threads


# Build carl-parser
###################
WORKDIR /opt/

# Obtain carl-parser from public repository
RUN git clone https://github.com/moves-rwth/carl-parser.git

# Switch to build directory
RUN mkdir -p /opt/carl-parser/build
WORKDIR /opt/carl-parser/build

# Configure carl-parser
RUN cmake .. -DCMAKE_BUILD_TYPE=$build_type

# Build carl-parser
RUN make carl-parser -j $no_threads


# Set-up virtual environment
############################
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN pip install setuptools

# Build pycarl
##############
RUN mkdir /opt/pycarl
WORKDIR /opt/pycarl

# Copy the content of the current local pycarl repository into the Docker image
COPY . .

# Build pycarl
RUN python setup.py build_ext $setup_args -j $no_threads develop

# Uncomment to build optional dependencies
#RUN pip install -e '.[doc]'
