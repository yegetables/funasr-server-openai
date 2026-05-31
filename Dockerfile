# ============================================================
# 阶段 1：构建阶段（安装所有依赖）
# ============================================================
FROM python:3.10-slim AS builder

# 系统依赖（音频处理 + 编译工具）
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libsndfile1 \
        libsox-dev \
        libsox-fmt-all \
        ffmpeg \
        build-essential \
    && rm -rf /var/lib/apt/lists/*

# 配置 pip 使用阿里云镜像源
RUN pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/ && \
    pip config set global.trusted-host mirrors.aliyun.com

# 升级 pip
RUN pip install --no-cache-dir --upgrade pip

# 安装纯 CPU 版 PyTorch（从阿里云 PyTorch CPU 镜像源）
RUN pip install --no-cache-dir \
    torch==2.3.0+cpu \
    torchaudio==2.3.0+cpu \
    -f https://mirrors.aliyun.com/pytorch-wheels/cpu/

# 安装 FunASR 及相关依赖（走阿里云镜像源）
RUN pip install --no-cache-dir \
    funasr \
    fastapi \
    uvicorn \
    python-multipart

# ============================================================
# 阶段 2：运行阶段（只保留运行时必需的内容）
# ============================================================
FROM python:3.10-slim

# 只装运行时系统依赖（不带编译工具）
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libsndfile1 \
        libsox-dev \
        libsox-fmt-all \
        ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# 从构建阶段复制 Python 包
COPY --from=builder /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# 工作目录
WORKDIR /app

# 暴露端口
EXPOSE 28717

# 启动命令
CMD ["funasr-server", "--device", "cpu", "--model", "sensevoice", "--port", "28717"]
