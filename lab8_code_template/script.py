def fillCharHead(oristr:str, fillchar:str, length:int) -> str:
    for i in range(0, length - len(oristr)):
        oristr = fillchar + oristr
    return oristr


def data_output(monitor_list: list, display_data: str, PC: str):

    stro = ""

    cnt = 0
    for i in monitor_list:
        if i == "alucontrol":
            stro += display_data[cnt:cnt+3]
            cnt += 3
            stro += "\t\t\t"
        else:
            stro += display_data[cnt]
            cnt += 1
            if len(i) < 4:
                stro += "\t"
            elif len(i) < 8:
                stro += "\t\t"
            else:
                stro += "\t\t\t"
    stro += PC
    print(stro)

    return


def convert(oridata: str, monitor_list: list, monitor_len=11):

    char_cnt = 0
    byte_cnt = 0
    cur_byte = ""
    total_bin = ""
    PC = ""

    stro = ""
    for i in monitor_list:
        stro += i
        stro += "\t"
    stro += "PC"
    print(stro)

    for c in oridata:
        char_cnt += 1
        if char_cnt == 3:
            char_cnt = 0
            byte_cnt += 1
            if byte_cnt == 4:
                data_output(monitor_list, total_bin, PC)
                total_bin = ""
                byte_cnt = 0
            continue
        cur_byte += c
        if char_cnt == 2:
            if byte_cnt == 3:
                PC = cur_byte
                cur_byte = ""
            else:
                cur_byte_bin = bin(int(cur_byte, 16))[2:]
                cur_byte_bin = fillCharHead(cur_byte_bin, '0', 8)
                total_bin += cur_byte_bin
                cur_byte = ""


def main():
    # 串口接收到的源数据
    recv = "A2 00 00 04 A2 00 00 08 A2 00 00 0C 61 00 00 10 60 00 00 14 82 00 00 18 06 00 00 1C 67 00 00 20 0E 01 00 24 A2 00 00 2C 62 00 00 30 66 00 00 34 82 02 00 38 A2 04 00 3C 12 00 00 40 A2 00 00 44 82 02 00 48 60 00 00 4C "

    # 你的目标列表
    monitor_list = ["alusrc", "regdst", "regwrite", "jump", "branch", "alucontrol", "memtoreg", "memwrite", "pcsrc"]

    # 调用函数
    convert(recv, monitor_list, monitor_len=11)


if __name__ == '__main__':
    main()
