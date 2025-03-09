#pragma once

extern "C" {
#include "syntax_tree.h"
extern syntax_tree *parse(const char *input);
}
#include <memory>
#include <vector>

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

class CalcAST;

struct CalcASTNode;
struct CalcASTInput;
struct CalcASTExpression;
struct CalcASTNum;
struct CalcASTTerm;
struct CalcASTFactor;

class CalcASTVisitor;

class CalcAST {
  public:
    CalcAST() = delete;
    CalcAST(syntax_tree *);
    //此处利用c++ 的右值引用,其实就是移动临时值的绑定罢了
    CalcAST(CalcAST &&tree) {
        root = tree.root;
        tree.root = nullptr;
    }
    CalcASTInput *get_root() { return root.get(); }
    void run_visitor(CalcASTVisitor &visitor);

  private:
//    成员函数 , 似乎是用来把语法树解析成node
    CalcASTNode *transform_node_iter(syntax_tree_node *);
    std::shared_ptr<CalcASTInput> root = nullptr;
};

//定义一个基类,用来给后面实现继承
struct CalcASTNode {
    virtual void accept(CalcASTVisitor &) = 0;
    virtual ~CalcASTNode() = default;
};

struct CalcASTInput : CalcASTNode {
    virtual void accept(CalcASTVisitor &) override final;
    std::shared_ptr<CalcASTExpression> expression;
};

struct CalcASTFactor : CalcASTNode {
    virtual void accept(CalcASTVisitor &) override;
};

struct CalcASTNum : CalcASTFactor {
    virtual void accept(CalcASTVisitor &) override final;
    int val;
};

struct CalcASTExpression : CalcASTFactor {
    virtual void accept(CalcASTVisitor &) override final;
    std::shared_ptr<CalcASTExpression> expression;
    AddOp op;
    std::shared_ptr<CalcASTTerm> term;
};

struct CalcASTTerm : CalcASTNode {
    virtual void accept(CalcASTVisitor &) override final;
    std::shared_ptr<CalcASTTerm> term;
    MulOp op;
    std::shared_ptr<CalcASTFactor> factor;
};

class CalcASTVisitor {
  public:
    virtual void visit(CalcASTInput &) = 0;
    virtual void visit(CalcASTNum &) = 0;
    virtual void visit(CalcASTExpression &) = 0;
    virtual void visit(CalcASTTerm &) = 0;
};
