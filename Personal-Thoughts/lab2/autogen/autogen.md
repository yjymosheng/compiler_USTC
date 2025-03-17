# 开发记录:

## 2025年3月18日:

### 下午18点27分记下 

今天修改了加减乘除的计算逻辑 . 

将原本写的通过IRBuilder调用对于加减乘除的方法删除. 改为了添加context.return_val 并进行逻辑调整.

好处是将计算变成了编译期,但是坏处是我仅仅用了double来计算.可能会导致爆数.但是先写完再说吧.

测试结果的分数从64 变成了48 . 不清楚能不能带来收益

### 晚上22点39分记下

在下午的基础上,添加了context.need_return_val 

添加缘由:

```c++
else {
            auto var_index = builder->create_gep(var, {CONST_INT(0), cast_index_value});
            auto ret_value = builder->create_load(var_index);
            context.need_return_val = false;
            return ret_value;
}
```

    AST Var数组的load值很难被记录到return_val中,需要将Value *传递回上层 .

    而大部分上层有时候可以直接通过return_val进行计算,有时候却需要传递的Value* ,显然添加一个flag是一个简单的方式

另外修改了数值类型的 context.need_return_val的修改 .

优化了AdditiveExpression的判断逻辑, 通过return_val 全部改为了builder->create_fcmp_xx() . double类型的大小限制 (或者说是float, 毕竟宏里加上了(float)的类型转换) 

经过一番折腾, 测试结果的分数从48变回了61

## 2025年3月19日:

### 中午11点21分记下

今天上午主要在思考need_return_val的设置. call需要return的 create_call值.

num可以直接获得context.return_val,因为是基本数字. 可以利用到term等进行计算.

var, 都需要return的value, 因为普通变量需要进行load ,array的值也需要load.

下午看一看如何处理吧

### 下午16点03分记下

今天下午发生了两件事:
1. iteration和selection需要有counter去进行标记,不然会出现label重复
2. while因为我所谓的编译期计算导致会出现死循环. 存在用实数代替变量名.

目前的解决思路 
1. 重写,重构context的部分 ,目前已有的3个已经有些捉襟见肘.可能需要思考尝试一下,毕竟重写太麻烦
```c++
    Function *func = nullptr;
	double return_val;
    bool need_return_val;
```

2. 尝试进行挽救一下吧,添加一个bool判断是否在Iteration中,如果在Iteration中就需要用原始的计算方式.


    虽然感觉很难不重写了...... 但我真心不想重写啊,太麻烦了.这玩意儿似乎耦合的有点深入了

### 下午16点19分记下

受不了了, 这玩意儿耦合太深了,每个地方都是return_val ,当初改过来就废了半天力气, 重写吧.

感觉应该学习一下[calculator](../../../lab2/tests/2-ir-gen/warmup/calculator)了,感觉这才是visitor的思路

慢慢写吧,先去重下一份builder.cpp.这根本改都懒得改.把废弃的cp一份放在里[autogen](.)吧

### 下午17点01分记下

根据上一次写法的反思, 以我所看,得从下往上推倒. 也就是说我要从ASTNum开始写 , 然后往上拓展.