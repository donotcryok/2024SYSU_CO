.text
program:
	addi $s0,$zero,0
	addi $s1,$zero,0
	addi $a0,$zero,0x00002000
	lw $t0,0($a0)
	andi $v0,$t0,0xC0000000
	addi $a0,$zero,1
	andi $t1,$t0,0x3FFF8000
	andi $t3,$t1,0x20000000
	beq $t3,$zero,pos
	addi $t5,$t1,0xC0000000
	addi $t1,$t5,0
	pos:
	addi $v1,$zero,15
	srav $t5,$t1,$v1
	addi $t1,$t5,0
	andi $t2,$t0,0x00007FFF
	andi $t3,$t2,0x00004000
	beq $t3,$zero,pos2
	addi $t5,$t2,0xFFFF8000
	addi $t2,$t5,0
	pos2:
	addi $a0,$zero,1
	addi $a1,$zero,0
	beq $v0,$a1,add
	addi $a1,$zero,0x40000000
	beq $v0,$a1,sub
	addi $a1,$zero,0x80000000
	beq $v0,$a1,mul
	j div
add:
	add $s0,$t2,$t1
	j end
sub:
	sub $s0,$t1,$t2
	j end
mul:
	addi $s0,$zero,0
	andi $v0,$t1,1
	addi $a0,$zero,1
	beq $v0,$a0,goadd
	j loop
	goadd:
		sub $s0,$zero,$t2
	loop:
		sllv $t5,$t2,$a0
		addi $t2,$t5,0
		andi $v0,$t1,1
		andi $v1,$t1,2
		srav $t5,$v1,$a0
		addi $v1,$t5,0
		slt $a1,$v0,$v1
		beq $a1,$a0,jf
		add $t5,$s0,$t2
		addi $s0,$t5,0
		slt $a1,$v1,$v0
		beq $a1,$a0,jf2
		jf:	
		sub $t5,$s0,$t2
		addi $s0,$t5,0
		jf2:
		srav $t5,$t1,$a0
		addi $t1,$t5,0
		beq $t1,$zero,end
		addi $t8,$zero,0xFFFFFFFF
		beq $t1,$t8,end
		j loop
div:
	xor $k1,$t1,$t2
	andi $t5,$k1,0x80000000
	addi $k1,$t5,0
	slt $k0,$t1,$zero
	slt $t9,$t2,$zero
	addi $t8,$k0,0
	beq $k0,$zero,not_fz
	xori $t5,$t1,0xFFFFFFFF
	addi $t1,$t5,0
	addi $t5,$t1,1
	addi $t1,$t5,0
	not_fz:
	slt $k0,$t2,$zero
	beq $k0,$zero,not_fz2
	xori $t5,$t2,0xFFFFFFFF
	addi $t2,$t5,0
	addi $t5,$t2,1
	addi $t2,$t5,0
	not_fz2:
	addi $s1,$zero,0
	addi $t7,$zero,33
	loop2:
		addi $t5,$t7,-1
		addi $t7,$t5,0
		beq $t7,$zero,end1
		slt $t0,$t1,$zero
		sllv $t5,$s0,$a0
		addi $s0,$t5,0
		sllv $t5,$s1,$a0
		addi $s1,$t5,0
		add $t5,$s1,$t0
		addi $s1,$t5,0
		sub $t5,$s1,$t2
		addi $s1,$t5,0
		slt $t0,$s1,$zero
		sub $t0,$a0,$t0
		add $t5,$s0,$t0
		addi $s0,$t5,0
		beq $t0,$a0,not_turn_back
		add $t5,$s1,$t2
		addi $s1,$t5,0
		not_turn_back:
		sllv $t5,$t1,$a0
		addi $t1,$t5,0
		j loop2	
	end1:
	addi $a0,$zero,1
	beq $t8,$a0,neg_t1
	beq $t9,$a0,pos_t1_neg_t2
	pos_t1:
	pos_t1_pos_t2:
		j end
	pos_t1_neg_t2:
		xori $t5,$s0,0xFFFFFFFF
		addi $s0,$t5,1
		j end
	neg_t1:
	beq $t9,$a0,neg_t1_neg_t2
	neg_t1_pos_t2:
		xori $t5,$s0,0xFFFFFFFF
		addi $s0,$t5,1
		beq $s1,$zero,end
		addi $t5,$s0,-1
		addi $s0,$t5,0
		sub $t5,$t2,$s1
		addi $s1,$t5,0
		j end
	neg_t1_neg_t2:
		beq $s1,$zero,end
		addi $t5,$s0,1
		addi $s0,$t5,0
		sub $t5,$t2,$s1
		addi $s1,$t5,0
		j end
#	beq $k1,$zero,not_cl
#	xori $t5,$s0,0xFFFFFFFF
#	addi $s0,$t5,0
#	addi $t5,$s0,1
#	addi $s0,$t5,0
#	beq $s1,$zero,not_cl
#	addi $t5,$s0,-1
#	addi $s0,$t5,0
#	sub $s1,$t2,$s1
#	j end
#	not_cl:
#	sub $t8,$a0,$t8
#	beq $t8,$t9,end
#	beq $t9,$zero,end
#	beq $s1,$zero,end
#	addi $t5,$s0,1
#	addi $s0,$t5,0
#	sub $s1,$t2,$s1
end:	
	addi $s2,$s0,0
	addi $s3,$s1,0