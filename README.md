# Ki2API - Claude Sonnet 4 OpenAI兼容API

一个简单易用的OpenAI兼容API服务，专门用于Claude Sonnet 4模型。支持Docker部署和本地Python运行。

## 功能特点

- 🚀 **一键启动** - Windows下双击bat文件即可运行
- 🔑 **固定API密钥** - 使用 `ki2api-key-2024`
- 🎯 **单一模型** - 仅支持 `claude-sonnet-4-20250514`
- 🌐 **OpenAI兼容** - 完全兼容OpenAI API格式
- 📡 **流式传输** - 支持SSE流式响应
- 🔄 **自动token刷新** - 支持token过期自动刷新
- 📁 **智能token读取** - 自动从Kiro配置文件读取token

## 环境安装

### Windows 环境（推荐）

#### 1. 安装 Miniconda
1. 下载 [Miniconda](https://docs.conda.io/en/latest/miniconda.html)
2. 安装到 `D:\ProgramData\miniconda3` （或修改脚本中的路径）
3. 确保安装时勾选"Add to PATH"选项

#### 2. 一键环境配置
```bash
# 右键以管理员身份运行
setup-kiro-env-auto.bat
```

这个脚本会自动：
- 创建名为 `kiro` 的conda环境
- 安装Python 3.11
- 安装所有项目依赖
- 配置pip和相关工具

#### 3. Kiro客户端配置（可选）

如果你需要使用Kiro客户端，可以运行：
```bash
# 右键以管理员身份运行
kiro.bat
```

这个脚本会自动：
- 创建 `data` 目录用于存储配置
- 将 `.kiro` 和 `.aws` 目录迁移到项目目录
- 创建符号链接，保持系统兼容性
- 启动Kiro客户端

#### 4. 验证安装
```bash
conda activate kiro
python --version  # 应该显示 Python 3.11.x
pip --version     # 确认pip可用
```

### 其他系统环境

#### macOS/Linux
```bash
# 安装Python 3.11+
python3 -m venv venv
source venv/bin/activate  # Linux/macOS
pip install -r requirements.txt
```

## 快速启动

### 方式一：完整启动流程（Windows推荐）

#### 步骤1：启动Kiro客户端（首次使用）
```bash
# 右键以管理员身份运行，配置Kiro环境
kiro.bat
```

#### 步骤2：启动API服务
```bash
# 双击运行，启动Ki2API服务
start-kiro-router.bat
```

`start-kiro-router.bat` 会自动：
- 激活conda环境
- 读取Kiro token配置
- 启动API服务

### 方式二：仅启动API服务

如果已经配置好Kiro环境，直接运行：
```bash
start-kiro-router.bat
```

### 方式三：手动启动

```bash
# 激活环境
conda activate kiro  # Windows
# 或 source venv/bin/activate  # Linux/macOS

# 启动服务
python app.py
```

### 方式四：Docker启动

```bash
docker-compose up -d
```

## Kiro客户端配置详解

### kiro.bat 脚本功能

`kiro.bat` 是一个智能配置脚本，主要功能包括：

1. **数据迁移**：将用户目录下的 `.kiro` 和 `.aws` 文件夹迁移到项目的 `data` 目录
2. **符号链接**：创建符号链接，使系统仍能正常访问配置文件
3. **便携化**：让Kiro配置与项目绑定，便于项目迁移和管理
4. **自动启动**：配置完成后自动启动Kiro客户端

### 工作原理

```
用户目录                    项目目录
%USERPROFILE%\.kiro   →    ki2api\data\.kiro (实际文件)
%USERPROFILE%\.aws    →    ki2api\data\.aws  (实际文件)
       ↑                           ↑
   符号链接                    真实数据
```

### 使用场景

- **首次使用**：自动迁移现有配置
- **项目迁移**：配置文件跟随项目一起移动
- **多环境管理**：不同项目使用独立的Kiro配置

## Token配置

### 自动读取（推荐）

服务会自动从以下位置读取token：
- **Windows**: `%USERPROFILE%\.aws\sso\cache\kiro-auth-token.json`
- **macOS/Linux**: `~/.aws/sso/cache/kiro-auth-token.json`

运行 `kiro.bat` 后，实际文件位置为：
- **项目目录**: `ki2api\data\.aws\sso\cache\kiro-auth-token.json`

只需确保已登录Kiro即可，无需手动配置。

### 手动配置（备用）

如果自动读取失败，可以设置环境变量：
```bash
# Windows
set KIRO_ACCESS_TOKEN=your_access_token
set KIRO_REFRESH_TOKEN=your_refresh_token

# Linux/macOS
export KIRO_ACCESS_TOKEN=your_access_token
export KIRO_REFRESH_TOKEN=your_refresh_token
```

## 使用示例

服务启动后，默认运行在 http://localhost:8989

### 获取模型列表
```bash
curl -H "Authorization: Bearer ki2api-key-2024" \
     http://localhost:8989/v1/models
```

### 非流式对话
```bash
curl -X POST http://localhost:8989/v1/chat/completions \
  -H "Authorization: Bearer ki2api-key-2024" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "claude-sonnet-4-20250514",
    "messages": [
      {"role": "user", "content": "你好，请介绍一下自己"}
    ],
    "max_tokens": 1000
  }'
```

### 流式对话
```bash
curl -X POST http://localhost:8989/v1/chat/completions \
  -H "Authorization: Bearer ki2api-key-2024" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "claude-sonnet-4-20250514",
    "messages": [
      {"role": "user", "content": "写一首关于春天的诗"}
    ],
    "stream": true,
    "max_tokens": 500
  }'
```

### Python客户端示例

```python
import openai

# 配置客户端
client = openai.OpenAI(
    api_key="ki2api-key-2024",
    base_url="http://localhost:8989/v1"
)

# 非流式对话
response = client.chat.completions.create(
    model="claude-sonnet-4-20250514",
    messages=[
        {"role": "user", "content": "你好，请介绍一下自己"}
    ],
    max_tokens=1000
)
print(response.choices[0].message.content)

# 流式对话
stream = client.chat.completions.create(
    model="claude-sonnet-4-20250514",
    messages=[
        {"role": "user", "content": "写一首关于春天的诗"}
    ],
    stream=True,
    max_tokens=500
)

for chunk in stream:
    if chunk.choices[0].delta.content is not None:
        print(chunk.choices[0].delta.content, end="")
```

## Docker部署（可选）

### 使用Docker Compose
```bash
# 启动服务
docker-compose up -d

# 查看日志
docker-compose logs -f

# 停止服务
docker-compose down
```

### 使用Docker命令
```bash
# 构建镜像
docker build -t ki2api .

# 运行容器（自动读取token）
docker run -d \
  -p 8989:8989 \
  -v ~/.aws/sso/cache:/root/.aws/sso/cache:ro \
  --name ki2api \
  ki2api
```

## API端点

### GET /v1/models
获取可用模型列表

### POST /v1/chat/completions
创建聊天完成

### GET /health
健康检查端点

## 配置说明

### 环境变量

| 变量名 | 默认值 | 说明 |
|--------|--------|------|
| API_KEY | ki2api-key-2024 | API访问密钥 |
| KIRO_ACCESS_TOKEN | 自动读取 | Kiro访问令牌（自动从配置文件读取） |
| KIRO_REFRESH_TOKEN | 自动读取 | Kiro刷新令牌（自动从配置文件读取） |

### 依赖要求

- Python 3.11+
- FastAPI 0.104.1+
- 其他依赖见 `requirements.txt`

## 开发模式

### 开发环境搭建
```bash
# 克隆项目
git clone <repository-url>
cd ki2api

# Windows: 运行环境配置脚本
setup-kiro-env-auto.bat

# 或手动安装
conda create -n kiro python=3.11 -y
conda activate kiro
pip install -r requirements.txt
```

### 调试运行
```bash
# 激活环境
conda activate kiro

# 启动开发服务器
python app.py

# 或使用uvicorn（支持热重载）
uvicorn app:app --reload --host 0.0.0.0 --port 8989
```

## 故障排除

### 常见问题

1. **环境配置失败**
   - 确保以管理员身份运行 `setup-kiro-env-auto.bat`
   - 检查Miniconda安装路径是否正确
   - 确保网络连接正常

2. **Kiro客户端配置问题**
   - 确保以管理员身份运行 `kiro.bat`
   - 检查是否有足够的磁盘空间进行数据迁移
   - 如果符号链接创建失败，检查Windows版本是否支持符号链接

3. **Token读取失败**
   - 确保已登录Kiro (https://kiro.dev)
   - 运行 `kiro.bat` 确保配置文件正确迁移
   - 检查token文件是否存在：`%USERPROFILE%\.aws\sso\cache\kiro-auth-token.json`
   - 尝试重新登录Kiro

4. **服务启动失败**
   - 检查端口8989是否被占用
   - 确认conda环境已正确激活
   - 查看错误日志定位问题

5. **API返回401**
   - 确认使用了正确的API密钥：`ki2api-key-2024`
   - 检查token是否有效或过期

### 查看日志
```bash
# 本地运行日志
python app.py

# Docker日志
docker-compose logs -f ki2api

# 保存日志到文件
python app.py 2>&1 | tee ki2api.log
```

### 重置环境
```bash
# 删除conda环境重新创建
conda env remove -n kiro
# 然后重新运行 setup-kiro-env-auto.bat
```

## 项目结构
```
ki2api/
├── app.py                    # 主应用文件
├── token_reader.py           # Token读取工具
├── kiro.bat                  # Kiro客户端配置脚本（Windows）
├── start-kiro-router.bat     # API服务启动脚本（Windows）
├── setup-kiro-env-auto.bat   # 环境配置脚本（Windows）
├── requirements.txt          # Python依赖
├── Dockerfile               # Docker镜像定义
├── docker-compose.yml       # Docker Compose配置
├── entrypoint.sh           # Docker入口脚本
├── data/                    # Kiro配置数据目录（运行kiro.bat后生成）
│   ├── .kiro/              # Kiro配置文件
│   └── .aws/               # AWS配置文件
├── huggingface/            # HuggingFace版本
│   └── ki2api/
│       ├── app.py          # HF版本应用文件
│       └── ...
└── README.md               # 本文档
```

## 许可证

MIT License