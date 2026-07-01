本仓库未提供统一的配置框架或集中式配置文件，而是采用“每个脚本自管 + 环境变量优先”的轻量级配置模式。具体体现在两个子技能中：

1. **ifind-finance-data**：通过 `mcp_config.json` 文件加载认证凭据（`auth_token`），由 `call.py` 在启动时读取并注入到 HTTP 请求头。
2. **plate-rotation-skill**：所有运行时参数均通过环境变量注入，核心变量包括：
   - `PR_CACHE_DIR`：缓存根目录（默认 `~/.cache/plate-rotation`）
   - `PR_CACHE_TTL`：缓存过期时间秒数（默认 3600）
   - `PR_CACHE_DISABLE`：全局关闭缓存（值为 `1`/`true`/`yes`）
   - `PR_COOKIE`：登录凭据（优先于 `~/.plate_rotation_cookie` 文件）

设计约定：
- 环境变量名以 `PR_` 前缀命名，避免冲突；
- 敏感信息（cookie、token）支持“环境变量 > 本地文件”两级回退；
- 行为开关使用布尔字符串集合判断，便于 shell 一键切换；
- 无 `.env` 文件、无 YAML/TOML 配置中心、无运行时热重载机制。

该模式适合小型 CLI 工具与脚本化工作流，但不具备多环境隔离、类型校验与集中管理的能力。