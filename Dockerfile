FROM base/archlinux AS build

# go to directory where to clone copybara
WORKDIR /opt

# update archlinux and install needed programs
RUN pacman -Syu --noconfirm \
    && pacman -S git --needed --noconfirm \
    && pacman -S jdk8-openjdk --needed --noconfirm \
    && pacman -S gcc --needed --noconfirm \
    && pacman -S bazel --needed --noconfirm \
    && pacman -S openssh --needed --noconfirm

# set git config and clone copybare
RUN git config --global user.name "OpenTOSCA Bot" \
    && git config --global user.email "opentosca@iaas.uni-stuttgart.de" \
    && git clone https://github.com/google/copybara.git

# go to directory where to build copybara
WORKDIR copybara

# build copybara using bazel and set link to standart binary folder for local builds
RUN bazel build //java/com/google/copybara \
    && bazel build //java/com/google/copybara:copybara_deploy.jar \
    && ln -s /opt/copybara/bazel-bin/java/com/google/copybara/copybara /usr/local/bin/copybara

# go to directory where to run copybara after building the container
WORKDIR /tmp/copybara