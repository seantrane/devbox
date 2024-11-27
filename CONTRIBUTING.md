# Contributing

> Thank you for contributing. Contributions are always welcome, no matter how large or small.

## Table of Contents

- [Guidelines](#guidelines)
- [Pull Requests](#submitting-a-pull-request)
- [Coding Rules](#coding-rules)
- [Working with Code](#working-with-code)
- [File Structure](#file-structure)

---

## Guidelines <a id="guidelines"></a>

As a contributor, here are the guidelines you should follow:

- [Code of conduct](#code-of-conduct)
- [How can I contribute?](#how-can-i-contribute)
- [Using the issue tracker](#using-the-issue-tracker)
- [Submitting a Pull Request](#submitting-a-pull-request)
- [Coding rules](#coding-rules)
- [Working with code](#working-with-code)

We also recommend to read [How to Contribute to Open Source](https://opensource.guide/how-to-contribute).

---

## Code of conduct <a id="code-of-conduct"></a>

Please read and follow our [code of conduct](CODE_OF_CONDUCT.md).

---

## How can I contribute? <a id="how-can-i-contribute"></a>

### Improve documentation <a id="improve-documentation"></a>

Consider helping us to improve our documentation by finding _documentation issues_ that need help, and by submitting pull requests for corrections, clarifications, more examples, new features, etc.

Please follow the [Documentation guidelines](STYLE_GUIDES.md#documentation).

### Give feedback on issues <a id=""></a>

Some issues are created without information requested in the [Bug report guideline](#bug-report). Help making them easier to resolve by adding any relevant information.

Issues with the [`type: discussion` label](https://github.com/seantrane/dotfiles/labels/type%3A%20discussion) are meant to discuss the implementation of new features. Participating in the discussion is a good opportunity to get involved and influence the future.

### Fix bugs and implement features <a id=""></a>

Confirmed [bug](https://github.com/seantrane/dotfiles/labels/type%3A%20bug) and ready to implement [features](https://github.com/seantrane/dotfiles/labels/type%3A%20feature) are marked with the [`help` label](https://github.com/seantrane/dotfiles/labels/help). Post a comment on an issue to indicate you would like to work on it, and to request help from the maintainer(s) and the community.

---

## Using the issue tracker <a id="using-the-issue-tracker"></a>

The issue tracker is the channel for [bug reports](#bug-report), [features requests](#feature-request) and [submitting pull requests](#submitting-a-pull-request) only. Please use the [Support](README.md#support) and [Get help](README.md#get-help) sections for support, troubleshooting and questions.

Before opening an Issue or a Pull Request, please use the [GitHub issue search](https://github.com/seantrane/dotfiles/issues) to make the bug or feature request hasn't been already reported or fixed.

### Bug report <a id="bug-report"></a>

[A good bug report](https://github.com/seantrane/dotfiles/issues/new?assignees=&labels=bug%2Ctriage&projects=&template=bug_report.yml&title=%5BBug%5D%3A+) shouldn't leave others needing to chase you up for more information. Please try to be as detailed as possible in your report and fill the information requested in the _[Bug Report](https://github.com/seantrane/dotfiles/issues/new?assignees=&labels=bug%2Ctriage&projects=&template=bug_report.yml&title=%5BBug%5D%3A+)_.

### Feature request <a id="feature-request"></a>

[Feature requests are welcome](https://github.com/seantrane/dotfiles/issues/new/choose). But take a moment to find out whether your idea fits with the scope and aims of the project. It's up to you to make a strong case to convince the project's developers of the merits of this feature. Please provide as much detail and context as possible and fill the information requested in the _[Agile User Story form/template](https://github.com/seantrane/dotfiles/issues/new?assignees=&labels=state%3A+pending%2Ctype%3A+discussion&projects=&template=agile_user_story.yml&title=%5BStory%5D%3A+As+a+%7Bpersona%7D%2C+I+want+%7Bsomething%7D%2C+so+that+%7Boutcome%7D.)_.

---

## Submitting a Pull Request <a id="submitting-a-pull-request"></a>

Good pull requests whether patches, improvements or new features are a fantastic help. They should remain focused in scope and avoid containing unrelated commits.

**Please ask first** before embarking on any significant pull request (e.g. implementing features, refactoring code), otherwise you risk spending a lot of time working on something that the project's developers might not want to merge into the project.

If you never created a pull request before, then [learn how to submit a pull request (great tutorial)](https://opensource.guide/how-to-contribute/#opening-a-pull-request).

Here is a summary of the steps to follow:

1. [Set up the workspace](#set-up-the-workspace)
2. If you cloned a while ago, get the latest changes from upstream and update dependencies.
3. Create a new topic branch (off the main project development branch) to contain your feature, change, or fix; `git checkout -b <topic-branch-name>`
4. Make your code changes, following the [Coding rules](#coding-rules)
5. Push your topic branch up to your fork; `git push origin <topic-branch-name>`
6. [Open a Pull Request](https://help.github.com/articles/creating-a-pull-request/#creating-the-pull-request) with a clear title and description.

**Tips**:

- Create your branch from `main`.
- Ensure your [git commit messages follow the required format](STYLE_GUIDES.md#git-commit-messages).
- Ensure your scripts are well-formed, well-documented and object-oriented.
- Ensure your scripts are stateless and can be reused by all.
- Update your branch, and resolve any conflicts, before making pull request.
- Fill in [the required template](.github/PULL_REQUEST_TEMPLATE/pull_request_template.md).
- Do not include issue numbers in the PR title.
- Include screenshots and animated GIFs in your pull request whenever possible.
- Follow the [style guide](STYLE_GUIDES.md) [applicable to the language](STYLE_GUIDES.md#languages) or task.
- Include thoughtfully-worded, well-structured tests/specs. See the [Tests/Specs Style Guide](STYLE_GUIDES.md#tests).
- Document new code based on the [Documentation Style Guide](STYLE_GUIDES.md#documentation).
- End all files with a newline.

---

## Coding rules <a id="coding-rules"></a>

- [Commit message guidelines](STYLE_GUIDES.md#git-commit-messages)
- [Documentation](STYLE_GUIDES.md#documentation)
- [Lint](STYLE_GUIDES.md#lint)
- [Source Code](STYLE_GUIDES.md#source-code)
- [Tests/Specs](STYLE_GUIDES.md#tests)

---

## Working with code <a id="working-with-code"></a>

- [Configure SSH authentication](#configure-ssh)
- [Set up the workspace](#set-up-the-workspace)

### Configure SSH authentication for _containerized workspace_ <a id="configure-ssh"></a>

The following steps enable the _containerized workspace_ to authenticate when retrieving private repositories from GitHub. This also ensures a universal experience for all contributors, without disrupting anyone's existing keys.

_If you've already created a "shared RSA key", you can skip this section._

1. Generate an RSA key:

   ```sh
   ssh-keygen -t rsa -b 4096 -C "{username}@users.noreply.github.com"
   ```

2. When prompted, provide file path `~/.ssh/id_rsa_shared`.

   ```text
   Enter file in which to save the key (~/.ssh/id_rsa): ~/.ssh/id_rsa_shared
   ```

3. **Do not** set a passphrase, just click enter twice.

   ```text
   Enter passphrase (empty for no passphrase):
   Enter same passphrase again:
   ```

4. This will create 2 files, a private-key and its public-key companion.

   ```text
   ~/.ssh/id_rsa_shared
   ~/.ssh/id_rsa_shared.pub
   ```

5. Create a `~/.ssh/config_shared` file and put the following text in it.

   ```text
   Host github.com
     IgnoreUnknown UseKeychain
     AddKeysToAgent yes
     IdentityFile /root/.ssh/id_rsa_shared
   ```

6. _Copy_ the contents of the public-key to your clipboard.

   ```sh
   cat ~/.ssh/id_rsa_shared.pub
   ```

7. [Add the `id_rsa_shared.pub` key to your GitHub Account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account#adding-a-new-ssh-key-to-your-account).

### Set up the workspace <a id="set-up-the-workspace"></a>

#### Clone the repo into the current directory <a id="clone-repo"></a>

```sh
git clone git@github.com:seantrane/devbox.git devbox && cd devbox
```

---

## File Structure <a id="file-structure"></a>

```text
devbox/
├─ .dependabot/                               * Dependabot config directory
├─ .github/                                   * GitHub config directory
│
├─ bin/                                       * Binaries directory
│  ├─ devbox                                  * DevBox binary to create image and run container
│  └─ devbox_remove                           * DevBox binary to destroy image
│
├─ src/                                       * Source files directory
│  ├─ dotfiles/                               * Dotfiles directory
│  │  ├─ aliases.symlink                      * '~/.aliases' file
│  │  ├─ bash_env.symlink                     * '~/.bash_env' file
│  │  ├─ bash_login.symlink                   * '~/.bash_login' file
│  │  ├─ bash_profile.symlink                 * '~/.bash_profile' file
│  │  ├─ bash_prompt.symlink                  * '~/.bash_prompt' file
│  │  ├─ bashrc.symlink                       * '~/.bashrc' file
│  │  └─ paths.symlink                        * '~/.paths' file
│  │
│  ├─ settings/                               * Settings/config/prefs directory
│  │  └─ maven-settings-docker.xml
│  │
│  ├─ docker-entrypoint.sh                    * Bash docker-entrypoint file
│  └─ Dockerfile                              * The DevBox Dockerfile
│
├─ .editorconfig                              * Keep developers/IDE's in sync
├─ .env.example                               * Environment configuration variables template
├─ .gitignore                                 * Ignore files for git
├─ .markdownlint.yaml                         * Markdown lint rules and config
├─ CODEOWNERS                                 * Default pull-request reviewers
├─ CONTRIBUTING.md                            * Contributing guidelines
└─ README.md                                  * Repository ReadMe file
```

## Where to put app files inside a Linux Docker image

```text
/
├─ dev/                       * For device files. "everything is a file" principle.
│  ├─ shm/                    * For (sensitive) files stored only in RAM (deleted on restart).
│  └─ null                    * Black hole file to pass unnecessary responses.
|
├─ etc/                       * System related configuration files.
│  └─ bash.bashrc             * Bash configuration for all users.
|
├─ mnt/                       * Contains temporary mount directories for mounting the file system.
│  └─ pwd/                    * Mount directory for `"$(pwd)"` host-path.
|
├─ home/                      * User directories for storing their own files.
|  └─ `non-root-user`/        * Directory for non-root user (used at runtime).
|     ├─ .aws/credentials     * AWS-CLI authentication credentials.
|     ├─ .bashrc              * Bash config for interactive non-login.
|     ├─ .gitconfig           * Git config file.
|     └─ .ssh/id_rsa          * SSH private key.
|
├─ opt/                       * For all non-distro software and add-on packages.
|  └─ `my-app`/               * `my-app` app/package directory.
|     ├─ bin/                 * Binary files for `my-app` app/package. Add to PATH or symlink.
|     │  └─ `my-app`          * Binary file for `my-app`, symlinked from /usr/local/bin/`my-app`.
|     ├─ etc/                 * Configuration files for `my-app`.
|     ├─ lib/                 * Compiled `my-app` files required by binary files.
|     └─ share/               * Contains 'shareable', architecture-independent files.
|
├─ srv/                       * Site-specific data served by the system..
|  └─ `my-app`/               * `my-app` service directory.
|     ├─ conf/                * Webserver configuration files.
|     ├─ www/                 * Website directory, served by the webserver. $ chmod -R 2774
|     └─ [subdomain]/         * Website subdomain directories. $ chmod -R 2774
|
├─ tmp/                       * Temporary space, typically cleared on reboot.
|  └─ `my-app`/               * Directory for `my-app` temporary files.
|
└─ var/                       * Writeable file storage partition of large size.
   └─ opt/                    * Temporary files preserved between system reboots.
      └─ `my-app`/            * Logs, persistent i/o files for `my-app`.
         ├─ log/              * Common for web apps, libraries, etc.
         │  ├─ access.log     * Webserver access log. $ chgrp -R www-data && chmod -R 2770
         │  ├─ error.log      * Binary app error log. $ chmod -R 2770
         │  ├─ history.log    * Binary app command history log. $ chmod -R 2770
         │  └─ output.log     * Binary app output log. $ chmod -R 2770
         └─ tmp/              * Temporary files preserved between system reboots.
            └─ uploads/       * For www-data (apache/nginx) to create uploads. $ chgrp -R www-data
```

---

#### Happy coding!
