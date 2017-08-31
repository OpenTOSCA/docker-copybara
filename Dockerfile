FROM ubuntu:16.04 as builder

ARG bazel_version="0.5.4"
RUN echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" > /etc/apt/sources.list.d/bazel.list \
    && apt-get -y update \
    && apt-get install -y curl git \
    && curl --fail https://bazel.build/bazel-release.pub.gpg | apt-key add - \
    && apt-get -y update \
    && apt-get install -y pkg-config zip g++ zlib1g-dev unzip

RUN curl --fail -L https://github.com/bazelbuild/bazel/releases/download/${bazel_version}/bazel-${bazel_version}-installer-linux-x86_64.sh -o /tmp/bazel-${bazel_version}-installer-linux-x86_64.sh \
    && chmod +x /tmp/bazel-${bazel_version}-installer-linux-x86_64.sh \
    && curl --fail -L https://github.com/bazelbuild/bazel/releases/download/${bazel_version}/bazel-${bazel_version}-installer-linux-x86_64.sh.sha256 -o /tmp/bazel-${bazel_version}-installer-linux-x86_64.sh.sha256 \
    && cd /tmp \
    && sha256sum -c bazel-${bazel_version}-installer-linux-x86_64.sh.sha256 \
    && /tmp/bazel-${bazel_version}-installer-linux-x86_64.sh

# TODO: get specific copybara revision for determinism
RUN git clone https://github.com/google/copybara.git /tmp/copybara \
    && cd /tmp/copybara \
    && bazel build //java/com/google/copybara:copybara_deploy.jar \
    && bazel test //javatests/com/google/copybara:all \
    && bazel test //copybara/integration:all

FROM openjdk:8u131-jre-alpine

RUN mkdir -p /opt/copybara \
  && apk add --no-cache git openssh
COPY --from=builder /tmp/copybara/bazel-bin/java/com/google/copybara/copybara_deploy.jar /opt/copybara/copybara_deploy.jar
ENTRYPOINT ["java", "-jar", "/opt/copybara/copybara_deploy.jar"]
