---
title: Markdown常用数学公式整理
date: 2021/8/4
tags: markdown
categories: 乱七八糟笔记整理
description: 仅作参考
cover: 'https://img2.baidu.com/it/u=1110695959,2322594919&fm=26&fmt=auto&gp=0.jpg'
abbrlink: 21277fde
layout:
---



# Markdown常用数学公式整理

最近写笔记经常要用到公式，整理了一波markdown公式以便自己查阅。

## 基础运算

加法运算，符号：+，如：`x+y=z`

减法运算，符号：-，如：`x-y=z`

斜法运算，符号：/，如：`x/y=z`

加减运算，符号：\pm，如：`x \pm y=z`
$$
x\pm y=z
$$
乘法运算，符号：\times，如：`x \times y=z`
$$
x \times y=z
$$
点乘运算，符号：\cdot，如：`x \cdot y=z`
$$
x \cdot y=z
$$


星乘运算，符号：\ast，如：`x \ast y=z`
$$
x \ast y=z
$$


除法运算，符号：\div，如：`x \div y=z`
$$
x \div y=z
$$


分式表示，符号：\frac{分子}{分母}，如：`\frac{x+y}{y+z}`
$$
\frac{x+y}{y+z}
$$


## 高级运算

平均数运算，符号：\overline{算式}，如：`\overline{x}`	$\overline {x}$​​

开二次方运算，符号：\sqrt，如：`\sqrt x`	$\sqrt  x$

开方运算，符号：\sqrt[开方数]{被开方数}，如：`\sqrt[3]{x+y}`	$\sqrt [3] {x+y}$​​

对数运算，符号：\log，如：`\log_{2}(x)`	$\log _{2} (x)$​​

对数运算，符号：\ln，如：`\ln(x)`	$\ln (x)$​

极限运算，符号：\lim，如：`\lim\limits_{x\rightarrow\infty}{\frac{sin\ x}{x}}`	$\lim\limits_{x\rightarrow\infty} {\frac{sin\ x} {x} }$​

极限运算，符号：\displaystyle \lim，如：`\displaystyle \lim_{x \to 0}{\frac{1}{x}}`	$\displaystyle \lim_{x \to 0} {\frac{1} {x} }$​

求和运算，符号：\sum，如：`\sum^{n}_{i = 1}{i}`	$\sum^{n}_{i=1} {i}$​

求和运算，符号：\displaystyle \sum，如：`\displaystyle \sum^{n}_{i = 1}{\frac{n}{i}}`	$\displaystyle \sum^{n}_{i = 1} {\frac{n} {i} }$​​

积分运算，符号：\int，如：`\int^{1}_{0}{xdx}`	$\int^{1}_{0} {xdx}$​

# 逻辑运算

等于运算，符号：=，如：`x+y=z`

大于运算，符号：>，如：`x+y>z`

小于运算，符号：<，如：`x+y<z`

大于等于运算，符号：\geq，如：`x+y \geq z`	$x+y \geq z$

小于等于运算，符号：\leq，如：`x+y \leq z`	$x+y \leq z$

不等于运算，符号：\neq，如：`x+y \neq z`	$x+y \neq z$

约等于运算，符号：\approx，如：`x+y \approx z`	$x+y \approx z$

恒定等于运算，符号：\equiv，如：`x+y \equiv z`	$x+y \equiv z$

## 数学符号

无穷，符号：`\infty` 	$\infty$

虚数，符号：`\imath` 	$\imath$

虚数，符号：`\jmath`	$\jmath$

不等号，符号：`\neq` 	$\neq$

上箭头，符号：`\uparrow` 	$\uparrow$

上箭头，符号：`\Uparrow` 	$\Uparrow$

下箭头，符号：`\downarrow` 	$\downarrow$

下箭头，符号：`\Downarrow` 	$\Downarrow$

左箭头，符号：`\leftarrow` 	$\leftarrow$

左箭头，符号：`\Leftarrow` 	$\Leftarrow$

右箭头，符号：`\rightarrow` 	$\rightarrow$

右箭头，符号：`\Rightarrow` 	$\Rightarrow$

矢量符号，符号：\vec{a}，如：`\vec{a}`	$\vec{a}$

底端对齐的省略号，符号：\ldots，如：`1,2,\ldots,n`	$1,2,\ldots,n$

中线对齐的省略号，符号：\cdots，如：`x_1^2 + x_2^2 + \cdots + x_n^2`	$x _1 ^2 + x _2 ^2 + \cdots + x _n ^2$​

方程组表示，符号`\begin{cases} \end{cases}`，如：

```markup
F(n) = 
\begin{cases}
0 & ,{n=0} \\ 
1 & ,{n=1,2} \\ 
F(n-1)+F(n-2) &,{n>2} 
\end{cases}
```

$$
F(n) = 
\begin{cases}
0 & ,{n=0} \\ 
1 & ,{n=1,2} \\ 
F(n-1)+F(n-2) &,{n>2} 
\end{cases}
$$



