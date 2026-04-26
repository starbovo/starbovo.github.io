---
title: 正点原子DA模块使用避坑
date: 2023/7/25
tags:
  - 电赛
  - FPGA
  - verilog
categories: FPGA
description: 折腾了两天终于知道为啥了
cover: 'https://s1.ax1x.com/2023/07/25/pCX4ph4.jpg'
abbrlink: b82fb0dd
---

## 写在前面

最近在做频谱仪，手上的模块有正点原子的双路DA（芯片为3PD5651E）和一路AD一路DA模块（其中DA模块用的是3PD9708）。这两个模块的区别在于双路DA是10位的，后者是8位的，最大速率都是125Msps。但本人在使用中遇到了一些问题，特此记录一下。

## 问题

因为频谱仪的理想输出是这样的：

[![pCX4ph4.jpg](https://s1.ax1x.com/2023/07/25/pCX4ph4.jpg)](https://imgse.com/i/pCX4ph4)

而本人DA输出的波形是这样的：

[![pCX4Anx.jpg](https://s1.ax1x.com/2023/07/25/pCX4Anx.jpg)](https://imgse.com/i/pCX4Anx)

我提供给DA的信号是这样的（直接把高10位给了DA）：

[![pCX4mND.jpg](https://s1.ax1x.com/2023/07/25/pCX4mND.jpg)](https://imgse.com/i/pCX4mND)

然后就怎么也想不明白为啥反过来了😭

上网查资料，大家都只是简单做了个dds，并没有关心正负是否正确，这让我十分困惑。

## 解决问题

对于3PD5651E，IOUTA和IOUTB为它输出的一对差分电流信号，通过外部电路低通滤波器与运放电路输出模拟电压信号，电压范围是-5V至+5V之间。当输入数据等于0时，3PD5651E输出的电压值为5V；当输入数据等于10’h3ff时，3PD5651E输出的电压值为-5V。

[![pCX4RC4.png](https://s1.ax1x.com/2023/07/25/pCX4RC4.png)](https://imgse.com/i/pCX4RC4)

由上图可知，数据在0至1023之间按照正弦波的波形变化，最终得到的电压也会按照正弦波波形变化，当输入数据重复按照正弦波的波形数据变化时，那么3PD5651E就可以持续不断的输出正弦波的模拟电压波形。需要注意的是，最终得到的3PD5651E的输出电压变化范围由其外部电路决定的，当输入数据为0时，3PD5651E输出+5V的电压；当输入数据为1023时，3PD5651E输出-5V的电压。

我们可以画出输入数据与输出电压的大致关系图：

[![pCXIZfe.jpg](https://s1.ax1x.com/2023/07/25/pCXIZfe.jpg)](https://imgse.com/i/pCXIZfe)

这与我们期望使用偏移二进制码达到的效果是相反的，所以应该对原始数据做一些转换。

如果我们用10'h3ff-原始数据，得到的结果就可以符合期望了，即，将10位的原始数据取反再提供给DA就可以了。

