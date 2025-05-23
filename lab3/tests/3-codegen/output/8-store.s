	.text
	.globl store
	.type store, @function
store:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -128
	st.d $a0, $fp, -24
	st.w $a1, $fp, -28
	st.w $a2, $fp, -32
.store_label_entry0:
# %op3 = alloca i32*
	addi.d $t1, $fp, -48
	st.d $t1, $fp, -40
# store i32* %arg0, i32** %op3
	ld.d $t0, $fp, -40
	ld.d $t1, $fp, -24
	st.d $t1, $t0, 0
# %op4 = alloca i32
	addi.d $t1, $fp, -60
	st.d $t1, $fp, -56
# store i32 %arg1, i32* %op4
	ld.d $t0, $fp, -56
	ld.w $t1, $fp, -28
	st.w $t1, $t0, 0
# %op5 = alloca i32
	addi.d $t1, $fp, -76
	st.d $t1, $fp, -72
# store i32 %arg2, i32* %op5
	ld.d $t0, $fp, -72
	ld.w $t1, $fp, -32
	st.w $t1, $t0, 0
# %op6 = load i32, i32* %op4
	ld.d $t0, $fp, -56
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -80
# %op7 = icmp sge i32 %op6, 0
	ld.w $t0, $fp, -80
	addi.w $t1, $zero, 0
	addi.w $t0, $t0, 1
	slt $t0, $t1, $t0
	st.b $t0, $fp, -81
# br i1 %op7, label %label_nextBB1, label %label_negBB2
	ld.b $t0, $fp, -81
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .store_label_nextBB1
	b .store_label_negBB2
.store_label_nextBB1:
# %op8 = load i32*, i32** %op3
	ld.d $t0, $fp, -40
	ld.d $t0, $t0, 0
	st.d $t0, $fp, -96
# %op9 = getelementptr i32, i32* %op8, i32 %op6
	ld.d $t0, $fp, -96
	ld.w $t1, $fp, -80
	lu12i.w $t3, 0
	ori $t3, $t3, 4
	mul.w $t1, $t1, $t3
	bstrpick.d $t1, $t1, 31, 0
	add.d $t0, $t0, $t1
	st.d $t0, $fp, -104
# %op10 = load i32, i32* %op9
	ld.d $t0, $fp, -104
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -108
# %op11 = load i32, i32* %op5
	ld.d $t0, $fp, -72
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -112
# store i32 %op11, i32* %op9
	ld.d $t0, $fp, -104
	ld.w $t1, $fp, -112
	st.w $t1, $t0, 0
# %op12 = load i32, i32* %op5
	ld.d $t0, $fp, -72
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -116
# ret i32 %op12
	ld.w $a0, $fp, -116
	addi.d $sp, $sp, 128
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.store_label_negBB2:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label_nextBB1
	b .store_label_nextBB1
	addi.d $sp, $sp, 128
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	.globl main
	.type main, @function
main:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -224
.main_label_entry3:
# %op0 = alloca [10 x i32]
	addi.d $t1, $fp, -64
	st.d $t1, $fp, -24
# %op1 = alloca i32
	addi.d $t1, $fp, -76
	st.d $t1, $fp, -72
# %op2 = alloca i32
	addi.d $t1, $fp, -92
	st.d $t1, $fp, -88
# %op3 = load i32, i32* %op1
	ld.d $t0, $fp, -72
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -96
# store i32 0, i32* %op1
	ld.d $t0, $fp, -72
	addi.w $t1, $zero, 0
	st.w $t1, $t0, 0
# br label %label_cmpBB5
	b .main_label_cmpBB5
.main_label_nextBB4:
# %op4 = load i32, i32* %op2
	ld.d $t0, $fp, -88
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -100
# store i32 0, i32* %op2
	ld.d $t0, $fp, -88
	addi.w $t1, $zero, 0
	st.w $t1, $t0, 0
# %op5 = load i32, i32* %op1
	ld.d $t0, $fp, -72
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -104
# store i32 0, i32* %op1
	ld.d $t0, $fp, -72
	addi.w $t1, $zero, 0
	st.w $t1, $t0, 0
# br label %label_cmpBB8
	b .main_label_cmpBB8
.main_label_cmpBB5:
# %op6 = load i32, i32* %op1
	ld.d $t0, $fp, -72
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -108
# %op7 = icmp slt i32 %op6, 10
	ld.w $t0, $fp, -108
	addi.w $t1, $zero, 10
	slt $t0, $t0, $t1
	st.b $t0, $fp, -109
# %op8 = zext i1 %op7 to i32
	ld.b $t0, $fp, -109
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -116
# %op9 = icmp sgt i32 %op8, 0
	ld.w $t0, $fp, -116
	addi.w $t1, $zero, 0
	slt $t0, $t1, $t0
	st.b $t0, $fp, -117
# br i1 %op9, label %label_whileBB6, label %label_nextBB4
	ld.b $t0, $fp, -117
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_whileBB6
	b .main_label_nextBB4
.main_label_whileBB6:
# %op10 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 0
	ld.d $t0, $fp, -24
	addi.w $t1, $zero, 0
	addi.w $t2, $zero, 0
	lu12i.w $t4, 0
	ori $t4, $t4, 4
	lu12i.w $t3, 0
	ori $t3, $t3, 40
	mul.w $t1, $t1, $t3
	mul.w $t2, $t2, $t4
	bstrpick.d $t1, $t1, 31, 0
	bstrpick.d $t2, $t2, 31, 0
	add.d $t0, $t0, $t1
	add.d $t0, $t0, $t2
	st.d $t0, $fp, -128
# %op11 = load i32, i32* %op1
	ld.d $t0, $fp, -72
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -132
# %op12 = load i32, i32* %op1
	ld.d $t0, $fp, -72
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -136
# %op13 = mul i32 %op12, 2
	ld.w $t0, $fp, -136
	addi.w $t1, $zero, 2
	mul.w $t2, $t0, $t1
	st.w $t2, $fp, -140
# %op14 = call i32 @store(i32* %op10, i32 %op11, i32 %op13)
	ld.d $a0, $fp, -128
	ld.w $a1, $fp, -132
	ld.w $a2, $fp, -140
	bl store
	st.w $a0, $fp, -144
# %op15 = load i32, i32* %op1
	ld.d $t0, $fp, -72
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -148
# %op16 = load i32, i32* %op1
	ld.d $t0, $fp, -72
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -152
# %op17 = add i32 %op16, 1
	ld.w $t0, $fp, -152
	addi.w $t1, $zero, 1
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -156
# store i32 %op17, i32* %op1
	ld.d $t0, $fp, -72
	ld.w $t1, $fp, -156
	st.w $t1, $t0, 0
# br label %label_cmpBB5
	b .main_label_cmpBB5
.main_label_nextBB7:
# %op18 = load i32, i32* %op2
	ld.d $t0, $fp, -88
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -160
# call void @output(i32 %op18)
	ld.w $a0, $fp, -160
	bl output
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 224
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label_cmpBB8:
# %op19 = load i32, i32* %op1
	ld.d $t0, $fp, -72
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -164
# %op20 = icmp slt i32 %op19, 10
	ld.w $t0, $fp, -164
	addi.w $t1, $zero, 10
	slt $t0, $t0, $t1
	st.b $t0, $fp, -165
# %op21 = zext i1 %op20 to i32
	ld.b $t0, $fp, -165
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -172
# %op22 = icmp sgt i32 %op21, 0
	ld.w $t0, $fp, -172
	addi.w $t1, $zero, 0
	slt $t0, $t1, $t0
	st.b $t0, $fp, -173
# br i1 %op22, label %label_whileBB9, label %label_nextBB7
	ld.b $t0, $fp, -173
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_whileBB9
	b .main_label_nextBB7
.main_label_whileBB9:
# %op23 = load i32, i32* %op2
	ld.d $t0, $fp, -88
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -180
# %op24 = load i32, i32* %op2
	ld.d $t0, $fp, -88
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -184
# %op25 = load i32, i32* %op1
	ld.d $t0, $fp, -72
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -188
# %op26 = icmp sge i32 %op25, 0
	ld.w $t0, $fp, -188
	addi.w $t1, $zero, 0
	addi.w $t0, $t0, 1
	slt $t0, $t1, $t0
	st.b $t0, $fp, -189
# br i1 %op26, label %label_nextBB10, label %label_negBB11
	ld.b $t0, $fp, -189
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_nextBB10
	b .main_label_negBB11
.main_label_nextBB10:
# %op27 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 %op25
	ld.d $t0, $fp, -24
	addi.w $t1, $zero, 0
	ld.w $t2, $fp, -188
	lu12i.w $t4, 0
	ori $t4, $t4, 4
	lu12i.w $t3, 0
	ori $t3, $t3, 40
	mul.w $t1, $t1, $t3
	mul.w $t2, $t2, $t4
	bstrpick.d $t1, $t1, 31, 0
	bstrpick.d $t2, $t2, 31, 0
	add.d $t0, $t0, $t1
	add.d $t0, $t0, $t2
	st.d $t0, $fp, -200
# %op28 = load i32, i32* %op27
	ld.d $t0, $fp, -200
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -204
# %op29 = add i32 %op24, %op28
	ld.w $t0, $fp, -184
	ld.w $t1, $fp, -204
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -208
# store i32 %op29, i32* %op2
	ld.d $t0, $fp, -88
	ld.w $t1, $fp, -208
	st.w $t1, $t0, 0
# %op30 = load i32, i32* %op1
	ld.d $t0, $fp, -72
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -212
# %op31 = load i32, i32* %op1
	ld.d $t0, $fp, -72
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -216
# %op32 = add i32 %op31, 1
	ld.w $t0, $fp, -216
	addi.w $t1, $zero, 1
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -220
# store i32 %op32, i32* %op1
	ld.d $t0, $fp, -72
	ld.w $t1, $fp, -220
	st.w $t1, $t0, 0
# br label %label_cmpBB8
	b .main_label_cmpBB8
.main_label_negBB11:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label_nextBB10
	b .main_label_nextBB10
	addi.d $sp, $sp, 224
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
