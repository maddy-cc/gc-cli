# gc-cli

`gc` 是一个本地分支记录工具，用来记录每次开发创建的分支、所属项目、迭代信息，并提供本地 Web 页面查看记录和批量创建 GitLab MR。

它只安装程序本身，不会上传或打包任何个人数据。

## 安装

```bash
curl -fsSL https://raw.githubusercontent.com/maddy-cc/gc-cli/main/install.sh | bash
```

如果安装后提示 `~/.local/bin` 不在 `PATH`，把下面这行加入 shell 配置：

```bash
export PATH="$HOME/.local/bin:$PATH"
```

如果使用 zsh，可以执行：

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

## 从源码安装

```bash
git clone https://github.com/maddy-cc/gc-cli.git
cd gc-cli
./install.sh
```

## 常用命令

创建并记录新分支：

```bash
gc ma-1.6.8-docFetch-5.20 -n "同行账号监控"
```

打开本地 Web 页面：

```bash
gc web
```

查看终端记录：

```bash
gc list
```

重命名当前分支，并同步更新本地记录：

```bash
gc rename ma-dhSelectOpt-5.22 -n "数字人列表选择优化"
```

只预览，不创建分支、不写入记录：

```bash
gc ma-1.6.8-docFetch-5.20 -n "同行账号监控" --dry-run
```

## 分支命名规范

创建分支时，命令参数里有两个必填项：

| 参数 | 是否必填 | 示例 | 说明 |
| --- | --- | --- | --- |
| `branch` | 必填 | `ma-1.6.8-docFetch-5.20` | 要创建的分支名 |
| `-n, --name` | 必填 | `"同行账号监控"` | 迭代名称，也会用于 MR 标题 |

`-n` 不是分支名的一部分，不参与分支名解析。

推荐格式：

```text
<owner>-<iteration_version>-<feature_key>-<branch_date>
```

示例：

```text
ma-1.6.8-docFetch-5.20
```

字段说明：

| 字段 | 是否必填 | 示例 | 说明 |
| --- | --- | --- | --- |
| `owner` | 必填 | `ma` | 创建人标识，必须放在第一段 |
| `iteration_version` | 可省略 | `1.6.8` | 迭代版本号，只识别数字点号格式 |
| `feature_key` | 必填 | `docFetch` | 功能标识，可以包含多个 `-` 分段 |
| `branch_date` | 可省略 | `5.20` | 分支日期，支持 `5.20`、`05.20`、`2026.05.20` |

### 必填字段

必须至少包含：

```text
<owner>-<feature_key>
```

例如：

```bash
gc ma-virtualListFix -n "虚拟列表修复"
```

下面这些会失败：

```text
ma
ma-1.6.8
ma-5.20
```

原因是缺少功能标识 `feature_key`。

### 迭代版本可以省略

带迭代版本：

```bash
gc ma-1.6.8-docFetch-5.20 -n "同行账号监控"
```

解析结果：

```text
owner: ma
iteration_version: 1.6.8
feature_key: docFetch
branch_date: 5.20
```

不带迭代版本：

```bash
gc ma-virtualList-fix-5.22 -n "虚拟列表修复"
```

解析结果：

```text
owner: ma
iteration_version: 空
feature_key: virtualList-fix
branch_date: 5.22
```

省略迭代版本后的影响：

- Web 页面“迭代”列为空
- 迭代筛选里不会出现这个版本
- 创建 MR 时，如果 `-n` 是 `虚拟列表修复`，MR 标题就是 `虚拟列表修复`

如果带迭代版本，MR 标题会是：

```text
1.6.8-同行账号监控
```

### 日期可以省略

带日期：

```bash
gc ma-1.6.8-docFetch-5.20 -n "同行账号监控"
```

不带日期：

```bash
gc ma-1.6.8-docFetch -n "同行账号监控"
```

省略日期后的行为：

- 分支名不会被自动改写
- 记录里的 `branch_date` 会使用创建当天日期
- 默认日期格式是 `M.DD`，例如 `6.02`

### 版本号识别规则

版本号只在 `owner` 后面的第一段识别，并且必须是数字点号格式：

```text
1.6.8
1.10
2.0.0
```

这些不会被识别为版本号，会被当成功能名的一部分：

```text
v1.6.8
release-1.6.8
docFetch
```

例如：

```bash
gc ma-v1.6.8-docFetch-5.20 -n "同行账号监控"
```

解析结果是：

```text
owner: ma
iteration_version: 空
feature_key: v1.6.8-docFetch
branch_date: 5.20
```

### 日期识别规则

日期只在最后一段识别，支持：

```text
5.20
05.20
2026.05.20
```

如果最后一段不是日期格式，会被当成功能名的一部分。

例如：

```bash
gc ma-1.6.8-docFetch-test -n "同行账号监控"
```

解析结果是：

```text
owner: ma
iteration_version: 1.6.8
feature_key: docFetch-test
branch_date: 创建当天日期
```

## 重命名分支

`gc rename` 用来重命名本地 Git 分支，并同步更新 `gc` 本地记录。

基本用法：

```bash
gc rename <new_branch>
```

示例：

```bash
gc rename ma-dhSelectOpt-5.22
```

这会执行：

```bash
git branch -m ma-dhSelectOpt-5.22
```

也就是把当前分支重命名为 `ma-dhSelectOpt-5.22`。

### 顺便更新迭代名称

```bash
gc rename ma-dhSelectOpt-5.22 -n "数字人列表选择优化"
```

`-n` 在 `gc rename` 中是可选的。

如果填写了 `-n`，会同步更新本地记录里的迭代名称。

### 指定旧分支

默认情况下，`gc rename` 会重命名当前分支。

如果要重命名一个非当前分支，可以使用 `--from`：

```bash
gc rename ma-newBranch-5.22 --from ma-oldBranch-5.22
```

这会执行：

```bash
git branch -m ma-oldBranch-5.22 ma-newBranch-5.22
```

### 只预览

```bash
gc rename ma-dhSelectOpt-5.22 --dry-run
```

只打印将要执行的操作，不会真正重命名，也不会更新本地记录。

### 对本地记录的影响

`gc rename` 会重新解析新分支名，并更新本地记录中的这些字段：

- 分支名
- 迭代版本
- 功能标识
- 分支日期
- 创建人标识
- 迭代名称，如果传了 `-n`

同步记录时，会用当前项目路径和旧分支名匹配记录。

如果找不到对应记录，Git 分支仍会被重命名，但会提示：

```text
未找到可同步的台账记录
```

### 远端分支处理

`gc rename` 只处理本地分支，不会自动 push，也不会自动删除远端旧分支。

如果旧分支还没有 push 到远端，重命名后直接 push 新分支：

```bash
git push -u origin ma-dhSelectOpt-5.22
```

如果旧分支已经 push 到远端，通常需要：

```bash
git push -u origin ma-dhSelectOpt-5.22
git push origin --delete old-branch-name
```

如果删除远端旧分支时报：

```text
remote ref does not exist
```

说明远端没有这个旧分支，一般可以忽略。

## GitLab MR

打开 Web 页面：

```bash
gc web
```

点击 `GitLab 设置`，填写：

- GitLab 地址
- Personal Access Token
- 默认目标分支

创建 MR 前，需要先把本地分支 push 到远程：

```bash
git push -u origin 当前分支名
```

然后在 `gc web` 页面中选择未上线记录，批量创建 MR。

MR 标题规则：

```text
有迭代版本：<iteration_version>-<iteration_name>
无迭代版本：<iteration_name>
```

示例：

```text
1.6.8-同行账号监控
虚拟列表修复
```

## 本地数据

安装脚本只安装 `gc` 程序，不包含个人数据。

每个用户的数据都保存在自己电脑上：

```text
~/.gc-branch-log.jsonl
~/.gc-config.json
```

说明：

- `~/.gc-branch-log.jsonl`：分支记录
- `~/.gc-config.json`：GitLab 配置和 token

## 升级

重新执行安装命令即可：

```bash
curl -fsSL https://raw.githubusercontent.com/maddy-cc/gc-cli/main/install.sh | bash
```

升级只覆盖 `~/.local/bin/gc`，不会删除本地记录或 GitLab 配置。

## 卸载

```bash
curl -fsSL https://raw.githubusercontent.com/maddy-cc/gc-cli/main/uninstall.sh | bash
```

卸载只删除：

```text
~/.local/bin/gc
```

不会删除：

```text
~/.gc-branch-log.jsonl
~/.gc-config.json
```
