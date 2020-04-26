# Javadoc

1. @link
   * 解释: 快速链接到相关代码
   
   * 用法: {@link 包名.类名#方法名(参数类型列表)},包名已导入可以省略
   
   * 示例
   
     ```java
     
     ```
   
2. @code
   * 解释: 将文本标记为代码,类名和方法名都要用它标记
   * 用法: {@code text}
3. @param
	
	* 解释: 一般类中支持泛型时会通过@param来解释泛型的类型
	
	* 示例:
	
	  ```java
	  /**
	   * @param <E> the type of elements in this list
	  */
	  public interface List<E> extends Collection<E> {}
	  ```
4. @see
   
   * 解释:标记关联的类和方法
5. @since
   * 解释: 从以下版本开始使用
   * 用法: @since 1.8  @since 2019/01/01

6. @version
   
   * 解释: 当前版本