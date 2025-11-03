FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app
COPY . .

# 默认端口，便于本地跑
ENV PORT=8000

# 依赖
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

EXPOSE 8000

# 直接用 Python 启动器（与 shell 无关）
CMD ["python", "start.py"]

