	.text
	.globl main
	.type main, @function
main:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -192
.main_label_entry0:
# %op0 = alloca [10 x i32]
	addi.d $t1, $fp, -64
	st.d $t1, $fp, -24
# %op1 = alloca i32
	addi.d $t1, $fp, -76
	st.d $t1, $fp, -72
# %op2 = load i32, i32* %op1
	ld.d $t0, $fp, -72
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -80
# store i32 0, i32* %op1
	ld.d $t0, $fp, -72
	addi.w $t1, $zero, 0
	st.w $t1, $t0, 0
# %op3 = icmp sge i32 0, 0
	addi.w $t0, $zero, 0
	addi.w $t1, $zero, 0
	addi.w $t0, $t0, 1
	slt $t0, $t1, $t0
	st.b $t0, $fp, -81
# br i1 %op3, label %label_nextBB1, label %label_negBB2
	ld.b $t0, $fp, -81
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_nextBB1
	b .main_label_negBB2
.main_label_nextBB1:
# %op4 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 0
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
	st.d $t0, $fp, -96
# %op5 = load i32, i32* %op4
	ld.d $t0, $fp, -96
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -100
# store i32 11, i32* %op4
	ld.d $t0, $fp, -96
	addi.w $t1, $zero, 11
	st.w $t1, $t0, 0
# %op6 = icmp sge i32 4, 0
	addi.w $t0, $zero, 4
	addi.w $t1, $zero, 0
	addi.w $t0, $t0, 1
	slt $t0, $t1, $t0
	st.b $t0, $fp, -101
# br i1 %op6, label %label_nextBB3, label %label_negBB4
	ld.b $t0, $fp, -101
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_nextBB3
	b .main_label_negBB4
.main_label_negBB2:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label_nextBB1
	b .main_label_nextBB1
.main_label_nextBB3:
# %op7 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 4
	ld.d $t0, $fp, -24
	addi.w $t1, $zero, 0
	addi.w $t2, $zero, 4
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
	st.d $t0, $fp, -112
# %op8 = load i32, i32* %op7
	ld.d $t0, $fp, -112
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -116
# store i32 22, i32* %op7
	ld.d $t0, $fp, -112
	addi.w $t1, $zero, 22
	st.w $t1, $t0, 0
# %op9 = icmp sge i32 9, 0
	addi.w $t0, $zero, 9
	addi.w $t1, $zero, 0
	addi.w $t0, $t0, 1
	slt $t0, $t1, $t0
	st.b $t0, $fp, -117
# br i1 %op9, label %label_nextBB5, label %label_negBB6
	ld.b $t0, $fp, -117
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_nextBB5
	b .main_label_negBB6
.main_label_negBB4:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label_nextBB3
	b .main_label_nextBB3
.main_label_nextBB5:
# %op10 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 9
	ld.d $t0, $fp, -24
	addi.w $t1, $zero, 0
	addi.w $t2, $zero, 9
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
# %op11 = load i32, i32* %op10
	ld.d $t0, $fp, -128
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -132
# store i32 33, i32* %op10
	ld.d $t0, $fp, -128
	addi.w $t1, $zero, 33
	st.w $t1, $t0, 0
# %op12 = icmp sge i32 0, 0
	addi.w $t0, $zero, 0
	addi.w $t1, $zero, 0
	addi.w $t0, $t0, 1
	slt $t0, $t1, $t0
	st.b $t0, $fp, -133
# br i1 %op12, label %label_nextBB7, label %label_negBB8
	ld.b $t0, $fp, -133
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_nextBB7
	b .main_label_negBB8
.main_label_negBB6:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label_nextBB5
	b .main_label_nextBB5
.main_label_nextBB7:
# %op13 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 0
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
	st.d $t0, $fp, -144
# %op14 = load i32, i32* %op13
	ld.d $t0, $fp, -144
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -148
# call void @output(i32 %op14)
	ld.w $a0, $fp, -148
	bl output
# %op15 = icmp sge i32 4, 0
	addi.w $t0, $zero, 4
	addi.w $t1, $zero, 0
	addi.w $t0, $t0, 1
	slt $t0, $t1, $t0
	st.b $t0, $fp, -149
# br i1 %op15, label %label_nextBB9, label %label_negBB10
	ld.b $t0, $fp, -149
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_nextBB9
	b .main_label_negBB10
.main_label_negBB8:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label_nextBB7
	b .main_label_nextBB7
.main_label_nextBB9:
# %op16 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 4
	ld.d $t0, $fp, -24
	addi.w $t1, $zero, 0
	addi.w $t2, $zero, 4
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
	st.d $t0, $fp, -160
# %op17 = load i32, i32* %op16
	ld.d $t0, $fp, -160
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -164
# call void @output(i32 %op17)
	ld.w $a0, $fp, -164
	bl output
# %op18 = icmp sge i32 9, 0
	addi.w $t0, $zero, 9
	addi.w $t1, $zero, 0
	addi.w $t0, $t0, 1
	slt $t0, $t1, $t0
	st.b $t0, $fp, -165
# br i1 %op18, label %label_nextBB11, label %label_negBB12
	ld.b $t0, $fp, -165
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_nextBB11
	b .main_label_negBB12
.main_label_negBB10:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label_nextBB9
	b .main_label_nextBB9
.main_label_nextBB11:
# %op19 = getelementptr [10 x i32], [10 x i32]* %op0, i32 0, i32 9
	ld.d $t0, $fp, -24
	addi.w $t1, $zero, 0
	addi.w $t2, $zero, 9
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
	st.d $t0, $fp, -176
# %op20 = load i32, i32* %op19
	ld.d $t0, $fp, -176
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -180
# call void @output(i32 %op20)
	ld.w $a0, $fp, -180
	bl output
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 192
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label_negBB12:
# call void @neg_idx_except()
	bl neg_idx_except
# br label %label_nextBB11
	b .main_label_nextBB11
	addi.d $sp, $sp, 192
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
