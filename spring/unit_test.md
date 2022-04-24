# unit_test

## 1. 单元测试介绍

* 对于Spring 项目来说,单元测试就是类的测试

* Spring boot 提供了 spring-boot-starter-test 依赖,包含以下几个库:

  | 名称           | 介绍                    |
  | -------------- | ----------------------- |
  | Junit5         | Java 单元测试工具       |
  | SpringBootTest | 提供SpringBoot 环境支持 |
  | AssertJ        | 流式断言库              |
  | Mockito        | Java 模拟框架           |
  | Hamcrest       | 匹配对象库              |
  | JSONassert     | JSON 断言库             |
  | JsonPath       | JSON ZPath              |

## 2. 单元测试引入

我们可以通过SpringBootTest 创建SpringBoot环境,直接注入对象来执行对应的方法;无法使用真实对象时,可以用InjectMock 模拟对象.另外, spring-test 提供了MockMvc 来模拟网络请求

```java
//获取启动类,加载配置,启动Spring测试环境
@SpringBootTest
//开启注入MockMvc,等同于MockMvcBuilders.webAppContextSetup(webApplicationContext).build();
@AutoConfigureMockMvc
public class XXXServiceTest {
  //像真实SpringBoot项目中一样注入对象
  @Autowired
  private XXXService xxxService;
  //创建模拟对象
  @InjectMock
  private YYYService yyyService;
  @Autowired
  private MockMvc mockMvc;
  
  @BeforeAll
  void beforeAll() {
  	System.out.println("在所有测试方法执行前执行一次");
    //使mock, InjectMock等生效
    MockitoAnnotations.openMocks(this);
  }
  
  @BeforeEach
  void beforeEach() {
  	System.out.println("每次有测试方法执行前都执行一次");
  }
  
  @AfterAll
  void beforeAll() {
  	System.out.println("在所有测试方法执行后执行一次");
  }
  
  @AfterEach
  void beforeEach() {
  	System.out.println("每次有测试方法执行后都执行一次");
  }
    
  //测试方法
  @Test
  //开启事务
  @Transactional
  //方法执行完后事务回滚,默认为true, 防止污染数据库
  @Rollback
  public void get() {
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");
    LocalDate start = LocalDate.parse("2020-10-26", dtf);
    LocalDate end = LocalDate.parse("2020-10-31", dtf);
    Integer integer = XXXService.ConflictTime("10000001", start, end);
    //断言
    Assert.assertThat(integer, Matchers.notNullValue());
  }
  
  @Test
  void post() throws Exception {
    //通过RequestBuilders 发送请求, 自动执行SpringMVC的流程映射到对应的Controller处理
    mockMvc.perform(MockMvcRequestBuilders
                    .post("/people")
                    .contentType(MediaType.APPLICATION_JSON)
                    .accept(MediaType.APPLICATION_JSON)
                    .content("{\"key\":\"value\"}")
                    .header("Authorization", "Bearer****")
                   )
    .andExpect(MockMvcResultMatchers.status().isOk())
    .andDo(result -> System.out.println(result.getResponse()));
  }
  
  @Test
  void get() throws Exception {    
    ResultActions resultActions = mockMvc.perform(MockMvcRequestBuilders
                  .get("/people")
                  .header("Authorization", "Bearer****")
                  .param("id", "1")
    );
    resultActions.andReturn().getResponse()
      .setCharacterEncoding(StandardCharsets.UTF_8.name());
    resultActions.andExpect(MockMvcResultMatchers.status().isOk())
      .andDo(result -> System.out.println(result.getResponse()));
  }
  
}
```

## 3. 断言介绍

断言(Assertion) 会对比预期结果和实际结果,得到测试结论.在SpringBoot单元测试中,通常用Assertions工具类和MatcherAssert扩充类

```java
    @Test
    void test() {
        Assertions.assertEquals("replaceMeWithExpectedResult", result);
        MatcherAssert.assertThat("result", is(equals("test")));
    }
```

