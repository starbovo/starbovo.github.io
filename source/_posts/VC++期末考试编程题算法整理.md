---
layout: 页面布局（配合主题文档使用）
title: C++期末简单算法回忆与整理
date: 2021/1/16
comments: 
tags: 
  - C++
  - 算法
categories: C++
description: 非常简单，仅作参考
cover: https://img1.baidu.com/it/u=4170950205,4151438384&fm=26&fmt=auto&gp=0.jpg
swiper_index: 2 #置顶轮播图顺序，非负整数，数字越大越靠前
---
#  VC++期末考试编程题算法整理

[TOC]

## 一、求最大公约数

###  1.辗转相除法（又名欧几里德法）

```cpp
	int t;                   //整形零时变量
	if(a < b)                     //a<b 则交换 
	{
		t = a;
		a = b;
		b = temp;
	}
	while(b != 0)
	{
		t = a % b;              //a中大数除以b中小数循环取余，直到b及余数为0
		a = b;
		b = t;
	}
```

 ![img](https://img-blog.csdnimg.cn/20190309220802466.PNG?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0JyaWxsaWFuY2VfcGFucGFu,size_16,color_FFFFFF,t_70) 

###  2.穷举法（也称枚举法） 

```cpp
	int t;
	t = (a > b)? b:a;         //采用条件运算表达式求出两个数中的最小值
	while(t > 0)
	{
		if(a%t==0 && b%t==0)     //只要找到一个数能同时被a,b所整除，则中止循环
			break;
		t--;               //如不满足if条件则变量自减，直到能被a,b所整除
	}
	//或者用for
	for(int i=0;i<=((a > b)? b:a);i++)
        if(a%i==0 && b%i==0)     //只要找到一个数能同时被a,b所整除，则中止循环
			return i;
	return 0;
```

## 二、求最小公倍数

#### 最小公倍数=两整数的乘积/最大公约数 

#### 三个整数可以用for枚举（前提是知道大小，按顺序排列）

```cpp
for(int i=a*b*c;i>=a;i--)			//假定大小顺序a<b<c，倒序遍历公倍数
        if(i%a==0 && i%b==0 && i%c==0)     //只要找到一个数能同时被a,b所整除，则中止循环
			return i;
return 0;
```

## 三、冒泡排序

```cpp
for (i = 0; i < n-1; ++i)  //比较n-1轮（n是数组总个数）
	for (j = 0; j < n-1-i; ++j)  //每轮比较n-1-i次（一定要记清）
		if (a[j] < a[j+1])
		{
        	t = a[j];
            a[j] = a[j+1];
            a[j+1] = t;
        }
```

## 四、循环剥数

```cpp
while(k)
{
	a[i++]=k%10;
	k/=10;
}
```

## 五、迭代求根

（1）选一个方程的近似根，赋给变量x0。

（2）将x0的值保存于变量x1，然后计算g(x1)，并将结果存于变量x0。

（3）当x0与x1的差的绝对值还小于指定的精度要求时，重复步骤（2）的计算。

若方程有根，并且用上述方法计算出来的近似根序列收敛，则按上述方法求得的x0就认为是方程的根。

上述算法用C++程序的形式表示为： 

```cpp
x0=初始近似根;

do 

{ 

	x1=x0;

	x0=g(x1);  // 按特定的方程计算新的近似根

} 

while ( fabs(x0-x1)>Epsilon);

cout<<“方程的近似根是”<<x0;
```

## 六、素数判断

```cpp
for(i=2;i<x/2;i++)
        if(x%i==0)
        break;
    if(i>=x/2)
    cout<<x<<"是素数"<<endl;
    else
    cout <<x<< "不是素数" << endl;

```

## 七、闰年判断（冷门）

```cpp
if(((n%4==0)&&(n%100!=0))||(n%400==0));
```

## 八、数制转换

```cpp
	char x[16] = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};									//十进制与十六进制对应的数组
	cout<<"请输入一个十进制的数:";
	int n;
	cin>>n;
	char y[100];			//创建数组储存十六进制数
	int i,j;
	j = 0;
	while( n >= 16 )		//把转换好的十六进制数依次输入数组
	{
		i = (n % 16);		//先是求余
		y[j] = x[i];		//把得到的余数转为十六进制数（例如“11”转“b”）
		j++;				//数组下标移位
		n /= 16;			//求商再赋值给它自己（方便下个循环再除）
		if(n < 16)
			y[j] = x[n];
	}						//此时数组y内的十六进制数是倒过来储存的
```

*出品：*

*电光3301班*

*赵婧萱*