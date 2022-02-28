# 排序算法

## 1. 快速排序

### 1.1. 概念

> 快速排序的核心思想是分治:选择数组中的某个数作为基数,将数组中比基数小的数字放到它的左边,比基数大的数字放到它的右边;按照此方法循环递归执行,直到整个数组变得有序

### 1.2. 思路

* 现有无序数组arr,要将它从小到大排序
  
  ```java
  int[] arr = {4,2,8,0,5,7,1,3,9}
  ```

* 基准数temp取数组第一个元素,并定义两个变量i,j,分别指向数组第一个元素start 和最后一个元素end
  
  ```java
  int i = start;
  int j = end;
  int temp = arr[i];
  ```
  
  ![](https://s2.loli.net/2022/02/28/RodWVskJgK4a683.png)

* 将比基准数大的数全放到它的右边，比基准数小的或者相等的数全放到它的左边.此时,arr[i] 的值已经赋值给了基准数temp,所以将arr[i]设置为坑位, 从数组右边向左寻找小于它的元素,移动过来
  
  ```java
  //从右到左查找小于temp的元素 
  while(i < j && arr[j] >= temp) {
    j--;
  }
  //找到以后,将arr[j]赋值给arr[i],并将i右移一位,arr[j]成为了新的坑位
  if(i < j) {
    arr[i] = arr[j];
    i++;
  }
  ```
  
  ![](https://s2.loli.net/2022/02/28/VYGPkgvlMbpymqz.png)

* 换好位置以后, 坑位移到了右边,那再从数组左边向右查找比基准数大的元素,放过去
  
  ```java
  while(i < j && arr[i] < tmep) {
    i++;
  }
  //找到以后, 将arr[i]赋值给arr[j],j左移一位, arr[i]成了新的空位
  if(i < j) {
    arr[j] = arr[i];
    j--;
  }
  ```
  
  ![](https://s2.loli.net/2022/02/28/wYa9v25jk86OsXe.png)

* 不断重复这两个步骤,直到i与j相遇(i等于j),此时坑位是arr[i],将基准值放入.到这里,i的左边都小于基准数,i的右边都大于基准数
  
  ```java
  //循环直到i = j 
  while(i < j) {   
    //从右到左查找小于temp的元素 
    while(i < j && arr[j] >= temp) {
      j--;
    }
    //找到以后,将arr[j]赋值给arr[i]并将i右移一位,arr[j]成为了新的坑位
    if(i < j) {
      arr[i] = arr[j];
      i++;
    }
  
    while(i < j && arr[i] < tmep) {
      i++;
    }
    //找到以后, 将arr[i]赋值给arr[j],j左移一位, arr[i]成了新的空位
    if(i < j) {
      arr[j] = arr[i];
      j--;
    }
  }
  //将一开始拿出来的arr[i](基准值)赋值给当前的坑位
  arr[i] = temp;
  ```
  
  ![](https://s2.loli.net/2022/02/28/VqJXtYLRUyCrI9z.png)

* 此时,已经分好了两个区域,区域一是小于基准数,区域二是大于基准数.对两个区域再次执行以上步骤,直到每个区域只有一个元素为止
  
  ```java
  //递归
  quickSort(arr, start, i - 1);
  quickSort(arr, i + 1, end);
  ```
  
  ![](https://s2.loli.net/2022/02/28/9ylG61ZfLjDsYFz.png)

### 1.3. 实现

```java
public class Test {
    public static void main(String[] args) {
        int[] arr = {4,2,8,0,5,7,1,3,9};
        arr = quickSort(arr, 0, arr.length - 1);
        System.out.println(Arrays.toString(arr));
    }

    private static int[] quickSort(int[] arr, int start, int end) {
        int i = start;
        int j = end;
        //递归退出条件: i < j. 如果i = j,说明只有一个元素了
        if (i < j) {
            //设置基准值为数组第一个元素
            int temp = arr[start];
            //循环直到i = j 
            while (i < j) {
                //从右到左查找小于temp的元素 
                while (i < j && arr[j] >= temp) {
                    j--;
                }
                //找到以后,将arr[j]赋值给arr[i],并将i右移一位,arr[j]成为了新的坑位
                if (i < j) {
                    arr[i] = arr[j];
                    i++;
                }

                while (i < j && arr[i] < temp) {
                    i++;
                }
                //找到以后, 将arr[i]赋值给arr[j],j左移一位, arr[i]成了新的空位
                if (i < j) {
                    arr[j] = arr[i];
                    j--;
                }
            }
            //将一开始拿出来的arr[i](基准值)赋值给当前的坑位
            arr[i] = temp;
            quickSort(arr, start, i - 1);
            quickSort(arr, i + 1, end);
        }
        return arr;
    }
}
```