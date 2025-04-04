from fastapi import FastAPI
from mangum import Mangum
import os

app = FastAPI(
    title="Hello World API",
    description="A simple API that returns hello world messages",
    version="0.1.0"
)

@app.get("/")
async def root():
    """
    Root endpoint providing basic information and instructions.
    """
    return {
        "message": "Welcome to the Hello World API",
        "endpoints": {
            "/hello": "Returns a hello world message"
        }
    }

@app.get("/hello")
async def hello_world():
    """
    Hello world endpoint that returns a greeting with environment information.
    """
    environment = os.environ.get("ENVIRONMENT", "development")
    return {
        "message": f"Hello World from {environment} environment!",
        "service": "hello-world-api",
        "powered_by": "FastAPI on AWS Lambda"
    }

# Lambda handler
handler = Mangum(app)