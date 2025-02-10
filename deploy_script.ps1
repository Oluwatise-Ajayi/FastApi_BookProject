# deploy_script.ps1

# Define variables
$repoPath = "C:\Users\user\Documents\HNG projects\FastApi_Book\fastapi-book-project" 
$serviceName = "FastApiService"  

# Navigate to the application directory
cd $repoPath

# Pull the latest changes from the repository
git pull origin main

# Install dependencies
pip install -r requirements.txt

# Restart the FastAPI application (assuming it's running as a service)
Stop-Service $serviceName
Start-Service $serviceName

# Update Nginx configuration (if needed)
Copy-Item "C:\Users\user\Documents\nginx-1.26.3\nginx-1.26.3\conf\nginx.conf" "C:\nginx\conf\nginx.conf" -Force
nginx -s reload