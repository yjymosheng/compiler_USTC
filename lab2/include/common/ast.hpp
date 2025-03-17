#pragma once

extern "C" {
#include "syntax_tree.h"
extern syntax_tree *parse(const char *input);
}
#include "User.hpp"
#include <memory>
#include <string>
#include <vector>

enum CminusType { TYPE_INT, TYPE_FLOAT, TYPE_VOID };

enum RelOp {
    // <=
    OP_LE,
    // <
    OP_LT,
    // >
    OP_GT,
    // >=
    OP_GE,
    // ==
    OP_EQ,
    // !=
    OP_NEQ
};

enum AddOp {
    // +
    OP_PLUS,
    // -
    OP_MINUS
};

enum MulOp {
    // *
    OP_MUL,
    // /
    OP_DIV
};

class AST;

struct ASTNode;
struct ASTProgram;
struct ASTDeclaration;
struct ASTNum;
struct ASTVarDeclaration;
struct ASTFunDeclaration;
struct ASTParam;
struct ASTCompoundStmt;
struct ASTStatement;
struct ASTExpressionStmt;
struct ASTSelectionStmt;
struct ASTIterationStmt;
struct ASTReturnStmt;
struct ASTFactor;
struct ASTExpression;
struct ASTVar;
struct ASTAssignExpression;
struct ASTSimpleExpression;
struct ASTAdditiveExpression;
struct ASTTerm;
struct ASTCall;

class ASTVisitor;

class AST {
  public:
    AST() = delete;
    AST(syntax_tree *);
    AST(AST &&tree) {
        root = tree.root;
        tree.root = nullptr;
    };
    ASTProgram *get_root() { return root.get(); }
    void run_visitor(ASTVisitor &visitor);

  private:
    ASTNode *transform_node_iter(syntax_tree_node *);
    std::shared_ptr<ASTProgram> root = nullptr;
};

struct ASTNode {
    virtual Value *accept(ASTVisitor &) = 0;
    virtual ~ASTNode() = default;
};
//根节点, 保存所有的声明节点
struct ASTProgram : ASTNode {
    virtual Value *accept(ASTVisitor &) override final;
    virtual ~ASTProgram() = default;
    // 就是把token解析成多个declaration 罢了
    std::vector<std::shared_ptr<ASTDeclaration>> declarations;
};

// 保存 type + id ,做基类
struct ASTDeclaration : ASTNode {
    virtual ~ASTDeclaration() = default;
    CminusType type;
    std::string id;
};

struct ASTFactor : ASTNode {
    virtual ~ASTFactor() = default;
};

// 数字的类型+ 数值
struct ASTNum : ASTFactor {
    virtual Value *accept(ASTVisitor &) override final;
    CminusType type;
    union {
        int i_val;
        float f_val;
    };
};

// 变量声明节点 , 里面保存一个,数字?疑似是数组长度
struct ASTVarDeclaration : ASTDeclaration {
    virtual Value *accept(ASTVisitor &) override final;
    std::shared_ptr<ASTNum> num;
};

//函数声明节点 , 保留一个参数列表, 以及后续的compound-stmt
struct ASTFunDeclaration : ASTDeclaration {
    virtual Value *accept(ASTVisitor &) override final;
    std::vector<std::shared_ptr<ASTParam>> params;
    std::shared_ptr<ASTCompoundStmt> compound_stmt;
};

struct ASTParam : ASTNode {
    virtual Value *accept(ASTVisitor &) override final;
    CminusType type;
    std::string id;
    // true if it is array param
    bool isarray;
};

struct ASTStatement : ASTNode {
    virtual ~ASTStatement() = default;
};
// 语法规则的有关statement 的5种情况.复合语句, 选择,循环, 返回, 普通表达式
struct ASTCompoundStmt : ASTStatement {
    virtual Value *accept(ASTVisitor &) override final;
    std::vector<std::shared_ptr<ASTVarDeclaration>> local_declarations;
    std::vector<std::shared_ptr<ASTStatement>> statement_list;
};

struct ASTExpressionStmt : ASTStatement {
    virtual Value *accept(ASTVisitor &) override final;
    std::shared_ptr<ASTExpression> expression;
};

struct ASTSelectionStmt : ASTStatement {
    virtual Value *accept(ASTVisitor &) override final;
    std::shared_ptr<ASTExpression> expression;
    std::shared_ptr<ASTStatement> if_statement;
    // should be nullptr if no else structure exists
    std::shared_ptr<ASTStatement> else_statement;
};

struct ASTIterationStmt : ASTStatement {
    virtual Value *accept(ASTVisitor &) override final;
    std::shared_ptr<ASTExpression> expression;
    std::shared_ptr<ASTStatement> statement;
};

struct ASTReturnStmt : ASTStatement {
    virtual Value *accept(ASTVisitor &) override final;
    // should be nullptr if return void
    std::shared_ptr<ASTExpression> expression;
};

struct ASTExpression : ASTFactor {};

struct ASTAssignExpression : ASTExpression {
    virtual Value *accept(ASTVisitor &) override final;
    std::shared_ptr<ASTVar> var;
    std::shared_ptr<ASTExpression> expression;
};

struct ASTSimpleExpression : ASTExpression {
    virtual Value *accept(ASTVisitor &) override final;
    std::shared_ptr<ASTAdditiveExpression> additive_expression_l;
    std::shared_ptr<ASTAdditiveExpression> additive_expression_r;
    RelOp op;
};

struct ASTVar : ASTFactor {
    virtual Value *accept(ASTVisitor &) override final;
    std::string id;
    // nullptr if var is of int type
    //数组index
    std::shared_ptr<ASTExpression> expression;
};

struct ASTAdditiveExpression : ASTNode {
    virtual Value *accept(ASTVisitor &) override final;
    std::shared_ptr<ASTAdditiveExpression> additive_expression;
    AddOp op;
    std::shared_ptr<ASTTerm> term;
};

struct ASTTerm : ASTNode {
    virtual Value *accept(ASTVisitor &) override final;
    std::shared_ptr<ASTTerm> term;
    MulOp op;
    std::shared_ptr<ASTFactor> factor;
};

struct ASTCall : ASTFactor {
    virtual Value *accept(ASTVisitor &) override final;
    std::string id;
    std::vector<std::shared_ptr<ASTExpression>> args;
};

class ASTVisitor {
  public:
    virtual Value *visit(ASTProgram &) = 0;
    virtual Value *visit(ASTNum &) = 0;
    virtual Value *visit(ASTVarDeclaration &) = 0;
    virtual Value *visit(ASTFunDeclaration &) = 0;
    virtual Value *visit(ASTParam &) = 0;
    virtual Value *visit(ASTCompoundStmt &) = 0;
    virtual Value *visit(ASTExpressionStmt &) = 0;
    virtual Value *visit(ASTSelectionStmt &) = 0;
    virtual Value *visit(ASTIterationStmt &) = 0;
    virtual Value *visit(ASTReturnStmt &) = 0;
    virtual Value *visit(ASTAssignExpression &) = 0;
    virtual Value *visit(ASTSimpleExpression &) = 0;
    virtual Value *visit(ASTAdditiveExpression &) = 0;
    virtual Value *visit(ASTVar &) = 0;
    virtual Value *visit(ASTTerm &) = 0;
    virtual Value *visit(ASTCall &) = 0;
};

class ASTPrinter : public ASTVisitor {
  public:
    virtual Value *visit(ASTProgram &) override final;
    virtual Value *visit(ASTNum &) override final;
    virtual Value *visit(ASTVarDeclaration &) override final;
    virtual Value *visit(ASTFunDeclaration &) override final;
    virtual Value *visit(ASTParam &) override final;
    virtual Value *visit(ASTCompoundStmt &) override final;
    virtual Value *visit(ASTExpressionStmt &) override final;
    virtual Value *visit(ASTSelectionStmt &) override final;
    virtual Value *visit(ASTIterationStmt &) override final;
    virtual Value *visit(ASTReturnStmt &) override final;
    virtual Value *visit(ASTAssignExpression &) override final;
    virtual Value *visit(ASTSimpleExpression &) override final;
    virtual Value *visit(ASTAdditiveExpression &) override final;
    virtual Value *visit(ASTVar &) override final;
    virtual Value *visit(ASTTerm &) override final;
    virtual Value *visit(ASTCall &) override final;
    void add_depth() { depth += 2; }
    void remove_depth() { depth -= 2; }

  private:
    int depth = 0;
};
