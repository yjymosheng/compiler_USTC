%option noyywrap
%{
/*****************声明和选项设置  begin*****************/
#include <stdio.h>
#include <stdlib.h>

#include "syntax_tree.h"
#include "syntax_analyzer.h"

int lines;
int pos_start;
int pos_end;


void pass_node(char *text){
     yylval.node = new_syntax_tree_node(text);
}

/*****************声明和选项设置  end*****************/

%}

ID                       [a-zA-Z]+
INTEGER                  [0-9]+
FLOATPOINT               ([0-9]+\.)|([0-9]*\.[0-9]+)

%%
 /* to do for students */
 /* two cases for you, pass_node will send flex's token to bison */

"void" 	{pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return VOID;}
"int"  {pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return INT;}
"float"  {pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return FLOAT;}
"return" 	{pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return RETURN;}
"while" 	{pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return WHILE;}
"if"	{pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return IF;}
"else" 	{pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return ELSE;}

"+" {pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return ADD;}
"-" {pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return SUB;}
"*" {pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return TIMES;}
"/" {pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return CHUFA;}
"<" 	{pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return LESS;}
"<=" 	{pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return LESSEQ;}
">" 	{pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return MORE;}
">="	{pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return MOREEQ;}
"==" 	{pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return EQEQ;}
"!=" 	{pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return UNEQ;}
"=" 	{pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return EQ;}
"," 	{pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return DOUHAO;}
";" {pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return SEMICOLON;}
"(" {pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return LPAREN;}
")" {pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return RPAREN;}
"["  	{pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return LMIDPAREN;}
"]" 	{pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return RMIDPAREN;}
"{" {pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return LBIGPAREN;}
"}" {pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return RBIGPAREN;}

{ID}   { pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return ID; }
{INTEGER} { pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return INTEGER; }
{FLOATPOINT}  { pos_start = pos_end; pos_end += yyleng; pass_node(yytext); return FLOATPOINT; }

[ \t\r]+  { pos_start = pos_end; pos_end += yyleng; }
\n|\r|\r\n {pos_start = 0 ; pos_end = 0 ; lines ++; }

((\/\*)([^*]|\*+[^*/])*(\*)+(\/)) { pos_start = pos_end; pos_end += yyleng;}

. {pos_start = pos_end; pos_end++; return ERROR; }



 /****请在此补全所有flex的模式与动作  end******/
%%
