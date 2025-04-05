from fastapi import FastAPI, Request
from mangum import Mangum
import os
from dotenv import load_dotenv
import logging
import time
import json

# Load environment variables from .env file if it exists
# This will be used for local development
if os.path.exists(".env"):
    load_dotenv()

# Configure logging
LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO").upper()
logging.basicConfig(
    level=getattr(logging, LOG_LEVEL),
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
)
logger = logging.getLogger("hello-world-api")

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


# Middleware for request logging
@app.middleware("http")
async def log_requests(request: Request, call_next):
    logger.info(f"Request started: {request.method} {request.url.path}")
    start_time = time.time()

    try:
        response = await call_next(request)
        process_time = time.time() - start_time
        logger.info(
            f"Request completed: {request.method} {request.url.path} - "
            f"Status: {response.status_code} - Duration: {process_time:.4f}s"
        )
        return response
    except Exception as e:
        process_time = time.time() - start_time
        logger.error(
            f"Request failed: {request.method} {request.url.path} - "
            f"Error: {str(e)} - Duration: {process_time:.4f}s"
        )
        raise


@app.get("/")
async def root():
    """
    Root endpoint providing basic information and instructions.
    """
    logger.info("Root endpoint called")
    return {
        "message": f"Welcome to the Hello World API ({ENVIRONMENT})",
        "endpoints": {"/hello": "Returns a hello world message"},
    }


@app.get("/hello")
async def hello_world():
    """
    Hello world endpoint that returns a greeting with environment information.
    """
    logger.info("Hello endpoint called")
    response_data = {
        "message": f"Hello World from {ENVIRONMENT} environment!",
        "service": "hello-world-api",
        "powered_by": "FastAPI on AWS Lambda",
    }
    logger.debug(f"Hello response: {json.dumps(response_data)}")
    return response_data


# Lambda handler
handler = Mangum(app)

# Add this section for local development
if __name__ == "__main__":
    import uvicorn

    logger.info(f"Starting local server in {ENVIRONMENT} environment")
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
