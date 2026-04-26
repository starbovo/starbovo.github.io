---
title: verilog串口二进制转字符
date: 2022/8/3
tags:
  - 电赛
  - FPGA
  - verilog
categories: FPGA
description: 这个问题真的纠结好久，记录一下，以后怎么处理就清楚了。
cover: 'https://my.eng.utah.edu/~nmcdonal/Tutorials/BCDTutorial/AlgorithmTable.png'
abbrlink: 1f3d2742
---
## 前言
电赛结束了，虽然本人不是verilog选手但也参与了一些程序的编写，让我印象最深的就是串口通信中的数值转数字字符，今天抽空来总结一下。
## UART的传输格式
UART也就是通用异步收发器，是我们平时所用最多的一种串口通信方式。在使用UART进行通信时，我们只需要接两根线：RX和TX，其中RX是UART的接收端，TX是UART的发送端，接收与发送是全双工形式（也就是可以同时收发）。
![](https://img-blog.csdnimg.cn/83f984d1a2a94bafb09ddf0a4b8cd577.png)
uart是将传输数据的每个字符一位接一位地传输。
其中每一位(Bit)的意义如下：
空闲位：高电平，表明当前无传输事务。
起始位：一位低电平信号，标志着数据传输的开始。
数据位：紧接着起始位之后。数据位的个数可以是4、5、6、7、8等，构成一个字符。通常采用ASCII码。从最低位开始传送，靠时钟定位。
奇偶校验位：数据位加上这一位后，使得“1”的位数应为偶数(偶校验)或奇数(奇校验)，以此来校验数据传送的正确性。
停止位:一个字符数据的结束标志。可以是1位、1.5位、2位的高电平。 由于数据是在传输线上定时的，并且每一个设备有其自己的时钟，很可能在通信中两台设备间出现了小小的不同步。因此停止位不仅仅是表示传输的结束，并且提供计算机校正时钟同步的机会。停止位的位数越多，不同时钟同步的容忍程度越大，但是数据传输率同时也越慢。
uart数据传输的速率用波特率表示，其含义为从一设备发到另一设备，每秒钟可以通信的数据比特个数。典型的波特率有300, 1200, 2400, 9600, 19200, 115200等。一般通信两端设备都要设为相同的波特率，但有些设备也可设置为自动检测波特率。
## UART的verilog实现
### 发送端
下面是正点原子的uart发送模块例程，当然用ip核也是可以的，不过我不太会用喵。
为了发送“一包”数据把整个发送模块都魔改了一下，以下例程的input和output只留下了clk、rst和txd，加入了我需要的输入数据。
先放魔改前的例程看看：
```verilog
module uart_send(
    input	           sys_clk,             //系统时钟
    input              sys_rst_n,           //系统复位，低电平有效
    
    input              uart_en,             //发送使能信号
    input       [ 7:0] uart_din,            //待发送数据
    output             uart_tx_busy,        //发送忙状态标志 
    output             en_flag     ,
    output  reg        tx_flag,             //发送过程标志信号
    output  reg [ 7:0] tx_data,             //寄存发送数据
    output  reg [ 3:0] tx_cnt,              //发送数据计数器
    output  reg        uart_txd             //UART发送端口
    );
    
//parameter define
parameter  CLK_FREQ = 50000000;             //系统时钟频率
parameter  UART_BPS = 9600;                 //串口波特率
localparam  BPS_CNT  = CLK_FREQ/UART_BPS;   //为得到指定波特率，对系统时钟计数BPS_CNT次

//reg define
reg        uart_en_d0; 
reg        uart_en_d1;  
reg [15:0] clk_cnt;                           //系统时钟计数器

//*****************************************************
//**                    main code
//*****************************************************
//在串口发送过程中给出忙状态标志
assign uart_tx_busy = tx_flag;

//捕获uart_en上升沿，得到一个时钟周期的脉冲信号
assign en_flag = (~uart_en_d1) & uart_en_d0;

//对发送使能信号uart_en延迟两个时钟周期
always @(posedge sys_clk or negedge sys_rst_n) begin         
    if (!sys_rst_n) begin
        uart_en_d0 <= 1'b0;                                  
        uart_en_d1 <= 1'b0;
    end                                                      
    else begin                                               
        uart_en_d0 <= uart_en;                               
        uart_en_d1 <= uart_en_d0;                            
    end
end

//当脉冲信号en_flag到达时,寄存待发送的数据，并进入发送过程          
always @(posedge sys_clk or negedge sys_rst_n) begin         
    if (!sys_rst_n) begin                                  
        tx_flag <= 1'b0;
        tx_data <= 8'd0;
    end 
    else if (en_flag) begin                 //检测到发送使能上升沿                      
            tx_flag <= 1'b1;                //进入发送过程，标志位tx_flag拉高
            tx_data <= uart_din;            //寄存待发送的数据
        end
                                            //计数到停止位结束时，停止发送过程
        else if ((tx_cnt == 4'd9) && (clk_cnt == BPS_CNT - (BPS_CNT/16))) begin                                       
            tx_flag <= 1'b0;                //发送过程结束，标志位tx_flag拉低
            tx_data <= 8'd0;
        end
        else begin
            tx_flag <= tx_flag;
            tx_data <= tx_data;
        end 
end

//进入发送过程后，启动系统时钟计数器
always @(posedge sys_clk or negedge sys_rst_n) begin         
    if (!sys_rst_n)                             
        clk_cnt <= 16'd0;                                  
    else if (tx_flag) begin                 //处于发送过程
        if (clk_cnt < BPS_CNT - 1)
            clk_cnt <= clk_cnt + 1'b1;
        else
            clk_cnt <= 16'd0;               //对系统时钟计数达一个波特率周期后清零
    end
    else                             
        clk_cnt <= 16'd0; 				        //发送过程结束
end

//进入发送过程后，启动发送数据计数器
always @(posedge sys_clk or negedge sys_rst_n) begin         
    if (!sys_rst_n)                             
        tx_cnt <= 4'd0;
    else if (tx_flag) begin               //处于发送过程
        if (clk_cnt == BPS_CNT - 1)			//对系统时钟计数达一个波特率周期
            tx_cnt <= tx_cnt + 1'b1;		//此时发送数据计数器加1
        else
            tx_cnt <= tx_cnt;       
    end
    else                              
        tx_cnt  <= 4'd0;				    //发送过程结束
end

//根据发送数据计数器来给uart发送端口赋值
always @(posedge sys_clk or negedge sys_rst_n) begin        
    if (!sys_rst_n)  
        uart_txd <= 1'b1;        
    else if (tx_flag)
        case(tx_cnt)
            4'd0: uart_txd <= 1'b0;         //起始位 
            4'd1: uart_txd <= tx_data[0];   //数据位最低位
            4'd2: uart_txd <= tx_data[1];
            4'd3: uart_txd <= tx_data[2];
            4'd4: uart_txd <= tx_data[3];
            4'd5: uart_txd <= tx_data[4];
            4'd6: uart_txd <= tx_data[5];
            4'd7: uart_txd <= tx_data[6];
            4'd8: uart_txd <= tx_data[7];   //数据位最高位
            4'd9: uart_txd <= 1'b1;         //停止位
            default: ;
        endcase
    else 
        uart_txd <= 1'b1;                   //空闲时发送端口为高电平
end

endmodule	          
```
魔改后：
```verilog
module uart_send(
    input	      sys_clk,
    input         sys_rst_n,
	input [3:0] mode,
	input [7:0] data1,
	input [3:0] data2,
    output  reg   uart_txd               
    );

//parameter define
parameter  CLK_FREQ = 100000000;
parameter  UART_BPS = 115200;
localparam BPS_CNT  = CLK_FREQ/UART_BPS;

//reg w=0;
reg[31:0] i;
reg [3:0] Data_Count;
reg [7:0] arry [Data_Len:0];
parameter [3:0] Data_Len=4'd8;
wire en_flag;

//reg define
reg        usart_down;
reg        uart_en_d0; 
reg        uart_d1;  
reg [15:0] clk_cnt;                   
reg [ 3:0] tx_cnt;                  
reg        tx_flag;               
reg [7:0]  tx_data;
reg        first;

wire [7:0]mode_char,data1_h,data1_m,data1_l,data2_char;

bin_to_1char(mode,mode_char);
bin_to_3char(data1,data1_h,data1_m,data1_l);
bin_to_1char(data2,data2_char);

always@(posedge sys_clk/* or posedge w*/)
begin

    for(i=0; i<=Data_Len; i=i+1'b1) begin    
        case(i)
          0: arry[0]<= "0";//"1"  8'd48
          1: arry[1]<= mode_char;
          2: arry[2]<= "+"; 
          3: arry[3]<= data1_l; 
          4: arry[4]<= data_m; 
          5: arry[5]<= data1_h; 
          6: arry[6]<= "+"; 
          7: arry[7]<= data2_char;
          8: arry[8]<= 8'h0d;
          endcase
     end
end


assign en_flag = (~uart_en_d1) & uart_en_d0;


always @(posedge sys_clk or negedge sys_rst_n) begin         
    if (!sys_rst_n) begin
        usart_down <= 1'b0;   
        first <= 1'b1; 
    end 
    else if (first)begin/
        usart_down <= 1;
        first <= 0;    
    end  
    else if(tx_cnt == 4'd0) begin                                      
        usart_down <= 1;      
    end
    else 
        usart_down <= 0; 
end


always @(posedge sys_clk or negedge sys_rst_n) begin 
    if (!sys_rst_n) begin 
        uart_en_d0 <= 1'b0;
        uart_en_d1 <= 1'b0;          
    end
    else begin
        uart_en_d0  <= usart_down;                   
        uart_en_d1  <= uart_en_d0;
    end   
end

always @(posedge sys_clk or negedge sys_rst_n) begin         
    if (!sys_rst_n) begin
        tx_flag <= 1'b0;
        tx_data <= arry[0];
        Data_Count <= 4'b0; 
    end 
    else if(en_flag) begin                                 
        tx_flag <= 1'b1;      
        tx_data <= arry[Data_Count];
    end
    else  if((tx_cnt == 4'd10)&&(clk_cnt == BPS_CNT/2))
    begin                          
        tx_flag <= 1'b0;    
        Data_Count<=Data_Count+4'b1;
    if (Data_Count==Data_Len)
        Data_Count<=4'b0;      
    end
end

always @(posedge sys_clk or negedge sys_rst_n) begin         
    if (!sys_rst_n) begin                             
        clk_cnt <= 16'd0;                                  
        tx_cnt  <= 4'd0;
    end                                                      
    else if (tx_flag) begin                
        if (clk_cnt < BPS_CNT - 1) begin
            clk_cnt <= clk_cnt + 1'b1;
            tx_cnt  <= tx_cnt;
        end
        else begin
            clk_cnt <= 16'd0;             
            tx_cnt  <= tx_cnt + 1'b1;      
        end
    end
    else be
        clk_cnt <= 16'd0;
        tx_cnt  <= 4'd0;
    end
end

always @(posedge sys_clk or negedge sys_rst_n) begin        
    if (!sys_rst_n)  
        uart_txd <= 1'b1;        
    else if (tx_flag)
        case(tx_cnt)
            4'd0: uart_txd <= 1'b0;       
            4'd1: uart_txd <= tx_data[0];
            4'd2: uart_txd <= tx_data[1];
            4'd3: uart_txd <= tx_data[2];
            4'd4: uart_txd <= tx_data[3];
            4'd5: uart_txd <= tx_data[4];
            4'd6: uart_txd <= tx_data[5];
            4'd7: uart_txd <= tx_data[6];
            4'd8: uart_txd <= tx_data[7];
            4'd9: uart_txd <= 1'b1;      
            default:uart_txd <= 1'b1;
        endcase
    else 
        uart_txd <= 1'b1;
end

endmodule	          
```
### 接收端
```verilog
module uart_recv(
    input			     sys_clk,                  //系统时钟
    input              sys_rst_n,                //系统复位，低电平有效
    
    input              uart_rxd,                 //UART接收端口
    output  reg        uart_done,                //接收一帧数据完成标志
    output  reg        rx_flag,                  //接收过程标志信号
    output  reg [3:0]  rx_cnt,                   //接收数据计数器
    output  reg [7:0]  rxdata,
    output  reg [7:0]  uart_data                 //接收的数据
    );
    
//parameter define
parameter  CLK_FREQ = 50000000;                //系统时钟频率
parameter  UART_BPS = 9600;                    //串口波特率
localparam  BPS_CNT  = CLK_FREQ/UART_BPS;      //为得到指定波特率，
                                               //需要对系统时钟计数BPS_CNT次
//reg define
reg        uart_rxd_d0;
reg        uart_rxd_d1;
reg [15:0] clk_cnt;                              //系统时钟计数器

//wire define
wire       start_flag;

//*****************************************************
//**                    main code
//*****************************************************
//捕获接收端口下降沿(起始位)，得到一个时钟周期的脉冲信号
assign  start_flag = uart_rxd_d1 & (~uart_rxd_d0);    

//对UART接收端口的数据延迟两个时钟周期
always @(posedge sys_clk or negedge sys_rst_n) begin 
    if (!sys_rst_n) begin 
        uart_rxd_d0 <= 1'b0;
        uart_rxd_d1 <= 1'b0;          
    end
    else begin
        uart_rxd_d0  <= uart_rxd;                   
        uart_rxd_d1  <= uart_rxd_d0;
    end   
end

//当脉冲信号start_flag到达时，进入接收过程           
always @(posedge sys_clk or negedge sys_rst_n) begin         
    if (!sys_rst_n)                                  
        rx_flag <= 1'b0;
    else begin
        if(start_flag)                          //检测到起始位
            rx_flag <= 1'b1;                    //进入接收过程，标志位rx_flag拉高
                                                //计数到停止位中间时，停止接收过程
        else if((rx_cnt == 4'd9) && (clk_cnt == BPS_CNT/2))
            rx_flag <= 1'b0;                    //接收过程结束，标志位rx_flag拉低
        else
            rx_flag <= rx_flag;
    end
end

//进入接收过程后，启动系统时钟计数器
always @(posedge sys_clk or negedge sys_rst_n) begin         
    if (!sys_rst_n)                             
        clk_cnt <= 16'd0;                                  
    else if ( rx_flag ) begin             //处于接收过程
        if (clk_cnt < BPS_CNT - 1)
            clk_cnt <= clk_cnt + 1'b1;
        else
            clk_cnt <= 16'd0;             //对系统时钟计数达一个波特率周期后清零
    end
    else                              				
        clk_cnt <= 16'd0;						//接收过程结束，计数器清零
end

//进入接收过程后，启动接收数据计数器
always @(posedge sys_clk or negedge sys_rst_n) begin         
    if (!sys_rst_n)                             
        rx_cnt  <= 4'd0;
    else if ( rx_flag ) begin                //处于接收过程
        if (clk_cnt == BPS_CNT - 1)				//对系统时钟计数达一个波特率周期
            rx_cnt <= rx_cnt + 1'b1;			//此时接收数据计数器加1
        else
            rx_cnt <= rx_cnt;       
    end
	 else
        rx_cnt  <= 4'd0;						//接收过程结束，计数器清零
end

//根据接收数据计数器来寄存uart接收端口数据
always @(posedge sys_clk or negedge sys_rst_n) begin 
    if ( !sys_rst_n)  
        rxdata <= 8'd0;                                     
    else if(rx_flag)                            //系统处于接收过程
        if (clk_cnt == BPS_CNT/2) begin         //判断系统时钟计数器计数到数据位中间
            case ( rx_cnt )
             4'd1 : rxdata[0] <= uart_rxd_d1;   //寄存数据位最低位
             4'd2 : rxdata[1] <= uart_rxd_d1;
             4'd3 : rxdata[2] <= uart_rxd_d1;
             4'd4 : rxdata[3] <= uart_rxd_d1;
             4'd5 : rxdata[4] <= uart_rxd_d1;
             4'd6 : rxdata[5] <= uart_rxd_d1;
             4'd7 : rxdata[6] <= uart_rxd_d1;
             4'd8 : rxdata[7] <= uart_rxd_d1;   //寄存数据位最高位
             default:;                                    
            endcase
        end
        else 
            rxdata <= rxdata;
    else
        rxdata <= 8'd0;
end

//数据接收完毕后给出标志信号并寄存输出接收到的数据
always @(posedge sys_clk or negedge sys_rst_n) begin        
    if (!sys_rst_n) begin
        uart_data <= 8'd0;                               
        uart_done <= 1'b0;
    end
    else if(rx_cnt == 4'd9) begin               //接收数据计数器计数到停止位时           
        uart_data <= rxdata;                    //寄存输出接收到的数据
        uart_done <= 1'b1;                      //并将接收完成标志位拉高
    end
    else begin
        uart_data <= 8'd0;                                   
        uart_done <= 1'b0; 
    end    
end

endmodule	
```
## 二进制数值转字符
### 为什么要转为字符发送
uart这样的串口数据发送方式一次发送8个bit也就是一个字节的数据，那么现在一个字节就既可以代表一个整数又可以代表一个字符了，但它本质上只是一个字节的数据，可以赋予了它不同的涵义，什么时候赋予它那种涵义就看编程者的意图了。比如对一个小于255的整数，它的二进制是小于8位的，我们可以选择使用一帧串口数据去传送它，在通信的下位机用同样的方式（按位计算出二进制所代表的数值）解读出来；也可以选择将这个数值拆成一个一个的字符来传输。
举个例子，“123”这个数的二进制表示为1111011，拆为字符则会变成'1'、'2'、'3'。
如果是更大的数呢？比如1234这个数，二进制表示是00000100 11010010，需要拆成高低两个字节来传输，那么在下位机端的解析就要更为复杂一些，拆成字符的话反而更通用。

### 如何将数值转为字符
在单片机C语言中，我们经常用/10,%10这样的方法将数字转换为字符串，反过来字符串转数字就用乘法：*10。
1829除以10，商182余9，得到个位数9。
182再除以10，商18余2，得到十位数2。
18除以10，商1余8，得到千位数1和百位数8。
但是这种方法并不适合于FPGA。因为乘法器和除法器都比较庞大，如果用在for循环里面，最后编译出来的电路会非常复杂，搞不好会把整个fpga的资源全部用完。
实际上，根本就不需要乘除法，我们只用加减法和移位就能搞定。
数字本质上就是二进制码，字符串本质上就是BCD码。
参考[Binary to BCD Conversion Algorithm](https://my.eng.utah.edu/~nmcdonal/Tutorials/BCDTutorial/BCDConversion.html) 
1. 先转为BCD码
   这是一个将8位二进制数转为三个字符的模块，原理就是反复进行以下的操作：
   - 如果任何一列（100's、10's、1's 等）为 5 或更大，则将 3 添加到该列。
    - 将所有 #'s 向左移 1 位。
    - 如果已经执行了 8 次变化，那就完成了 BCD 转换。
    - 转到步骤 1。
   ![](https://my.eng.utah.edu/~nmcdonal/Tutorials/BCDTutorial/AlgorithmTable.png)
   ```verilog
   module BCD3(
        input [7:0] binary,
        output reg [3:0] Hundreds,
        output reg [3:0] Tens,
        output reg [3:0] Ones
        );
        integer i;
        always@(binary)begin
            //set 100's,10's,and 1's to 0
            Hundreds = 4'd0;
            Tens = 4'd0;
            Ones = 4'd0;

            for(i=7;i>=0;i=i-1)begin
                //add 3 to columns >= 5
                if(Hundreds >= 5)
                    Hundreds = Hundreds + 3;
                if(Tens >= 5)
                    Tens = Tens + 3;
                if(Ones >= 5)
                    Ones = Ones + 3;
                
                //shift left one
                Hundreds = Hundreds<<1;
                Hundreds[0] = Tens[3];
                Tens = Tens<<1;
                Tens[0] = Ones[3];
                Ones = Ones<<1;
                Ones[0] = binary[i];
            end
        end
    endmodule
    ```
2. BCD码加上高位
    数字18是：00010010
    而字符串"18"的十六进制形式是0x31 0x38
    把左边的3去掉，剩下的就是1和8，合起来就是BCD码 0001 1000
    所以我们只需要给求得的BCD码加上0x30就可以啦，也就是在高四位赋0011。
    ```verilog
    module To_char(
        input  [3:0] BCDnum,
        output [7:0] singalchar
    );
        assign singalchar[3:0] = BCDnum;
        assign singalchar[7:4] = 4'b0011;
    endmodule
    ```
### 如何将接收的字符转为数字
参考[BCD to Binary Conversion on an FPGA](https://embeddedthoughts.com/2016/06/01/bcd-to-binary-conversion-on-an-fpga/)
不多解释（水）了