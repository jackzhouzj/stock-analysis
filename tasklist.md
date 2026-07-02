# 待办清单（Task List）

> 更新日期：2026-07-01

---

## P0 — 安全基础

- [ ] **.gitignore 配置**
  - 保护含 token 的文件：`mcp/同花顺_MCP.json`、`skills/ifind-finance-data-1.3.0/mcp_config.json`
  - 忽略编译缓存：`__pycache__/`、`*.pyc`

---

## P1 — 数据源扩展

- [ ] **接入新浪财经 MCP**（优先级已下调 ⬇️）

  - 用途：免费实时市场情绪数据（涨跌分布、涨停数量、炸板率），补充短线环境判断
  - 地址：https://zyhub.finance.sina.cn/mcp
  - **⚠️ 2026-07-02 校正**：经实测，**iFinD `search_stocks` 已可取到连板梯队（连续涨停天数）与炸板率（最高价触及涨停价但收盘<涨停价）**，情绪数据缺口已由现有数据源补齐。本项降级为"可选备用源/交叉验证"，非必需。
  - 接入方式：见下方「接入方法」
- [ ] **A股涨停追踪模块调研**（优先级已下调 ⬇️）

  - 用途：涨停/连板/炸板率量化数据，增强短线策略的情绪周期判断
  - 候选：GitHub `a-stock` topic 下 29 个 Skills 中的涨停追踪模块
  - 参考：https://github.com/topics/a-stock
  - **⚠️ 2026-07-02 校正**：涨停/连板/炸板数据 iFinD `search_stocks` 已覆盖（见 `strategy/大盘环境模块.md` 取数配方），本项仅在需要更细颗粒（如封单额、开板时点、连板晋级率）时再评估。
- [ ] **接入 Tushare MCP**

  - 用途：作为 iFinD 的备用数据源（免费层 + Pro 层）
  - 地址：https://github.com/buuzzy/tushare_MCP
  - 接入方式：见下方「接入方法」

---

## P1.5 — 分析能力扩展（Skills / Agent）

- [ ] **Claude-Code-Stock-Deep-Research-Agent**

  - 用途：8 阶段股票投资尽调框架，28 个并行研究 Agent，深度研报级分析
  - 地址：https://github.com/liangdabiao/Claude-Code-Stock-Deep-Research-Agent
  - 与本项目互补：比体检策略更深入，适合重仓标的的深度研究
  - 接入方式：见下方「接入方法」
- [ ] **A股 29 个即插即用 Skills**

  - 用途：覆盖数据采集/大盘分析/资金流向/涨停追踪/技术面/基本面/估值/回测/风控
  - 地址：https://github.com/topics/a-stock
  - 与本项目互补：挑选「涨停追踪」「资金流向」补充现有策略缺少的维度
  - 接入方式：见下方「接入方法」
- [ ] **Day1Global-Skills（科技股财报深度分析）**

  - 用途：16 大分析模块、6 大投资哲学视角、多方法估值矩阵
  - 地址：https://gitcode.com/gh_mirrors/da/Day1Global-Skills
  - 与本项目互补：如果重仓科技股，可用于财报季深度分析
  - 接入方式：见下方「接入方法」
- [ ] **daily_stock_analysis（自动化日报）**

  - 用途：LLM 驱动的多市场股票智能分析 + 定时推送
  - 地址：https://skillsllm.com/skill/daily-stock-analysis
  - 与本项目互补：每日收盘后自动跑策略路由 + 环境判断
  - 接入方式：见下方「接入方法」

---

## P2 — 功能补全

- [ ] **持仓管理模板**

  - 用途：跟踪当前持仓、入场价、止损位、复检状态、下次验证节点
  - 位置：`strategy/持仓管理.md` 或 `manual/持仓管理模板.md`
- [ ] **实战案例**

  - 用途：放 1-2 个真实体检报告示例，让 AI 输出有参照格式
  - 位置：`examples/` 目录

---

## P3 — 远期优化

- [ ] **策略版本记录** — 阈值调整历史（如止损从-5%调到-8%的原因）
- [ ] **项目 LICENSE** — 如需开源
- [ ] **自动化日报** — 每日收盘后自动生成市场环境 + 策略路由判断

---

---

# 数据源接入方法

## 1. 新浪财经 MCP

**概述**：免费、无需 token，提供 A 股实时涨跌分布、市场情绪数据。

**能力**：

- 涨跌分布统计（涨停/跌停/各区间数量）
- 市场整体情绪判断

**接入配置**（添加到 `mcp/` 或 IDE 全局 MCP 设置中）：

```json
{
  "mcpServers": {
    "sina-finance": {
      "type": "sse",
      "url": "https://zyhub.finance.sina.cn/mcp/sse"
    }
  }
}
```

**验证**：接入后调用涨跌分布查询工具，确认能返回当日数据。

**用途映射**：

- 短线环境闸 → 市场赚钱效应判断
- 策略路由 → 涨停数/炸板率辅助环境定性

---

## 2. Tushare MCP

**概述**：基于 Tushare Pro 的 MCP 服务，30+ 金融数据接口，作为 iFinD 备用。

**前置条件**：

1. 注册 Tushare Pro 账号：https://tushare.pro/register
2. 获取 API token（个人中心 → 接口TOKEN）

**安装**：

```bash
# 克隆项目
git clone https://github.com/buuzzy/tushare_MCP.git
cd tushare_MCP

# 安装依赖
pip install -r requirements.txt

# 配置 token（环境变量）
export TUSHARE_TOKEN="your_tushare_pro_token"
```

**接入配置**（stdio 模式）：

```json
{
  "mcpServers": {
    "tushare": {
      "command": "python",
      "args": ["/path/to/tushare_MCP/server.py"],
      "env": {
        "TUSHARE_TOKEN": "your_tushare_pro_token"
      }
    }
  }
}
```

**主要能力**：

- 日线/周线/月线行情
- 财务报表（利润表/资产负债表/现金流量表）
- 公司基本面（股本/股东/分红）
- 市场参考数据（复权因子/停复牌）

**用途映射**：

- iFinD 接口异常时的降级备选
- 历史数据回测场景

---

## 3. mcp-cn-a-stock（轻量免费）

**概述**：开源轻量 A 股数据 MCP，零配置开箱即用。

**安装**：

```bash
# 方式一：npx 直接运行（推荐）
npx mcp-cn-a-stock

# 方式二：克隆
git clone https://github.com/elsejj/mcp-cn-a-stock.git
cd mcp-cn-a-stock
npm install
```

**接入配置**：

```json
{
  "mcpServers": {
    "cn-a-stock": {
      "command": "npx",
      "args": ["mcp-cn-a-stock"]
    }
  }
}
```

**主要能力**：

- `brief`：股票基本信息摘要
- 实时行情/K线
- 板块信息

**用途映射**：

- 快速获取个股基本信息（体检第 1 步补充）
- 轻量场景下替代 iFinD 的 `get_stock_summary`

---

## 4. A股 Skills 集合（Claude/Qoder 技能）

**概述**：GitHub 上有覆盖 A 股多维度分析的 Skills 集合。

**参考项目**：

- https://github.com/topics/a-stock（29 个即插即用 Skills）
- 覆盖：数据采集/大盘分析/资金流向/涨停追踪/技术面/基本面/估值/回测/风控

**接入方式**：

```bash
# 克隆感兴趣的 skill
git clone <skill-repo-url> skills/<skill-name>/

# 确认目录内有 SKILL.md
# 路径使用 {SKILL_DIR} 占位符保持可移植性
```

**重点关注模块**：

- 涨停追踪 — 补充短线策略的情绪周期（涨停数/连板高度/炸板率）
- 资金流向 — 与现有 iFinD 资金数据交叉验证

---

## 5. Claude-Code-Stock-Deep-Research-Agent

**概述**：基于 Claude Code 的股票深度研究智能体，8 阶段尽调框架，28 个并行研究 Agent。

**能力**：

- 8 阶段尽调：行业分析 → 竞争格局 → 财务深度 → 估值建模 → 风险评估 → 多空平衡 → 结论
- 多空平衡视角，比体检策略更深入

**接入方式**：

```bash
# 克隆
git clone https://github.com/liangdabiao/Claude-Code-Stock-Deep-Research-Agent.git

# 可作为独立工具调用，或将其方法论融入本项目的体检策略
# 核心价值：尽调框架 + 多空平衡思维
```

**用途映射**：

- 重仓标的的深度研究（体检通过后的二次确认）
- 长线核心仓候选的深度尽调

---

## 6. Day1Global-Skills（科技股财报深度分析）

**概述**：专为 Claude 打造的科技公司财报深度分析系统。16 大分析模块、6 大投资哲学视角。

**能力**：

- 16 大分析模块（营收/利润/现金流/资本配置/增长质量...）
- 6 大投资哲学视角（巴菲特/戴维斯/彼得林奇...）
- 多方法估值矩阵 + 反偏见框架

**接入方式**：

```bash
git clone https://gitcode.com/gh_mirrors/da/Day1Global-Skills.git skills/day1global-skills/

# 财报季时用于科技股持仓的深度分析
# 配合本项目长线策略的季度复检环节使用
```

**用途映射**：

- 长线持仓季度复检时的财报深度分析
- 科技股体检第 3 步（基本面）的深化版

---

## 7. daily_stock_analysis（自动化日报）

**概述**：LLM 驱动的多市场股票智能分析系统，支持定时运行和自动推送。

**能力**：

- 多源行情数据采集
- 实时新闻整合
- 决策看板生成
- 定时触发 + 消息推送

**接入方式**：

```bash
# 参考项目
git clone <daily-stock-analysis-repo>

# 核心价值：定时任务框架
# 可配合本项目的策略路由，每日收盘后自动跑：
# 1. 环境判断（大盘+主线）
# 2. 策略路由结果
# 3. 持仓复检
# 4. 推送结论
```

**用途映射**：

- 自动化 P3 待办「自动化日报」的实现参考
- 每日策略路由 + 持仓复检的自动化

---

## 接入后的集成检查清单

接入新数据源后，按以下步骤确认集成完整：

- [ ] MCP 配置写入 `mcp/` 目录（或 IDE 设置）
- [ ] 验证工具调用可正常返回数据
- [ ] 在对应策略文件中标注新工具的使用场景
- [ ] 更新 `SKILL.md` 的 MCP 工具清单
- [ ] 含 token 的配置文件加入 `.gitignore`
- [ ] README 目录树同步更新
