#include "cminusf_builder.hpp"

#define CONST_FP(num) ConstantFP::get((float)num, module.get())
#define CONST_INT(num) ConstantInt::get(num, module.get())
#define DEBUG 0
// types
Type *VOID_T;
Type *INT1_T;
Type *INT32_T;
Type *INT32PTR_T;
Type *FLOAT_T;
Type *FLOATPTR_T;

//Value* convert(Value* val , Type* target_type ,IRBuilder * builder ){
//    //类型相同返回
//    if (val -> get_type() == target_type){
//        return  val;
//    }
//
//    // float 类型
//    if (val->get_type()->is_float_type()){
//        if (target_type->is_int32_type()) {
//            return builder->create_fptosi(val , INT32_T);
//        }else {
//            std::cerr << "Convert target_type not support"<<"  ";
//            std::cerr << "Convert val_type is float"<<std::endl;
//            std::abort();
//        }
//    }
//    // int32 类型
//    else if (val->get_type()->is_int32_type()) {
//        if (target_type->is_float_type()) {
//            return builder->create_sitofp(val , FLOAT_T);
//        }else {
//            std::cerr << "Convert target_type not support"<<"  ";
//            std::cerr << "Convert val_type is int32"<<std::endl;
//            std::abort();
//        }
//    }
//    // bool类型
//    else if (val->get_type()->is_int1_type()) {
//        if (target_type->is_float_type()) {
//            auto val_int32_value = builder-> create_zext(val , INT32_T);
//            return builder->create_sitofp(val_int32_value , FLOAT_T);
//        }else if (target_type->is_int32_type()) {
//            return builder-> create_zext(val , INT32_T);
//        }else {
//            std::cerr << "Convert target_type not support"<<"  ";
//            std::cerr << "Convert val_type is int32"<<std::endl;
//            std::abort();
//        }
//    }else {
//        std::cerr << "Convert val_type not support"<<std::endl;
//        std::abort();
//    }
//
//}

/*
 * use CMinusfBuilder::Scope to construct scopes
 * scope.enter: enter a new scope
 * scope.exit: exit current scope
 * scope.push: add a new binding to current scope
 * scope.find: find and return the value bound to the name
 */

Value *CminusfBuilder::visit(ASTProgram &node)
{
    VOID_T = module->get_void_type();
    INT1_T = module->get_int1_type();
    INT32_T = module->get_int32_type();
    INT32PTR_T = module->get_int32_ptr_type();
    FLOAT_T = module->get_float_type();
    FLOATPTR_T = module->get_float_ptr_type();

    Value *ret_val = nullptr;
    for (auto &decl : node.declarations)
    {
        ret_val = decl->accept(*this);
    }
    return ret_val;
}

Value *CminusfBuilder::visit(ASTNum &node)
{
    // TODO: This function is empty now.
    // Add some code here.
    if (node.type == TYPE_INT)
    {
        context.value_type = TYPE_INT;
        context.value_value = CONST_INT(node.i_val);
        context.valint = node.i_val;
    }
    else if (node.type == TYPE_FLOAT)
    {
        context.value_type = TYPE_FLOAT;
        context.value_value = CONST_FP(node.f_val);
    }
    else
    {
        context.value_type = TYPE_VOID;
        context.value_value = nullptr;
    }
    return nullptr;
}

Value *CminusfBuilder::visit(ASTVarDeclaration &node)
{
    // TODO: This function is empty now.
    // Add some code here.
    Type *type = nullptr;
    if (node.type == TYPE_INT)
    {
        type = INT32_T;
    }
    else if (node.type == TYPE_FLOAT)
    {
        type = FLOAT_T;
    }
    if (not scope.in_global())
    {
        if (node.num == nullptr)
        {

            auto alloca_value = (type != nullptr) ? builder->create_alloca(type) : nullptr;
            scope.push(node.id, alloca_value);
        }
        else
        {
            node.num->accept(*this);
            if (context.valint <= 0)
                builder->create_call(scope.find("neg_idx_except"), std::vector<Value *>{});
            auto arrytype = ArrayType::get(type, context.valint);
            auto arryAllca = builder->create_alloca(arrytype);
            scope.push(node.id, arryAllca);
        }
    }
    else
    {
        auto initializer = ConstantZero::get(INT32_T, builder->get_module());
        if (node.num == nullptr)
        {

            auto alloca_value = (type != nullptr) ? GlobalVariable::create(node.id, builder->get_module(), type, false, initializer) : nullptr;
            scope.push(node.id, alloca_value);
        }
        else
        {
            node.num->accept(*this);
            if (context.valint <= 0)
                builder->create_call(scope.find("neg_idx_except"), std::vector<Value *>{});
            auto arrytype = ArrayType::get(type, context.valint);
            auto arryAllca = GlobalVariable::create(node.id, builder->get_module(), arrytype, false, initializer);
            scope.push(node.id, arryAllca);
        }
    }
    return nullptr;
}

Value *CminusfBuilder::visit(ASTFunDeclaration &node)
{
    FunctionType *fun_type;
    Type *ret_type;
    std::vector<Type *> param_types;
    std::vector<std::string> param_id;
    if (node.type == TYPE_INT)
        ret_type = INT32_T;
    else if (node.type == TYPE_FLOAT)
        ret_type = FLOAT_T;
    else
        ret_type = VOID_T;

    for (auto &param : node.params)
    {
        // TODO: Please accomplish param_types.
        param->accept(*this);
        param_types.push_back(context.param_type);
        param_id.push_back(context.param_id);
    }

    fun_type = FunctionType::get(ret_type, param_types);
    auto func = Function::create(fun_type, node.id, builder->get_module());
    //
    scope.push(node.id, func);
    context.func = func;
    auto funBB = BasicBlock::create(builder->get_module(), "entry" + std::to_string(context.counter++), func);
    builder->set_insert_point(funBB);
    scope.enter();
    std::vector<Value *> args;
    for (auto &arg : func->get_args())
    {
        args.push_back(&arg);
    }
    for (size_t i = 0; i < node.params.size(); ++i)
    {
        // TODO: You need to deal with params and store them in the scope.
        auto argAlloca = builder->create_alloca(args[i]->get_type());
        builder->create_store(args[i], argAlloca);
        scope.push(param_id[i], argAlloca);
    }
    node.compound_stmt->accept(*this);
    if (not builder->get_insert_block()->is_terminated())
    {
        if (context.func->get_return_type()->is_void_type())
            builder->create_void_ret();
        else if (context.func->get_return_type()->is_float_type())
            builder->create_ret(CONST_FP(0.));
        else
            builder->create_ret(CONST_INT(0));
    }
    scope.exit();
    return nullptr;
}

Value *CminusfBuilder::visit(ASTParam &node)
{
    // TODO: This function is empty now.
    // Add some code here.
    context.param_id=node.id;
    if (node.isarray)
    {
        if (node.type == TYPE_INT)
        {
            context.param_type = PointerType::get(INT32_T);
        }
        else if (node.type == TYPE_FLOAT)
        {
            context.param_type = PointerType::get(FLOAT_T);
        }
        else
        {
            context.param_type = PointerType::get(VOID_T);
        }
    }
    else
    {
        if (node.type == TYPE_INT)
        {
            context.param_type = INT32_T;
        }
        else if (node.type == TYPE_FLOAT)
        {
            context.param_type = FLOAT_T;
        }
        else
        {
            context.param_type = VOID_T;
        }
    }
    return nullptr;
}

Value *CminusfBuilder::visit(ASTCompoundStmt &node)
{
    // TODO: This function is not complete.
    // You may need to add some code here
    // to deal with complex statements.
    scope.enter();
    for (auto &decl : node.local_declarations)
    {

        decl->accept(*this);
    }
    for (auto &stmt : node.statement_list)
    {
        stmt->accept(*this);
        if (builder->get_insert_block()->is_terminated())
            break;
    }
    scope.exit();
    return nullptr;
}

Value *CminusfBuilder::visit(ASTExpressionStmt &node)
{
    // TODO: This function is empty now.
    // Add some code here.
    scope.enter();
    if (node.expression)
    {
        node.expression->accept(*this);
    }
    scope.exit();
    return nullptr;
}

Value *CminusfBuilder::visit(ASTSelectionStmt &node)
{
    // TODO: This function is empty now.
    // Add some code here.
    scope.enter();
    BasicBlock *nextBB = BasicBlock::create(builder->get_module(), "nextBB" + std::to_string(context.counter++), context.func);
    BasicBlock *trueBB = nullptr;
    BasicBlock *falseBB = nullptr;
    Value *cmp = nullptr;
    if (node.expression)
    {
        node.expression->accept(*this);
    }
    if (context.value_type == TYPE_INT)
    {
        cmp = builder->create_icmp_gt(context.value_value, CONST_INT(0));
    }
    else if (context.value_type == TYPE_FLOAT)
    {
        cmp = builder->create_fcmp_gt(context.value_value, CONST_FP(0));
    }
    if (node.if_statement)
    {
        trueBB = BasicBlock::create(builder->get_module(), "trueBB" + std::to_string(context.counter++), context.func);
        if (node.else_statement)
            falseBB = BasicBlock::create(builder->get_module(), "falseBB" + std::to_string(context.counter++), context.func);
        else
            falseBB = nextBB;
        builder->create_cond_br(cmp, trueBB, falseBB);
        builder->set_insert_point(trueBB);
        scope.enter();
        node.if_statement->accept(*this);
        if (not builder->get_insert_block()->is_terminated()) builder->create_br(nextBB);
        scope.exit();
    }
    if (node.else_statement)
    {
        builder->set_insert_point(falseBB);
        scope.enter();
        node.else_statement->accept(*this);
        if (not builder->get_insert_block()->is_terminated()) builder->create_br(nextBB);
        scope.exit();
    }
    scope.exit();
    builder->set_insert_point(nextBB);
    return nullptr;
}

Value *CminusfBuilder::visit(ASTIterationStmt &node)
{
    // TODO: This function is empty now.
    // Add some code here.
    scope.enter();
    BasicBlock *nextBB = BasicBlock::create(builder->get_module(), "nextBB" + std::to_string(context.counter++), context.func);
    BasicBlock *cmpBB = BasicBlock::create(builder->get_module(), "cmpBB" + std::to_string(context.counter++), context.func);
    BasicBlock *whileBB = BasicBlock::create(builder->get_module(), "whileBB" + std::to_string(context.counter++), context.func);
    Value *cmp = nullptr;
    builder->create_br(cmpBB);
    builder->set_insert_point(cmpBB);
    scope.enter();
    if (node.expression)
    {
        node.expression->accept(*this);
    }
    if (context.value_type == TYPE_INT)
    {
        cmp = builder->create_icmp_gt(context.value_value, CONST_INT(0));
    }
    else if (context.value_type == TYPE_FLOAT)
    {
        cmp = builder->create_fcmp_gt(context.value_value, CONST_FP(0));
    }
    builder->create_cond_br(cmp, whileBB, nextBB);
    scope.exit();
    builder->set_insert_point(whileBB);
    scope.enter();
    node.statement->accept(*this);
    if (not builder->get_insert_block()->is_terminated()) builder->create_br(cmpBB);
    scope.exit();
    scope.exit();
    builder->set_insert_point(nextBB);
    return nullptr;
}

Value *CminusfBuilder::visit(ASTReturnStmt &node)
{
    scope.enter();
    if (node.expression == nullptr)
    {
        builder->create_void_ret();
        return nullptr;
    }
    else
    {
        // TODO: The given code is incomplete.
        // You need to solve other return cases (e.g. return an integer).
        if (node.expression)
        {
            node.expression->accept(*this);
        }
        Type* return_type = context.func->get_return_type();
        if(return_type->is_float_type()&&context.value_type!=TYPE_FLOAT){
            context.value_value = builder->create_sitofp(context.value_value,FLOAT_T);
            context.value_type = TYPE_FLOAT;
        }
        else if(return_type->is_int32_type()&&context.value_type!=TYPE_INT){
            context.value_value = builder->create_fptosi(context.value_value,INT32_T);
            context.value_type = TYPE_INT;
        }
        builder->create_ret(context.value_value);
    }
    scope.exit();
    return nullptr;
}

Value *CminusfBuilder::visit(ASTVar &node)
{
    // TODO: This function is empty now.
    // Add some code here.
    if (node.expression == nullptr)
    {
        context.value_ptr = scope.find(node.id);
        if (context.value_ptr->get_type()->get_pointer_element_type()->is_array_type())
        {
            context.value_ptr = builder->create_gep(context.value_ptr, {CONST_INT(0),CONST_INT(0)});
        }
        else if(context.value_ptr->get_type()->get_pointer_element_type()->is_pointer_type()){
            context.value_ptr = builder->create_load(context.value_ptr);
        }
        else
        {
            if (context.value_ptr->get_type()->get_pointer_element_type()->is_int32_type())
            {
                context.value_value = builder->create_load(context.value_ptr);
                context.value_type = TYPE_INT;
            }
            else if (context.value_ptr->get_type()->get_pointer_element_type()->is_float_type())
            {
                context.value_value = builder->create_load(context.value_ptr);
                context.value_type = TYPE_FLOAT;
            }
        }
    }
    else
    {
        if (node.expression)
        {
            node.expression->accept(*this);
        }
        Value *baseAddr = scope.find(node.id);
        auto nextBB = BasicBlock::create(builder->get_module(), "nextBB" + std::to_string(context.counter++), context.func);
        auto negBB = BasicBlock::create(builder->get_module(), "negBB" + std::to_string(context.counter++), context.func);
        if (context.value_type == TYPE_FLOAT)
        {
            FCmpInst *Fcmp = builder->create_fcmp_ge(context.value_value, CONST_FP(0));
            builder->create_cond_br(Fcmp, nextBB, negBB);
        }
        if (context.value_type == TYPE_INT)
        {
            ICmpInst *Icmp = builder->create_icmp_ge(context.value_value, CONST_INT(0));
            builder->create_cond_br(Icmp, nextBB, negBB);
        }
        builder->set_insert_point(negBB);
        builder->create_call(scope.find("neg_idx_except"), std::vector<Value *>{});
        builder->create_br(nextBB);
        builder->set_insert_point(nextBB);
        if (context.value_type == TYPE_FLOAT)
        {
            context.value_value = builder->create_fptosi(context.value_value, INT32_T);
            context.value_type = TYPE_INT;
        }
        if(baseAddr->get_type()->get_pointer_element_type()->is_array_type()){
        context.value_ptr = builder->create_gep(baseAddr, {CONST_INT(0), context.value_value});}
        else {
            context.value_ptr = builder->create_load(baseAddr);
            context.value_ptr = builder->create_gep(context.value_ptr,{context.value_value});
        }
        if (context.value_ptr->get_type()->get_pointer_element_type()->is_int32_type())
        {
            context.value_value = builder->create_load(context.value_ptr);
            context.value_type = TYPE_INT;
        }
        else if (context.value_ptr->get_type()->get_pointer_element_type()->is_float_type())
        {
            context.value_value = builder->create_load(context.value_ptr);
            context.value_type = TYPE_FLOAT;
        }
    }
    return nullptr;
}

Value *CminusfBuilder::visit(ASTAssignExpression &node)
{
    // TODO: This function is empty now.
    // Add some code here.
    node.var->accept(*this);
    Value* store_ptr = context.value_ptr;
    if (node.expression)
    {
        node.expression->accept(*this);
    }
    Type *eleType = store_ptr->get_type()->get_pointer_element_type();
    if (eleType->is_int32_type() && context.value_type != TYPE_INT)
    {
        context.value_value = builder->create_fptosi(context.value_value, INT32_T);
        context.value_type = TYPE_INT;
        builder->create_store(context.value_value, store_ptr);
    }
    else if (eleType->is_float_type() && context.value_type != TYPE_FLOAT)
    {
        context.value_value = builder->create_sitofp(context.value_value, FLOAT_T);
        context.value_type = TYPE_FLOAT;
        builder->create_store(context.value_value, store_ptr);
    }
    else
    {
        builder->create_store(context.value_value, store_ptr);
    }
    return nullptr;
}

Value *CminusfBuilder::visit(ASTSimpleExpression &node)
{
    // TODO: This function is empty now.
    // Add some code here.
    Value *l_value = nullptr, *r_value = nullptr, *expression_compare_value = nullptr;
    bool l_type = 0, r_type = 0;
    if (node.additive_expression_r != nullptr)
    {
        node.additive_expression_l->accept(*this);
        l_value = context.value_value;
        if (context.value_type == TYPE_INT)
        {
            l_type = 0;
        }
        else if (context.value_type == TYPE_FLOAT)
        {
            l_type = 1;
        }
        context.value_type = TYPE_VOID;
        node.additive_expression_r->accept(*this);
        r_value = context.value_value;
        if (context.value_type == TYPE_INT)
        {
            r_type = 0;
        }
        else if (context.value_type == TYPE_FLOAT)
        {
            r_type = 1;
        }
        context.value_type = TYPE_INT;
        if (l_type == false && r_type == false)
        {
            switch (node.op)
            {
            case OP_LE:
            {
                expression_compare_value = builder->create_icmp_le(l_value, r_value);
                context.value_value = builder->create_zext(expression_compare_value, INT32_T);
                break;
            }
            case OP_LT:
            {
                expression_compare_value = builder->create_icmp_lt(l_value, r_value);
                context.value_value = builder->create_zext(expression_compare_value, INT32_T);
                break;
            }
            case OP_GT:
            {
                expression_compare_value = builder->create_icmp_gt(l_value, r_value);
                context.value_value = builder->create_zext(expression_compare_value, INT32_T);
                break;
            }
            case OP_GE:
            {
                expression_compare_value = builder->create_icmp_ge(l_value, r_value);
                context.value_value = builder->create_zext(expression_compare_value, INT32_T);
                break;
            }
            case OP_EQ:
            {
                expression_compare_value = builder->create_icmp_eq(l_value, r_value);
                context.value_value = builder->create_zext(expression_compare_value, INT32_T);
                break;
            }
            case OP_NEQ:
            {
                expression_compare_value = builder->create_icmp_ne(l_value, r_value);
                context.value_value = builder->create_zext(expression_compare_value, INT32_T);
                break;
            }
            default:
            {
                break;
            }
            }
        }
        else
        {
            l_value = (l_type == false) ? builder->create_sitofp(l_value, FLOAT_T) : l_value;
            r_value = (r_type == false) ? builder->create_sitofp(r_value, FLOAT_T) : r_value;
            switch (node.op)
            {
            case OP_LE:
            {
                expression_compare_value = builder->create_fcmp_le(l_value, r_value);
                context.value_value = builder->create_zext(expression_compare_value, INT32_T);
                break;
            }
            case OP_LT:
            {
                expression_compare_value = builder->create_fcmp_lt(l_value, r_value);
                context.value_value = builder->create_zext(expression_compare_value, INT32_T);
                break;
            }
            case OP_GT:
            {
                expression_compare_value = builder->create_fcmp_gt(l_value, r_value);
                context.value_value = builder->create_zext(expression_compare_value, INT32_T);
                break;
            }
            case OP_GE:
            {
                expression_compare_value = builder->create_fcmp_ge(l_value, r_value);
                context.value_value = builder->create_zext(expression_compare_value, INT32_T);
                break;
            }
            case OP_EQ:
            {
                expression_compare_value = builder->create_fcmp_eq(l_value, r_value);
                context.value_value = builder->create_zext(expression_compare_value, INT32_T);
                break;
            }
            case OP_NEQ:
            {
                expression_compare_value = builder->create_fcmp_ne(l_value, r_value);
                context.value_value = builder->create_zext(expression_compare_value, INT32_T);
                break;
            }
            default:
            {
                break;
            }
            }
        }
    }
    else
    {
        node.additive_expression_l->accept(*this);
    }
    return nullptr;
}

Value *CminusfBuilder::visit(ASTAdditiveExpression &node)
{
    // TODO: This function is empty now.
    // Add some code here.
    Value *l_value = nullptr, *r_value = nullptr;
    bool l_type = 0, r_type = 0;
    if (node.additive_expression != nullptr)
    {
        node.additive_expression->accept(*this);
        l_value = context.value_value;
        if (context.value_type == TYPE_INT)
        {
            l_type = 0;
        }
        else if (context.value_type == TYPE_FLOAT)
        {
            l_type = 1;
        }
        context.value_type = TYPE_VOID;
        node.term->accept(*this);
        r_value = context.value_value;
        if (context.value_type == TYPE_INT)
        {
            r_type = 0;
        }
        else if (context.value_type == TYPE_FLOAT)
        {
            r_type = 1;
        }
        context.value_type = TYPE_VOID;
        if (l_type == false && r_type == false)
        {
            switch (node.op)
            {
            case OP_PLUS:
            {
                context.value_value = builder->create_iadd(l_value, r_value);
                break;
            }
            case OP_MINUS:
            {
                context.value_value = builder->create_isub(l_value, r_value);
                break;
            }
            }
            context.value_type = TYPE_INT;
        }
        else
        {
            l_value = (l_type == false) ? builder->create_sitofp(l_value, FLOAT_T) : l_value;
            r_value = (r_type == false) ? builder->create_sitofp(r_value, FLOAT_T) : r_value;
            switch (node.op)
            {
            case OP_PLUS:
            {
                context.value_value = builder->create_fadd(l_value, r_value);
                break;
            }
            case OP_MINUS:
            {
                context.value_value = builder->create_fsub(l_value, r_value);
                break;
            }
            }
            context.value_type = TYPE_FLOAT;
        }
    }
    else
    {
        node.term->accept(*this);
    }
    return nullptr;
}

Value *CminusfBuilder::visit(ASTTerm &node)
{
    // TODO: This function is empty now.
    // Add some code here.
    Value *l_value = nullptr, *r_value = nullptr;
    bool l_type = 0, r_type = 0;
    if (node.term != nullptr)
    {
        node.term->accept(*this);
        l_value = context.value_value;
        if (context.value_type == TYPE_INT)
        {
            l_type = 0;
        }
        else if (context.value_type == TYPE_FLOAT)
        {
            l_type = 1;
        }
        context.value_type = TYPE_VOID;
        node.factor->accept(*this);
        r_value = context.value_value;
        if (context.value_type == TYPE_INT)
        {
            r_type = 0;
        }
        else if (context.value_type == TYPE_FLOAT)
        {
            r_type = 1;
        }
        context.value_type = TYPE_VOID;
        if (l_type == false && r_type == false)
        {
            switch (node.op)
            {
            case OP_MUL:
            {
                context.value_value = builder->create_imul(l_value, r_value);
                break;
            }
            case OP_DIV:
            {
                context.value_value = builder->create_isdiv(l_value, r_value);
                break;
            }
            }
            context.value_type = TYPE_INT;
        }
        else
        {
            l_value = (l_type == false) ? builder->create_sitofp(l_value, FLOAT_T) : l_value;
            r_value = (r_type == false) ? builder->create_sitofp(r_value, FLOAT_T) : r_value;
            switch (node.op)
            {
            case OP_MUL:
            {
                context.value_value = builder->create_fmul(l_value, r_value);
                break;
            }
            case OP_DIV:
            {
                context.value_value = builder->create_fdiv(l_value, r_value);
                break;
            }
            }
            context.value_type = TYPE_FLOAT;
        }
    }
    else
    {
        node.factor->accept(*this);
    }
    return nullptr;
}

Value *CminusfBuilder::visit(ASTCall &node)
{
    // TODO: This function is empty now.
    // Add some code here.
    std::vector<Value *> function_args;
    Function *function_value = dynamic_cast<Function *>(scope.find(node.id));
    Type *arg_type = nullptr;
    int i = 0;
    for (auto &arg : node.args)
    {
        arg->accept(*this);
        arg_type = function_value->get_function_type()->get_param_type(i);
        if (arg_type->is_pointer_type())
        {
            function_args.push_back(context.value_ptr);
        }
        else
        {
            if (arg_type->is_float_type() && context.value_type != TYPE_FLOAT)
            {
                auto temp_value = builder->create_sitofp(context.value_value, FLOAT_T);
                function_args.push_back(temp_value);
            }
            else if (arg_type->is_integer_type() && context.value_type != TYPE_INT)
            {
                auto temp_value = builder->create_fptosi(context.value_value, INT32_T);
                function_args.push_back(temp_value);
            }
            else
            {
                function_args.push_back(context.value_value);
            }
        }
        i++;
    }
    auto return_type = function_value->get_return_type();
    context.value_value = builder->create_call(function_value, function_args);
    if (return_type->is_float_type())
    {
        context.value_type = TYPE_FLOAT;
    }
    else if (return_type->is_int32_type())
    {
        context.value_type = TYPE_INT;
    }
    else {
        context.value_type = TYPE_VOID;
    }
    return nullptr;
}
