#-*- coding:utf-8 -*-
import re

def get_word_list(s1):
    # 把句子按字分开，中文按字分，英文按单词，数字按空格
    regEx = re.compile('[\\W]*')    # 我们可以使用正则表达式来切分句子，切分的规则是除单词，数字外的任意字符串
    res = re.compile(r"([\u4e00-\u9fa5])")    #  [\u4e00-\u9fa5]中文范围

    p1 = regEx.split(s1.lower())
    str1_list = []
    for str in p1:
        if res.split(str) == None:
            str1_list.append(str)
        else:
            ret = res.split(str)
            for ch in ret:
                str1_list.append(ch)

    list_word1 = [w for w in str1_list if len(w.strip()) > 0]  # 去掉为空的字符

    return  list_word1


s = "12、China's Legend Holdings will split its several business arms 	to go public on stock markets,  the group's president Zhu Linan said on Tuesday.该集团总裁朱利安周二表示，haha中国联想控股将分拆其多个业务部门在股市上市,。"


if __name__ == '__main__':
    s = "12、China's Legend Holdings will split its several business arms to go public on stock markets,  the group's president Zhu Linan said on Tuesday.该集团总裁朱利安周二表示，haha中国联想控股将分拆其多个业务部门在股市上市。"
    list_word1=get_word_list(s)
    print(list_word1)
