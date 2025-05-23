# Global variables
	.text
	.section .bss, "aw", @nobits
	.globl n
	.type n, @object
	.size n, 4
n:
	.space 4
	.globl m
	.type m, @object
	.size m, 4
m:
	.space 4
	.globl w
	.type w, @object
	.size w, 20
w:
	.space 20
	.globl v
	.type v, @object
	.size v, 20
v:
	.space 20
	.globl dp
	.type dp, @object
	.size dp, 264
dp:
	.space 264
	.text
	.globl max
	.type max, @function
max:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -80
	st.w $a0, $fp, -20
	st.w $a1, $fp, -24
.max_label_entry0:
# %op2 = alloca i32
	addi.d $t1, $fp, -36
	st.d $t1, $fp, -32
# store i32 %arg0, i32* %op2
	ld.d $t0, $fp, -32
	ld.w $t1, $fp, -20
	st.w $t1, $t0, 0
# %op3 = alloca i32
	addi.d $t1, $fp, -52
	st.d $t1, $fp, -48
# store i32 %arg1, i32* %op3
	ld.d $t0, $fp, -48
	ld.w $t1, $fp, -24
	st.w $t1, $t0, 0
# %op4 = load i32, i32* %op2
	ld.d $t0, $fp, -32
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -56
# %op5 = load i32, i32* %op3
	ld.d $t0, $fp, -48
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -60
# %op6 = icmp sgt i32 %op4, %op5
	ld.w $t0, $fp, -56
	ld.w $t1, $fp, -60
	slt $t0, $t1, $t0
	st.b $t0, $fp, -61
# %op7 = zext i1 %op6 to i32
	ld.b $t0, $fp, -61
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -68
# %op8 = icmp sgt i32 %op7, 0
	ld.w $t0, $fp, -68
	addi.w $t1, $zero, 0
	slt $t0, $t1, $t0
	st.b $t0, $fp, -69
# br i1 %op8, label %label_trueBB2, label %label_falseBB3
	ld.b $t0, $fp, -69
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .max_label_trueBB2
	b .max_label_falseBB3
.max_label_nextBB1:
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 80
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.max_label_trueBB2:
# %op9 = load i32, i32* %op2
	ld.d $t0, $fp, -32
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -76
# ret i32 %op9
	ld.w $a0, $fp, -76
	addi.d $sp, $sp, 80
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.max_label_falseBB3:
# %op10 = load i32, i32* %op3
	ld.d $t0, $fp, -48
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -80
# ret i32 %op10
	ld.w $a0, $fp, -80
	addi.d $sp, $sp, 80
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	addi.d $sp, $sp, 80
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	.globl knapsack
	.type knapsack, @function
knapsack:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -384
	st.w $a0, $fp, -20
	st.w $a1, $fp, -24
.knapsack_label_entry4:
# %op2 = alloca i32
	addi.d $t1, $fp, -36
	st.d $t1, $fp, -32
# store i32 %arg0, i32* %op2
	ld.d $t0, $fp, -32
	ld.w $t1, $fp, -20
	st.w $t1, $t0, 0
# %op3 = alloca i32
	addi.d $t1, $fp, -52
	st.d $t1, $fp, -48
# store i32 %arg1, i32* %op3
	ld.d $t0, $fp, -48
	ld.w $t1, $fp, -24
	st.w $t1, $t0, 0
# %op4 = alloca i32
	addi.d $t1, $fp, -68
	st.d $t1, $fp, -64
# %op5 = load i32, i32* %op3
	ld.d $t0, $fp, -48
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -72
# %op6 = icmp sle i32 %op5, 0
	ld.w $t0, $fp, -72
	addi.w $t1, $zero, 0
	addi.w $t1, $t1, 1
	slt $t0, $t0, $t1
	st.b $t0, $fp, -73
# %op7 = zext i1 %op6 to i32
	ld.b $t0, $fp, -73
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -80
# %op8 = icmp sgt i32 %op7, 0
	ld.w $t0, $fp, -80
	addi.w $t1, $zero, 0
	slt $t0, $t1, $t0
	st.b $t0, $fp, -81
# br i1 %op8, label %label_trueBB6, label %label_nextBB5
	ld.b $t0, $fp, -81
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .knapsack_label_trueBB6
	b .knapsack_label_nextBB5
.knapsack_label_nextBB5:
# %op9 = load i32, i32* %op2
	ld.d $t0, $fp, -32
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -88
# %op10 = icmp eq i32 %op9, 0
	ld.w $t0, $fp, -88
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	nor $t0, $t2, $t3
	st.b $t0, $fp, -89
# %op11 = zext i1 %op10 to i32
	ld.b $t0, $fp, -89
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -96
# %op12 = icmp sgt i32 %op11, 0
	ld.w $t0, $fp, -96
	addi.w $t1, $zero, 0
	slt $t0, $t1, $t0
	st.b $t0, $fp, -97
# br i1 %op12, label %label_trueBB8, label %label_nextBB7
	ld.b $t0, $fp, -97
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .knapsack_label_trueBB8
	b .knapsack_label_nextBB7
.knapsack_label_trueBB6:
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 384
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.knapsack_label_nextBB7:
# %op13 = load i32, i32* %op2
	ld.d $t0, $fp, -32
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -104
# %op14 = mul i32 %op13, 11
	ld.w $t0, $fp, -104
	addi.w $t1, $zero, 11
	mul.w $t2, $t0, $t1
	st.w $t2, $fp, -108
# %op15 = load i32, i32* %op3
	ld.d $t0, $fp, -48
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -112
# %op16 = add i32 %op14, %op15
	ld.w $t0, $fp, -108
	ld.w $t1, $fp, -112
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -116
# %op17 = icmp sge i32 %op16, 0
	ld.w $t0, $fp, -116
	addi.w $t1, $zero, 0
	addi.w $t0, $t0, 1
	slt $t0, $t1, $t0
	st.b $t0, $fp, -117
# br i1 %op17, label %label_nextBB10, label %label_negBB11
	ld.b $t0, $fp, -117
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .knapsack_label_nextBB10
	b .knapsack_label_negBB11
.knapsack_label_trueBB8:
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 384
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.knapsack_label_nextBB9:
# %op18 = load i32, i32* %op3
	ld.d $t0, $fp, -48
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -124
# %op19 = load i32, i32* %op2
	ld.d $t0, $fp, -32
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -128
# %op20 = sub i32 %op19, 1
	ld.w $t0, $fp, -128
	addi.w $t1, $zero, 1
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -132
# %op21 = icmp sge i32 %op20, 0
	ld.w $t0, $fp, -132
	addi.w $t1, $zero, 0
	addi.w $t0, $t0, 1
	slt $t0, $t1, $t0
	st.b $t0, $fp, -133
# br i1 %op21, label %label_nextBB16, label %label_negBB17
	ld.b $t0, $fp, -133
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .knapsack_label_nextBB16
	b .knapsack_label_negBB17
.knapsack_label_nextBB10:
# %op22 = getelementptr [66 x i32], [66 x i32]* @dp, i32 0, i32 %op16
	la.local $t0, dp
	addi.w $t1, $zero, 0
	ld.w $t2, $fp, -116
	lu12i.w $t4, 0
	ori $t4, $t4, 4
	lu12i.w $t3, 0
	ori $t3, $t3, 264
	mul.w $t1, $t1, $t3
	mul.w $t2, $t2, $t4
	bstrpick.d $t1, $t1, 31, 0
	bstrpick.d $t2, $t2, 31, 0
	add.d $t0, $t0, $t1
	add.d $t0, $t0, $t2
	st.d $t0, $fp, -144
# %op23 = load i32, i32* %op22
	ld.d $t0, $fp, -144
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -148
# %op24 = icmp sge i32 %op23, 0
	ld.w $t0, $fp, -148
	addi.w $t1, $zero, 0
	addi.w $t0, $t0, 1
	slt $t0, $t1, $t0
	st.b $t0, $fp, -149
# %op25 = zext i1 %op24 to i32
	ld.b $t0, $fp, -149
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -156
# %op26 = icmp sgt i32 %op25, 0
	ld.w $t0, $fp, -156
	addi.w $t1, $zero, 0
	slt $t0, $t1, $t0
	st.b $t0, $fp, -157
# br i1 %op26, label %label_trueBB12, label %label_nextBB9
	ld.b $t0, $fp, -157
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .knapsack_label_trueBB12
	b .knapsack_label_nextBB9
.knapsack_label_negBB11:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label_nextBB10
	b .knapsack_label_nextBB10
.knapsack_label_trueBB12:
# %op27 = load i32, i32* %op2
	ld.d $t0, $fp, -32
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -164
# %op28 = mul i32 %op27, 11
	ld.w $t0, $fp, -164
	addi.w $t1, $zero, 11
	mul.w $t2, $t0, $t1
	st.w $t2, $fp, -168
# %op29 = load i32, i32* %op3
	ld.d $t0, $fp, -48
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -172
# %op30 = add i32 %op28, %op29
	ld.w $t0, $fp, -168
	ld.w $t1, $fp, -172
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -176
# %op31 = icmp sge i32 %op30, 0
	ld.w $t0, $fp, -176
	addi.w $t1, $zero, 0
	addi.w $t0, $t0, 1
	slt $t0, $t1, $t0
	st.b $t0, $fp, -177
# br i1 %op31, label %label_nextBB13, label %label_negBB14
	ld.b $t0, $fp, -177
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .knapsack_label_nextBB13
	b .knapsack_label_negBB14
.knapsack_label_nextBB13:
# %op32 = getelementptr [66 x i32], [66 x i32]* @dp, i32 0, i32 %op30
	la.local $t0, dp
	addi.w $t1, $zero, 0
	ld.w $t2, $fp, -176
	lu12i.w $t4, 0
	ori $t4, $t4, 4
	lu12i.w $t3, 0
	ori $t3, $t3, 264
	mul.w $t1, $t1, $t3
	mul.w $t2, $t2, $t4
	bstrpick.d $t1, $t1, 31, 0
	bstrpick.d $t2, $t2, 31, 0
	add.d $t0, $t0, $t1
	add.d $t0, $t0, $t2
	st.d $t0, $fp, -192
# %op33 = load i32, i32* %op32
	ld.d $t0, $fp, -192
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -196
# ret i32 %op33
	ld.w $a0, $fp, -196
	addi.d $sp, $sp, 384
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.knapsack_label_negBB14:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label_nextBB13
	b .knapsack_label_nextBB13
.knapsack_label_nextBB15:
# %op34 = load i32, i32* %op2
	ld.d $t0, $fp, -32
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -200
# %op35 = mul i32 %op34, 11
	ld.w $t0, $fp, -200
	addi.w $t1, $zero, 11
	mul.w $t2, $t0, $t1
	st.w $t2, $fp, -204
# %op36 = load i32, i32* %op3
	ld.d $t0, $fp, -48
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -208
# %op37 = add i32 %op35, %op36
	ld.w $t0, $fp, -204
	ld.w $t1, $fp, -208
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -212
# %op38 = icmp sge i32 %op37, 0
	ld.w $t0, $fp, -212
	addi.w $t1, $zero, 0
	addi.w $t0, $t0, 1
	slt $t0, $t1, $t0
	st.b $t0, $fp, -213
# br i1 %op38, label %label_nextBB24, label %label_negBB25
	ld.b $t0, $fp, -213
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .knapsack_label_nextBB24
	b .knapsack_label_negBB25
.knapsack_label_nextBB16:
# %op39 = getelementptr [5 x i32], [5 x i32]* @w, i32 0, i32 %op20
	la.local $t0, w
	addi.w $t1, $zero, 0
	ld.w $t2, $fp, -132
	lu12i.w $t4, 0
	ori $t4, $t4, 4
	lu12i.w $t3, 0
	ori $t3, $t3, 20
	mul.w $t1, $t1, $t3
	mul.w $t2, $t2, $t4
	bstrpick.d $t1, $t1, 31, 0
	bstrpick.d $t2, $t2, 31, 0
	add.d $t0, $t0, $t1
	add.d $t0, $t0, $t2
	st.d $t0, $fp, -224
# %op40 = load i32, i32* %op39
	ld.d $t0, $fp, -224
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -228
# %op41 = icmp slt i32 %op18, %op40
	ld.w $t0, $fp, -124
	ld.w $t1, $fp, -228
	slt $t0, $t0, $t1
	st.b $t0, $fp, -229
# %op42 = zext i1 %op41 to i32
	ld.b $t0, $fp, -229
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -236
# %op43 = icmp sgt i32 %op42, 0
	ld.w $t0, $fp, -236
	addi.w $t1, $zero, 0
	slt $t0, $t1, $t0
	st.b $t0, $fp, -237
# br i1 %op43, label %label_trueBB18, label %label_falseBB19
	ld.b $t0, $fp, -237
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .knapsack_label_trueBB18
	b .knapsack_label_falseBB19
.knapsack_label_negBB17:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label_nextBB16
	b .knapsack_label_nextBB16
.knapsack_label_trueBB18:
# %op44 = load i32, i32* %op4
	ld.d $t0, $fp, -64
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -244
# %op45 = load i32, i32* %op2
	ld.d $t0, $fp, -32
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -248
# %op46 = sub i32 %op45, 1
	ld.w $t0, $fp, -248
	addi.w $t1, $zero, 1
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -252
# %op47 = load i32, i32* %op3
	ld.d $t0, $fp, -48
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -256
# %op48 = call i32 @knapsack(i32 %op46, i32 %op47)
	ld.w $a0, $fp, -252
	ld.w $a1, $fp, -256
	bl knapsack
	st.w $a0, $fp, -260
# store i32 %op48, i32* %op4
	ld.d $t0, $fp, -64
	ld.w $t1, $fp, -260
	st.w $t1, $t0, 0
# br label %label_nextBB15
	b .knapsack_label_nextBB15
.knapsack_label_falseBB19:
# %op49 = load i32, i32* %op4
	ld.d $t0, $fp, -64
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -264
# %op50 = load i32, i32* %op2
	ld.d $t0, $fp, -32
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -268
# %op51 = sub i32 %op50, 1
	ld.w $t0, $fp, -268
	addi.w $t1, $zero, 1
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -272
# %op52 = load i32, i32* %op3
	ld.d $t0, $fp, -48
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -276
# %op53 = call i32 @knapsack(i32 %op51, i32 %op52)
	ld.w $a0, $fp, -272
	ld.w $a1, $fp, -276
	bl knapsack
	st.w $a0, $fp, -280
# %op54 = load i32, i32* %op2
	ld.d $t0, $fp, -32
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -284
# %op55 = sub i32 %op54, 1
	ld.w $t0, $fp, -284
	addi.w $t1, $zero, 1
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -288
# %op56 = load i32, i32* %op3
	ld.d $t0, $fp, -48
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -292
# %op57 = load i32, i32* %op2
	ld.d $t0, $fp, -32
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -296
# %op58 = sub i32 %op57, 1
	ld.w $t0, $fp, -296
	addi.w $t1, $zero, 1
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -300
# %op59 = icmp sge i32 %op58, 0
	ld.w $t0, $fp, -300
	addi.w $t1, $zero, 0
	addi.w $t0, $t0, 1
	slt $t0, $t1, $t0
	st.b $t0, $fp, -301
# br i1 %op59, label %label_nextBB20, label %label_negBB21
	ld.b $t0, $fp, -301
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .knapsack_label_nextBB20
	b .knapsack_label_negBB21
.knapsack_label_nextBB20:
# %op60 = getelementptr [5 x i32], [5 x i32]* @w, i32 0, i32 %op58
	la.local $t0, w
	addi.w $t1, $zero, 0
	ld.w $t2, $fp, -300
	lu12i.w $t4, 0
	ori $t4, $t4, 4
	lu12i.w $t3, 0
	ori $t3, $t3, 20
	mul.w $t1, $t1, $t3
	mul.w $t2, $t2, $t4
	bstrpick.d $t1, $t1, 31, 0
	bstrpick.d $t2, $t2, 31, 0
	add.d $t0, $t0, $t1
	add.d $t0, $t0, $t2
	st.d $t0, $fp, -312
# %op61 = load i32, i32* %op60
	ld.d $t0, $fp, -312
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -316
# %op62 = sub i32 %op56, %op61
	ld.w $t0, $fp, -292
	ld.w $t1, $fp, -316
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -320
# %op63 = call i32 @knapsack(i32 %op55, i32 %op62)
	ld.w $a0, $fp, -288
	ld.w $a1, $fp, -320
	bl knapsack
	st.w $a0, $fp, -324
# %op64 = load i32, i32* %op2
	ld.d $t0, $fp, -32
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -328
# %op65 = sub i32 %op64, 1
	ld.w $t0, $fp, -328
	addi.w $t1, $zero, 1
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -332
# %op66 = icmp sge i32 %op65, 0
	ld.w $t0, $fp, -332
	addi.w $t1, $zero, 0
	addi.w $t0, $t0, 1
	slt $t0, $t1, $t0
	st.b $t0, $fp, -333
# br i1 %op66, label %label_nextBB22, label %label_negBB23
	ld.b $t0, $fp, -333
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .knapsack_label_nextBB22
	b .knapsack_label_negBB23
.knapsack_label_negBB21:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label_nextBB20
	b .knapsack_label_nextBB20
.knapsack_label_nextBB22:
# %op67 = getelementptr [5 x i32], [5 x i32]* @v, i32 0, i32 %op65
	la.local $t0, v
	addi.w $t1, $zero, 0
	ld.w $t2, $fp, -332
	lu12i.w $t4, 0
	ori $t4, $t4, 4
	lu12i.w $t3, 0
	ori $t3, $t3, 20
	mul.w $t1, $t1, $t3
	mul.w $t2, $t2, $t4
	bstrpick.d $t1, $t1, 31, 0
	bstrpick.d $t2, $t2, 31, 0
	add.d $t0, $t0, $t1
	add.d $t0, $t0, $t2
	st.d $t0, $fp, -344
# %op68 = load i32, i32* %op67
	ld.d $t0, $fp, -344
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -348
# %op69 = add i32 %op63, %op68
	ld.w $t0, $fp, -324
	ld.w $t1, $fp, -348
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -352
# %op70 = call i32 @max(i32 %op53, i32 %op69)
	ld.w $a0, $fp, -280
	ld.w $a1, $fp, -352
	bl max
	st.w $a0, $fp, -356
# store i32 %op70, i32* %op4
	ld.d $t0, $fp, -64
	ld.w $t1, $fp, -356
	st.w $t1, $t0, 0
# br label %label_nextBB15
	b .knapsack_label_nextBB15
.knapsack_label_negBB23:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label_nextBB22
	b .knapsack_label_nextBB22
.knapsack_label_nextBB24:
# %op71 = getelementptr [66 x i32], [66 x i32]* @dp, i32 0, i32 %op37
	la.local $t0, dp
	addi.w $t1, $zero, 0
	ld.w $t2, $fp, -212
	lu12i.w $t4, 0
	ori $t4, $t4, 4
	lu12i.w $t3, 0
	ori $t3, $t3, 264
	mul.w $t1, $t1, $t3
	mul.w $t2, $t2, $t4
	bstrpick.d $t1, $t1, 31, 0
	bstrpick.d $t2, $t2, 31, 0
	add.d $t0, $t0, $t1
	add.d $t0, $t0, $t2
	st.d $t0, $fp, -368
# %op72 = load i32, i32* %op71
	ld.d $t0, $fp, -368
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -372
# %op73 = load i32, i32* %op4
	ld.d $t0, $fp, -64
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -376
# store i32 %op73, i32* %op71
	ld.d $t0, $fp, -368
	ld.w $t1, $fp, -376
	st.w $t1, $t0, 0
# %op74 = load i32, i32* %op4
	ld.d $t0, $fp, -64
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -380
# ret i32 %op74
	ld.w $a0, $fp, -380
	addi.d $sp, $sp, 384
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.knapsack_label_negBB25:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label_nextBB24
	b .knapsack_label_nextBB24
	addi.d $sp, $sp, 384
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	.globl main
	.type main, @function
main:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -272
.main_label_entry26:
# %op0 = alloca i32
	addi.d $t1, $fp, -28
	st.d $t1, $fp, -24
# %op1 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -32
# store i32 0, i32* %op0
	ld.d $t0, $fp, -24
	addi.w $t1, $zero, 0
	st.w $t1, $t0, 0
# %op2 = load i32, i32* @n
	la.local $t0, n
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -36
# store i32 5, i32* @n
	la.local $t0, n
	addi.w $t1, $zero, 5
	st.w $t1, $t0, 0
# %op3 = load i32, i32* @m
	la.local $t0, m
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -40
# store i32 10, i32* @m
	la.local $t0, m
	addi.w $t1, $zero, 10
	st.w $t1, $t0, 0
# %op4 = icmp sge i32 0, 0
	addi.w $t0, $zero, 0
	addi.w $t1, $zero, 0
	addi.w $t0, $t0, 1
	slt $t0, $t1, $t0
	st.b $t0, $fp, -41
# br i1 %op4, label %label_nextBB27, label %label_negBB28
	ld.b $t0, $fp, -41
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_nextBB27
	b .main_label_negBB28
.main_label_nextBB27:
# %op5 = getelementptr [5 x i32], [5 x i32]* @w, i32 0, i32 0
	la.local $t0, w
	addi.w $t1, $zero, 0
	addi.w $t2, $zero, 0
	lu12i.w $t4, 0
	ori $t4, $t4, 4
	lu12i.w $t3, 0
	ori $t3, $t3, 20
	mul.w $t1, $t1, $t3
	mul.w $t2, $t2, $t4
	bstrpick.d $t1, $t1, 31, 0
	bstrpick.d $t2, $t2, 31, 0
	add.d $t0, $t0, $t1
	add.d $t0, $t0, $t2
	st.d $t0, $fp, -56
# %op6 = load i32, i32* %op5
	ld.d $t0, $fp, -56
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -60
# store i32 2, i32* %op5
	ld.d $t0, $fp, -56
	addi.w $t1, $zero, 2
	st.w $t1, $t0, 0
# %op7 = icmp sge i32 1, 0
	addi.w $t0, $zero, 1
	addi.w $t1, $zero, 0
	addi.w $t0, $t0, 1
	slt $t0, $t1, $t0
	st.b $t0, $fp, -61
# br i1 %op7, label %label_nextBB29, label %label_negBB30
	ld.b $t0, $fp, -61
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_nextBB29
	b .main_label_negBB30
.main_label_negBB28:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label_nextBB27
	b .main_label_nextBB27
.main_label_nextBB29:
# %op8 = getelementptr [5 x i32], [5 x i32]* @w, i32 0, i32 1
	la.local $t0, w
	addi.w $t1, $zero, 0
	addi.w $t2, $zero, 1
	lu12i.w $t4, 0
	ori $t4, $t4, 4
	lu12i.w $t3, 0
	ori $t3, $t3, 20
	mul.w $t1, $t1, $t3
	mul.w $t2, $t2, $t4
	bstrpick.d $t1, $t1, 31, 0
	bstrpick.d $t2, $t2, 31, 0
	add.d $t0, $t0, $t1
	add.d $t0, $t0, $t2
	st.d $t0, $fp, -72
# %op9 = load i32, i32* %op8
	ld.d $t0, $fp, -72
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -76
# store i32 2, i32* %op8
	ld.d $t0, $fp, -72
	addi.w $t1, $zero, 2
	st.w $t1, $t0, 0
# %op10 = icmp sge i32 2, 0
	addi.w $t0, $zero, 2
	addi.w $t1, $zero, 0
	addi.w $t0, $t0, 1
	slt $t0, $t1, $t0
	st.b $t0, $fp, -77
# br i1 %op10, label %label_nextBB31, label %label_negBB32
	ld.b $t0, $fp, -77
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_nextBB31
	b .main_label_negBB32
.main_label_negBB30:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label_nextBB29
	b .main_label_nextBB29
.main_label_nextBB31:
# %op11 = getelementptr [5 x i32], [5 x i32]* @w, i32 0, i32 2
	la.local $t0, w
	addi.w $t1, $zero, 0
	addi.w $t2, $zero, 2
	lu12i.w $t4, 0
	ori $t4, $t4, 4
	lu12i.w $t3, 0
	ori $t3, $t3, 20
	mul.w $t1, $t1, $t3
	mul.w $t2, $t2, $t4
	bstrpick.d $t1, $t1, 31, 0
	bstrpick.d $t2, $t2, 31, 0
	add.d $t0, $t0, $t1
	add.d $t0, $t0, $t2
	st.d $t0, $fp, -88
# %op12 = load i32, i32* %op11
	ld.d $t0, $fp, -88
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -92
# store i32 6, i32* %op11
	ld.d $t0, $fp, -88
	addi.w $t1, $zero, 6
	st.w $t1, $t0, 0
# %op13 = icmp sge i32 3, 0
	addi.w $t0, $zero, 3
	addi.w $t1, $zero, 0
	addi.w $t0, $t0, 1
	slt $t0, $t1, $t0
	st.b $t0, $fp, -93
# br i1 %op13, label %label_nextBB33, label %label_negBB34
	ld.b $t0, $fp, -93
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_nextBB33
	b .main_label_negBB34
.main_label_negBB32:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label_nextBB31
	b .main_label_nextBB31
.main_label_nextBB33:
# %op14 = getelementptr [5 x i32], [5 x i32]* @w, i32 0, i32 3
	la.local $t0, w
	addi.w $t1, $zero, 0
	addi.w $t2, $zero, 3
	lu12i.w $t4, 0
	ori $t4, $t4, 4
	lu12i.w $t3, 0
	ori $t3, $t3, 20
	mul.w $t1, $t1, $t3
	mul.w $t2, $t2, $t4
	bstrpick.d $t1, $t1, 31, 0
	bstrpick.d $t2, $t2, 31, 0
	add.d $t0, $t0, $t1
	add.d $t0, $t0, $t2
	st.d $t0, $fp, -104
# %op15 = load i32, i32* %op14
	ld.d $t0, $fp, -104
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -108
# store i32 5, i32* %op14
	ld.d $t0, $fp, -104
	addi.w $t1, $zero, 5
	st.w $t1, $t0, 0
# %op16 = icmp sge i32 4, 0
	addi.w $t0, $zero, 4
	addi.w $t1, $zero, 0
	addi.w $t0, $t0, 1
	slt $t0, $t1, $t0
	st.b $t0, $fp, -109
# br i1 %op16, label %label_nextBB35, label %label_negBB36
	ld.b $t0, $fp, -109
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_nextBB35
	b .main_label_negBB36
.main_label_negBB34:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label_nextBB33
	b .main_label_nextBB33
.main_label_nextBB35:
# %op17 = getelementptr [5 x i32], [5 x i32]* @w, i32 0, i32 4
	la.local $t0, w
	addi.w $t1, $zero, 0
	addi.w $t2, $zero, 4
	lu12i.w $t4, 0
	ori $t4, $t4, 4
	lu12i.w $t3, 0
	ori $t3, $t3, 20
	mul.w $t1, $t1, $t3
	mul.w $t2, $t2, $t4
	bstrpick.d $t1, $t1, 31, 0
	bstrpick.d $t2, $t2, 31, 0
	add.d $t0, $t0, $t1
	add.d $t0, $t0, $t2
	st.d $t0, $fp, -120
# %op18 = load i32, i32* %op17
	ld.d $t0, $fp, -120
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -124
# store i32 4, i32* %op17
	ld.d $t0, $fp, -120
	addi.w $t1, $zero, 4
	st.w $t1, $t0, 0
# %op19 = icmp sge i32 0, 0
	addi.w $t0, $zero, 0
	addi.w $t1, $zero, 0
	addi.w $t0, $t0, 1
	slt $t0, $t1, $t0
	st.b $t0, $fp, -125
# br i1 %op19, label %label_nextBB37, label %label_negBB38
	ld.b $t0, $fp, -125
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_nextBB37
	b .main_label_negBB38
.main_label_negBB36:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label_nextBB35
	b .main_label_nextBB35
.main_label_nextBB37:
# %op20 = getelementptr [5 x i32], [5 x i32]* @v, i32 0, i32 0
	la.local $t0, v
	addi.w $t1, $zero, 0
	addi.w $t2, $zero, 0
	lu12i.w $t4, 0
	ori $t4, $t4, 4
	lu12i.w $t3, 0
	ori $t3, $t3, 20
	mul.w $t1, $t1, $t3
	mul.w $t2, $t2, $t4
	bstrpick.d $t1, $t1, 31, 0
	bstrpick.d $t2, $t2, 31, 0
	add.d $t0, $t0, $t1
	add.d $t0, $t0, $t2
	st.d $t0, $fp, -136
# %op21 = load i32, i32* %op20
	ld.d $t0, $fp, -136
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -140
# store i32 6, i32* %op20
	ld.d $t0, $fp, -136
	addi.w $t1, $zero, 6
	st.w $t1, $t0, 0
# %op22 = icmp sge i32 1, 0
	addi.w $t0, $zero, 1
	addi.w $t1, $zero, 0
	addi.w $t0, $t0, 1
	slt $t0, $t1, $t0
	st.b $t0, $fp, -141
# br i1 %op22, label %label_nextBB39, label %label_negBB40
	ld.b $t0, $fp, -141
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_nextBB39
	b .main_label_negBB40
.main_label_negBB38:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label_nextBB37
	b .main_label_nextBB37
.main_label_nextBB39:
# %op23 = getelementptr [5 x i32], [5 x i32]* @v, i32 0, i32 1
	la.local $t0, v
	addi.w $t1, $zero, 0
	addi.w $t2, $zero, 1
	lu12i.w $t4, 0
	ori $t4, $t4, 4
	lu12i.w $t3, 0
	ori $t3, $t3, 20
	mul.w $t1, $t1, $t3
	mul.w $t2, $t2, $t4
	bstrpick.d $t1, $t1, 31, 0
	bstrpick.d $t2, $t2, 31, 0
	add.d $t0, $t0, $t1
	add.d $t0, $t0, $t2
	st.d $t0, $fp, -152
# %op24 = load i32, i32* %op23
	ld.d $t0, $fp, -152
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -156
# store i32 3, i32* %op23
	ld.d $t0, $fp, -152
	addi.w $t1, $zero, 3
	st.w $t1, $t0, 0
# %op25 = icmp sge i32 2, 0
	addi.w $t0, $zero, 2
	addi.w $t1, $zero, 0
	addi.w $t0, $t0, 1
	slt $t0, $t1, $t0
	st.b $t0, $fp, -157
# br i1 %op25, label %label_nextBB41, label %label_negBB42
	ld.b $t0, $fp, -157
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_nextBB41
	b .main_label_negBB42
.main_label_negBB40:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label_nextBB39
	b .main_label_nextBB39
.main_label_nextBB41:
# %op26 = getelementptr [5 x i32], [5 x i32]* @v, i32 0, i32 2
	la.local $t0, v
	addi.w $t1, $zero, 0
	addi.w $t2, $zero, 2
	lu12i.w $t4, 0
	ori $t4, $t4, 4
	lu12i.w $t3, 0
	ori $t3, $t3, 20
	mul.w $t1, $t1, $t3
	mul.w $t2, $t2, $t4
	bstrpick.d $t1, $t1, 31, 0
	bstrpick.d $t2, $t2, 31, 0
	add.d $t0, $t0, $t1
	add.d $t0, $t0, $t2
	st.d $t0, $fp, -168
# %op27 = load i32, i32* %op26
	ld.d $t0, $fp, -168
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -172
# store i32 5, i32* %op26
	ld.d $t0, $fp, -168
	addi.w $t1, $zero, 5
	st.w $t1, $t0, 0
# %op28 = icmp sge i32 3, 0
	addi.w $t0, $zero, 3
	addi.w $t1, $zero, 0
	addi.w $t0, $t0, 1
	slt $t0, $t1, $t0
	st.b $t0, $fp, -173
# br i1 %op28, label %label_nextBB43, label %label_negBB44
	ld.b $t0, $fp, -173
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_nextBB43
	b .main_label_negBB44
.main_label_negBB42:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label_nextBB41
	b .main_label_nextBB41
.main_label_nextBB43:
# %op29 = getelementptr [5 x i32], [5 x i32]* @v, i32 0, i32 3
	la.local $t0, v
	addi.w $t1, $zero, 0
	addi.w $t2, $zero, 3
	lu12i.w $t4, 0
	ori $t4, $t4, 4
	lu12i.w $t3, 0
	ori $t3, $t3, 20
	mul.w $t1, $t1, $t3
	mul.w $t2, $t2, $t4
	bstrpick.d $t1, $t1, 31, 0
	bstrpick.d $t2, $t2, 31, 0
	add.d $t0, $t0, $t1
	add.d $t0, $t0, $t2
	st.d $t0, $fp, -184
# %op30 = load i32, i32* %op29
	ld.d $t0, $fp, -184
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -188
# store i32 4, i32* %op29
	ld.d $t0, $fp, -184
	addi.w $t1, $zero, 4
	st.w $t1, $t0, 0
# %op31 = icmp sge i32 4, 0
	addi.w $t0, $zero, 4
	addi.w $t1, $zero, 0
	addi.w $t0, $t0, 1
	slt $t0, $t1, $t0
	st.b $t0, $fp, -189
# br i1 %op31, label %label_nextBB45, label %label_negBB46
	ld.b $t0, $fp, -189
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_nextBB45
	b .main_label_negBB46
.main_label_negBB44:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label_nextBB43
	b .main_label_nextBB43
.main_label_nextBB45:
# %op32 = getelementptr [5 x i32], [5 x i32]* @v, i32 0, i32 4
	la.local $t0, v
	addi.w $t1, $zero, 0
	addi.w $t2, $zero, 4
	lu12i.w $t4, 0
	ori $t4, $t4, 4
	lu12i.w $t3, 0
	ori $t3, $t3, 20
	mul.w $t1, $t1, $t3
	mul.w $t2, $t2, $t4
	bstrpick.d $t1, $t1, 31, 0
	bstrpick.d $t2, $t2, 31, 0
	add.d $t0, $t0, $t1
	add.d $t0, $t0, $t2
	st.d $t0, $fp, -200
# %op33 = load i32, i32* %op32
	ld.d $t0, $fp, -200
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -204
# store i32 6, i32* %op32
	ld.d $t0, $fp, -200
	addi.w $t1, $zero, 6
	st.w $t1, $t0, 0
# br label %label_cmpBB48
	b .main_label_cmpBB48
.main_label_negBB46:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label_nextBB45
	b .main_label_nextBB45
.main_label_nextBB47:
# %op34 = load i32, i32* @n
	la.local $t0, n
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -208
# %op35 = load i32, i32* @m
	la.local $t0, m
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -212
# %op36 = call i32 @knapsack(i32 %op34, i32 %op35)
	ld.w $a0, $fp, -208
	ld.w $a1, $fp, -212
	bl knapsack
	st.w $a0, $fp, -216
# call void @output(i32 %op36)
	ld.w $a0, $fp, -216
	bl output
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 272
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label_cmpBB48:
# %op37 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -220
# %op38 = icmp slt i32 %op37, 66
	ld.w $t0, $fp, -220
	addi.w $t1, $zero, 66
	slt $t0, $t0, $t1
	st.b $t0, $fp, -221
# %op39 = zext i1 %op38 to i32
	ld.b $t0, $fp, -221
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -228
# %op40 = icmp sgt i32 %op39, 0
	ld.w $t0, $fp, -228
	addi.w $t1, $zero, 0
	slt $t0, $t1, $t0
	st.b $t0, $fp, -229
# br i1 %op40, label %label_whileBB49, label %label_nextBB47
	ld.b $t0, $fp, -229
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_whileBB49
	b .main_label_nextBB47
.main_label_whileBB49:
# %op41 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -236
# %op42 = icmp sge i32 %op41, 0
	ld.w $t0, $fp, -236
	addi.w $t1, $zero, 0
	addi.w $t0, $t0, 1
	slt $t0, $t1, $t0
	st.b $t0, $fp, -237
# br i1 %op42, label %label_nextBB50, label %label_negBB51
	ld.b $t0, $fp, -237
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_nextBB50
	b .main_label_negBB51
.main_label_nextBB50:
# %op43 = getelementptr [66 x i32], [66 x i32]* @dp, i32 0, i32 %op41
	la.local $t0, dp
	addi.w $t1, $zero, 0
	ld.w $t2, $fp, -236
	lu12i.w $t4, 0
	ori $t4, $t4, 4
	lu12i.w $t3, 0
	ori $t3, $t3, 264
	mul.w $t1, $t1, $t3
	mul.w $t2, $t2, $t4
	bstrpick.d $t1, $t1, 31, 0
	bstrpick.d $t2, $t2, 31, 0
	add.d $t0, $t0, $t1
	add.d $t0, $t0, $t2
	st.d $t0, $fp, -248
# %op44 = load i32, i32* %op43
	ld.d $t0, $fp, -248
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -252
# %op45 = sub i32 0, 1
	addi.w $t0, $zero, 0
	addi.w $t1, $zero, 1
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -256
# store i32 %op45, i32* %op43
	ld.d $t0, $fp, -248
	ld.w $t1, $fp, -256
	st.w $t1, $t0, 0
# %op46 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -260
# %op47 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -264
# %op48 = add i32 %op47, 1
	ld.w $t0, $fp, -264
	addi.w $t1, $zero, 1
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -268
# store i32 %op48, i32* %op0
	ld.d $t0, $fp, -24
	ld.w $t1, $fp, -268
	st.w $t1, $t0, 0
# br label %label_cmpBB48
	b .main_label_cmpBB48
.main_label_negBB51:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label_nextBB50
	b .main_label_nextBB50
	addi.d $sp, $sp, 272
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
