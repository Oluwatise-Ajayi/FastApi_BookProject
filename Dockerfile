FROM tiangolo/uvicorn-gunicorn-fastapi:python3.8

# Install Nginx
RUN apt-get update && apt-get install -y nginx

# Copy Nginx configuration
COPY nginx.conf /etc/nginx/sites-available/default

# Start Nginx and the FastAPI application
CMD service nginx start && uvicorn main:app --host 0.0.0.0 --port 8000