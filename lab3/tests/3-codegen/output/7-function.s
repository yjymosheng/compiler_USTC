	.text
	.globl min
	.type min, @function
min:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -80
	st.w $a0, $fp, -20
	st.w $a1, $fp, -24
.min_label_entry0:
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
# %op6 = icmp sle i32 %op4, %op5
	ld.w $t0, $fp, -56
	ld.w $t1, $fp, -60
	addi.w $t1, $t1, 1
	slt $t0, $t0, $t1
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
	bnez $t1, .min_label_trueBB2
	b .min_label_falseBB3
.min_label_nextBB1:
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 80
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.min_label_trueBB2:
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
.min_label_falseBB3:
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
	.globl main
	.type main, @function
main:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -112
.main_label_entry4:
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
# %op8 = call i32 @min(i32 %op6, i32 %op7)
	ld.w $a0, $fp, -76
	ld.w $a1, $fp, -80
	bl min
	st.w $a0, $fp, -84
# call void @output(i32 %op8)
	ld.w $a0, $fp, -84
	bl output
# %op9 = load i32, i32* %op1
	ld.d $t0, $fp, -40
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -88
# %op10 = load i32, i32* %op2
	ld.d $t0, $fp, -56
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -92
# %op11 = call i32 @min(i32 %op9, i32 %op10)
	ld.w $a0, $fp, -88
	ld.w $a1, $fp, -92
	bl min
	st.w $a0, $fp, -96
# call void @output(i32 %op11)
	ld.w $a0, $fp, -96
	bl output
# %op12 = load i32, i32* %op2
	ld.d $t0, $fp, -56
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -100
# %op13 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -104
# %op14 = call i32 @min(i32 %op12, i32 %op13)
	ld.w $a0, $fp, -100
	ld.w $a1, $fp, -104
	bl min
	st.w $a0, $fp, -108
# call void @output(i32 %op14)
	ld.w $a0, $fp, -108
	bl output
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 112
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	addi.d $sp, $sp, 112
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
