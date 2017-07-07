FROM ubuntu:16.04 as builder

RUN echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" > /etc/apt/sources.list.d/bazel.list \
    && apt-get -y update \
    && apt-get install -y curl git \
    && curl https://bazel.build/bazel-release.pub.gpg | apt-key add - \
    && apt-get -y update \
    && apt-get -y install bazel \
    && apt-get install -y pkg-config zip g++ zlib1g-dev unzip

RUN curl -L https://github.com/bazelbuild/bazel/releases/download/0.5.2/bazel-0.5.2-installer-linux-x86_64.sh -o /tmp/bazel-0.5.2-installer-linux-x86_64.sh \
    && chmod +x /tmp/bazel-0.5.2-installer-linux-x86_64.sh \
    && curl -L https://github.com/bazelbuild/bazel/releases/download/0.5.2/bazel-0.5.2-installer-linux-x86_64.sh.sha256 -o /tmp/bazel-0.5.2-installer-linux-x86_64.sh.sha256 \
    && cd /tmp \
    && sha256sum -c /tmp/bazel-0.5.2-installer-linux-x86_64.sh.sha256 \
    && /tmp/bazel-0.5.2-installer-linux-x86_64.sh

RUN git clone https://github.com/google/copybara.git /tmp/copybara \
    && cd /tmp/copybara \
    && bazel build //java/com/google/copybara \
    && bazel test //javatests/com/google/copybara:all \
    && bazel test //copybara/integration:all

RUN ln -s /tmp/copybara/bazel-bin/java/com/google/copybara/copybara /usr/local/bin/copybara 

ENTRYPOINT ["copybara"]

# TODO: use multi-stage builds once I figure out how to relocate a binary built by bazel

# FROM openjdk:8u131-jre-alpine
# FROM ubuntu:16.04

# RUN mkdir -p /opt/copybara
    # && apk add --no-cache bash
# COPY --from=builder /tmp/copybara/bazel-bin/java/com/google/copybara/ /opt/copybara
