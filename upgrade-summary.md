# Butterfly主题升级总结

## 升级过程

### 1. 原版本
- hexo-theme-butterfly 版本：4.12.0
- 升级前时间：2024年左右

### 2. 升级后版本
- hexo-theme-butterfly 版本：5.5.4
- 升级后时间：2026年4月26日

### 3. 遇到的问题及解决方案

#### 问题1：Helper函数缺失
**错误信息：**
```
TypeError: aside_categories is not a function
```

**原因：**
升级到新版本后，主题的helper函数没有正确加载。

**解决方案：**
从主题目录复制helper函数到博客根目录的`scripts/`文件夹：
- `scripts/helpers/aside_categories.js`
- `scripts/helpers/aside_archives.js`
- `scripts/helpers/inject_head_js.js`
- `scripts/helpers/page.js`
- `scripts/helpers/related_post.js`

#### 问题2：端口被占用
**错误信息：**
```
Port 4000 has been used. Try other port instead.
```

**解决方案：**
使用端口5000启动服务器：`hexo server -p 5000`

### 4. 验证结果
- ✅ 网站成功生成（164个文件）
- ✅ 服务器成功启动在 http://localhost:5000
- ✅ 所有页面正常渲染

### 5. 备份文件
- `_config.yml.backup` - 主题配置文件备份

### 6. 升级脚本
创建了`upgrade-butterfly.ps1`脚本用于自动化升级过程。

## 注意事项
1. 新版本可能需要更新部分配置项
2. 如有自定义修改，需要检查与新版本的兼容性
3. 建议定期检查主题更新以获得最新功能和安全修复