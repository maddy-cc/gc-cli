# gc-cli

`gc` is a local branch ledger and GitLab MR helper.

It records branches created for each project, shows them in a local web dashboard, and can create GitLab merge requests for selected records.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/maddy-cc/gc-cli/main/install.sh | bash
```

If `~/.local/bin` is not in your `PATH`, add this to your shell profile:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

For zsh:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

## Install From Clone

```bash
git clone https://github.com/maddy-cc/gc-cli.git
cd gc-cli
./install.sh
```

## Usage

Create and record a new branch:

```bash
gc ma-1.6.8-docFetch-5.20 -n "同行账号监控"
```

Open the local dashboard:

```bash
gc web
```

Rename the current branch and update the local record:

```bash
gc rename ma-dhSelectOpt-5.22 -n "数字人列表选择优化"
```

Show records in the terminal:

```bash
gc list
```

## GitLab Settings

Open the dashboard:

```bash
gc web
```

Then click `GitLab 设置` and fill in:

- GitLab URL
- Personal Access Token
- Default target branch

The token is stored only on the current user's machine.

## Local Data

The installer only installs the `gc` program. It does not include or upload user data.

Local user files:

```text
~/.gc-branch-log.jsonl
~/.gc-config.json
```

## Upgrade

Run the install command again:

```bash
curl -fsSL https://raw.githubusercontent.com/maddy-cc/gc-cli/main/install.sh | bash
```

## Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/maddy-cc/gc-cli/main/uninstall.sh | bash
```

This removes `~/.local/bin/gc` only. Local records and config are not deleted.
