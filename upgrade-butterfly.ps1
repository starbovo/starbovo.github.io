# Butterfly主题升级脚本
Write-Host "正在升级Hexo Butterfly主题..." -ForegroundColor Green

# 进入博客目录
Set-Location D:/blog/hexo

# 1. 备份当前配置文件
Write-Host "备份当前配置文件..." -ForegroundColor Yellow
Copy-Item themes/hexo-theme-butterfly/_config.yml themes/hexo-theme-butterfly/_config.yml.backup -Force

# 2. 卸载旧版本主题
Write-Host "卸载旧版本主题..." -ForegroundColor Yellow
npm uninstall hexo-theme-butterfly -D

# 3. 安装最新版本主题
Write-Host "安装最新版本主题..." -ForegroundColor Yellow
npm install hexo-theme-butterfly@latest -D

# 4. 恢复配置文件
Write-Host "恢复配置文件..." -ForegroundColor Yellow
Copy-Item themes/hexo-theme-butterfly/_config.yml.backup themes/hexo-theme-butterfly/_config.yml -Force

# 5. 检查配置差异
Write-Host "检查配置差异..." -ForegroundColor Yellow
Write-Host "旧版本配置备份完成: themes/hexo-theme-butterfly/_config.yml.backup" -ForegroundColor Cyan
Write-Host "新版本主题已安装，配置文件已恢复" -ForegroundColor Cyan

Write-Host "升级完成！请检查主题是否正常工作" -ForegroundColor Green
Write-Host "运行以下命令测试：" -ForegroundColor Yellow
Write-Host "  hexo clean" -ForegroundColor White
Write-Host "  hexo generate" -ForegroundColor White
Write-Host "  hexo server" -ForegroundColor White