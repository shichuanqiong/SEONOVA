# ---- Base image ----
FROM python:3.12-slim

# 更稳定的 Python 运行
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# ---- Workdir & files ----
WORKDIR /app
COPY . .

# Railway/Render 通常会注入 PORT；默认 8000 便于本地运行
ENV PORT=8000

# ---- Dependencies ----
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

# ---- Start script ----
# APP_PATH 支持自定义入口（默认 billing-app.backend.main:app）
# 例如你的入口在 billing-app/main.py，则在平台环境变量里设置：
# APP_PATH=billing-app.main:app
RUN printf '%s\n' \
'#!/bin/sh' \
'APP_PATH="${APP_PATH:-billing-app.backend.main:app}"' \
'PORT_TO_USE="${PORT:-8000}"' \
'exec python -m uvicorn "$APP_PATH" --host 0.0.0.0 --port "$PORT_TO_USE"' \
> /start.sh && chmod +x /start.sh

EXPOSE 8000

# ---- Run ----
CMD ["/start.sh"]
