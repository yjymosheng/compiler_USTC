# 作业内容
### 词法分析器
![作业一截图.png](image/%E4%BD%9C%E4%B8%9A%E4%B8%80%E6%88%AA%E5%9B%BE.png)

#### 我进行的行为 :
1. [syntax_analyzer.y](../../../lab1/src/parser/syntax_analyzer.y)中第40行添加测例中出现的相关token. 

    (这个实际上没有什么意义,仅仅是用来面向测例编程)
```bison
%token <node> VOID MAIN LPAREN RPAREN RETURN SEMIGRITION LBIGPAREN RBIGPAREN
```

2. [lexical_analyzer.l](../../../lab1/src/parser/lexical_analyzer.l) 规则部分填写测例汇中出现的规则

```flex
%%
 /* to do for students */
 /* two cases for you, pass_node will send flex's token to bison */
void 	{pos_start = pos_end; pos_end += 4; pass_node(yytext); return VOID;}
main 	{pos_start = pos_end; pos_end += 4; pass_node(yytext); return MAIN;}
return 	{pos_start = pos_end; pos_end += 6; pass_node(yytext); return RETURN;}
\( {pos_start = pos_end; pos_end ++; pass_node(yytext); return LPAREN;}
\) {pos_start = pos_end; pos_end ++; pass_node(yytext); return RPAREN;}
\{ {pos_start = pos_end; pos_end ++; pass_node(yytext); return LBIGPAREN;}
\} {pos_start = pos_end; pos_end ++; pass_node(yytext); return RBIGPAREN;}
\; {pos_start = pos_end; pos_end ++; pass_node(yytext); return SEMIGRITION;}
\n {pos_start = pos_end ; pos_end ++ ; lines ++; }
\  {pos_start = pos_end ; pos_end ++ ;}
. {}

 /****请在此补全所有flex的模式与动作  end******/
%%
```

3. [lexer.c](../../../lab1/src/parser/lexer.c)第33行处添加 [syntax_analyzer.y](../../../lab1/src/parser/syntax_analyzer.y)中有关lines,pos_start,pos_end的初始化内容

   因为parse 函数是在调用parser.c中的yyparse()前被调用. 在lexer.c中不会调用parse函数.会出现与文档不符合的情况.也可能是我没找到真正的原因.

```c++
//添加了34行,因为与要求的文档内容有冲突
lines = pos_start = pos_end = 1;
```

### 语法分析器
![作业二截图.png](image/%E4%BD%9C%E4%B8%9A%E4%BA%8C%E6%88%AA%E5%9B%BE.png)

#### 我进行的行为 : 
1. 在[syntax_analyzer.y](../../../lab1/src/parser/syntax_analyzer.y)中添加所有的关键字token ,以及type token. 
   1. 这个部分主要是在根据语法树进行编写.难点在于理解语法树的逻辑思维,以及整个规约的抽象

2. 在[lexical_analyzer.l](../../../lab1/src/parser/lexical_analyzer.l)填写所有需要识别的token regular 
   1. 这个部分的难点在于理解flex的识别规律,将关键词等固定的识别token前置,避免出现错误识别情况(flex尽可能识别更长的匹配长度, 同一长度情况下优先识别最早定义的)

#### 值得注意的地方
1. 测试是否正确 ,可以直接运行parser,然后根据复制粘贴认为可能出错的地方进行试探
2. 大部分错误出现在regex的错误编写上,请检查regex的定义