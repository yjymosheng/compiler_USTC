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
    auto builder = new IRBuilder(nullptr , module );
    auto* Int32Type  = module-> get_int32_type();

    std::vector<Type *> Ints(1, Int32Type);
    auto calleeFunTy = FunctionType::get(Int32Type, Ints);

    auto calleeFun = Function::create(calleeFunTy, "callee", module);
    auto bb = BasicBlock::create(module, "entry", calleeFun);
    builder->set_insert_point(bb);

    auto retAlloca = builder->create_alloca(Int32Type);
    auto aAlloca = builder->create_alloca(Int32Type);
    std::vector<Value *> args;
    for (auto &arg: calleeFun->get_args()) {
        args.push_back(&arg);
    }
    builder->create_store(args[0], aAlloca);
    auto aLoad = builder->create_load(aAlloca);
    auto mulNum = builder->create_imul(CONST_INT(2), aLoad );
    builder->create_store(mulNum ,retAlloca);
    auto retLoad = builder->create_load(retAlloca);

    builder->create_ret(retLoad);

    auto mainFun = Function::create(FunctionType::get(Int32Type,{}), "main", module);
    bb = BasicBlock::create(module, "entry", mainFun);
    builder->set_insert_point(bb);
    retAlloca = builder->create_alloca(Int32Type);

    builder->create_store(CONST_INT(0), retAlloca);
    aAlloca = builder->create_alloca(Int32Type);
    builder->create_store(CONST_INT(110), aAlloca);
    auto paramLoad = builder->create_load(aAlloca);

    auto call = builder-> create_call(calleeFun,{paramLoad});

    builder->create_ret(call);
    std::cout<< module->print();
    delete builder;
    delete module;

    return 0;
}
