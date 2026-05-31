# FunASR Server

基于 [FunASR](https://github.com/modelscope/FunASR) 的语音识别服务，运行在 CPU 模式下。

## ✨ 特性

- **多阶段构建**：构建阶段安装编译工具，运行阶段只保留运行时依赖，镜像更精简
- **版本锁定**：PyTorch 锁定 `2.4.0+cpu`，确保构建稳定可复现
- **纯净 CPU 版**：从官方 CPU-only 源安装，无冗余 CUDA 库
- **国内镜像加速**：
  - PyTorch CPU：阿里云 `mirrors.aliyun.com`
  - 其他 PyPI 包：阿里云 `mirrors.aliyun.com`
- **完整音频支持**：包含 `ffmpeg`、`libsndfile1`、`libsox-dev` 等音频处理依赖
- **自动构建**：GitHub Actions 自动构建并推送到 GitHub Container Registry (ghcr.io)

## 🚀 快速开始

### 使用 Docker Compose（推荐）

```bash
# 克隆项目
git clone https://github.com/YOUR_USERNAME/funasr-server.git
cd funasr-server

# 创建模型缓存目录
mkdir -p models

# 构建并启动
docker-compose up -d --build

# 查看日志
docker-compose logs -f
```

### 使用 Docker

```bash
# 构建镜像
docker build -t funasr-server .

# 运行容器
docker run -d \
  --name funasr-server \
  -p 28717:28717 \
  -v $(pwd)/models:/root/.cache/modelscope \
  funasr-server
```

### 使用 GHCR 镜像

```bash
# 拉取镜像
docker pull ghcr.io/YOUR_USERNAME/funasr-server:main

# 运行容器
docker run -d \
  --name funasr-server \
  -p 28717:28717 \
  -v $(pwd)/models:/root/.cache/modelscope \
  ghcr.io/YOUR_USERNAME/funasr-server:main
```

## 📋 系统要求

- **CPU**: 支持 x86_64 架构
- **内存**: 建议至少 4GB 可用内存
- **磁盘**: 模型下载约 1-2GB
- **网络**: 首次启动需要网络下载模型

## 🔧 配置说明

### 端口映射

默认端口为 `28717`，如需修改：

1. 编辑 `docker-compose.yml` 中的 `ports` 配置
2. 同时修改 `Dockerfile` 中的 `EXPOSE` 和 `CMD` 参数

### 模型缓存

模型缓存挂载到本地 `./models` 目录，避免每次启动都重新下载：

```yaml
volumes:
  - ./models:/root/.cache/modelscope
```

### 环境变量

- `PYTHONUNBUFFERED=1`: 确保日志实时输出

## 📦 包含的模型

运行 `funasr-server --model sensevoice` 会自动下载以下模型：

| 模型 | 说明 | 大小 |
|------|------|------|
| `iic/SenseVoiceSmall` | 语音识别模型 | ~800MB |
| `fsmn-vad` | 语音活动检测模型 | ~10MB |

## 🔍 API 使用

服务启动后，可通过以下地址访问：

- **API 地址**: `http://localhost:28717`

### 示例请求

```bash
curl -X POST "http://localhost:28717/api/v1/asr" \
  -H "Content-Type: audio/wav" \
  --data-binary @audio.wav
```

## 🛠️ 开发

### 本地开发

```bash
# 安装依赖
pip install -r requirements.txt

# 运行服务
funasr-server --device cpu --model sensevoice --port 28717
```

### 构建镜像

```bash
# 构建镜像
docker build -t funasr-server .

# 运行测试
docker run --rm funasr-server --help
```

## 📝 常见问题

### Q: 首次启动很慢？

A: 首次启动需要下载模型（约 1-2GB），请耐心等待。模型会缓存在 `./models` 目录，后续启动无需重新下载。

### Q: 如何更新模型？

A: 删除 `./models` 目录后重新启动容器，会自动下载最新模型。

### Q: 支持哪些音频格式？

A: 支持 WAV、MP3、FLAC、OGG 等常见格式（依赖 ffmpeg）。

## 🙏 致谢

本项目基于以下开源项目：

- **[FunASR](https://github.com/modelscope/FunASR)** - 由 [ModelScope](https://www.modelscope.cn/) 团队开发的语音识别框架
  - 许可证：[MIT License](https://github.com/modelscope/FunASR/blob/main/LICENSE)
  - 版权归属：ModelScope Team

感谢 FunASR 团队提供的优秀开源项目，让我们能够轻松构建语音识别服务！

## 📄 许可证

本项目基于 FunASR 项目，遵循 [MIT License](LICENSE)。

## 🔗 相关链接

- [FunASR 官方仓库](https://github.com/modelscope/FunASR)
- [FunASR 文档](https://github.com/modelscope/FunASR/blob/main/README.md)
- [ModelScope](https://www.modelscope.cn/)
- [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
