# start.py
import os
import uvicorn

# 入口模块：默认 billing-app.backend.main:app
APP_PATH = os.getenv("APP_PATH", "billing-app.backend.main:app")
HOST = "0.0.0.0"
PORT = int(os.getenv("PORT", "8000"))  # 强制为整数

uvicorn.run(APP_PATH, host=HOST, port=PORT)
