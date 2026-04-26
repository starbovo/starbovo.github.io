---
title: 捣鼓STM32nucleo：点灯
date: 2022/7/7
tags:
  - 电赛
  - 单片机
  - STM32
categories: 捣鼓STM32nucleo
description: STM32Cube与HAL库实现GPIO基本操作
cover: 'https://s1.ax1x.com/2022/07/05/jUSRdU.png'
abbrlink: b4a5ec5d
---
## STM32CubeMX软件使用
首先打开我们装好的CubeMX软件，进入创建工程类型选择页面，可以看到有三种类型可供选择：
![](https://s1.ax1x.com/2022/07/07/j0rxnP.png)
这里因为我使用的是ST官方开发板之一nucleo，所以我选择了第二个也就是根据开发板创建项目。
创建好之后进入项目，我们可以看到一个大芯片：
![](https://s1.ax1x.com/2022/07/07/j0sd4e.png)
开发板项目一般都是配置好的，基本不用改。
这里在生成工程的时候要注意：
![](https://s1.ax1x.com/2022/07/08/j0yfZ6.png)
还有一个配置是：
![](https://s1.ax1x.com/2022/07/08/j0yLLt.png)
配置好之后我们点生成，就可以自动生成项目啦。
## 用HAL库的GPIO函数试一下点灯
