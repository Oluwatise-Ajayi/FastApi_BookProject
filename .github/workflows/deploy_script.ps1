# deploy_script.ps1

# Define variables
$repoPath = "/home/user/Documents/HNG projects/FastApi_Book/fastapi-book-project"
$serviceName = "FastApiService"
$nginxConfigPath = "/home/user/Documents/nginx-1.26.3/nginx-1.26.3/conf/nginx.conf"


# Navigate to the application directory
Set-Location $repoPath

# Pull the latest changes from the repository
try {
    git pull origin main
} catch {
    Write-Error "Git pull failed: $_"
    exit 1
}

# Install dependencies
try {
    pip install -r requirements.txt
} catch {
    Write-Error "Pip installation failed: $_"
    exit 1
}

# Restart the FastAPI application (assuming it's running as a service)
try {
    systemctl restart $serviceName
} catch {
    Write-Error "Service restart failed: $_"
    exit 1
}

# Update Nginx configuration (if needed)
try {
    if (Test-Path $nginxConfigPath) {
        $destDir = "/etc/nginx/conf.d"
        if (!(Test-Path $destDir)) {
            New-Item -ItemType Directory -Path $destDir -ErrorAction Stop
        }
        Copy-Item $nginxConfigPath "$destDir/nginx.conf" -Force -ErrorAction Stop
        systemctl reload nginx
    } else {
        Write-Warning "Nginx configuration file not found: $nginxConfigPath"
    }
} catch {
    Write-Error "Nginx configuration update failed: $($Error[0].Message)"
    exit 1
}
