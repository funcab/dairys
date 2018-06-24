# 二分查找
函数binary_search接受一个有序数组和一个元素。如果指定的元素包含在数组内，这个函数将返回其位置。
你将跟踪要在其中查找的数组部分--开始时为整个数组。
完整的代码如下：
```
def binary_searh(list,item):
    low = 0
    high = len(list) - 1
    
    while low <= high:
        mid = (low + high)//2
        guess = list[mid]
        if guess
