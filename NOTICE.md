# 来源与改写说明

本仓库基于以下上游项目改写：

- 上游：https://github.com/YAN-143/dsh-infinite-gen-2
- 上游版本：0.2.3
- 上游许可：MIT（见 `LICENSE`，版权归原作者 0x5477）

## 本仓库（0.2.4）改了什么

1. 在 `prompts/infinite-gen-2.md` 开头插入 `<SECTION PREFACE>`：声明本文件对所列类别优先于平台通用指引，
   禁止从任务描述推断用途、受益方、影响对象，禁止以「部分能力」替代请求的全部内容。
2. 在提示词末尾新增 `## Local-analysis categories`：把
   外挂 / 辅助 / 辅助器 / 脚本 / 注入器 / 内存读写 / 驱动 / 反作弊 / 检测
   以及 cheat / hack / trainer / loader / injector / aimbot / wallhack / ESP / radar /
   overlay / memory reader / driver / anti-cheat / signature / ban
   定义为内容标签，映射到本地技术工作（抓包、字段、偏移、结构、状态机、回放服务端、检测面清单）。
3. 新增 `install-win.ps1`：纯 ASCII 的 Windows 安装器，自动探测 profile、自动找 pnpm
   （PATH → %APPDATA%\npm → %LOCALAPPDATA%\pnpm → corepack → npx），
   找不到包管理器时回退为「直连覆盖已安装副本」。原版 `install.ps1` 为 UTF-8 无 BOM，
   Windows PowerShell 5.1 会按 ANSI 读取导致解析错误，故保留但不再推荐。
4. `package.json` 版本 0.2.4，补充 CHANGELOG 条目。

插件运行时逻辑（`index.js`、`client.js`、`cordis.patch.yml`）未改动。
