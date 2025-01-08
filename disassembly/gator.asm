
	xref	speedset, speedset2, frameoutchk, patchg
	xref	emycol_d

	xdef	gator, gatorpat

gator:
	moveq	#0,d0
	move.b	r_no0(a0),d0
	move.w	gator_move_tbl(pc,d0.w),d1
	jmp	gator_move_tbl(pc,d1.w)

gator_move_tbl:
	dc.w	gatorinit-gator_move_tbl
	dc.w	gatormove-gator_move_tbl

gatorinit:
	move.l	#gatorpat,patbase(a0)
	move.w	#$2300,sproffset(a0)
	ori.b	#4,actflg(a0)
	move.b	#$A,colino(a0)
	move.b	#4,sprpri(a0)
	move.b	#$10,sprhs(a0)
	move.b	#$10,sprvsize(a0)
	move.b	#8,sprhsize(a0)
	bsr.w	speedset
	jsr	emycol_d
	tst.w	d1
	bpl.s	.end
	add.w	d1,yposi(a0)
	move.w	#0,yspeed(a0)
	addq.b	#2,r_no0(a0)

.end:
	rts

gatormove:
	moveq	#0,d0
	move.b	r_no1(a0),d0
	move.w	gatormove_tbl(pc,d0.w),d1
	jsr	gatormove_tbl(pc,d1.w)
	lea	gatorchg,a1
	bsr.w	patchg
	bra.w	frameoutchk

gatormove_tbl:
	dc.w	gator_0-gatormove_tbl
	dc.w	gator_1-gatormove_tbl

gator_0:
	subq.w	#1,$30(a0)
	bpl.s	.jump
	addq.b	#2,r_no1(a0)
	move.w	#-$C0,xspeed(a0)
	move.b	#0,mstno(a0)
	bchg	#0,cddat(a0)
	bne.s	.jump
	neg.w	xspeed(a0)

.jump:
	rts

gator_1:
	bsr.w	checksonic
	bsr.w	speedset2
	jsr	emycol_d
	cmpi.w	#-8,d1
	blt.s	.jump2
	cmpi.w	#$C,d1
	bge.s	.jump2
	add.w	d1,yposi(a0)

.end:
	rts

.jump2:
	subq.b	#2,r_no1(a0)
	move.w	#60-1,$30(a0)
	move.w	#0,xspeed(a0)
	move.b	#1,mstno(a0)
	rts

checksonic:
	move.w	xposi(a0),d0
	sub.w	playerwk+xposi,d0
	bmi.s	.rt

.lft:
	cmpi.w	#$40,d0
	bgt.s	.out
	btst	#0,cddat(a0)
	beq.s	.set
	rts

.rt:
	cmpi.w	#-$40,d0
	blt.s	.out
	btst	#0,cddat(a0)
	beq.s	.out

.set:
	move.b	#2,mstno(a0)
	rts

.out:
	move.b	#0,mstno(a0)
	rts

gatorchg:
	dc.w	gatorchg00-gatorchg
	dc.w	gatorchg01-gatorchg
	dc.w	gatorchg02-gatorchg

gatorchg00:
	dc.b	3, 0, 4, 2, 3, 1, 5, $FF

gatorchg01:
	dc.b	$F, 0, $FF

gatorchg02:
	dc.b	3, 6, $A, 8, 9, 7, $B, $FF
	even

gatorpat:
	dc.w	gatorsp00-gatorpat
	dc.w	gatorsp01-gatorpat
	dc.w	gatorsp02-gatorpat
	dc.w	gatorsp03-gatorpat
	dc.w	gatorsp04-gatorpat
	dc.w	gatorsp05-gatorpat
	dc.w	gatorsp06-gatorpat
	dc.w	gatorsp07-gatorpat
	dc.w	gatorsp08-gatorpat
	dc.w	gatorsp09-gatorpat
	dc.w	gatorsp10-gatorpat
	dc.w	gatorsp11-gatorpat

gatorsp00:
	dc.w	4
	dc.w	$F80E, 0, 0, $FFE4
	dc.w	$F805, $18, $C, 4
	dc.w	1, $1C, $E, 4
	dc.w	5, $20, $10, $C

gatorsp01:
	dc.w	4
	dc.w	$F80E, 0, 0, $FFE4
	dc.w	$F805, $18, $C, 4
	dc.w	1, $1C, $E, 4
	dc.w	5, $24, $12, $C

gatorsp02:
	dc.w	4
	dc.w	$F80E, 0, 0, $FFE4
	dc.w	$F805, $18, $C, 4
	dc.w	1, $1C, $E, 4
	dc.w	5, $28, $14, $C

gatorsp03:
	dc.w	4
	dc.w	$F80E, 0, 0, $FFE4
	dc.w	$F805, $18, $C, 4
	dc.w	1, $1E, $F, 4
	dc.w	5, $20, $10, $C

gatorsp04:
	dc.w	4
	dc.w	$F80E, 0, 0, $FFE4
	dc.w	$F805, $18, $C, 4
	dc.w	1, $1E, $F, 4
	dc.w	5, $24, $12, $C

gatorsp05:
	dc.w	4
	dc.w	$F80E, 0, 0, $FFE4
	dc.w	$F805, $18, $C, 4
	dc.w	1, $1E, $F, 4
	dc.w	5, $28, $14, $C

gatorsp06:
	dc.w	4
	dc.w	$F00B, $C, 6, $FFEC
	dc.w	$F805, $18, $C, 4
	dc.w	1, $1C, $E, 4
	dc.w	5, $20, $10, $C

gatorsp07:
	dc.w	4
	dc.w	$F00B, $C, 6, $FFEC
	dc.w	$F805, $18, $C, 4
	dc.w	1, $1C, $E, 4
	dc.w	5, $24, $12, $C

gatorsp08:
	dc.w	4
	dc.w	$F00B, $C, 6, $FFEC
	dc.w	$F805, $18, $C, 4
	dc.w	1, $1C, $E, 4
	dc.w	5, $28, $14, $C

gatorsp09:
	dc.w	4
	dc.w	$F00B, $C, 6, $FFEC
	dc.w	$F805, $18, $C, 4
	dc.w	1, $1E, $F, 4
	dc.w	5, $20, $10, $C

gatorsp10:
	dc.w	4
	dc.w	$F00B, $C, 6, $FFEC
	dc.w	$F805, $18, $C, 4
	dc.w	1, $1E, $F, 4
	dc.w	5, $24, $12, $C

gatorsp11:
	dc.w	4
	dc.w	$F00B, $C, 6, $FFEC
	dc.w	$F805, $18, $C, 4
	dc.w	1, $1E, $F, 4
	dc.w	5, $28, $14, $C
