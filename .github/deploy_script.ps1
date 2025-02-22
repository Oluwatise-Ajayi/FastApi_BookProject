# deploy_script.ps1

# Define variables
# $repoPath = "C:\Users\user\Documents\HNG projects\FastApi_Book\fastapi-book-project"
$repoPath = "../"
$serviceName = "FastApiService"
$nginxConfigPath = "C:\Users\user\Documents\nginx-1.26.3\nginx-1.26.3\conf\nginx.conf"


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

# Check if service exists
$service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue

# Restart only if the service exists
if ($service) {
    Restart-Service -Name $serviceName -Force
    Write-Output "Service $serviceName restarted successfully."
} else {
    Write-Warning "Skipping service restart: Service '$serviceName' not found."
}

#Update Nginx configuration (if needed)
try {
    if (Test-Path $nginxConfigPath) {
        $destDir = "C:\nginx\conf"
        if (!(Test-Path $destDir)) {
            New-Item -ItemType Directory -Path $destDir
            -ErrorAction stop
        }
        Copy-Item $nginxConfigPath "$destDir\nginx.conf" -Force
         -ErrorAction stop
        & "C:\nginx\nginx.exe" -s reload  -ErrorAction stop
    } else {
        Write-Warning "Nginx configuration file not found: $nginxConfigPath"
    }
} catch {
    Write-Error "Nginx configuration update failed: $($Error[0].Message)"
    exit 1
 }