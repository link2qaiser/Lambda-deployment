from fastapi import FastAPI
from mangum import Mangum
import os
from dotenv import load_dotenv

# Load environment variables from .env file if it exists
# This will be used for local development
if os.path.exists(".env"):
    load_dotenv()

# Environment configuration
ENVIRONMENT = os.getenv("ENVIRONMENT", "development")
API_TITLE = os.getenv("API_TITLE", "Hello World API")
API_DESCRIPTION = os.getenv(
    "API_DESCRIPTION", "A simple API that returns hello world messages"
)
API_VERSION = os.getenv("API_VERSION", "0.1.0")
DEBUG = os.getenv("DEBUG", "False").lower() in ("true", "1", "t")

app = FastAPI(
    title=API_TITLE, description=API_DESCRIPTION, version=API_VERSION, debug=DEBUG
)


@app.get("/")
async def root():
    """
    Root endpoint providing basic information and instructions.
    """
    return {
        "message": f"Welcome to the Hello World API ({ENVIRONMENT})",
        "endpoints": {"/hello": "Returns a hello world message"},
    }


@app.get("/hello")
async def hello_world():
    """
    Hello world endpoint that returns a greeting with environment information.
    """
    return {
        "message": f"Hello World from {ENVIRONMENT} environment!",
        "service": "hello-world-api",
        "powered_by": "FastAPI on AWS Lambda",
    }


# Lambda handler
handler = Mangum(app)

# Add this section for local development
if __name__ == "__main__":
    import uvicorn

    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
