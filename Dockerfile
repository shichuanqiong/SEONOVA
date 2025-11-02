# 构建阶段 1: 依赖安装
FROM python:3.12-slim as deps-python

WORKDIR /app/backend
COPY billing-app/backend/requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# 构建阶段 2: Node 依赖
FROM node:20-alpine as deps-node

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# 构建阶段 3: 生产运行环境
FROM python:3.12-slim as runtime

WORKDIR /app

# 安装系统依赖（后端）
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 复制 Python 依赖
COPY --from=deps-python /root/.local /root/.local

# 设置 Python PATH
ENV PATH=/root/.local/bin:$PATH

# 复制应用文件
COPY . .

# 设置默认 PORT（Railway 会覆盖）
ENV PORT=8000

# 暴露 PORT（使用 ARG 支持动态端口）
EXPOSE ${PORT}

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:${PORT}/api/health || exit 1

# 启动应用（使用 $PORT 环境变量）
CMD ["sh", "-c", "python -m uvicorn billing-app.backend.main:app --host 0.0.0.0 --port ${PORT}"]
