# Global variables
	.text
	.section .bss, "aw", @nobits
	.globl seed
	.type seed, @object
	.size seed, 4
seed:
	.space 4
	.text
	.globl randomLCG
	.type randomLCG, @function
randomLCG:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -48
.randomLCG_label_entry0:
# %op0 = load i32, i32* @seed
	la.local $t0, seed
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -20
# %op1 = load i32, i32* @seed
	la.local $t0, seed
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -24
# %op2 = mul i32 %op1, 1103515245
	ld.w $t0, $fp, -24
	lu12i.w $t1, 269412
	ori $t1, $t1, 3693
	mul.w $t2, $t0, $t1
	st.w $t2, $fp, -28
# %op3 = add i32 %op2, 12345
	ld.w $t0, $fp, -28
	lu12i.w $t1, 3
	ori $t1, $t1, 57
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -32
# store i32 %op3, i32* @seed
	la.local $t0, seed
	ld.w $t1, $fp, -32
	st.w $t1, $t0, 0
# %op4 = load i32, i32* @seed
	la.local $t0, seed
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -36
# ret i32 %op4
	ld.w $a0, $fp, -36
	addi.d $sp, $sp, 48
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	addi.d $sp, $sp, 48
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	.globl randBin
	.type randBin, @function
randBin:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -32
.randBin_label_entry1:
# %op0 = call i32 @randomLCG()
	bl randomLCG
	st.w $a0, $fp, -20
# %op1 = icmp sgt i32 %op0, 0
	ld.w $t0, $fp, -20
	addi.w $t1, $zero, 0
	slt $t0, $t1, $t0
	st.b $t0, $fp, -21
# %op2 = zext i1 %op1 to i32
	ld.b $t0, $fp, -21
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -28
# %op3 = icmp sgt i32 %op2, 0
	ld.w $t0, $fp, -28
	addi.w $t1, $zero, 0
	slt $t0, $t1, $t0
	st.b $t0, $fp, -29
# br i1 %op3, label %label_trueBB3, label %label_falseBB4
	ld.b $t0, $fp, -29
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .randBin_label_trueBB3
	b .randBin_label_falseBB4
.randBin_label_nextBB2:
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 32
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.randBin_label_trueBB3:
# ret i32 1
	addi.w $a0, $zero, 1
	addi.d $sp, $sp, 32
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.randBin_label_falseBB4:
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 32
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	addi.d $sp, $sp, 32
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	.globl returnToZeroSteps
	.type returnToZeroSteps, @function
returnToZeroSteps:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -144
.returnToZeroSteps_label_entry5:
# %op0 = alloca i32
	addi.d $t1, $fp, -28
	st.d $t1, $fp, -24
# %op1 = alloca i32
	addi.d $t1, $fp, -44
	st.d $t1, $fp, -40
# %op2 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -48
# store i32 0, i32* %op0
	ld.d $t0, $fp, -24
	addi.w $t1, $zero, 0
	st.w $t1, $t0, 0
# %op3 = load i32, i32* %op1
	ld.d $t0, $fp, -40
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -52
# store i32 0, i32* %op1
	ld.d $t0, $fp, -40
	addi.w $t1, $zero, 0
	st.w $t1, $t0, 0
# br label %label_cmpBB7
	b .returnToZeroSteps_label_cmpBB7
.returnToZeroSteps_label_nextBB6:
# ret i32 20
	addi.w $a0, $zero, 20
	addi.d $sp, $sp, 144
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.returnToZeroSteps_label_cmpBB7:
# %op4 = load i32, i32* %op1
	ld.d $t0, $fp, -40
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -56
# %op5 = icmp slt i32 %op4, 20
	ld.w $t0, $fp, -56
	addi.w $t1, $zero, 20
	slt $t0, $t0, $t1
	st.b $t0, $fp, -57
# %op6 = zext i1 %op5 to i32
	ld.b $t0, $fp, -57
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -64
# %op7 = icmp sgt i32 %op6, 0
	ld.w $t0, $fp, -64
	addi.w $t1, $zero, 0
	slt $t0, $t1, $t0
	st.b $t0, $fp, -65
# br i1 %op7, label %label_whileBB8, label %label_nextBB6
	ld.b $t0, $fp, -65
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .returnToZeroSteps_label_whileBB8
	b .returnToZeroSteps_label_nextBB6
.returnToZeroSteps_label_whileBB8:
# %op8 = call i32 @randBin()
	bl randBin
	st.w $a0, $fp, -72
# %op9 = icmp sgt i32 %op8, 0
	ld.w $t0, $fp, -72
	addi.w $t1, $zero, 0
	slt $t0, $t1, $t0
	st.b $t0, $fp, -73
# br i1 %op9, label %label_trueBB10, label %label_falseBB11
	ld.b $t0, $fp, -73
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .returnToZeroSteps_label_trueBB10
	b .returnToZeroSteps_label_falseBB11
.returnToZeroSteps_label_nextBB9:
# %op10 = load i32, i32* %op1
	ld.d $t0, $fp, -40
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -80
# %op11 = load i32, i32* %op1
	ld.d $t0, $fp, -40
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -84
# %op12 = add i32 %op11, 1
	ld.w $t0, $fp, -84
	addi.w $t1, $zero, 1
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -88
# store i32 %op12, i32* %op1
	ld.d $t0, $fp, -40
	ld.w $t1, $fp, -88
	st.w $t1, $t0, 0
# %op13 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -92
# %op14 = icmp eq i32 %op13, 0
	ld.w $t0, $fp, -92
	addi.w $t1, $zero, 0
	slt $t2, $t0, $t1
	slt $t3, $t1, $t0
	nor $t0, $t2, $t3
	st.b $t0, $fp, -93
# %op15 = zext i1 %op14 to i32
	ld.b $t0, $fp, -93
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -100
# %op16 = icmp sgt i32 %op15, 0
	ld.w $t0, $fp, -100
	addi.w $t1, $zero, 0
	slt $t0, $t1, $t0
	st.b $t0, $fp, -101
# br i1 %op16, label %label_trueBB13, label %label_nextBB12
	ld.b $t0, $fp, -101
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .returnToZeroSteps_label_trueBB13
	b .returnToZeroSteps_label_nextBB12
.returnToZeroSteps_label_trueBB10:
# %op17 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -108
# %op18 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -112
# %op19 = add i32 %op18, 1
	ld.w $t0, $fp, -112
	addi.w $t1, $zero, 1
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -116
# store i32 %op19, i32* %op0
	ld.d $t0, $fp, -24
	ld.w $t1, $fp, -116
	st.w $t1, $t0, 0
# br label %label_nextBB9
	b .returnToZeroSteps_label_nextBB9
.returnToZeroSteps_label_falseBB11:
# %op20 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -120
# %op21 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -124
# %op22 = sub i32 %op21, 1
	ld.w $t0, $fp, -124
	addi.w $t1, $zero, 1
	sub.w $t2, $t0, $t1
	st.w $t2, $fp, -128
# store i32 %op22, i32* %op0
	ld.d $t0, $fp, -24
	ld.w $t1, $fp, -128
	st.w $t1, $t0, 0
# br label %label_nextBB9
	b .returnToZeroSteps_label_nextBB9
.returnToZeroSteps_label_nextBB12:
# br label %label_cmpBB7
	b .returnToZeroSteps_label_cmpBB7
.returnToZeroSteps_label_trueBB13:
# %op23 = load i32, i32* %op1
	ld.d $t0, $fp, -40
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -132
# ret i32 %op23
	ld.w $a0, $fp, -132
	addi.d $sp, $sp, 144
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	addi.d $sp, $sp, 144
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
	.globl main
	.type main, @function
main:
	st.d $ra, $sp, -8
	st.d $fp, $sp, -16
	addi.d $fp, $sp, 0
	addi.d $sp, $sp, -80
.main_label_entry14:
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
# %op2 = load i32, i32* @seed
	la.local $t0, seed
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -36
# store i32 3407, i32* @seed
	la.local $t0, seed
	lu12i.w $t1, 0
	ori $t1, $t1, 3407
	st.w $t1, $t0, 0
# br label %label_cmpBB16
	b .main_label_cmpBB16
.main_label_nextBB15:
# ret i32 0
	addi.w $a0, $zero, 0
	addi.d $sp, $sp, 80
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
.main_label_cmpBB16:
# %op3 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -40
# %op4 = icmp slt i32 %op3, 20
	ld.w $t0, $fp, -40
	addi.w $t1, $zero, 20
	slt $t0, $t0, $t1
	st.b $t0, $fp, -41
# %op5 = zext i1 %op4 to i32
	ld.b $t0, $fp, -41
	bstrpick.w $t0, $t0, 0, 0
	st.w $t0, $fp, -48
# %op6 = icmp sgt i32 %op5, 0
	ld.w $t0, $fp, -48
	addi.w $t1, $zero, 0
	slt $t0, $t1, $t0
	st.b $t0, $fp, -49
# br i1 %op6, label %label_whileBB17, label %label_nextBB15
	ld.b $t0, $fp, -49
	bstrpick.d $t1, $t0, 0, 0
	bnez $t1, .main_label_whileBB17
	b .main_label_nextBB15
.main_label_whileBB17:
# %op7 = call i32 @returnToZeroSteps()
	bl returnToZeroSteps
	st.w $a0, $fp, -56
# call void @output(i32 %op7)
	ld.w $a0, $fp, -56
	bl output
# %op8 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -60
# %op9 = load i32, i32* %op0
	ld.d $t0, $fp, -24
	ld.d $t0, $t0, 0
	st.w $t0, $fp, -64
# %op10 = add i32 %op9, 1
	ld.w $t0, $fp, -64
	addi.w $t1, $zero, 1
	add.w $t2, $t0, $t1
	st.w $t2, $fp, -68
# store i32 %op10, i32* %op0
	ld.d $t0, $fp, -24
	ld.w $t1, $fp, -68
	st.w $t1, $t0, 0
# br label %label_cmpBB16
	b .main_label_cmpBB16
	addi.d $sp, $sp, 80
	ld.d $ra, $sp, -8
	ld.d $fp, $sp, -16
	jr $ra
