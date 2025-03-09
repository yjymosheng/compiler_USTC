# 理解IR框架
```shell
  module/
├── Function0
│       └── BasicBlock
│           ├── instructions0
│           ├── instructions1
│           ├── instructions2
│           ├── instructions3
│           ├── instructions4
│           └── instructions5
├── Function1
│       └── BasicBlock
│           ├── instructions0
│           ├── instructions1
│           ├── instructions2
│           ├── instructions3
│           ├── instructions4
│           └── instructions5
├── Function2
│       └── BasicBlock
│           ├── instructions0
│           ├── instructions1
│           ├── instructions2
│           ├── instructions3
│           ├── instructions4
│           └── instructions5
├── Function3
│       └── BasicBlock
│           ├── instructions0
│           ├── instructions1
│           ├── instructions2
│           ├── instructions3
│           ├── instructions4
│           └── instructions5
└── Function4
    └── BasicBlock
        ├── instructions0
        ├── instructions1
        ├── instructions2
        ├── instructions3
        ├── instructions4
        └── instructions5
```

# 思考题

### 在 Light IR 简介里，你已经了解了 IR 代码的基本结构，请尝试编写一个有全局变量的 cminus 程序，并用 clang 编译生成中间代码，解释全局变量在其中的位置。

```c++
int x[10];
int y[10];

int main(){
    int i=0 ;
    int sum=0;
    while (i<10){
        x[i] = 2*i;
        y[i] = 1*i;
        sum = x[i] + y[i] + sum;
    }
    return sum ;
}
```
全局变量存放在整个ll文件的最上层, 仅次于module 结构.

### Light IR 中基本类型 label 在 Light IR C++ 库中是如何用类表示的？
    
label 被封装在BasicBlock中,每当一个新的BasicBlock被创建, 会通过传入的name参数构建一个label的名称.

### Light IR C++ 库中 Module 类中对基本类型与组合类型存储的方式是一样的吗？请尝试解释组合类型使用其存储方式的原因。

不一样. 由于cminusf没有struct ,所以组合类型其实就是不同维度数组的展现方式. 

组合类型取决于编写程序对于数组维度的定义,它是一个动态的过程,Module库中采用map进行存储不同的组合类型

基本类型是固定的,不会有大的变化,这里采用unique_ptr来管理,避免了map的查找开销

