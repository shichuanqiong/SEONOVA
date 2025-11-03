FROM python:3.12-slim

WORKDIR /app

COPY . .

ENV PORT=8000

# 直接安装依赖
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

EXPOSE ${PORT}

CMD ["sh", "-c", "python -m uvicorn billing-app.backend.main:app --host 0.0.0.0 --port ${PORT}"]
