# 使用轻量版 Python 镜像
FROM python:3.12-slim

# 设置工作目录
WORKDIR /app

# 复制所有项目文件到容器
COPY . .

# 默认端口
ENV PORT=8000

# 安装依赖（不需要 requirements.txt）
RUN pip install --no-cache-dir \
    fastapi==0.104.1 \
    uvicorn==0.24.0 \
    sqlalchemy==2.0.23 \
    stripe==7.5.0 \
    httpx==0.25.0 \
    beautifulsoup4==4.12.2 \
    aiohttp==3.9.0 \
    pyjwt==2.8.0 \
    python-dotenv==1.0.0

# 暴露端口
EXPOSE 8000

# 启动 FastAPI 应用
CMD ["sh", "-c", "python -m uvicorn billing-app.backend.main:app --host 0.0.0.0 --port ${PORT:-8000}"]
