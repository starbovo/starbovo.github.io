---
title: 利用Hexo+Github搭建个人博客
date: 2021/8/6
tags: hexo
categories: 技术相关
description: >-
  第一天，搭了个框架；第二天，换了域名，加了魔改：第三天，完善了公式编辑和图片上传相关。这里把我搭建过程用的博文记录一下。如果你也想搭建，我博客上面这些链接应该能解决你大部分的困扰。
cover: 'https://z3.ax1x.com/2021/08/06/fm4pM6.png'
abbrlink: 11119f15
layout:
---

## 利用Hexo+Github搭建个人博客（记录帖）

### 准备

一台能联网的电脑，最好能连上GitHub。[点击链接试试](https://github.com/)

如果你没有接触过markdown，建议在电脑上下载[typora](https://sspai.com/post/54912)熟悉一下md的语法。

不用担心有没有基础，反正我是前端零基础纯小白。

### 让我们开始吧！

尽管CSDN上有关这种搭建方法的文章很多，真正有时效性而且浅显易懂的还是很少。

如果你是`windows系统`，这是我第一天搭建框架时查阅的**最有用**的文章，非！常！详！细！

TRHX • 鲍勃：[使用 Github Pages 和 Hexo 搭建自己的独立博客【超级详细的小白教程】](https://itrhx.blog.csdn.net/article/details/82121420)，以及知乎上这篇[吴润：GitHub+Hexo 搭建个人网站详细教程](https://zhuanlan.zhihu.com/p/26625249) 。

如果你是linux系统，那么我不知道。

如果你不想安装git和node.js的话，我推荐`hexo懒人包`：[bilibili视频：懒人版HEXO搭建](https://www.bilibili.com/video/av51432005/)，以及[两分钟学会最新的用github+便携版hexo做网站服务器教程+绑定域名](https://blog.csdn.net/lison_zhu/article/details/79321571)，还有[Portable Hexo的官网](https://portablehexo.bitmoe.cn/) 。

### 安装过程中出现的问题

不知当讲不当讲，我的node.js装了两遍...第一次安装的时候npm管理总是出问题，害的我改了好几次npm的资源镜像链接，还是淘宝的链接最管用。后来才发现blog根目录和hexo根目录是两个不一样的东西，在两个地方git bash的时候一定要看清现在的位置。

可以参考[关于安装hexo遇到的一些问题](https://blog.csdn.net/l_2581154176/article/details/91387425)

[hexo搭建博客踩坑](https://tru-xu.github.io/2019/05/10/hexo%E6%90%AD%E5%BB%BA%E5%8D%9A%E5%AE%A2%E8%B8%A9%E5%9D%91/)

### 美化/魔改

本人选择的是`butterfly主题`，这是一款集成了很多实用小功能的主题，作者是香港人，介绍语言是我们能看懂的繁体中文。这个主题本身也比较成熟，已经更新到3.8.3。推荐大家选择主题时要在自己喜欢的基础上，**选择一个比较成熟，而且有人更新维护的。**

这是butterfly主题的帮助文档：[Butterfly 安裝文檔(一) 快速開始](https://butterfly.js.org/posts/21cfbf15/)

当然，对于不同主题来说，美化的方式也会存在不同，我们需要查阅相关主题的帮助文档来获取信息。

这是butterfly的魔改文章目录：[Butterfly 美化/優化/魔改 教程合集](https://butterfly.js.org/posts/7670b080/)

### 公式/图片

关于`公式`的插入，参阅的是这几篇文章：

[这次彻底解决在Hexo中渲染MathJax数学公式出现的问题！！！](https://song-yang-ji.blog.csdn.net/article/details/114582328)

[hexo主题渲染latex公式之多行公式显示问题](https://blog.csdn.net/qq_34769162/article/details/107687801)

[butterfly主题帮助文档（二）-Math数学](https://butterfly.js.org/posts/ceeb73f/#Math-%E6%95%B8%E5%AD%B8)

关于`图片`的插入，这篇文章基本解决：

[hexo博客中插入图片失败——解决思路及个人最终解决办法](https://blog.csdn.net/m0_43401436/article/details/107191688)

Hexo 默认文章链接生成规则是按照年、月、日、标题来生成的。一旦文章标题或者发布时间被修改，URL 就会发生变化，之前文章地址也会变成 404，而且 URL 层级很深，不利于分享和搜索引擎收录。如果文章标题中有中文，URL 被转码后会很长，我装了hexo-abbrlink插件，会为每篇生成一个唯一字符串，并不受文章标题和发布时间的影响。

参见 [Hexo | 博客文章链接优化之abbrlink](https://blog.csdn.net/u011063477/article/details/104743929)
以及图片无法显示的问题：[解决：Hexo安装abbrlink插件后asset-image无法显示图片](https://blog.csdn.net/Copanko/article/details/105428249)

### 博客的迁移

如果换了电脑，或者预防电脑损坏而更新不了博客，可以通过在github的仓库创建分支来备份你的文章和配置文件。

具体可以参考（由于俺本人还没用到，所以留着链接等着看）：

[利用Hexo在多台电脑上提交和更新博客](https://blog.csdn.net/nightmare_dimple/article/details/86661514)

[换电脑后怎么继续维护以前hexo+GitHub创建的个人网站](https://blog.csdn.net/wwwwwwwwwwwwdi/article/details/78184437?spm=1001.2014.3001.5501)

[如何解决github+Hexo的博客多终端同步问题](https://blog.csdn.net/Monkey_LZL/article/details/60870891)

[hexo：更换电脑，如何继续写博客](https://blog.csdn.net/eternity1118_/article/details/71194395)

[hexo系列问题之我们换了电脑怎么办](https://blog.csdn.net/wxl1555/article/details/79293159)



好啦，我们搭建个人博客的旅程就告一段落，如果你也在安装中遇到了问题，可以来跟我探讨一下。（其实我啥也不会，要是我也遇到过这个问题可以帮帮你，否则的话就去指路大佬啦XD）