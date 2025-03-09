#include "BasicBlock.hpp"
#include "Constant.hpp"
#include "Function.hpp"
#include "IRBuilder.hpp"
#include "Module.hpp"
#include "Type.hpp"

#include <iostream>
#include <memory>
// 定义一个从常数值获取/创建 ConstantInt 类实例化的宏，方便多次调用
#define CONST_INT(num) \
ConstantInt::get(num, module)

// 定义一个从常数值获取/创建 ConstantFP 类实例化的宏，方便多次调用
#define CONST_FP(num) \
ConstantFP::get(num, module)

int main(){
    auto module = new Module();
    auto builder = new IRBuilder(nullptr ,module);
    auto*  Int32Type = module->get_int32_type();
    auto* arrayType = ArrayType::get(Int32Type, 10) ;
    auto mainFun = Function::create(FunctionType::get(Int32Type,{}),"main",module);
    auto bb = BasicBlock::create(module , "entry",mainFun);
    builder->set_insert_point(bb);


    auto*  retAlloca = builder->create_alloca(Int32Type);
    builder->create_store(CONST_INT(0), retAlloca);

    auto aAlloca = builder->create_alloca(arrayType);
    auto a0ptr = builder-> create_gep(aAlloca , {CONST_INT(0), CONST_INT(0)});
    // 用 builder 创建 store 指令，将 10 常数值存至上条语句取出的 a[0] 的地址
    builder->create_store(CONST_INT(10), a0ptr);

    auto a0load = builder->create_load(a0ptr);

    auto mulNum = builder->create_imul(a0load, CONST_INT(2));

    auto a1ptr = builder-> create_gep(aAlloca , {CONST_INT(0), CONST_INT(1)});
    builder->create_store(mulNum, a1ptr);

    auto a1load = builder->create_load(a1ptr);

    builder->create_store(a1load, retAlloca);

    auto retLoad = builder->create_load(retAlloca);
    builder-> create_ret(retLoad);
    std::cout << module->print();
    delete builder;
    delete module;
    return 0;

}