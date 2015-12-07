# Test File for 40 Instruction, include:
# 1. Subset 1:
# ADD/SUB/SLL/SRL/SRA/SLLV/SRLV/SRAV/AND/OR/XOR/NOR/  
# SLT															12				
# 2. Subset 2:
# ADDI/ANDI/ORI/XORI/LUI/SLTI									6
# 3. Subset 3:
# LB/LH/LW/SB/SH/SW 											6
# 4. Subset 4:
# BEQ/BNE/BGEZ/BGTZ/BLEZ/BLTZ									6
# 5. Subset 5:
# J/JAL/JR/JALR													4
# 6. Subset 6:
# MULT/DIV/MFLO/MFHI/MTLO/MTHI									6
# 																40
##################################################################
### Make sure following Settings :
# Settings -> Memory Configuration -> Compact, Data at address 0
# Settings -> Delayed branching

.data
.globl array cnt
array:
	.word 0:16	# array of 16 words
cnt:
	.word 0		# counter of Branch
.text
	##################
	# Test Subset 2  #
	ori $v0, $0, 0x1234
	lui $v1, 0x9876
	addi $a0, $v0, 0x3456
	addi $a1, $v1, -1024
	xori $a2, $v0, 0xabcd
	slti $a1, $a0, 0x34
	slti $a1, $v0, -1
	andi $a3, $a2, 0x7654
	slti $t0, $v1, 0x1234 
	
	
	##################
	# Test Subset 1  #
	sub $t0, $v1, $v0
	xor $t1, $t0, $v1
	add $t2, $t1, $t0
	add $t2, $t2, $v0
	sub $t3, $t2, $v1
	nor $t4, $t3, $t2
	or  $t5, $t3, $t2
	and $t6, $t3, $t2
	slt $s3, $t5, $t4
	slt $s4, $t5, $t4
	
	### Test for shift
	sll $t0, $t0, 3
	srl $t1, $t0, 16
	sra $t2, $t0, 29
	addi $t3, $0, 0x3410	# pay attention to register shift
	sllv $t4, $t0, $t3
	srlv $t5, $t0, $t3
	srav $t6, $t0, $t3
	
	
	##################
	# Test Subset 3  #
	add $a0, $v0, $v1
	la $sp, array
	
	### Test for store
	sw $a0, 0($sp)
	sw $a0, 4($sp)
	sw $a0, 8($sp)
	sh $t0, 4($sp)
	sh $t1, 10($sp)
	sb $t2, 7($sp)
	sb $t0, 9($sp)
	sb $t1, 8($sp)
	
	### Test for load
	lw $t0, 0($sp)
	nop
	nop
	sw $t0, 12($sp)
	lh $t1, 2($sp)
	nop
	nop
	sw $t1, 16($sp)
	lh $t1, 2($sp)
	nop
	nop
	sw $t1, 20($sp)
	lb $t2, 3($sp)
	nop
	nop
	sw $t2, 24($sp)
	lb $t2, 3($sp)
	nop
	nop
	sw $t2, 28($sp)
	lb $t2, 1($sp)
	nop
	nop
	sw $t2, 32($sp)

	
	##################
	# Test Subset 4  #
	la $sp, cnt
	sw $0, 0($sp)
	and $v0, $0, $t0
	nop
	nop
	bne $t0, $t1, _lb1
	nop
	addi $v0, $v0, 1

	_lb1:
	bgtz $t0, _lb2
	nop
	addi $v0, $v0, 1

	_lb2:
	blez $t0, _lb3
	nop
	addi $v0, $v0, 1

	_lb3:
	bltz $t1, _lb4
	nop
	addi $v0, $v0, 1

	_lb4:
	bgez $t0, _lb5
	nop
	addi $v0, $v0, 1

	_lb5:
	beq $t1, $t2, _lb6
	nop
	addi $v0, $v0, 1

	_lb6:
	sw $v0, 0($sp)

	
	##################
	# Test Subset 5  #
	la $sp, cnt
	lw $v0, 0($sp)
	j _target
	nop
	add $v0, $v0, $t0

	_target:
	addi $v0, $v0, 1
	jal F_Test_JAL
	nop
	add $a1, $a1, $v0
	
	##################
	#    Save GPR    #
	sw $0,96($0)
	sw $1,100($0)
	sw $2,104($0)
	sw $3,108($0)
	sw $4,112($0)
	sw $5,116($0)
	sw $6,120($0)
	sw $7,124($0)
	sw $8,128($0)
	sw $9,132($0)
	sw $10,136($0)
	sw $11,140($0)
	sw $12,144($0)
	sw $13,148($0)
	sw $14,152($0)
	sw $15,156($0)
	sw $16,160($0)
	sw $17,164($0)
	sw $18,168($0)
	sw $19,172($0)
	sw $20,176($0)
	sw $21,180($0)
	sw $22,184($0)
	sw $23,188($0)
	sw $24,192($0)
	sw $25,196($0)
	sw $26,200($0)
	sw $27,204($0)
	sw $28,208($0)
	sw $29,212($0)
	sw $30,216($0)
	sw $31,220($0)
	
	
	##################
	# Test Subset 6  #


	
	
	_loop:
	j _loop		# Dead loop
	nop

F_Test_JAL:
	la $sp, array
	sw $ra, 40($sp)
	ori $v0, $v0, 0x5500
	la $t1, F_Test_JALR
	nop
	jalr $t1
	nop
	la $sp, cnt
	sw $v0, 0($sp)
	la $sp, array
	lw $ra, 40($sp)
	jr $ra
	nop
	
F_Test_JALR:
	la $sp, array
	sw $ra, 44($sp)
	ori $v0, $v0, 0x50
	jr $ra
	nop
