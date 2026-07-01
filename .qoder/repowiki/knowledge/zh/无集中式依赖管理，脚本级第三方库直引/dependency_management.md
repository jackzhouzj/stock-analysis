本仓库未采用任何集中式的依赖管理系统（如 Python 的 `requirements.txt`/`pyproject.toml`、Node.js 的 `package.json`、Go 的 `go.mod` 等），也未发现 vendoring 或私有包注册表配置。所有代码以独立脚本形式组织，第三方库通过运行时直接 import 引入，具体分布如下：

- **ifind-finance-data skill**：Python 端 `call.py` 使用标准库 `json/math/pathlib` 与第三方库 `requests`；Node.js 端 `call-node.js` 仅依赖 Node 内置模块（`fs`/`path`/`http`/`https`）。
- **plate-rotation skill**：`scripts/fetch.py`、`cache.py`、`parsers.py`、`platerotat.py` 全部只使用 Python 标准库（`argparse`、`urllib`、`hashlib`、`json`、`os`、`time`、`re`、`subprocess` 等），无任何第三方依赖。
- 根目录及 `strategy/`、`manual/` 下均为 Markdown 文档，不涉及依赖声明。

因此该仓库不存在统一的依赖版本锁定、升级策略或供应商隔离机制；每个 skill 目录各自为政，依赖安装需由使用者自行在运行环境中满足（例如手动 `pip install requests`）。