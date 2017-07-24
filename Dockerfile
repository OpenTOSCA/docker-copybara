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
    && bazel build //java/com/google/copybara:copybara_deploy.jar \
    && bazel test //javatests/com/google/copybara:all \
    && bazel test //copybara/integration:all

FROM openjdk:8u131-jre-alpine

RUN mkdir -p /opt/copybara \
  && apk add --no-cache git
COPY --from=builder /tmp/copybara/bazel-bin/java/com/google/copybara/copybara_deploy.jar /opt/copybara/copybara_deploy.jar
ENTRYPOINT ["java", "-jar", "/opt/copybara/copybara_deploy.jar"]
