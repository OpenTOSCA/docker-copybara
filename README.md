# Docker Copybara

[Copybara](https://github.com/google/copybara) docker image


## Building

    docker build -t copybara

## Running Copybara

    docker run -it --rm --mount type=bind,source="$PWD",target="$PWD" -w "$PWD" --mount type=bind,source="$HOME",target="/root" -e HOME="/root" copybara copy.bara.sky
