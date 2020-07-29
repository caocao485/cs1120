# -*- coding: utf-8 -*
from bs4 import BeautifulSoup
import requests
import csv
import xlwt
import re
import json
import time


singleAnswerList = []
multipleAnswerList = []
judgeList = []
style = xlwt.XFStyle()

urls = [
]



def analyze(url):
    response = requests.get(url)
    response.encoding = 'utf-8'
    soup = BeautifulSoup(response.text,"html.parser")
    for urlsA in soup.select(".number-line button a"):
        urls.append("https://www.jiaoguan.com/jk/car-kemu1-320100000000/exercise_seq/"+ urlsA.attrs["href"])
    




def writeToXl():
    # 创建 xls 文件对象
    wb = xlwt.Workbook()
    # 新增两个表单页
    sh1 = wb.add_sheet('单选题')
    sh3 = wb.add_sheet('判断题')
    
    sh1.write(0, 0, '字数')   
    sh1.write(0, 1, '题目')   
    sh1.write(0, 2, '选项')  
    sh1.write(0, 3, '答案')
    sh1.write(0, 4, '图片链接')
    for startRow , single in zip(range(1,len(singleAnswerList)) ,singleAnswerList):
        single.write(sh1,startRow)
    sh3.write(0, 0, '字数')   
    sh3.write(0, 1, '题目')   
    sh3.write(0, 2, '答案')
    sh3.write(0, 3, '图片链接')
    for st , judge in zip(range(1,len(judgeList)) ,judgeList):
        judge.write(sh3,st)
    wb.save('交管所科目一题库1.xls')

#soup.select('tr')[1].select('img')  由len长短来确定是否有img

#soup.select('tr')[1].a.strings 内容/选项 如果list(strings)为1，说明是判断题

#len(soup.select('tr')[10].select('.DAV strong')[0].string) 单选/多选 答案

class SingleSelection:
    def __init__(self,selector):
        self._selector = selector
        if(self._selector['mediaType'] == 1):
            self._img_src = self._selector['mediaUrl']
        else:
            self._img_src = ''
        
        #(str(self._img_src))

        self._question = self._selector['question']
        self._selections = []
        self._selections.append("A、"+self._selector['optionA'])
        self._selections.append("B、"+self._selector['optionB'])
        print(self._selector['optionC'])
        self._selections.append("C、"+self._selector['optionC'])
        self._selections.append("D、"+self._selector['optionD'])
        self._questionlen = len(self._question)
        self._answer = self._selector['factAnswerLabel'][0]

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
        if(self._selector['mediaType'] == 1):
            self._img_src = self._selector['mediaUrl']
        else:
            self._img_src = ''
        
        #(str(self._img_src))

        self._question = self._selector['question']
        self._questionlen = len(self._question)
        self._answer = self._selector['factAnswerLabel'][0]

    def write(self,writer,start):
        writer.write(start,0,str(self._questionlen))
        writer.write(start,1,self._question)
        writer.write(start,2,self._answer)
        writer.write(start,3,self._img_src)
        #writer.writerow([str(self._questionlen), self._question,self._answer,self._img_src])

excterUrls = []

def start():
  try:
    analyze("https://www.jiaoguan.com/jk/car-kemu1-320100000000/exercise_seq/17728.html")
    for url in urls[450:]:
        #time.sleep(2)
        print(url)
        if(url not in excterUrls):
            analyzeJson(url)
    writeToXl()
  except:
    writeToXl()
    print(traceback.format_exc())

#response = requests.get('https://www.jsyks.com/kms-st-z1511')
#response.encoding = 'utf-8'
#soup = BeautifulSoup(response.text,"html.parser")

def analyzeSingle(url):
    response = requests.get(url)
    response.encoding = 'utf-8'
    soup = BeautifulSoup(response.text,"html.parser")
    return soup

# 选择题
#soup.select(".number-line button a").attrs["href"] 题目链接
#soup.select(".checkbox-circle")
#for i in su.select(".checkbox-circle label"): 选项
#   i.text.strip() 各个选型
#
# su.select(".one-t a")[0].text.strip().split()[2][1:] 题目
# su.select(".one-e span")[2].string.strip() 答案

# 判断题

# su.select(".one-e span")[2].string.strip() 答案

# 选择题

# p = re.compile('detail:(.*)\n')

# p = re.compile(r'detail:(.*),')

def analyzeJson(url):
    jsonObject = json.loads(matchResult(analyzeSingle(url)),strict=False)
    if(len(jsonObject["optionValues"]) == 4):
        singleAnswerList.append(SingleSelection(jsonObject))
    else:
        judgeList.append(Trueor(jsonObject))



def matchResult(soup):
    jsonResult = None;
    p = re.compile(r'detail:(.*),')
    for script in soup.find_all("script",{"src":False}):
        if script:
            m = p.search(script.string)
            if not m is None:
                jsonResult = m.group(1)
    print(jsonResult)
    return jsonResult

# 转换成中文 encode('utf-8').decode("unicode_escape")

# json.loads(string) json字符串转换成字典

def htmlEscape(input):
        if not input:
            return input
        input = input.replace("&", "&amp;")
        input = input.replace("<", "&lt;")
        input = input.replace(">", "&gt;")
        input = input.replace(" ", "&nbsp;")
        input = input.replace("'", "&#39;") 
        input = input.replace("\"", "&quot;")
        input = input.replace("\n", "<br/>") 
        return input
