# FunASR Server 部署指南

## 📋 目录

- [快速部署](#快速部署)
- [本地构建](#本地构建)
- [GitHub Actions](#github-actions)
- [GitHub Pages](#github-pages)
- [常见问题](#常见问题)

## 快速部署

### 使用 GHCR 镜像（推荐）

```bash
# 克隆项目
git clone https://github.com/yegetables/funasr-server-openai.git
cd funasr-server-openai

# 创建模型缓存目录
mkdir -p models

# 启动服务（自动从 ghcr.io 拉取镜像）
docker-compose up -d

# 查看日志
docker-compose logs -f
```

### 使用 Docker

```bash
# 拉取镜像
docker pull ghcr.io/yegetables/funasr-server-openai:main

# 运行容器
docker run -d \
  --name funasr-server \
  -p 28717:28717 \
  -v $(pwd)/models:/root/.cache/modelscope \
  ghcr.io/yegetables/funasr-server-openai:main
```

## 本地构建

### 使用部署脚本

```bash
# 克隆项目
git clone https://github.com/yegetables/funasr-server-openai.git
cd funasr-server-openai

# 使用 --build 参数进行本地构建
./setup.sh --build
```

### 手动构建

```bash
# 克隆项目
git clone https://github.com/yegetables/funasr-server-openai.git
cd funasr-server-openai

# 创建模型缓存目录
mkdir -p models

# 编辑 docker-compose.yml，启用本地构建
# 注释掉 image 行，取消注释 build 部分
# image: ghcr.io/yegetables/funasr-server-openai:main
build:
  context: .
  dockerfile: Dockerfile

# 构建并启动
docker-compose up -d --build

# 查看日志
docker-compose logs -f
```

## GitHub Actions

### 自动构建

每次推送到 `main` 分支或创建版本标签时，GitHub Actions 会自动：

1. 构建 Docker 镜像
2. 推送到 GitHub Container Registry (ghcr.io)
3. 镜像标签：
   - `main` - main 分支最新代码
   - `v1.0.0` - 版本标签
   - `sha-abc1234` - 提交哈希

### 查看构建状态

1. 在 GitHub 仓库页面点击 "Actions" 标签
2. 查看 "Build and Push to GHCR" 工作流状态
3. 如果失败，点击查看详情并修复问题

## GitHub Pages

### 启用文档站点

1. 在仓库页面点击 "Settings"
2. 左侧菜单选择 "Pages"
3. "Source" 选择 "Deploy from a branch"
4. "Branch" 选择 `gh-pages`
5. 文件夹选择 `/ (root)`
6. 点击 "Save"

### 访问文档

部署完成后，文档地址为：
```
https://yegetables.github.io/funasr-server-openai/
```

## 常见问题

### Q: 首次启动很慢？

A: 首次启动需要下载模型（约 1-2GB），请耐心等待。模型会缓存在 `./models` 目录，后续启动无需重新下载。

### Q: 如何更新模型？

A: 删除 `./models` 目录后重新启动容器，会自动下载最新模型。

### Q: 支持哪些音频格式？

A: 支持 WAV、MP3、FLAC、OGG 等常见格式（依赖 ffmpeg）。

### Q: 如何切换 GHCR 镜像和本地构建？

A: 编辑 `docker-compose.yml` 文件：

**使用 GHCR 镜像**：
```yaml
services:
  funasr:
    image: ghcr.io/yegetables/funasr-server-openai:main
    # build:
    #   context: .
    #   dockerfile: Dockerfile
```

**本地构建**：
```yaml
services:
  funasr:
    # image: ghcr.io/yegetables/funasr-server-openai:main
    build:
      context: .
      dockerfile: Dockerfile
```

### Q: 如何更新镜像？

A: 推送代码到 GitHub 后，GitHub Actions 会自动构建新镜像：
```bash
git add .
git commit -m "Update: your changes"
git push
```

### Q: 如何回滚到旧版本？

A: 使用 Git 标签：
```bash
# 查看所有标签
git tag

# 切换到指定版本
git checkout v1.0.0

# 重新构建（如果使用本地构建）
docker-compose up -d --build
```

## 📚 相关文档

- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [GitHub Pages 文档](https://docs.github.com/en/pages)
- [Docker Compose 文档](https://docs.docker.com/compose/)
- [GitHub Container Registry 文档](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
