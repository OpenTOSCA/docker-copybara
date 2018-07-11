# Docker Copybara [![](https://images.microbadger.com/badges/image/opentosca/copybara.svg)](https://microbadger.com/images/opentosca/copybara)

A docker image for [Google's Copybara](https://github.com/google/copybara), which is the successor of [Google's Makeing Opensource Easy](https://github.com/google/moe).
[koppor's git-oss-releaser](https://github.com/koppor/git-oss-releaser) does not have the same functionalities as Copybara.

## Dockerfile

With the prepared `Dockerfile` you can build a container where you can run `copybara` in a container with [base/archlinux](https://hub.docker.com/r/base/archlinux/) image.

## Building

To build the container run the command in the directory containing the Dockerfile:

```
docker build --rm -t copybara .
```

## Directory Preparation

`<wd>` is a placeholder for your working directory you want to use and should contain the following:

```
<wd>/copy.bara.sky
<wd>/<originRepository>
<wd>/<targetRepository>
```

- `copy.bara.sky` has to contain the config for copybara execution.
- `<originRepository>` has to contain the origin repository, if you use a local one.
- `<targetRepository>` has to contain the target repository, if you use a local one.
- `<originRepository>` and `<targetRepository>` has to be specified in the config file `copy.bara.sky`.

## Running Copybara

Run the command in the directory `<wd>`:

```
docker run -v "$(pwd):/tmp/copybara" -it opentosca/copybara:latest copybara copy.bara.sky --force
```

## Example with Linux Bash

Run following commands in the bash:

```
$ git clone https://github.com/OpenTOSCA/docker-copybara.git
$ cd docker-copybara
$ docker build --rm -t copybara .
$ mkdir targetRepo
$ cd targetRepo
$ git init --bare
$ cd ..
```

Create file `copy.bara.sky` in the current directory with following content (first example from https://github.com/google/copybara/blob/master/docs/examples.md with changed destination path):

```
urlOrigin = "https://github.com/google/copybara.git"
urlDestination = "file:///tmp/copybara/targetRepo"

core.workflow(
    name = "default",

    origin = git.origin(
        url = urlOrigin,
        ref = "master",
    ),

    destination = git.destination(
        url = urlDestination,
        fetch = "master",
        push = "master",
    ),

    destination_files = glob(["**"], exclude = ["README_INTERNAL.txt"]),

    authoring = authoring.pass_thru("Default email <default@default.com>"),
)
```

At last you can run the copybara in the docker container:

```
docker run -v "$(pwd):/tmp/copybara" -it opentosca/copybara:latest copybara copy.bara.sky --force
```

This will copy the content of the origin repository to the target repository you created in `targetRepo`.
