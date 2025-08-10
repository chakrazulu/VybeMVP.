# PowerShell script for Windows users
# KASPER MLX Release Cards Generator

Write-Host "🔮 KASPER MLX Release Cards Generator (Windows)" -ForegroundColor Cyan
Write-Host "=" * 50 -ForegroundColor Cyan

try {
    # Check Python installation
    $pythonVersion = python --version 2>$null
    if (-not $pythonVersion) {
        Write-Error "Python not found. Please install Python 3.11+"
        exit 1
    }
    
    Write-Host "Using: $pythonVersion" -ForegroundColor Green
    
    # Install dependencies if needed
    Write-Host "Installing dependencies..." -ForegroundColor Yellow
    pip install -r requirements-dev.txt --quiet
    
    # Run the generator
    Write-Host "Generating release documentation..." -ForegroundColor Yellow
    python scripts/release_cards.py
    
    Write-Host "✅ Complete!" -ForegroundColor Green
    
} catch {
    Write-Error "Failed to generate release cards: $_"
    exit 1
}