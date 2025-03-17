#include "cminusf_builder.hpp"

#define CONST_FP(num) ConstantFP::get((float)num, module.get())
#define CONST_INT(num) ConstantInt::get(num, module.get())
#define DEBUG
// types
Type *VOID_T;
Type *INT1_T;
Type *INT32_T;
Type *INT32PTR_T;
Type *FLOAT_T;
Type *FLOATPTR_T;



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
       context.return_val = (double)node.i_val;
       context.need_return_val = true;
      return  CONST_INT(node.i_val);
    }else if (node.type == TYPE_FLOAT) {
      context.return_val = node.f_val;
      context.need_return_val = true;
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
		  auto initializer = ConstantZero::get(INT32_T, module.get());
          var = GlobalVariable::create(node.id,module.get(),var_type,false ,initializer );
           }
          else if(var_type == FLOAT_T) {
             auto initializer = ConstantZero::get(FLOAT_T, module.get());
             var = GlobalVariable::create(node.id,module.get(),var_type,false ,initializer );
          } else {
            auto initializer = ConstantZero::get(VOID_T, module.get());
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
          var = GlobalVariable::create(node.id,module.get(),arr_type,false ,ConstantZero::get(var_type, module.get()) );
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

    auto if_counter = context.counter;
    auto conditionBB = BasicBlock::create(module.get(), "condition_"+ std::to_string(if_counter), context.func);
    auto bodyBB = BasicBlock::create(module.get(), "true_"+ std::to_string(if_counter), context.func);
    auto falseBB = BasicBlock::create(module.get(), "false_"+ std::to_string(if_counter), context.func);
    auto afterBB = BasicBlock::create(module.get(), "after_"+ std::to_string(if_counter), context.func);
	context.counter ++;

// TODO: 添加Additive 的 need_return_val的修改.
//    TODO:添加这边的icmp逻辑修改
    Value*  conditionvalue = node.expression->accept(*this);
    if (context.need_return_val) {
		auto return_val = context.return_val;
        conditionvalue = CONST_FP(return_val);
    }

    builder->create_br(conditionBB);
    builder->set_insert_point(conditionBB);
    // 修改成fcmp
    conditionvalue = convert(conditionvalue, INT32_T , builder.get());
    auto condition_bool = builder->create_icmp_ne(conditionvalue, CONST_INT(0));
    builder->create_cond_br(condition_bool , bodyBB, falseBB);

    builder->set_insert_point(bodyBB);
     node.if_statement->accept(*this);
//     if (context.need_return_val) {
//		auto return_val = context.return_val;
//        temp_value = CONST_FP(return_val);
//    }else conditionvalue = node.expression->accept(*this);
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
    context.in_iteration = true;
    auto conditionBB = BasicBlock::create(module.get(), "condition", context.func);
    auto bodyBB = BasicBlock::create(module.get(), "true", context.func);
    auto falseBB = BasicBlock::create(module.get(), "false", context.func);



	Value*  conditionvalue = node.expression->accept(*this);
    if (context.need_return_val) {
		auto return_val = context.return_val;
        conditionvalue = CONST_FP(return_val);
    }

    builder->create_br(conditionBB);
    builder->set_insert_point(conditionBB);

    conditionvalue = convert(conditionvalue, INT32_T , builder.get());
    auto condition_bool  = builder->create_icmp_ne(conditionvalue , CONST_INT(0));
    builder->create_cond_br(condition_bool, bodyBB, falseBB);

    builder->set_insert_point(bodyBB);
	if(node.statement){
     	node.statement->accept(*this);
    }
    builder->create_br(conditionBB);

    builder->set_insert_point(falseBB);

    context.in_iteration = false;
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
	//(gdb) print *var->get_type()
    //$1 = {tid_ = Type::PointerTyID, m_ = 0x55bb63a32a50}
    //(gdb) print *var->get_type()->get_pointer_element_type()
    //$2 = {tid_ = Type::ArrayTyID, m_ = 0x55bb63a32a50}
    //(gdb) print *var->get_type()->get_pointer_element_type()->get_array_element_type()
    //$3 = {tid_ = Type::IntegerTyID, m_ = 0x55bb63a32a50}

    //这里获得的是一个指针类型
    auto var = scope.find(node.id);
    if (var == nullptr) {
        std::cerr << "CminusfBuilder::visit: variable not found" << std::endl;
        return nullptr;
    }
    //单纯 普通变量
    if(node.expression == nullptr){
    	auto a = builder->create_load(var);
        context.need_return_val = false;
        return a ;
    }else {
      	// 浮点数index的变量
        auto neg_fun =  scope.find("neg_idx_except");
		//实际通过ASTNum 返回ConstantFP 或者 ConstantInt
        auto index = node.expression-> accept(*this);

        auto array_type = static_cast<ArrayType * >(var->get_type()->get_pointer_element_type());
        auto array_len =	array_type->get_num_of_elements();

        if(index->get_type()->is_float_type() ){
		  // run  testcases/lv1/negidx_float.cminus -emit-llvm
          // b /workspace/src/cminusfc/cminusf_builder.cpp:354
          // 考虑直接获得传入的index值,通过编译器将其化作int 类型, 然后通过CONST_INT直接获得对应的值.
          //double double_value =  (static_cast<ConstantFP*>(index))->get_value();
          //std::cerr << double_value << std::endl;
		 	//int convert_index = (int)(static_cast<ConstantFP*>(index))->get_value();

//			auto cast = convert(index , INT32_T , builder.get());
//			auto cast_value = (static_cast<ConstantInt*>(cast->get_type()))->get_value();

            auto calc_index = context.return_val;
			auto cast_index_value = CONST_INT(((int)calc_index));

            #ifdef DEBUG
            	std::cerr << "CminusfBuilder::visit: ASTVar calc_index "<< calc_index << std::endl;
            #endif

			if(calc_index < 0 ) {
					std::cerr << "CminusfBuilder::visit: negative index < 0 " << std::endl;
					std::cerr << "value "<< calc_index<< " len " << array_len<< std::endl;

	    	 		builder->create_call(neg_fun,{});
					return CONST_INT(0);


             }else if(calc_index> (double)array_len ) {
	    			builder->create_call(neg_fun,{});
					std::cerr << "CminusfBuilder::visit: negative index > len " << std::endl;
					std::cerr << "value "<< calc_index<< " len " << array_len<< std::endl;
					return CONST_INT(0);
             }
        	else {
            auto var_index = builder->create_gep(var, {CONST_INT(0), cast_index_value});
            auto ret_value = builder->create_load(var_index);
            context.need_return_val = false;
            return ret_value;
        	}
        }else {
          //
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
            context.need_return_val = false;
            return ret_value;
        	}
		}
    }
    return nullptr;
}

Value* CminusfBuilder::visit(ASTAssignExpression &node) {
    // TODO: This function is empty now.
    // Add some code here.
    // 得到[void, int,  float,] *
    auto id_find_var = scope.find(node.var->id);
    if (!id_find_var) {
    std::cerr << "CminusfBuilder::visit: id_find_var is not find" << std::endl;
    std::abort();
	}
    if (! id_find_var->get_type()->is_pointer_type()) {
      std::cerr << "CminusfBuilder::visit: id_find_var is not pointer" << std::endl;
      std::abort();
    }

    auto expression = node.expression->accept(*this);
    if (!context.in_iteration) {
	    if (context.need_return_val ) {
            auto ret_val = context.return_val;
        	expression = CONST_FP(ret_val);
	    }
    }

	Value*  store_ptr = nullptr;
//这里可以添加其他判断内容. 大概率会需要
    Value* convert_value = nullptr;
    auto need_type = id_find_var->get_type()->get_pointer_element_type();
    if (need_type->is_array_type()) {
		convert_value = convert(expression, need_type->get_array_element_type() , builder.get());
        auto index = node.var->expression-> accept(*this);
		store_ptr = builder->create_gep(id_find_var, {CONST_INT(0), index});
    }else{
		convert_value = convert(expression, need_type , builder.get());
		store_ptr = id_find_var;
    }


    if (!convert_value) {
      std::cerr << "CminusfBuilder::visit: convert failed" << std::endl;
    std::abort();
	}
    auto ret_var = builder->create_store(convert_value, store_ptr);


    return ret_var;
}

Value* CminusfBuilder::visit(ASTSimpleExpression &node) {
    // Add some code here.
    if(node.additive_expression_r ==nullptr){
        auto ret_value = node.additive_expression_l->accept(*this);
      if(context.need_return_val){
      		double ret_num ;
        if (ret_value->get_type()->is_float_type()){
			ret_num = context.return_val;
			return CONST_FP(ret_num);
        }else{
          	ret_num = context.return_val;
            return CONST_INT((int)ret_num);
        }
      }else return ret_value;
    }else {
        node.additive_expression_l -> accept(*this);
        auto l_val = context.return_val;
//        if (l_type-> is_int1_type() ) {
//         	l_val = builder->create_zext(l_val , INT32_T) ;
//            l_type = l_val->get_type();
//        }

        node.additive_expression_r -> accept(*this);
        auto r_val = context.return_val;

        switch (node.op) {
                  // <=
            case OP_LE: {
              	double ret_val = l_val <= r_val;
                context.return_val = ret_val;
				#ifdef DEBUG
                std::cerr << "CminusfBuilder::visit: "<<l_val<<" <= "<<r_val << std::endl;
                #endif
                context.need_return_val = false;
                return builder->create_fcmp_le (CONST_FP(l_val),CONST_FP(r_val));
            }
            	// <
            case OP_LT:{
                double ret_val = l_val < r_val;
                context.return_val = ret_val;
                #ifdef DEBUG
                std::cerr << "CminusfBuilder::visit: "<<l_val<<" < "<<r_val << std::endl;
                #endif
                context.need_return_val = false;
                return builder->create_fcmp_lt(CONST_FP(l_val),CONST_FP(r_val));
            }
             	// >
            case OP_GT:{
                double ret_val = l_val > r_val;
                context.return_val = ret_val;
                #ifdef DEBUG
                std::cerr << "CminusfBuilder::visit: "<<l_val<<" > "<<r_val << std::endl;
                #endif
                context.need_return_val = false;
                return builder->create_fcmp_gt(CONST_FP(l_val),CONST_FP(r_val));
            }
             	// >=
            case OP_GE:{
                double ret_val = l_val >= r_val;
                context.return_val = ret_val;
                #ifdef DEBUG
                std::cerr << "CminusfBuilder::visit: "<<l_val<<" >= "<<r_val << std::endl;
                #endif
                context.need_return_val = false;
                return builder->create_fcmp_ge (CONST_FP(l_val),CONST_FP(r_val));
            }
            	// ==
            case OP_EQ:{
                double ret_val = l_val == r_val;
                context.return_val = ret_val;
                #ifdef DEBUG
                std::cerr << "CminusfBuilder::visit: "<<l_val<<" == "<<r_val << std::endl;
                #endif
                context.need_return_val = false;
                return builder->create_fcmp_eq (CONST_FP(l_val),CONST_FP(r_val));
            }
             	// !=
            case OP_NEQ:{
                double ret_val = l_val != r_val;
                context.return_val = ret_val;
                #ifdef DEBUG
                std::cerr << "CminusfBuilder::visit: "<<l_val<<" != "<<r_val << std::endl;
                #endif
                context.need_return_val = false;
                return builder->create_fcmp_ne (CONST_FP(l_val),CONST_FP(r_val));
            }
        }
	}

    return nullptr;
}
//通过添加context变为编译期计算. 实属无奈啊. 痛苦,基类向子类的转化太痛了 . 有隐患
//TODO: 存放的return_val 说实在有点小,可能会爆,要不要考虑添加基础库改成类似python呢?
Value* CminusfBuilder::visit(ASTAdditiveExpression &node) {
    // TODO: This function is empty now.
    // Add some code here.
    if (node.additive_expression == nullptr){
      auto ret_value = node.term->accept(*this);
      if(context.need_return_val){
      		double ret_num ;
        if (ret_value->get_type()->is_float_type()){
			ret_num = context.return_val;
			return CONST_FP(ret_num);
        }else{
          	ret_num = context.return_val;
            return CONST_INT((int)ret_num);
        }
      }else return ret_value;
    }else {
      auto l_val_value = node.additive_expression->accept(*this);
      auto l_type = l_val_value->get_type();
      double l_val_float ;
      if (context.need_return_val){
      	l_val_float =context.return_val;
        l_val_value = CONST_FP(l_val_float);
      }

      auto r_val_value = node.term->accept(*this);
      auto r_type = r_val_value->get_type();
	  double r_val_float ;
	  if (context.need_return_val){
      	r_val_float =context.return_val;
        r_val_value = CONST_FP(r_val_float);
      }

      if (node.op == OP_PLUS){
        if(l_type->is_float_type() && r_type->is_float_type()){
          	auto ret_val = l_val_float+r_val_float;
            std::cerr << l_val_float<<" + "<< r_val_float <<" = "<< ret_val<< std::endl;
            context.return_val = ret_val;
            context.need_return_val = false;
            return builder->create_fadd(l_val_value,r_val_value);
        }
        else if (l_type->is_int32_type() && r_type->is_int32_type()){
          	auto ret_val = (int)l_val_float +(int)r_val_float;
            std::cerr << l_val_float <<" + "<< r_val_float <<" = "<< ret_val<< std::endl;
 			context.return_val = (double)ret_val;
            context.need_return_val = false;
            return builder->create_iadd(l_val_value,r_val_value);
        }
        else if (l_type->is_float_type() && r_type->is_int32_type()){
          	auto ret_val = l_val_float +r_val_float;
			std::cerr << l_val_float <<" + "<< r_val_float <<" = "<< ret_val<< std::endl;
			context.return_val = ret_val;
            context.need_return_val = false;
            return builder->create_fadd(l_val_value,r_val_value);
        }
        else if (l_type->is_int32_type() && r_type->is_float_type()){
         	auto ret_val = l_val_float +r_val_float;
			std::cerr << l_val_float <<" + "<< r_val_float <<" = "<< ret_val<< std::endl;
			context.return_val = ret_val;
            context.need_return_val = false;
            return builder->create_fadd(l_val_value,r_val_value);
        }
      }else {
    	 if(l_type->is_float_type() && r_type->is_float_type()){
          	auto ret_val = l_val_float-r_val_float;
            std::cerr << l_val_float<<" - "<< r_val_float <<" = "<< ret_val<< std::endl;
            context.return_val = ret_val;
            context.need_return_val = false;
            return builder->create_fadd(l_val_value,r_val_value);
        }
        else if (l_type->is_int32_type() && r_type->is_int32_type()){
            auto ret_val = (int)l_val_float -(int)r_val_float;
            std::cerr << l_val_float <<" - "<< r_val_float <<" = "<< ret_val<< std::endl;
			context.return_val = (double)ret_val;
            context.need_return_val = false;
            return builder->create_iadd(l_val_value,r_val_value);
        }
        else if (l_type->is_float_type() && r_type->is_int32_type()){
          	auto ret_val = l_val_float-r_val_float;
			std::cerr << l_val_float<<" - "<< r_val_float <<" = "<< ret_val<< std::endl;
			context.return_val = ret_val;
            context.need_return_val = false;
            return builder->create_fadd(l_val_value,r_val_value);
        }
        else if (l_type->is_int32_type() && r_type->is_float_type()){
         	auto ret_val = (double)l_val_float -r_val_float;
	        std::cerr << l_val_float <<" - "<< r_val_float <<" = "<< ret_val<< std::endl;
			context.return_val = ret_val;
            context.need_return_val = false;
            return builder->create_fadd(l_val_value,r_val_value);
        }
      }
    }
    return nullptr;
}

Value* CminusfBuilder::visit(ASTTerm &node) {
    // TODO: This function is empty now.
    // Add some code here.
    if (node.term == nullptr){
		auto ret_value = node.factor->accept(*this);
      if(context.need_return_val){
      		double ret_num ;
        if (ret_value->get_type()->is_float_type()){
			ret_num = context.return_val;
			return CONST_FP(ret_num);
        }else{
          	ret_num = context.return_val;

            return CONST_INT((int)ret_num);
        }
      }else return ret_value;
    }else {
        auto l_val = node.term->accept(*this);
      	auto l_type = l_val->get_type();
       	double l_val_float ;
     	l_val_float =context.return_val;

      auto r_val = node.factor->accept(*this);
      auto r_type = r_val->get_type();
      double r_val_float ;
      r_val_float =context.return_val;

      if (node.op == OP_MUL){
        if(l_type->is_float_type() && r_type->is_float_type()){
          	auto ret_val = l_val_float*r_val_float;
            std::cerr << l_val_float<<" * "<< r_val_float <<" = "<< ret_val<< std::endl;
            context.return_val = ret_val;
            context.need_return_val = false;
            return CONST_FP(ret_val);
        }
        else if (l_type->is_int32_type() && r_type->is_int32_type()){
          auto ret_val = (int)l_val_float*(int)r_val_float;
		  std::cerr << l_val_float<<" * "<< r_val_float <<" = "<< ret_val<< std::endl;
          context.return_val = (double)ret_val;
            context.need_return_val = false;
            return CONST_INT(ret_val);
        }
        else if (l_type->is_float_type() && r_type->is_int32_type()){
          	auto ret_val = l_val_float*r_val_float;
			 std::cerr << l_val_float<<" * "<< r_val_float <<" = "<< ret_val<< std::endl;
			context.return_val = ret_val;
            context.need_return_val = false;
            return CONST_FP(ret_val);
        }
        else if (l_type->is_int32_type() && r_type->is_float_type()){
         	auto ret_val = l_val_float*r_val_float;
			std::cerr << l_val_float<<" * "<< r_val_float <<" = "<< ret_val<< std::endl;
			context.return_val = ret_val;
            context.need_return_val = false;
            return CONST_FP(ret_val);
        }
      }
      else {
       if(l_type->is_float_type() && r_type->is_float_type()){
          	auto ret_val = l_val_float/r_val_float;
  			std::cerr << l_val_float<<" / "<< r_val_float <<" = "<< ret_val<< std::endl;
			context.return_val = ret_val;
            context.need_return_val = false;
            return CONST_FP(ret_val);
        }
        else if (l_type->is_int32_type() && r_type->is_int32_type()){
          auto ret_val = (int)l_val_float/(int)r_val_float;
            std::cerr << (int)l_val_float<<" / "<< r_val_float <<" = "<< ret_val<< std::endl;

          context.return_val = (double)ret_val;
            context.need_return_val = false;
            return CONST_INT(ret_val);
        }
        else if (l_type->is_float_type() && r_type->is_int32_type()){
          	auto ret_val = l_val_float/ r_val_float;
		   std::cerr << l_val_float<<" / "<< r_val_float <<" = "<< ret_val<< std::endl;
			context.return_val = ret_val;
            context.need_return_val = false;
            return CONST_FP(ret_val);
        }
        else if (l_type->is_int32_type() && r_type->is_float_type()){
         	auto ret_val = l_val_float/r_val_float;
			std::cerr << l_val_float<<" / "<< r_val_float <<" = "<< ret_val<< std::endl;
			context.return_val = ret_val;
            context.need_return_val = false;
            return CONST_FP(ret_val);
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
	context.need_return_val = false;
    return a;
}
