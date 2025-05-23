	.text
	.globl main
	.type main, @function
main:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -160
.main_label_entry0:
# %op0 = alloca i32
	addi.d $t1, $fp, -28
	st.d $t1, $fp, -24
# %op1 = alloca i32
	addi.d $t1, $fp, -44
	st.d $t1, $fp, -40
# %op2 = alloca i32
	addi.d $t1, $fp, -60
	st.d $t1, $fp, -56
# %op3 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -64
# store i32 11, i32* %op0
	ld.d $t0, $fp, -24
	addi.w $t1, $zero, 11
	st.w $t1, $t0, 0
# %op4 = load i32, i32* %op1
	ld.d $t0, $fp, -40
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -68
# store i32 22, i32* %op1
	ld.d $t0, $fp, -40
	addi.w $t1, $zero, 22
	st.w $t1, $t0, 0
# %op5 = load i32, i32* %op2
	ld.d $t0, $fp, -56
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -72
# store i32 33, i32* %op2
	ld.d $t0, $fp, -56
	addi.w $t1, $zero, 33
	st.w $t1, $t0, 0
# %op6 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -76
# %op7 = load i32, i32* %op1
	ld.d $t0, $fp, -40
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -80
# %op8 = icmp sgt i32 %op6, %op7
	ld.w $t0, $fp, -76
	ld.w $t1, $fp, -80
	slt $t0, $t1, $t0
	st.b $t0, $fp, -81
# %op9 = zext i1 %op8 to i32
	ld.b $t0, $fp, -81
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -88
# %op10 = icmp sgt i32 %op9, 0
	ld.w $t0, $fp, -88
	addi.w $t1, $zero, 0
	slt $t0, $t1, $t0
	st.b $t0, $fp, -89
# br i1 %op10, label %label_trueBB2, label %label_falseBB3
	ld.b $t0, $fp, -89
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_trueBB2
	b .main_label_falseBB3
.main_label_nextBB1:
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 160
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label_trueBB2:
# %op11 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -96
# %op12 = load i32, i32* %op2
	ld.d $t0, $fp, -56
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -100
# %op13 = icmp sgt i32 %op11, %op12
	ld.w $t0, $fp, -96
	ld.w $t1, $fp, -100
	slt $t0, $t1, $t0
	st.b $t0, $fp, -101
# %op14 = zext i1 %op13 to i32
	ld.b $t0, $fp, -101
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -108
# %op15 = icmp sgt i32 %op14, 0
	ld.w $t0, $fp, -108
	addi.w $t1, $zero, 0
	slt $t0, $t1, $t0
	st.b $t0, $fp, -109
# br i1 %op15, label %label_trueBB5, label %label_falseBB6
	ld.b $t0, $fp, -109
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_trueBB5
	b .main_label_falseBB6
.main_label_falseBB3:
# %op16 = load i32, i32* %op2
	ld.d $t0, $fp, -56
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -116
# %op17 = load i32, i32* %op1
	ld.d $t0, $fp, -40
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -120
# %op18 = icmp slt i32 %op16, %op17
	ld.w $t0, $fp, -116
	ld.w $t1, $fp, -120
	slt $t0, $t0, $t1
	st.b $t0, $fp, -121
# %op19 = zext i1 %op18 to i32
	ld.b $t0, $fp, -121
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -128
# %op20 = icmp sgt i32 %op19, 0
	ld.w $t0, $fp, -128
	addi.w $t1, $zero, 0
	slt $t0, $t1, $t0
	st.b $t0, $fp, -129
# br i1 %op20, label %label_trueBB8, label %label_falseBB9
	ld.b $t0, $fp, -129
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_trueBB8
	b .main_label_falseBB9
.main_label_nextBB4:
# br label %label_nextBB1
	b .main_label_nextBB1
.main_label_trueBB5:
# %op21 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -136
# call void @output(i32 %op21)
	ld.w $a0, $fp, -136
	bl output
# br label %label_nextBB4
	b .main_label_nextBB4
.main_label_falseBB6:
# %op22 = load i32, i32* %op2
	ld.d $t0, $fp, -56
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -140
# call void @output(i32 %op22)
	ld.w $a0, $fp, -140
	bl output
# br label %label_nextBB4
	b .main_label_nextBB4
.main_label_nextBB7:
# br label %label_nextBB1
	b .main_label_nextBB1
.main_label_trueBB8:
# %op23 = load i32, i32* %op1
	ld.d $t0, $fp, -40
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -144
# call void @output(i32 %op23)
	ld.w $a0, $fp, -144
	bl output
# br label %label_nextBB7
	b .main_label_nextBB7
.main_label_falseBB9:
# %op24 = load i32, i32* %op2
	ld.d $t0, $fp, -56
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -148
# call void @output(i32 %op24)
	ld.w $a0, $fp, -148
	bl output
# br label %label_nextBB7
	b .main_label_nextBB7
	addi.d $sp, $sp, 160
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
