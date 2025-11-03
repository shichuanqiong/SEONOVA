# start.py  —— 兼容 billing-app/ 有连字符的目录名
import os
import sys
import importlib
import uvicorn
from pathlib import Path

ROOT = Path(__file__).resolve().parent
HOST = "0.0.0.0"
PORT = int(os.getenv("PORT", "8000"))

# 允许用户用 APP_PATH 显式指定（例如：billing_app.backend.main:app）
APP_PATH = os.getenv("APP_PATH")

def run_with_import_string(path: str):
    uvicorn.run(path, host=HOST, port=PORT)

def run_with_object(pkg_dir: Path, module_path: str, attr: str = "app"):
    sys.path.append(str(pkg_dir))  # 让 Python 能在该目录内查找包
    module = importlib.import_module(module_path)
    app = getattr(module, attr)
    uvicorn.run(app, host=HOST, port=PORT)

if APP_PATH:
    # 用户显式指定了入口，直接用
    run_with_import_string(APP_PATH)
else:
    # 尝试常见布局（优先支持 billing-app/ 这种有连字符的目录）
    candidates = [
        # (要加入 sys.path 的目录,  模块路径,           属性名)
        (ROOT / "billing-app",       "backend.main",       "app"),
        (ROOT / "billing-app",       "main",               "app"),
        (ROOT,                       "billing_app.backend.main", "app"),
        (ROOT,                       "billing_app.main",        "app"),
        (ROOT,                       "backend.main",       "app"),
        (ROOT,                       "main",               "app"),
    ]
    for base_dir, module_path, attr in candidates:
        try:
            if base_dir.exists():
                run_with_object(base_dir, module_path, attr)
                break
        except Exception as e:
            # 尝试下一个候选
            continue
    else:
        raise RuntimeError(
            "无法定位 FastAPI 应用。请设置环境变量 APP_PATH，例如："
            "billing_app.backend.main:app 或 billing_app.main:app"
        )
