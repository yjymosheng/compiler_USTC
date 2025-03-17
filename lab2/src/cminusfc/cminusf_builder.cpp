#include "cminusf_builder.hpp"

#define CONST_FP(num) ConstantFP::get((float)num, module.get())
#define CONST_INT(num) ConstantInt::get(num, module.get())

// types
Type *VOID_T;
Type *INT1_T;
Type *INT32_T;
Type *INT32PTR_T;
Type *FLOAT_T;
Type *FLOATPTR_T;

Value * convert(Value * value , Type* target_type, IRBuilder *  builder ){

	if (value->get_type()->is_int32_type() ){
          if (target_type->is_float_type() ){
            return builder->create_sitofp(value , FLOAT_T);
          }
	}else if (value->get_type()->is_float_type() ){
          if (target_type->is_int32_type() ){
            return builder->create_fptosi(value , INT32_T);
          }
	}else if (value->get_type()->is_int1_type() ){
          if (target_type->is_int32_type() ){
            return builder->create_zext(value , INT32_T);
          }else if (target_type->is_float_type() ){
            auto tmp = builder->create_zext(value , INT32_T);
            return builder->create_sitofp(tmp , FLOAT_T);
          }
	}else {
			bool flag = value->get_type()->is_int1_type();
          std::cerr<< flag << "unsupported type" << std::endl;
          return nullptr;
          std::abort();
	}
        return nullptr;
}

/*
 * use CMinusfBuilder::Scope to construct scopes
 * scope.enter: enter a new scope
 * scope.exit: exit current scope
 * scope.push: add a new binding to current scope
 * scope.find: find and return the value bound to the name
 */

Value* CminusfBuilder::visit(ASTProgram &node) {
    VOID_T = module->get_void_type();
    INT1_T = module->get_int1_type();
    INT32_T = module->get_int32_type();
    INT32PTR_T = module->get_int32_ptr_type();
    FLOAT_T = module->get_float_type();
    FLOATPTR_T = module->get_float_ptr_type();

    Value *ret_val = nullptr;
    for (auto &decl : node.declarations) {
        ret_val = decl->accept(*this);
    }
    return ret_val;
}

Value* CminusfBuilder::visit(ASTNum &node) {
    // TODO: This function is empty now.
    // Add some code here.
     if (node.type == TYPE_INT ) {
      return  CONST_INT(node.i_val);
    }else if (node.type == TYPE_FLOAT) {
      return CONST_FP(node.f_val);
    }
    return nullptr;
}

Value* CminusfBuilder::visit(ASTVarDeclaration &node) {
    // TODO: This function is empty now.
    // Add some code here.
    Type* var_type = nullptr ;
    if (node.type == TYPE_INT ) {
      var_type = INT32_T;
    }else if (node.type == TYPE_FLOAT) {
      var_type = FLOAT_T;
    }else var_type = VOID_T;

    Value*  var = nullptr ;
    if (node.num == nullptr){
        if(scope.in_global()){
          if (var_type == INT32_T){
		  auto initializer = ConstantZero::get(INT32_T, module);
          var = GlobalVariable::create(node.id,module.get(),var_type,false ,initializer );
           }
          else if(var_type == FLOAT_T) {
             auto initializer = ConstantZero::get(FLOAT_T, module);
             var = GlobalVariable::create(node.id,module.get(),var_type,false ,initializer );
          } else {
            auto initializer = ConstantZero::get(VOID_T, module);
            var = GlobalVariable::create(node.id,module.get(),var_type,false ,initializer );
          }
        }
        else {
          var = builder->create_alloca(var_type);
        }
    }else {
        if (node.num->type == TYPE_FLOAT) {
          auto neg_fun =  scope.find("neg_idx_except" );
          builder->create_call(neg_fun,{});
          return nullptr;
        }
        int  size = node.num->i_val;
        auto arr_type = ArrayType::get(var_type , size);
        if(scope.in_global()){
          var = GlobalVariable::create(node.id,module.get(),arr_type,false ,ConstantZero::get(arr_type, module.get()) );
        }
        else {
          var = builder->create_alloca(arr_type);
        }
    }

    scope.push(node.id , var);

    return var;
}

Value* CminusfBuilder::visit(ASTFunDeclaration &node) {
    FunctionType *fun_type;
    Type *ret_type;
    std::vector<Type *> param_types;
    if (node.type == TYPE_INT)
        ret_type = INT32_T;
    else if (node.type == TYPE_FLOAT)
        ret_type = FLOAT_T;
    else
        ret_type = VOID_T;


    // 这里实际上是进行 普通语言到IR的类型转化
    for (auto &param : node.params) {
        // TODO: Please accomplish param_types.
        if (param->type == TYPE_INT){
          	param_types.push_back(INT32_T);
        }else if (param->type == TYPE_FLOAT){
          	param_types.push_back(FLOAT_T);
        } else {
          param_types.push_back(VOID_T);
        }

    }

    fun_type = FunctionType::get(ret_type, param_types);
    auto func = Function::create(fun_type, node.id, module.get());
    scope.push(node.id, func);
    context.func = func;
    auto funBB = BasicBlock::create(module.get(), "entry", func);
    builder->set_insert_point(funBB);
    scope.enter();
    std::vector<Value *> args;
    for (auto &arg : func->get_args()) {
        args.push_back(&arg);
    }
    for (size_t i = 0; i < node.params.size(); ++i) {
        // TODO: You need to deal with params and store them in the scope.
		scope.push(node.params.at(i)->id, args[i]);
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

Value* CminusfBuilder::visit(ASTParam &node) {
    // Add some code here.
    Type *param_type;

    // 1. 确定基本类型
    if (node.type == TYPE_INT) {
        param_type = INT32_T;
    } else if (node.type == TYPE_FLOAT) {
        param_type = FLOAT_T;
    } else {
        param_type = VOID_T;
    }

    // 2. 处理数组参数
    if (node.isarray) {
        param_type = PointerType::get(param_type);
    }

    // 3. 生成参数变量（在 visit(ASTFunDeclaration) 里实际存储）
    auto param_var = builder->create_alloca(param_type);
    scope.push(node.id, param_var);

    return param_var;
}

Value* CminusfBuilder::visit(ASTCompoundStmt &node) {
    // TODO: This function is not complete.
    // You may need to add some code here
    // to deal with complex statements.
    for (auto &decl : node.local_declarations) {
        decl->accept(*this);
    }

    for (auto &stmt : node.statement_list) {
        stmt->accept(*this);
        if (builder->get_insert_block()->is_terminated())
            break;
    }
    return nullptr;
}

Value* CminusfBuilder::visit(ASTExpressionStmt &node) {
    // TODO: This function is empty now.
    // Add some code here.
       if (node.expression == nullptr) {
    return nullptr;
}else {
    auto a = node.expression->accept(*this);
    return a;
}
    return nullptr;
}

Value* CminusfBuilder::visit(ASTSelectionStmt &node) {
    // TODO: This function is empty now.
    // Add some code here.
    auto conditionBB = BasicBlock::create(module.get(), "condition", context.func);
    auto bodyBB = BasicBlock::create(module.get(), "true", context.func);
    auto falseBB = BasicBlock::create(module.get(), "false", context.func);
    auto afterBB = BasicBlock::create(module.get(), "after", context.func);


    auto conditionvalue = node.expression->accept(*this);
    builder->create_br(conditionBB);

    builder->set_insert_point(conditionBB);
    auto condition_bool = builder->create_icmp_ne(conditionvalue, CONST_INT(0));
    builder->create_cond_br(condition_bool , bodyBB, falseBB);

    builder->set_insert_point(bodyBB);
     node.if_statement->accept(*this);
    builder->create_br(afterBB);

    builder->set_insert_point(falseBB);
    if(node.else_statement){
     node.else_statement->accept(*this);
    }
    builder->create_br(afterBB);

    builder->set_insert_point(afterBB);


    return nullptr;
}

Value* CminusfBuilder::visit(ASTIterationStmt &node) {
    // TODO: This function is empty now.
    // Add some code here.
    auto conditionBB = BasicBlock::create(module.get(), "condition", context.func);
    auto bodyBB = BasicBlock::create(module.get(), "true", context.func);
    auto falseBB = BasicBlock::create(module.get(), "false", context.func);

    builder->create_br(conditionBB);
    builder->set_insert_point(conditionBB);
    auto a = node.expression->accept(*this);
    auto condition  = builder->create_icmp_ne(a , CONST_INT(0));
    builder->create_cond_br(condition, bodyBB, falseBB);

    builder->set_insert_point(bodyBB);
   node.statement->accept(*this);
    builder->create_br(conditionBB);

    builder->set_insert_point(falseBB);

    return nullptr;
}

Value* CminusfBuilder::visit(ASTReturnStmt &node) {
    if (node.expression == nullptr) {
        builder->create_void_ret();
        return nullptr;
    } else {
        // TODO: The given code is incomplete.
        // You need to solve other return cases (e.g. return an integer).
        auto ret_type = context.func->get_return_type();
	    auto expression_value  = node.expression->accept(*this);

		if (ret_type->is_float_type() ) {
                  if (expression_value->get_type()->is_int32_type()) {
						expression_value = builder->create_sitofp(expression_value,FLOAT_T);
                  }else if (expression_value->get_type()->is_int1_type()) {
                    	expression_value = builder->create_zext(expression_value,INT32_T);
						expression_value = builder->create_sitofp(expression_value,FLOAT_T);
                  }
		}else if (ret_type->is_int32_type()  ) {
            if(expression_value->get_type()->is_float_type()) {
				expression_value = builder->create_fptosi(expression_value,INT32_T);
            }else if (expression_value->get_type()->is_int1_type()) {
                    	expression_value = builder->create_zext(expression_value,INT32_T);
                  }
		}

		return builder->create_ret(expression_value);

    }
    return nullptr;
}

Value* CminusfBuilder::visit(ASTVar &node) {
    // TODO: This function is empty now.
    // Add some code here.
    auto var = scope.find(node.id);
    if (var == nullptr) {
        std::cerr << "CminusfBuilder::visit: variable not found" << std::endl;
        return nullptr;
    }
    if(node.expression == nullptr){
    	auto a = builder->create_load(var);
        return a ;
    }else {
        auto index = node.expression-> accept(*this);
        auto neg_fun =  scope.find("neg_idx_except");
        // TODO:这个转换也是错的.根本原因是define有问题,这个晚点再来考虑吧
        auto array_type = static_cast<ArrayType * >(var->get_type());
        auto array_len =	array_type->get_num_of_elements();
        if(index->get_type()->is_float_type() ){
          //TODO:问题在于这个static_cast的内容会出问题. 根本数据不对.这个转换崩溃了
          //TODO:实在不行考虑通过builder来创建吧
          auto convert_value = convert(index , INT32_T , builder.get());
          auto cast = static_cast<ConstantInt *>(convert_value);
			if((unsigned int )cast->get_value() < 0 ) {
					std::cerr << "CminusfBuilder::visit: negative index overflow" << std::endl;
	    	 		builder->create_call(neg_fun,{});
                                       return CONST_INT(0);

             }else if((unsigned int )cast->get_value() > array_len ) {
	    			builder->create_call(neg_fun,{});
					std::cerr << "CminusfBuilder::visit: negative index overflow" << std::endl;
                                       return CONST_INT(0);
             }
        	else {
            auto var_index = builder->create_gep(var, {CONST_INT(0), cast});
            auto ret_value = builder->create_load(var_index);
            return ret_value;
        	}
        }else {
             auto   cast = static_cast<ConstantInt *>(index);
              if(cast->get_value() < 0 ) {
	    	 		builder->create_call(neg_fun,{});
                                                          std::cerr << "CminusfBuilder::visit: negative index overflow" << std::endl;

                                       return CONST_INT(0);

             }else if((unsigned int )cast->get_value() > array_len ) {
	    			builder->create_call(neg_fun,{});
                                std::cerr << "CminusfBuilder::visit: negative index overflow" << std::endl;
                                       return CONST_INT(0);
             }
        	else {
            auto var_index = builder->create_gep(var, {CONST_INT(0), index});
            auto ret_value = builder->create_load(var_index);
            return ret_value;
        	}
		}
    }
    return nullptr;
}

Value* CminusfBuilder::visit(ASTAssignExpression &node) {
    // TODO: This function is empty now.
    // Add some code here.
    auto id_find_var = node.var->accept(*this);
        // 确保 id_find_var 是指针
    if (!id_find_var->get_type()->is_pointer_type()) {
        id_find_var = builder->create_alloca(id_find_var->get_type());
    }

    auto expression = node.expression->accept(*this);
    if (!expression) {
        std::cerr << "CminusfBuilder::visit: expression is null" << std::endl;
        std::abort();
    }

    // 存储值
    auto ret_var = builder->create_store(expression, id_find_var);
//    if (!id_find_var) {
//    std::cerr << "CminusfBuilder::visit: id_find_var is null" << std::endl;
//    std::abort();
//	}
//
//    auto expression = node.expression->accept(*this);
////	auto var_ptr = builder-> create_alloca(id_find_var->get_type());
//
////这里可以添加其他判断内容. 大概率会需要
//	auto convert_value = convert(expression, id_find_var->get_type() , builder.get());
//    auto ret_var = builder->create_store(convert_value, id_find_var);


    return ret_var;
}

Value* CminusfBuilder::visit(ASTSimpleExpression &node) {
    // Add some code here.
    if(node.additive_expression_r ==nullptr){
        auto a = node.additive_expression_l -> accept(*this);
        return a ;
    }else {
        auto l_val  = node.additive_expression_l -> accept(*this);
        auto l_type = l_val->get_type();
        if (l_type-> is_int1_type() ) {
         	l_val = builder->create_zext(l_val , INT32_T) ;
            l_type = l_val->get_type();
        }
        auto r_val  = node.additive_expression_r -> accept(*this);
        auto r_type = r_val->get_type();
        if (r_type-> is_int1_type() ) {
         	r_val = builder->create_zext(r_val , INT32_T) ;
            r_type = r_val->get_type();
        }
        RelOp op  = node.op ;

        if (l_type->is_float_type() && r_type->is_float_type()){
            if (op ==  OP_LE) {
              return builder->create_fcmp_le(l_val, r_val);
            }
            else if (op ==  OP_LT) {return builder->create_fcmp_lt(l_val, r_val);}
            else if (op ==  OP_GT) {return builder->create_fcmp_gt(l_val, r_val);}
            else if (op ==  OP_GE) {return builder->create_fcmp_ge(l_val, r_val);}
            else if (op ==  OP_EQ) {return builder->create_fcmp_eq(l_val, r_val);}
            else if (op ==  OP_NEQ) {return builder->create_fcmp_ne(l_val, r_val);}
 }else if (l_type->is_int32_type() && r_type->is_int32_type()){
                     if (op ==  OP_LE) {
                          return builder->create_icmp_le(l_val, r_val);
                        }
                        else if (op ==  OP_LT) {return builder->create_icmp_lt(l_val, r_val);}
                        else if (op ==  OP_GT) {return builder->create_icmp_gt(l_val, r_val);}
                        else if (op ==  OP_GE) {return builder->create_icmp_ge(l_val, r_val);}
                        else if (op ==  OP_EQ) {return builder->create_icmp_eq(l_val, r_val);}
                        else if (op ==  OP_NEQ) {return builder->create_icmp_ne(l_val, r_val);}
 }else if (l_type->is_float_type() && r_type->is_int32_type()){
                   auto r_new_val =  builder->create_sitofp(r_val,FLOAT_T);
                if (op ==  OP_LE) {
                          return builder->create_fcmp_le(l_val, r_new_val);
                        }
                        else if (op ==  OP_LT) {return builder->create_fcmp_lt(l_val, r_new_val);}
                        else if (op ==  OP_GT) {return builder->create_fcmp_gt(l_val, r_new_val);}
                        else if (op ==  OP_GE) {return builder->create_fcmp_ge(l_val, r_new_val);}
                        else if (op ==  OP_EQ) {return builder->create_fcmp_eq(l_val, r_new_val);}
                        else if (op ==  OP_NEQ) {return builder->create_fcmp_ne(l_val, r_new_val);}
 }else if (l_type->is_int32_type() && r_type->is_float_type()){
            auto l_new_val =  builder->create_sitofp(l_val,FLOAT_T);
            if (op ==  OP_LE) {
                   return builder->create_fcmp_le(l_new_val, r_val);
                 }
                 else if (op ==  OP_LT) {return builder->create_fcmp_lt(l_new_val, r_val);}
                 else if (op ==  OP_GT) {return builder->create_fcmp_gt(l_new_val, r_val);}
                 else if (op ==  OP_GE) {return builder->create_fcmp_ge(l_new_val, r_val);}
                 else if (op ==  OP_EQ) {return builder->create_fcmp_eq(l_new_val, r_val);}
                 else if (op ==  OP_NEQ) {return builder->create_fcmp_ne(l_new_val, r_val);}
}}
    return nullptr;
}

Value* CminusfBuilder::visit(ASTAdditiveExpression &node) {
    // TODO: This function is empty now.
    // Add some code here.
    if (node.additive_expression == nullptr){
      return node.term->accept(*this);
    }else {
        auto l_val = node.additive_expression->accept(*this);
      auto l_type = l_val->get_type();
      auto r_val = node.term->accept(*this);
      auto r_type = r_val->get_type();
      if (node.op == OP_PLUS){
        if(l_type->is_float_type() && r_type->is_float_type()){
            return builder->create_fadd(l_val, r_val);
        }
        else if (l_type->is_int32_type() && r_type->is_int32_type()){
          return builder->create_iadd(l_val, r_val);
        }
        else if (l_type->is_float_type() && r_type->is_int32_type()){
          auto r_new_val = builder->create_sitofp(r_val,FLOAT_T);
          return builder->create_fadd(l_val, r_new_val);
        }
        else if (l_type->is_int32_type() && r_type->is_float_type()){
          auto l_new_val = builder->create_sitofp(l_val,FLOAT_T);
          return builder->create_fadd(l_new_val, r_val);
        }
      }else {
    	if(l_type->is_float_type() && r_type->is_float_type()){
            return builder->create_fsub(l_val, r_val);
        }
        else if (l_type->is_int32_type() && r_type->is_int32_type()){
          return builder->create_isub(l_val, r_val);
        }
        else if (l_type->is_float_type() && r_type->is_int32_type()){
          auto r_new_val = builder->create_sitofp(r_val,FLOAT_T);
          return builder->create_fsub(l_val, r_new_val);
        }
        else if (l_type->is_int32_type() && r_type->is_float_type()){
          auto l_new_val = builder->create_sitofp(l_val,FLOAT_T);
          return builder->create_fsub(l_new_val, r_val);
        }
      }
    }
    return nullptr;
}

Value* CminusfBuilder::visit(ASTTerm &node) {
    // TODO: This function is empty now.
    // Add some code here.
    if (node.term == nullptr){
      return node.factor->accept(*this);
    }else {
        auto l_val = node.term->accept(*this);
      auto l_type = l_val->get_type();
      auto r_val = node.factor->accept(*this);
      auto r_type = r_val->get_type();
      if (node.op == OP_MUL){
        if(l_type->is_float_type() && r_type->is_float_type()){
            return builder->create_fmul(l_val, r_val);
        }
        else if (l_type->is_int32_type() && r_type->is_int32_type()){
          return builder->create_imul(l_val, r_val);
        }
        else if (l_type->is_float_type() && r_type->is_int32_type()){
          auto r_new_val = builder->create_sitofp(r_val,FLOAT_T);
          return builder->create_fmul(l_val, r_new_val);
        }
        else if (l_type->is_int32_type() && r_type->is_float_type()){
          auto l_new_val = builder->create_sitofp(l_val,FLOAT_T);
          return builder->create_fmul(l_new_val, r_val);
        }
      }
      else {
        if(l_type->is_float_type() && r_type->is_float_type()){
            return builder->create_fdiv(l_val, r_val);
        }
        else if (l_type->is_int32_type() && r_type->is_int32_type()){
          return builder->create_isdiv(l_val, r_val);
        }
        else if (l_type->is_float_type() && r_type->is_int32_type()){
          auto r_new_val = builder->create_sitofp(r_val,FLOAT_T);
          return builder->create_fdiv(l_val, r_new_val);
        }
        else if (l_type->is_int32_type() && r_type->is_float_type()){
          auto l_new_val = builder->create_sitofp(l_val,FLOAT_T);
          return builder->create_fdiv(l_new_val, r_val);
        }
      }
    }
    return nullptr;
}

Value* CminusfBuilder::visit(ASTCall &node) {
    // TODO: This function is empty now.
    // Add some code here.
    auto function = scope.find(node.id);
    if (function == nullptr) {
        std::cerr << "CminusfBuilder::visit: function not found" << std::endl;
        return nullptr;
    }

    auto function_args = static_cast<FunctionType *>(function->get_type());
	auto call_args = node.args ;



    auto function_need_len = function_args->get_num_of_args();
	auto call_args_len = call_args.size();

    if (function_need_len != call_args_len) {
      std::cerr << "ASTCall::visit: function args number not equal" << std::endl;
      std::abort();
        return nullptr;
    }

     std::vector<Value *> args;


    for (size_t i =0 ;i<call_args_len ; i++){
       if (call_args[i] == nullptr) {
        // 这里记录调用栈信息，方便调试
        std::cerr << "Error: call_args[" << i << "] is nullptr" << std::endl;
        std::abort(); // 可以跳过该参数或进行其他错误处理
    	}

      	auto call_arg_value = call_args[i]->accept(*this);

        if (call_arg_value == nullptr) {
        // 这里记录调用栈信息，方便调试
        std::cerr << "Error: call_arg_value is nullptr  "<< i  << std::endl;
        std::abort(); // 可以跳过该参数或进行其他错误处理
    	}

		if(function_args->get_param_type(i)== call_arg_value->get_type()){
			args.push_back(call_arg_value);
		}else {
			auto convert_arg_value = convert( call_arg_value , function_args->get_param_type(i) ,builder.get());
			args.push_back(convert_arg_value);
		}
    }

    auto a = builder->create_call(function, args);

    return a;
}
