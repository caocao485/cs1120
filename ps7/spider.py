# -*- coding: utf-8 -*
from bs4 import BeautifulSoup
import requests
import csv
import xlwt

singleAnswerList = []
multipleAnswerList = []
judgeList = []
style = xlwt.XFStyle()

urls = ['https://www.jsyks.com/kms-st-z1511',
    'https://www.jsyks.com/kms-st-z1512',
    'https://www.jsyks.com/kms-st-z1513',
    'https://www.jsyks.com/kms-st-z1514',
    'https://www.jsyks.com/kms-st-z1515',
    'https://www.jsyks.com/kms-st-z1516',
    'https://www.jsyks.com/kms-st-z1517'
]



def analyze(url):
    response = requests.get(url)
    response.encoding = 'utf-8'
    soup = BeautifulSoup(response.text,"html.parser")
    for select in soup.select('tr')[1:]:
        if len(list(select.a.strings)) == 1:
            judgeList.append(Trueor(select))
        elif len(select.select('.DAV strong')[0].string) ==1:
            singleAnswerList.append(SingleSelection(select))
        else:
            multipleAnswerList.append(MultipleChoice(select))


def writeToExcel():
    jFile = open('judge.csv', 'w',encoding='utf8',newline='')
    jWriter = csv.writer(jFile)
    jWriter.writerow(['字数', '问题', '答案','图片链接'])
    for jg in judgeList:
        jg.write(jWriter)
    jFile.close()
    sFile = open('single.csv', 'w',encoding='utf8',newline='')
    sWriter = csv.writer(sFile)
    sWriter.writerow(['字数', '问题', '选项','答案','图片链接'])
    for sg in singleAnswerList:
        sg.write(sWriter)
    sFile.close()
    mFile = open('multiple.csv', 'w',encoding='utf8',newline='')
    mWriter = csv.writer(mFile)
    mWriter.writerow(['字数', '问题', '选项','答案','图片链接'])
    for mu in multipleAnswerList:
        mu.write(mWriter)
    mFile.close()

def writeToXl():
    # 创建 xls 文件对象
    wb = xlwt.Workbook()
    # 新增两个表单页
    sh1 = wb.add_sheet('单选题')
    sh2 = wb.add_sheet('多选题')
    sh3 = wb.add_sheet('判断题')
    
    sh1.write(0, 0, '字数')   
    sh1.write(0, 1, '题目')   
    sh1.write(0, 2, '选项')  
    sh1.write(0, 3, '答案')
    sh1.write(0, 4, '图片链接')
    for startRow , single in zip(range(1,len(singleAnswerList)) ,singleAnswerList):
        single.write(sh1,startRow)
    sh2.write(0, 0, '字数')   
    sh2.write(0, 1, '题目')   
    sh2.write(0, 2, '选项')  
    sh2.write(0, 3, '答案')
    sh2.write(0, 4, '图片链接')
    for start , mul in zip(range(1,len(multipleAnswerList)) ,multipleAnswerList):
        mul.write(sh2,start)
    sh3.write(0, 0, '字数')   
    sh3.write(0, 1, '题目')   
    sh3.write(0, 2, '答案')
    sh3.write(0, 3, '图片链接')
    for st , judge in zip(range(1,len(judgeList)) ,judgeList):
        judge.write(sh3,st)
    wb.save('题库.xls')


#soup.select('tr')[1].select('img')  由len长短来确定是否有img

#soup.select('tr')[1].a.strings 内容/选项 如果list(strings)为1，说明是判断题

#len(soup.select('tr')[10].select('.DAV strong')[0].string) 单选/多选 答案

class SingleSelection:
    def __init__(self,selector):
        self._selector = selector
        img_src = self._selector.select('img')
        print(str(img_src))
        if len(img_src) == 1:
            if img_src[0].has_attr('src'):
                self._img_src = 'http:' + img_src[0].attrs['src']
            else:
                self._img_src = 'http:' + img_src[0].attrs['ybsrc']
        else:
            self._img_src = ''
        question_selections = list(self._selector.a.strings)
        self._question = question_selections[0]
        self._selections = question_selections[1:]
        self._questionlen = len(self._question)
        self._answer = self._selector.select('.DAV strong')[0].string

    def write(self,writer,startRow):
        writer.write(startRow,0,str(self._questionlen))
        writer.write(startRow,1,self._question)
        writer.write(startRow,2,'\n'.join(self._selections))
        writer.write(startRow,3,self._answer)
        writer.write(startRow,4,self._img_src)
        #writer.writerow([str(self._questionlen), self._question, self._selections,self._answer,self._img_src])
        

class MultipleChoice:
    def __init__(self,selector):
        self._selector = selector
        img_src = self._selector.select('img')
        if len(img_src) == 1:
            if img_src[0].has_attr('src'):
                self._img_src = 'http:' + img_src[0].attrs['src']
            else:
                self._img_src = 'http:' + img_src[0].attrs['ybsrc']
        else:
            self._img_src = ''
        question_selections = list(self._selector.a.strings)
        self._question = question_selections[0]
        self._selections = question_selections[1:]
        self._questionlen = len(self._question)
        self._answer = self._selector.select('.DAV strong')[0].string

    def write(self,writer,startRow):
        writer.write(startRow,0,str(self._questionlen))
        writer.write(startRow,1,self._question)
        writer.write(startRow,2,'\n'.join(self._selections))
        writer.write(startRow,3,self._answer)
        writer.write(startRow,4,self._img_src)
        #writer.writerow([str(self._questionlen), self._question, self._selections,self._answer,self._img_src])


class Trueor:
    def __init__(self,selector):
        self._selector = selector
        img_src = self._selector.select('img')
        if len(img_src) == 1:
            if img_src[0].has_attr('src'):
                self._img_src = 'http:' + img_src[0].attrs['src']
            else:
                self._img_src = 'http:' + img_src[0].attrs['ybsrc']
        else:
            self._img_src = ''
        question_selections = list(self._selector.a.strings)
        self._question = question_selections[0]
        self._questionlen = len(self._question)
        self._answer = self._selector.select('.DAV strong')[0].string

    def write(self,writer,start):
        writer.write(start,0,str(self._questionlen))
        writer.write(start,1,self._question)
        writer.write(start,2,self._answer)
        writer.write(start,3,self._img_src)
        #writer.writerow([str(self._questionlen), self._question,self._answer,self._img_src])


def start():
    for url in urls:
        analyze(url)
    writeToXl()

#response = requests.get('https://www.jsyks.com/kms-st-z1511')
#response.encoding = 'utf-8'
#soup = BeautifulSoup(response.text,"html.parser")