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

  auto  Int32Type = module-> get_int32_type();
  auto  FloatType = module-> get_float_type();

  auto mainFun = Function::create(FunctionType::get(Int32Type,{}),"main",module);
  auto bb = BasicBlock::create(module, "entry", mainFun);
  builder -> set_insert_point(bb);

  auto retAlloca = builder->create_alloca(Int32Type);

  auto aAlloca = builder->create_alloca(FloatType);
  builder->create_store(CONST_FP(5.555), aAlloca);
  auto aload = builder->create_load(aAlloca);

  auto bAlloca = builder->create_alloca(FloatType);
  builder->create_store(CONST_FP(1.0), bAlloca);
  auto bload = builder->create_load(bAlloca);

  auto cmpbool = builder->create_fcmp_gt(aload, bload);



  auto trueBB = BasicBlock::create(module, "trueBB", mainFun);
  auto falseBB = BasicBlock::create(module, "falseBB", mainFun);

  auto retBB = BasicBlock::create(module, "", mainFun);

  builder->create_cond_br(cmpbool, trueBB, falseBB);


  builder->set_insert_point(trueBB);
  builder->create_store(CONST_INT(233), retAlloca);
  builder -> create_br(retBB);

  builder->set_insert_point(falseBB);
  builder->create_store(CONST_INT(0), retAlloca);
  builder -> create_br(retBB);


  builder->set_insert_point(retBB);
  auto retload = builder->create_load(retAlloca);
  builder->create_ret(retload);


  std::cout <<module->print();
  delete builder;
  delete module;
  return 0 ;
}