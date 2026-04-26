---
title: 由C++基础简单入门Arduino
date: 2022/4/9
tags:
  - 电赛
  - 单片机
  - arduino
categories: 单片机
description: 欢迎入门arduino了解单片机世界捏。
cover: 'https://pic2.zhimg.com/v2-d2dda2d314ba7133d238a5a0c026c86d_r.jpg'
abbrlink: 43cd5719
---
# 由C++基础简单入门Arduino
## Arduino简单介绍
Arduino 是一个便捷灵活、方便上手的开源电子生态链，包含硬件（各种型号的arduino板）和软件（arduino IDE）。几乎任何人，即使不太懂电脑编程，也能用Arduino做出很酷的东西，比如对感测器作出回应，闪烁灯光，还能控制马达。
在我看来，Arduino适用于你需要快速验证某种猜想（比如给宿舍装一个wifi控制的灯开关）的场合。对于硬件开发初学者而言，arduino不需要你去纠结太多底层的硬件知识，可以更专注于程序部分的编写和兴趣的培养。
本篇文章更偏向于入门arduino的编程语言，对于硬件电路搭建等不作详细介绍。
## 如何开始学习Arduino
### 选择一款开发板
arduino有许多种开发板可供选择，板载资源略有不同，主流板子比较如下图：
![](https://www.arduino.cn/data/attachment/forum/201412/07/163213kzisi4szjanz14fy.jpg)
通常来说，初学者入门更推荐使用UNO和MEGA。
### IDE的安装与使用
Arduino IDE是Arduino产品的软件编辑环境。简单的说就是用来写代码，下载代码的地方。任何的Arduino产品都需要下载代码后才能运作。我们所搭建的硬件电路是辅助代码来完成的，两者是缺一不可的。
我们可以在官网找到Arduino IDE的下载链接，安装后打开软件。我们可以通过选择菜单栏File → Preferences讲软件更改为我们习惯的中文界面。打开后界面如图：
![](https://pic1.zhimg.com/v2-5968ad8611936807d6fd94940b4dfd9c_r.jpg)
我们把板子插到电脑上，在IDE的工具-开发板中找到我们手边的板子型号,并选择当前板子所连接的电脑串口。
输入程序后，点击上传就可以把程序刷到板子里啦。
### 点亮第一个灯
以Arduino UNO为例，我们来尝试点亮开发板上的led灯。
在文件-示例中找到一个名为Blink的例程：
```
/*
Blink
等待一秒钟，点亮LED，再等待一秒钟，熄灭LED，如此循环
*/

// 在大多数Arduino控制板上 13号引脚都连接了一个标有“L”的LED灯
// 给13号引脚连接的设备设置一个别名“led”
int led = 13;

// 在板子启动或者复位重启后， setup部分的程序只会运行一次
void setup(){
  // 将“led”引脚设置为输出状态
  pinMode(led, OUTPUT);     
}

// setup部分程序运行完后，loop部分的程序会不断重复运行
void loop() 
{
  digitalWrite(led, HIGH);   // 点亮LED
  delay(1000);           // 等待一秒钟
  digitalWrite(led, LOW);   // 通过将引脚电平拉低，关闭LED
  delay(1000);           // 等待一秒钟
}
```
点击上传按钮，调试提示区会显示“正在编译项目…”，很快该提示会变成“上传”，此时Arduino Uno上标有TX、RX的两个LED会快速闪烁，这说明你的程序正在被写入Arduino Uno中。
当显示“上传成功”时，说明该程序已经上传到Arduino中。
大概5秒后，可以看到该段程序的效果——板子上的标有L的LED在按设定的程序闪烁了。
## 了解Arduino的程序构成
我们已经看到第一个Arduino程序Blink，如果你使用过C/C++语言，你会发现Arduino的程序结构与传统的C/C++结构的不同——Arduino程序中没有main函数。
其实并不是Arduino没有main函数，而是main函数的定义被封装在了Arduino的核心库文件中。Arduino开发一般不直接操作main函数，而是使用Setup和loop这个两个函数。
Arduino控制器通电或复位后，即会开始执行setup() 函数中的程序，该部分只会执行一次。通常我们会在setup() 函数中完成Arduino的初始化设置，如配置I/O口状态，初始化串口等操作。
在setup() 函数中的程序执行完后，Arduino会接着执行loop() 函数中的程序。而loop()函数是一个死循环，其中的程序会不断的重复运行。通常我们会在loop() 函数中完成程序的主要功能，如驱动各种模块，采集数据等。
## 数字IO和模拟IO
#### 数字信号和模拟信号
数字信号是以0、1表示的电平不连续变化的信号，也就是以二进制的形式表示的信号。而模拟信号是连续变化的。
![](https://www.arduino.cn/data/attachment/forum/201803/03/225627eimw9nzlugybg9ub.jpg)
#### Arduino中数字IO口的使用
Arduino上每一个带有数字编号的引脚，都是数字引脚，包括写有“A”编号的模拟输入引脚。使用这些引脚，可以完成输入输出数字信号的功能。
1. 通过pinmode()配置引脚模式
在使用输入或输出功能前，你需要先通过pinMode() 函数配置引脚的模式为输入模式或输出模式。
pinMode(pin, mode);
参数pin为指定配置的引脚编号，参数mode为指定的配置模式。
可使用的三种模式:INPUT（输入模式）、OUTPUT（输出模式）和INPUT_PULLUP（输入上拉模式）。
如之前我们在Blink程序中使用到了pinMode(13, OUTPUT)，即是把13号引脚配置为输出模式。
2. 输出模式要用digitalWrite()指定高低电平
配置成输出模式后，你还需要使用digitalWrite() 让其输出高电平或者是低电平。其调用形式为：
digitalWrite(pin, value);
参数pin为指定输出的引脚编号；参数value为你要指定输出的电平，使用HIGH指定输出高电平，或是使用LOW指定输出低电平。
Arduino中输出的低电平为0V，输出的高电平为当前Arduino的工作电压。例如Arduino UNO的工作电压为5V，其高电平输出也是5V；Arduino Due工作电压为3.3V，所以高电平输出也就是3.3V。
3. 输入模式用digitalRead()读取输入信号
数字引脚除了用于输出信号外，还可以用digitalRead() 函数读取外部输入的数字信号，其调用形式为：
int value = digitalRead(pin);
参数pin为指定读取状态的引脚编号；返回值value为获取到的信号状态，1为高电平，0为低电平。
Arduino UNO会将大于3V的输入电压视为高电平识别，小于1.5V的电压视为低电平识别。超过5V的输入电压可能会损坏Arduino UNO。（不同型号的板子有所不同）
#### Arduino中模拟IO口的使用
1. 模拟输入
模拟输入功能需要使用analogRead() 函数。
int value = analogRead(pin)
参数pin是指定要读取模拟值的引脚，被指定的引脚必须是模拟输入引脚。如analogRead(A0)即是读取A0引脚上的模拟值。
2. 模拟输出
与模拟输入功能对应的是模拟输出功能，我们使用analogWrite() 函数实现这个功能。但该函数并不是输出真正意义上的模拟值，而是以一种特殊的方式来达到输出近似模拟值的效果，这种方式叫做脉冲宽度调制（PWM）。在Arduino UNO中，提供PWM功能的引脚为3、5、6、9、10、11。
当使用analogWrite() 函数时，指定引脚会通过高低电平的不断转换输出一个周期固定的方波，通过改变高低电平在每个周期中所占的比例（占空比），而得到近似输出不同的电压的效果。
analogWrite(pin,value)
参数pin是指定要输出PWM波的引脚，参数value指定是PWM的脉冲宽度，范围为0～255。

参考网页：
https://www.arduino.cn/thread-1066-1-1.html
https://zhuanlan.zhihu.com/p/342322345


