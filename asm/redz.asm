
	xref	speedset, speedset2, actionsub, frameout
	xref	patchg, emycol_d

	xdef	redz, redzpat

redz:
	moveq	#0,d0
	move.b	r_no0(a0),d0
	move.w	redz_move_tbl(pc,d0.w),d1
	jmp	redz_move_tbl(pc,d1.w)

redz_move_tbl:
	dc.w	redzinit-redz_move_tbl
	dc.w	redzmove-redz_move_tbl
	dc.w	redzdie-redz_move_tbl

redzinit:
	move.l	#redzpat,patbase(a0)
	move.w	#$500,sproffset(a0)
	move.b	#4,actflg(a0)
	move.b	#4,sprpri(a0)
	move.b	#$10,sprhs(a0)
	move.b	#$10,sprvsize(a0)
	move.b	#6,sprhsize(a0)
	move.b	#$C,colino(a0)
	bsr.w	speedset
	jsr	emycol_d
	tst.w	d1
	bpl.s	.end
	add.w	d1,yposi(a0)
	move.w	#0,yspeed(a0)
	addq.b	#2,r_no0(a0)
	bchg	#0,cddat(a0)

.end:
	rts

redzmove:
	moveq	#0,d0
	move.b	r_no1(a0),d0
	move.w	redzmove_tbl(pc,d0.w),d1
	jsr	redzmove_tbl(pc,d1.w)
	lea	redzchg,a1
	bsr.w	patchg
	move.w	xposi(a0),d0
	andi.w	#$FF80,d0
	sub.w	$FFF7DA,d0
	cmpi.w	#$280,d0
	bhi.w	.frameout
	bra.w	actionsub

.frameout:
	lea	flagworkcnt,a2
	moveq	#0,d0
	move.b	cdsts(a0),d0
	beq.s	.frameout2
	bclr	#7,2(a2,d0.w)

.frameout2:
	bra.w	frameout

redzmove_tbl:
	dc.w	redz_0-redzmove_tbl
	dc.w	redz_1-redzmove_tbl

redz_0:		
	subq.w	#1,$30(a0)
	bpl.s	.jump
	addq.b	#2,r_no1(a0)
	move.w	#-$80,xspeed(a0)
	move.b	#1,mstno(a0)
	bchg	#0,cddat(a0)
	bne.s	.jump
	neg.w	xspeed(a0)

.jump:
	rts

redz_1:		
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
	move.b	#0,mstno(a0)
	rts

redzdie:
	bra.w	frameout

redzchg:
	dc.w	redzchg0-redzchg
	dc.w	redzchg1-redzchg

redzchg0:
	dc.b	9, 1, $FF

redzchg1:
	dc.b	9, 0, 1, 2, 1, $FF
	even

redzpat:
	dc.w	redzsp0-redzpat
	dc.w	redzsp1-redzpat
	dc.w	redzsp2-redzpat

redzsp0:
	dc.w	1
	dc.w	$F00F, 0, 0, $FFF0

redzsp1:
	dc.w	1
	dc.w	$F00F, $10, 8, $FFF0

redzsp2:
	dc.w	1
	dc.w	$F00F, $20, $10, $FFF0
	
	dc.w	0	; Alignment
