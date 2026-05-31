# FunASR Server 部署指南

## 📋 目录

- [GitHub 仓库设置](#github-仓库设置)
- [GitHub Actions 配置](#github-actions-配置)
- [GitHub Pages 配置](#github-pages-配置)
- [本地部署](#本地部署)
- [Docker Hub 部署](#docker-hub-部署)

## GitHub 仓库设置

### 1. 创建 GitHub 仓库

1. 访问 [GitHub](https://github.com/) 并登录
2. 点击右上角的 "+" 按钮，选择 "New repository"
3. 填写仓库信息：
   - **Repository name**: `funasr-server`
   - **Description**: FunASR 语音识别服务 - CPU 版本
   - **Visibility**: Public（推荐）或 Private
   - **不要**勾选 "Add a README file"（我们已经有了）
4. 点击 "Create repository"

### 2. 上传代码

```bash
# 进入项目目录
cd funasr-server

# 初始化 Git 仓库
git init

# 添加所有文件
git add .

# 提交
git commit -m "Initial commit: FunASR Server with Docker support"

# 添加远程仓库（替换 YOUR_USERNAME 为你的 GitHub 用户名）
git remote add origin https://github.com/YOUR_USERNAME/funasr-server.git

# 推送到 GitHub
git branch -M main
git push -u origin main
```

## GitHub Actions 配置

### 1. 配置 Docker Hub 密钥

1. 在 GitHub 仓库页面，点击 "Settings"
2. 左侧菜单选择 "Secrets and variables" → "Actions"
3. 点击 "New repository secret"，添加以下密钥：

| 名称 | 说明 |
|------|------|
| `DOCKERHUB_USERNAME` | 你的 Docker Hub 用户名 |
| `DOCKERHUB_TOKEN` | 你的 Docker Hub 访问令牌 |

#### 获取 Docker Hub 访问令牌

1. 访问 [Docker Hub](https://hub.docker.com/) 并登录
2. 点击右上角头像 → "Account Settings"
3. 左侧菜单选择 "Security"
4. 点击 "New Access Token"
5. 填写描述（如 "GitHub Actions"），权限选择 "Read, Write, Delete"
6. 点击 "Generate"
7. **复制生成的令牌**（只显示一次）

### 2. 验证工作流

推送代码后，GitHub Actions 会自动运行：

1. 在仓库页面点击 "Actions" 标签
2. 查看 "Docker Build and Push" 工作流状态
3. 如果失败，点击查看详情并修复问题

## GitHub Pages 配置

### 1. 启用 GitHub Pages

1. 在仓库页面点击 "Settings"
2. 左侧菜单选择 "Pages"
3. "Source" 选择 "Deploy from a branch"
4. "Branch" 选择 "gh-pages"（工作流会自动创建）
5. 文件夹选择 "/ (root)"
6. 点击 "Save"

### 2. 访问文档

部署完成后，文档地址为：
```
https://YOUR_USERNAME.github.io/funasr-server/
```

### 3. 自定义域名（可选）

如果有自定义域名：

1. 在 "Pages" 设置中，"Custom domain" 填写你的域名
2. 勾选 "Enforce HTTPS"
3. 在你的域名 DNS 设置中，添加 CNAME 记录指向 `YOUR_USERNAME.github.io`

## 本地部署

### 方式一：使用部署脚本

```bash
# 克隆仓库
git clone https://github.com/YOUR_USERNAME/funasr-server.git
cd funasr-server

# 运行部署脚本
./setup.sh
```

### 方式二：手动部署

```bash
# 克隆仓库
git clone https://github.com/YOUR_USERNAME/funasr-server.git
cd funasr-server

# 创建模型缓存目录
mkdir -p models

# 构建并启动
docker-compose up -d --build

# 查看日志
docker-compose logs -f
```

### 方式三：使用 Docker

```bash
# 克隆仓库
git clone https://github.com/YOUR_USERNAME/funasr-server.git
cd funasr-server

# 构建镜像
docker build -t funasr-server .

# 运行容器
docker run -d \
  --name funasr-server \
  -p 28717:28717 \
  -v $(pwd)/models:/root/.cache/modelscope \
  funasr-server
```

## Docker Hub 部署

### 1. 推送镜像到 Docker Hub

GitHub Actions 会自动构建并推送镜像到 Docker Hub：

```
docker pull YOUR_USERNAME/funasr-server:main
```

### 2. 使用 Docker Hub 镜像

```bash
# 拉取镜像
docker pull YOUR_USERNAME/funasr-server:main

# 运行容器
docker run -d \
  --name funasr-server \
  -p 28717:28717 \
  -v $(pwd)/models:/root/.cache/modelscope \
  YOUR_USERNAME/funasr-server:main
```

### 3. 镜像标签说明

| 标签 | 说明 |
|------|------|
| `main` | main 分支最新代码 |
| `v1.0.0` | 版本标签 |
| `sha-abc1234` | 提交哈希 |

## 🔧 常见问题

### Q: GitHub Actions 构建失败？

A: 检查以下几点：
1. Docker Hub 密钥是否正确配置
2. Docker Hub 访问令牌是否过期
3. 查看 Actions 日志获取详细错误信息

### Q: GitHub Pages 无法访问？

A: 检查以下几点：
1. Pages 是否已启用
2. 分支是否选择正确（gh-pages）
3. 等待几分钟让部署完成

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

# 重新构建
docker-compose up -d --build
```

## 📚 相关文档

- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [GitHub Pages 文档](https://docs.github.com/en/pages)
- [Docker Hub 文档](https://docs.docker.com/docker-hub/)
- [Docker Compose 文档](https://docs.docker.com/compose/)
