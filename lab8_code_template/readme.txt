# 实验8 存储器与控制器实验 代码模板

本压缩包中提供了本次实验所需要的代码模板以及一些资料。

## Verilog 源文件

- proc_top.v

这是处理器的顶层模块，也应该是你工程中的顶层模块，模板中已经例化了串口监视器，剩下的都需要你根据实验手册在其中实现所需模块。

- alu_dec.v
- main_dec.v
- controller.v

这些是本次需要编写的控制器部分文件，仅包含输入输出接口和模块例化，需要自己编写其中的逻辑。

- sys_monitor.v
- uart_top.v
- uart_rx.v
- uart_tx.v
  
这些是已经编写好的串口监视器，按照实验手册引入你的工程并例化FIFO即可使用。

## COE 指令ROM初始化文件

- mipstest.coe

包含了一个简单的程序，`coe指令说明.jpg`中介绍了指令的具体信息。

## 串口信息转换脚本

- script.py

使用Python编写的一个转换脚本，可以将串口中的数据转换成一个比较容易看懂的表格。如果你嫌我写的不好也可以自己写一个。

```python
def main():
    # 串口接收到的源数据，替换成你的串口接收到的数据
    recv = "60 00 00 04 A2 00 00 08 A2 00 00 0C 12 00 00 10 60 00 00 44 82 02 00 48 60 00 00 4C "

    # 你的目标列表
    monitor_list = ["alusrc", "regdst", "regwrite", "jump", "branch", "alucontrol", "memtoreg", "memwrite", "pcsrc"]

    # 调用函数
    convert(recv, monitor_list, monitor_len=11)
```

```
alusrc	regdst	regwrite	jump	branch	alucontrol	memtoreg	memwrite	pcsrc	PC
0		1		1			0		0		000			0			0			0		04
1		0		1			0		0		010			0			0			0		08
1		0		1			0		0		010			0			0			0		0C
0		0		0			1		0		010			0			0			0		10
0		1		1			0		0		000			0			0			0		44
```