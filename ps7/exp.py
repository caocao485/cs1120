# -*- coding: utf-8 -*
import xlwt
import xlrd

singleAnswerList=[]
filterList = []

w_to_n = {
        'A' : 0,
        'B' : 1,
        'C': 2,
       'D' : 3
}

def readFromXl():
    workbook = xlrd.open_workbook("科目一题库汇总.xlsx")  # 打开工作簿
    sheets = workbook.sheet_names()  # 获取工作簿中的所有表格
    worksheet = workbook.sheet_by_name(sheets[0])  # 获取工作簿中所有表格中的的第一个表格
    singleData = []
    for i in range(1, worksheet.nrows):
        for j in range(0, worksheet.ncols):
            if (j == 2):
                print(worksheet.cell_value(i, j))
                singleData.append(worksheet.cell_value(i, j).split("\n"))
                singleData.append(worksheet.cell_value(i, j))
            else:
                singleData.append(worksheet.cell_value(i, j)) # 逐行逐列读取数据
        #if(singleData[5] ==''):
        filtered = []
        filtered.append(singleData[1])
        filtered.append(singleData[2][w_to_n[singleData[4]]][2:])
        filtered.append(len(singleData[2]))
        if(singleData[5] != ''):
            filtered.append(singleData[5])
        if filtered  not in filterList:
            filterList.append(filtered)
            singleAnswerList.append(singleData)
        #else:
        #  singleAnswerList.append(singleData)
        singleData = []





def writeToXl():
    # 创建 xls 文件对象
    wb = xlwt.Workbook()
    # 新增两个表单页
    sh1 = wb.add_sheet('单选题')
    
    sh1.write(0, 0, '字数')   
    sh1.write(0, 1, '题目')   
    sh1.write(0, 2, '选项')  
    sh1.write(0, 3, '答案')
    sh1.write(0, 4, '图片链接')
    for startRow , single in zip(range(1,len(singleAnswerList)) ,singleAnswerList):
        sh1.write(startRow, 0, single[0])   
        sh1.write(startRow, 1, single[1])   
        sh1.write(startRow, 2, single[3])  
        sh1.write(startRow, 3, single[4])
        sh1.write(startRow, 4, single[5])

    wb.save('选择题题库修正.xls')


def start():
    readFromXl()
    writeToXl()