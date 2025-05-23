#include "calc_builder.hpp"
#include <memory>
std::unique_ptr<Module> CalcBuilder::build(CalcAST &ast) {
  //创建自己这个类的module , builder
    module = std::unique_ptr<Module>(new Module());
    builder = std::make_unique<IRBuilder>(nullptr, module.get());

//    获得一个空类型 ,一个int32 类型
    auto TyVoid = module->get_void_type();
    TyInt32 = module->get_int32_type();
    std::vector<Type *> output_params;
    output_params.push_back(TyInt32);
    auto output_type = FunctionType::get(TyVoid, output_params);
    auto output_fun = Function::create(output_type, "output", module.get());
    auto main =
        Function::create(FunctionType::get(TyInt32, {}), "main", module.get());
    auto bb = BasicBlock::create(module.get(), "entry", main);
    builder->set_insert_point(bb);
    ast.run_visitor(*this);
    builder->create_call(output_fun, {val});
    builder->create_ret(ConstantInt::get(0, module.get()));
    return std::move(module);
}
void CalcBuilder::visit(CalcASTInput &node) { node.expression->accept(*this); }
void CalcBuilder::visit(CalcASTExpression &node) {
    if (node.expression == nullptr) {
        node.term->accept(*this);
    } else {
        node.expression->accept(*this);
        auto l_val = val;
        node.term->accept(*this);
        auto r_val = val;
        switch (node.op) {
        case OP_PLUS:
            val = builder->create_iadd(l_val, r_val);
            break;
        case OP_MINUS:
            val = builder->create_isub(l_val, r_val);
            break;
        }
    }
}

void CalcBuilder::visit(CalcASTTerm &node) {
    if (node.term == nullptr) {
        node.factor->accept(*this);
    } else {
        node.term->accept(*this);
        auto l_val = val;
        node.factor->accept(*this);
        auto r_val = val;
        switch (node.op) {
        case OP_MUL:
            val = builder->create_imul(l_val, r_val);
            break;
        case OP_DIV:
            val = builder->create_isdiv(l_val, r_val);
            break;
        }
    }
}

void CalcBuilder::visit(CalcASTNum &node) {
    val = ConstantInt::get(node.val, module.get());
}
