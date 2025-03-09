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

int main() {
    auto module = new Module();
    auto builder = new IRBuilder(nullptr, module);
    auto Int32Type = module-> get_int32_type();

    auto mainFun = Function::create(FunctionType::get(Int32Type,{}),"main",module);
    auto bb = BasicBlock::create(module, "entry", mainFun);
    builder -> set_insert_point(bb);

    auto retAlloca = builder->create_alloca(Int32Type);
    auto aAlloca = builder->create_alloca(Int32Type);
    auto iAlloca = builder->create_alloca(Int32Type);

    builder->create_store(CONST_INT(10), aAlloca);
    builder->create_store(CONST_INT(0), iAlloca);
    auto whileBB = BasicBlock::create(module, "while", mainFun);
	builder->create_br(whileBB);

    builder -> set_insert_point(whileBB);
    auto iload = builder->create_load(iAlloca);
    auto cmp = builder->create_icmp_lt(iload, CONST_INT(10));

    auto trueBB = BasicBlock::create(module, "true", mainFun);
    auto falseBB = BasicBlock::create(module, "false", mainFun);

    builder->create_cond_br(cmp , trueBB ,falseBB );

    builder->set_insert_point(trueBB);
    iload = builder->create_load(iAlloca);
    auto aLoad = builder->create_load(aAlloca);
    auto new_i = builder-> create_iadd(CONST_INT(1), iload);
    builder->create_store(new_i, iAlloca);
    iload = builder->create_load(iAlloca);
    auto new_a = builder-> create_iadd(aLoad, iload);
    builder->create_store(new_a, aAlloca);
    builder->create_br(whileBB);


    builder->set_insert_point(falseBB);
    aLoad = builder->create_load(aAlloca);
    builder->create_store(aLoad, retAlloca);
    auto retLoad = builder->create_load(retAlloca);
    builder -> create_ret(retLoad);


    std::cout<< module->print();

    delete builder;
    delete module;
    return 0;
}
