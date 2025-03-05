# 基本格式
定义规则.引入基本头文件,变量,函数等定义
```bison
%{
    
%}
```

然后进行语法规则定义.通过%token %left %union 等定义一种标识符 


然后进行语法规则定义
```bison
%%
program: program expr '\n' {} ; 
%%
```

类似于rust marco 通过capture 以及recursive 等思想实现 解析


# 思考题
### 上述计算器例子的文法中存在左递归，为什么 bison 可以处理？
虽然存在左递归,但是存在expr的单独存在形式,即存在最小形态.
加上bison 采取自底向上的LR分析法,先解析最小的term 再拓展为 大的expr

### 能否修改计算器例子的文法，使得它支持除数 0 规避功能？
根据除法前对$3 进行检测,如果是0 就打印错误,然后返回YYERROR进行退出

```bison
 switch ($2) {
    case '*': $$ = $1 * $3; break;
    case '/':
      if ( $3==0){
             yyerror(" zero error");
             YYERROR;
         }
    $$ = $1 / $3; break; // 这里会出什么问题？
    }
```
