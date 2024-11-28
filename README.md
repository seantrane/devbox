# DevBox

> DevBox is a portable virtual development environment supporting Everything-as-Code principles.

## Table of Contents

- [About](#about)
- [Install](#install)
- [Usage](#usage)
- [Support](#support)
- [Contributing](#contributing)
- [Changelog](#changelog)
- [License](#license)

---

## About <a id="about"></a>

The DevBox is a portable shell environment and toolkit for software/ops engineers, using Docker/containers.

It contains many of the _typical_ dependencies that full-stack engineers use on a regular basis. It is meant to be forked and manicured to whatever liking an individual wishes, as everyone has their own unique preferences.

## Install <a id="install"></a>

1. Clone repo to a user-accessible directory. These instructions use the "$HOME" directory, where most users are guaranteed to have access.

   ```sh
   git clone https://github.com/seantrane/devbox.git "$HOME/devbox"
   ```

2. Bootstrap the DevBox. This edits the `~/.profile` and `~/.bash_profile` files, adding the DevBox bin directory to `PATH`.

   ```sh
   "$HOME/devbox/bin/devbox" bootstrap
   ```

3. Restart the terminal or shell environment.

4. This should enable easier access to the DevBox CLI, without typing the full path to the script.

   ```sh
   devbox run
   ```

## Usage <a id="usage"></a>

### Quickstart

1. Run any binary, command, alias, or function (from the DevBox) in the current host directory.

   ```sh
   devbox run tree -aC --gitignore
   ```

2. Launch the DevBox container, mounting the current host directory to the DevBox `/mnt/pwd` directory.

   ```sh
   devbox run
   ```

3. The DevBox has many built-in aliases, functions, and shortcuts.

   ```sh
   la   # =>  ls -lahF --color=always --time-style=long-iso
   lsd  # =>  ls -AhF --color=always --time-style=long-iso | sed '/[^\/]$/d'
   lsdl # =>  ls -lAhF --color=always --time-style=long-iso | sed '/^[-l]/d'
   ..   # =>  cd ..
   ...  # =>  cd ../..
   .... # =>  cd ../../..
   ```

4. Create shell aliases in the host machine that point to commands in the DevBox. This saves having to install such dependencies on the host machine.

   ```sh
   alias aws="devbox run aws"
   alias gcloud="devbox run gcloud"
   alias gh="devbox run gh"
   alias go="devbox run go"
   alias terraform="devbox run terraform"
   alias terragrunt="devbox run terragrunt"
   alias tflint="devbox run tflint"
   alias tofu="devbox run tofu"
   ```

### How it works

#### Dockerfiles

The `config` directory is for storing Dockerfiles. All files should follow the `Dockerfile.[name]` naming convention, to avoid conflict and enable selection by CLI script. Existing `image` _names_ are:

- `base` – shell enhacement only
- **`full` – full-stack toolset (default)**
- `iac` – Infrastructure-as-Code tools only

#### Context

The `context` directory is for storing all assets that will be shared with the container image. The image build process will not be able to access anything outside of this path. _If the asset must be `COPY` or `ADD` to the image, it belongs in this directory._

##### The `context/opt/devbox` directory is copied to the `/opt/devbox` directory in the container.

### Command-Line Interface (CLI)

The CLI provides a short, easy-to-type command format to enable quick access and control of any DevBox.

#### CLI Usage

```txt
devbox

  DevBox is a portable virtual development environment supporting Everything-as-Code principles.

Usage:

  devbox [command][-image]                                  (launch Bash session in container)

  devbox [command][-image] [bin-command] [arguments]        (execute binary command inside container)

  devbox [command][-image] [alias/function] [arguments]     (execute shell alias/function inside container)

  devbox [docker-command][-image] [docker-command-options]  (docker command proxy)

Options:

  -h, --help
     Display help message and exit.

Arguments:

  [1] [command][-image] is a dash-separated compound argument with 2 segments.
      Only [command] is required. Dash is only required with [image] segment.
      The 'Command' argument segment is meant to proxy Docker commands.
      - DevBox commands: remove, build, run, rerun, rebuild, upgrade.
      - Docker commands also work, with no need for trailing image-argument.
      The 'Image' argument segment is optional (default: 'full'), represents
      the extension of Dockerfile to use for build, e.g.; Dockerfile.full.
      - Image options: base, iac, full

  [*] All additional arguments are passed into the container.
      Bash prompt is provided when no arguments are passed.

Returns:

  None

Examples of (devbox [command][-image]):

  devbox remove               = devbox remove-full
  devbox build                = devbox build-full
  devbox rebuild              = devbox rebuild-full
  devbox run                  = devbox run-full
  devbox rerun                = devbox rerun-full
  devbox inspect              = devbox inspect:full

  devbox [docker-command]     = devbox [docker-command]-full

  devbox remove-base
  devbox build-base
  devbox rebuild-base
  devbox run-base
  devbox rerun-base
  devbox inspect-base

Examples of (devbox [command][-image] [bin-command] [arguments]):

  devbox run tree -aC --gitignore
  devbox run apt search vim

Examples of (devbox [command][-image] [alias/function] [arguments]):

  devbox run la /
  devbox run ip opensource.org

Examples of (devbox [docker-command][-image] [docker-command-options]):

  devbox inspect              = devbox inspect-full
  devbox inspect-base
```

---

## Support <a id="support"></a>

[Submit an issue](https://github.com/seantrane/devbox/issues/new), in which you should provide as much detail as necessary for your issue.

## Contributing <a id="contributing"></a>

Contributions are always appreciated. Read [CONTRIBUTING.md](https://github.com/seantrane/devbox/blob/master/CONTRIBUTING.md) documentation to learn more.

## Changelog <a id="changelog"></a>

Release details are documented in the [CHANGELOG.md](https://github.com/seantrane/devbox/blob/master/CHANGELOG.md) file, and on the [GitHub Releases page](https://github.com/seantrane/devbox/releases).

---

## License <a id="license"></a>

[ISC License](https://github.com/seantrane/devbox/blob/master/LICENSE)

Copyright (c) 2020 [Sean Trane Sciarrone](https://github.com/seantrane)