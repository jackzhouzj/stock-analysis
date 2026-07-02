# Stock Analysis - 股票分析系统

基于 AI Agent 驱动的个人股票分析与交易策略管理系统。通过模块化的 Skills 提供数据能力，结合结构化的 Strategy 管理交易决策规则，配合 Manual 沉淀指标知识。

## 项目结构

```
stock-analysis/
├── SKILL.md                         # 系统入口（AI + 人类使用说明）
├── manual/                          # 投资手册（指标科普 + 体系总纲）
│   ├── 股票常用指标手册.md       # 指标怎么读、怎么用、怎么选股
│   └── 股票投资实战手册.md       # 总纲入口，串联全部文档
├── skills/                          # 数据能力 Skills
│   ├── ifind-finance-data-1.3.0/      # 同花顺 iFinD 金融数据查询
│   └── plate-rotation-skill/          # A股板块轮动分析
├── strategy/                        # 交易策略
│   ├── 策略路由.md                  # 入口：当前适合做什么
│   ├── 大盘环境模块.md             # 共享：统一的大盘环境判断口径
│   ├── 消息面事件驱动模块.md       # 共享：消息面对环境分的定性修正/否决
│   ├── 个股综合体检策略.md         # 综合分析（六步体检+三线评级）
│   ├── 账户分析策略.md             # 读持仓·逐票诊断·组合风控·操作清单
│   ├── 资金与风险管理策略.md       # 共享：仓位/熔断/集中度/回撤统一口径
│   ├── 卖出决策策略.md             # 止损/止盈/减仓/换仓决策系统
│   ├── 持仓管理.md                 # 持仓台账规范与维护流程
│   ├── 复盘与进化策略.md           # 统一复盘中枢·校准闭环（实盘后验证）
│   ├── 回测与验证策略.md           # 实盘前验证·把经验值变成数据值
│   ├── 异动归因策略.md             # 涨跌停/放量/闪崩快速归因
│   ├── 阈值与版本记录.md           # 阈值单一来源+调整留痕
│   ├── 短线炒股策略.md             # 短线方法论
│   ├── 短线严格筛选策略.md         # 短线量化执行版
│   ├── 中线投资策略.md             # 中线方法论
│   ├── 中线严格筛选策略.md         # 中线量化执行版
│   ├── 长线投资策略.md             # 长线方法论
│   └── 长线严格筛选策略.md         # 长线量化执行版
├── mcp/                             # MCP 服务配置
│   └── 同花顺_MCP.json              # iFinD 数据接口连接配置
├── account/                         # 账户持仓数据（每个 {名}.csv 是一个账户）
│   ├── erik.csv
│   └── erik_meta.txt
└── README.MD
```

## 模块说明

### Manual（投资手册）

沉淀指标知识与体系总纲，是全部策略的认知底座：

| 文件 | 职责 |
|------|------|
| 股票常用指标手册 | 估值/盈利/成长/财务/资金/技术指标的读法与组合用法 |
| 股票投资实战手册 | 总入口，串联手册与策略，提供速查表与核心纪律 |

### Skills（数据能力）

提供数据获取与分析工具，是策略执行的数据底座：

| Skill | 职责 | 数据范围 |
|-------|------|----------|
| ifind-finance-data | 同花顺 iFinD 金融数据查询 | 股票/基金/债券/指数/宏观/新闻/港美股 |
| plate-rotation | A股板块轮动分析 | 板块强度、妖王榜、排名曲线、双源对照 |

### Strategy（交易策略）

每条线成对出现：方法论（理念+流程）+ 严格筛选（闸门+量化打分）：

| 时间纬度 | 方法论 | 量化执行版 | 核心理念 |
|----------|--------|------------|----------|
| 路由 | 策略路由 | — | 判断当前环境适合哪条线 |
| 环境 | 大盘环境模块 | — | 全策略共享的统一环境判断口径 |
| 消息面 | 消息面事件驱动模块 | — | 共享：消息面对环境分的定性修正/否决 |
| 短线 | 短线炒股策略 | 短线严格筛选策略 | 资金主线 + 形态触发 + 机械纪律 |
| 中线 | 中线投资策略 | 中线严格筛选策略 | 趋势确立 + 景气兑现 + 破位即走 |
| 长线 | 长线投资策略 | 长线严格筛选策略 | 盈利质量 + 护城河 + 好价格 |
| 综合 | 个股综合体检策略 | — | 六步全维度体检 + 三线适用性评估 |
| 账户 | 账户分析策略 | — | 读持仓 + 逐票诊断 + 组合风控 + 操作清单 |
| 风控 | 资金与风险管理策略 | — | 共享：仓位/熔断/集中度/回撤统一口径 |
| 卖出 | 卖出决策策略 | — | 止损/止盈/减仓/换仓决策系统 |
| 台账 | 持仓管理 | — | 持仓台账规范与维护流程（account/ 载体） |
| 复盘 | 复盘与进化策略 | — | 统一复盘中枢 + 校准闭环（实盘后验证） |
| 回测 | 回测与验证策略 | — | 实盘前验证：历史样本统计 + 模拟盘前向验证 |
| 异动 | 异动归因策略 | — | 涨跌停/放量/闪崩快速归因 |
| 记录 | 阈值与版本记录 | — | 阈值单一来源 + 调整留痕 |

## 数据源

系统通过 MCP 接口接入同花顺 iFinD 数据服务，支持以下数据能力：

- **股票数据** — 行情、财务、股东、ESG、高频报价
- **指数/板块** — 指数行情、板块数据、板块轮动
- **基金数据** — 基金概况、持仓、业绩
- **债券数据** — 基本面、行情、高频报价
- **宏观数据** — 经济数据库（EDB）
- **资讯数据** — 公告、新闻搜索
- **全球市场** — 港美股行情与财务数据

## 使用方式

1. **学习认知**：阅读 `manual/` 下的指标手册建立基础
2. **个股分析**：按策略对应的闸门流程逐层筛选
3. **板块轮动**：使用 plate-rotation skill 识别资金主线
4. **异动归因**：对盘中异动进行快速原因分析

## 设计原则

- **职责分离** — Manual 负责「认知」，Skills 负责「取数」，Strategy 负责「决策」
- **方法论 + 执行版成对** — 每条线都有理念篇和可执行的量化筛选版
- **数据驱动** — 所有分析基于实时数据，减少主观判断
- **可迭代** — 策略可根据执行结果持续优化

---

## 环境配置

### 前置要求

| 依赖 | 版本要求 | 用途 |
|------|----------|------|
| Python | ≥ 3.10 | plate-rotation 脚本、ifind-finance-data 备用调用 |
| Node.js | ≥ 16.x | ifind-finance-data 主调用方式（call-node.js） |
| pip | 随 Python 自带 | 安装 requests 库（ifind Python 方案需要） |

### 安装步骤

#### 1. 克隆项目

```bash
git clone <repo-url> stock-analysis
cd stock-analysis
```

#### 2. 配置 MCP（数据接口）

本项目使用同花顺 iFinD MCP 作为主数据源。

**方式一：IDE 全局配置（推荐）**

在 Qoder/Claude 的 MCP 设置中添加以下服务：

```json
{
  "mcpServers": {
    "hexin-ifind-ds-stock-mcp": {
      "type": "streamablehttp",
      "url": "https://api-mcp.51ifind.com:8643/ds-mcp-servers/hexin-ifind-ds-stock-mcp",
      "headers": { "Authorization": "<your-ifind-token>" }
    },
    "hexin-ifind-ds-fund-mcp": {
      "type": "streamablehttp",
      "url": "https://api-mcp.51ifind.com:8643/ds-mcp-servers/hexin-ifind-ds-fund-mcp",
      "headers": { "Authorization": "<your-ifind-token>" }
    },
    "hexin-ifind-ds-edb-mcp": {
      "type": "streamablehttp",
      "url": "https://api-mcp.51ifind.com:8643/ds-mcp-servers/hexin-ifind-ds-edb-mcp",
      "headers": { "Authorization": "<your-ifind-token>" }
    },
    "hexin-ifind-ds-news-mcp": {
      "type": "streamablehttp",
      "url": "https://api-mcp.51ifind.com:8643/ds-mcp-servers/hexin-ifind-ds-news-mcp",
      "headers": { "Authorization": "<your-ifind-token>" }
    },
    "hexin-ifind-ds-bond-mcp": {
      "type": "streamablehttp",
      "url": "https://api-mcp.51ifind.com:8643/ds-mcp-servers/hexin-ifind-ds-bond-mcp",
      "headers": { "Authorization": "<your-ifind-token>" }
    },
    "hexin-ifind-ds-global-stock-mcp": {
      "type": "streamablehttp",
      "url": "https://api-mcp.51ifind.com:8643/ds-mcp-servers/hexin-ifind-ds-global-stock-mcp",
      "headers": { "Authorization": "<your-ifind-token>" }
    },
    "hexin-ifind-ds-index-mcp": {
      "type": "streamablehttp",
      "url": "https://api-mcp.51ifind.com:8643/ds-mcp-servers/hexin-ifind-ds-index-mcp",
      "headers": { "Authorization": "<your-ifind-token>" }
    }
  }
}
```

> Token 获取：https://www.51ifind.com → MCP官网 → 个人中心 → 密钥

**方式二：项目内配置**

直接编辑 `mcp/同花顺_MCP.json`，填入真实 token，然后在 IDE 中导入该配置文件。

#### 3. 配置 Skills

**plate-rotation（板块轮动）**：

```bash
# 无额外依赖，仅需 Python 3.10+，用内置库
# 验证运行：
python3 skills/plate-rotation-skill/scripts/platerotat.py today --n 3
```

**ifind-finance-data（iFinD 数据查询）**：

```bash
# 方式一：Node.js（推荐，无额外依赖）
# 确保 node ≥ 16.x 即可

# 方式二：Python（备选）
pip install requests
```

配置密钥：

```bash
# 编辑 skills/ifind-finance-data-1.3.0/mcp_config.json
# 将 auth_token 替换为真实的 iFinD token
```

#### 4. 验证安装

```bash
# 验证 plate-rotation
python3 skills/plate-rotation-skill/scripts/platerotat.py today --n 3
# 应输出 Top 3 板块排名

# 验证 MCP（在 Qoder/Claude 中）
# 输入：贵州茅台最新估值
# 应返回 PE/PB/PS 等数据
```

#### 5. 安全配置（推送代码前必做）

确保 `.gitignore` 包含：

```
# Token / 密钥
mcp/同花顺_MCP.json
skills/ifind-finance-data-1.3.0/mcp_config.json

# 缓存
__pycache__/
*.pyc
.cache/
```