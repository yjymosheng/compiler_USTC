	.text
	.globl main
	.type main, @function
main:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -96
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
# store i32 23, i32* %op0
	ld.d $t0, $fp, -24
	addi.w $t1, $zero, 23
	st.w $t1, $t0, 0
# %op4 = load i32, i32* %op1
	ld.d $t0, $fp, -40
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -68
# store i32 25, i32* %op1
	ld.d $t0, $fp, -40
	addi.w $t1, $zero, 25
	st.w $t1, $t0, 0
# %op5 = load i32, i32* %op2
	ld.d $t0, $fp, -56
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -72
# store i32 4, i32* %op2
	ld.d $t0, $fp, -56
	addi.w $t1, $zero, 4
	st.w $t1, $t0, 0
# %op6 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -76
# %op7 = load i32, i32* %op1
	ld.d $t0, $fp, -40
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -80
# %op8 = load i32, i32* %op2
	ld.d $t0, $fp, -56
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -84
# %op9 = mul i32 %op7, %op8
	ld.w $t0, $fp, -80
	ld.w $t1, $fp, -84
	mul.w $t2, $t0, $t1
	st.w $t2, $fp, -88
# %op10 = add i32 %op6, %op9
	ld.w $t0, $fp, -76
	ld.w $t1, $fp, -88
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -92
# ret i32 %op10
	ld.w $a0, $fp, -92
	addi.d $sp, $sp, 96
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	addi.d $sp, $sp, 96
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
