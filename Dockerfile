FROM python:3.12-slim

WORKDIR /app

# 复制所有文件
COPY . .

# 设置默认 PORT
ENV PORT=8000

# 安装依赖
RUN pip install --no-cache-dir -r billing-app/backend/requirements.txt

# 暴露端口
EXPOSE ${PORT}

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:${PORT}/api/health || exit 1

# 启动应用
CMD ["sh", "-c", "python -m uvicorn billing-app.backend.main:app --host 0.0.0.0 --port ${PORT}"]
