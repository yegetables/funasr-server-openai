#!/bin/bash

# FunASR Server 快速部署脚本

set -e

echo "🚀 FunASR Server 部署脚本"
echo "========================"

# 检查 Docker 是否安装
if ! command -v docker &> /dev/null; then
    echo "❌ 错误: 未安装 Docker"
    echo "请先安装 Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

# 检查 Docker Compose 是否安装
if ! command -v docker-compose &> /dev/null; then
    echo "❌ 错误: 未安装 Docker Compose"
    echo "请先安装 Docker Compose: https://docs.docker.com/compose/install/"
    exit 1
fi

# 创建模型缓存目录
echo "📁 创建模型缓存目录..."
mkdir -p models

# 启动服务（自动从 ghcr.io 拉取镜像）
echo "🚀 启动服务（从 ghcr.io 拉取镜像）..."
docker-compose up -d

echo ""
echo "✅ 部署完成!"
echo ""
echo "📋 服务信息:"
echo "   - API 地址: http://localhost:28717"
echo "   - 查看日志: docker-compose logs -f"
echo "   - 停止服务: docker-compose down"
echo ""
echo "⏳ 首次启动需要下载模型（约 1-2GB），请耐心等待..."
echo "   模型会缓存在 ./models 目录，后续启动无需重新下载。"
echo ""
