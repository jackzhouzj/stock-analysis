本仓库为股票分析工具集，包含两个独立的 Python 脚本模块。整体未建立统一的错误类型体系或全局中间件，而是采用按模块自治的轻量风格：在各自脚本内用标准异常加幂等重试加文件缓存兜底来保证健壮性。

## ifind-finance-data-1.3.0/call.py
- 参数校验失败直接 raise TypeError（如非 dict、含 blocked key、非有限浮点数、不支持类型）。
- 未知 server_type / tool_name 使用 raise ValueError 快速失败。
- 初始化后缺失 Mcp-Session-Id 或 tools/list 响应结构异常时 raise RuntimeError。
- HTTP 层统一通过 requests.post(...).raise_for_status() 把网络/状态码错误上抛；对服务端返回的 JSON error 字段则转为 {ok: False, status_code, error, raw} 结构化结果，由调用方自行判断。
- 无自定义异常类，无日志记录，无重试逻辑。

## plate-rotation-skill/scripts/fetch.py
- 参数解析错误（无效 host alias、非法 kv、JSON 格式错误）直接 sys.exit(...) 退出并带前缀 [fetch] ERROR: 提示，适合 CLI 场景。
- HTTP 请求封装在 do_request 中，对 429/500/502/503/504 及任意网络异常执行指数退避重试（默认最多 3 次，间隔 1s/2s/4s），最终失败统一 raise RuntimeError，并在 main 中捕获后输出到 stderr 并以 exit code 2 退出。
- 非可重试 4xx 错误直接 raise，不重试。
- POST 请求默认走本地磁盘缓存（cache.py），TTL 可配置；缓存命中直接返回原始 body，绕过网络。

## plate-rotation-skill/scripts/cache.py
- 提供 PR_CACHE_DISABLE / PR_CACHE_TTL / PR_CACHE_DIR 环境变量开关 TTL 与目录。
- 读缓存时若 JSON 损坏则静默删除文件并 miss；写缓存使用 .json.tmp + os.replace 原子落盘，避免半写文件导致后续读取崩溃。
- 清理接口 cache_clear 对单个文件操作一律 try/except OSError pass，保证批量清理不因个别权限问题中断。

## plate-rotation-skill/scripts/parsers.py
- 纯解析函数，对缺失字段采用 data.get("html", "") 回退空串，正则匹配不到则跳过该行，属于宽容解析而非报错。
- 无显式异常抛出，依赖上层 fetch 保证输入是合法 JSON。

## 设计决策与约定
- 没有定义统一的 Error 基类或错误码枚举，错误以 Python 内置异常加字符串消息表达。
- CLI 入口倾向 sys.exit(非零码) 快速失败；库函数倾向 raise 让调用方决定策略。
- 对外部不稳定资源（HTTP、文件系统）普遍采用 try/except 包裹加降级路径（缓存、raw 输出、空列表）而非集中式错误处理。
- 未引入 logging 框架，调试信息通过 print(..., file=sys.stderr) 输出。
- 无 panic/recover 语义（Python 本身无此概念），也未见全局 except 吞异常的迹象。