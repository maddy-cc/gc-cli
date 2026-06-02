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
