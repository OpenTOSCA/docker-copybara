# Docker Copybara [![](https://images.microbadger.com/badges/image/opentosca/copybara.svg)](https://microbadger.com/images/opentosca/copybara "Get your own image badge on microbadger.com")

A docker image for [Google's Copybara](https://github.com/google/copybara), which is the successor of [Google's Makeing Opensource Easy](https://github.com/google/moe).
[koppor's git-oss-releaser](https://github.com/koppor/git-oss-releaser) does not have the same functionalities as Copybara.

## Building

    docker build -t copybara

## Running Copybara

    docker run -it --rm --mount type=bind,source="$PWD",target="$PWD" -w "$PWD" --mount type=bind,source="$HOME",target="/root" -e HOME="/root" copybara copy.bara.sky
