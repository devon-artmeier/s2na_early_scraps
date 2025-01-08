
	xref	soundset, speedset, actionsub, frameout
	xref	dualmodesub, actwkchk2, ridechksub_t

	xdef	sisoo, sisoopat, sballpat

sisoo:
	moveq	#0,d0
	move.b	r_no0(a0),d0
	move.w	sisoo_move_tbl(pc,d0.w),d1
	jsr	sisoo_move_tbl(pc,d1.w)
	move.w	$30(a0),d0
	andi.w	#$FF80,d0
	sub.w	$FFF7DA,d0
	cmpi.w	#$280,d0
	bhi.w	actionsub
	bra.w	frameout

sisoo_move_tbl:
	dc.w	sisooinit-sisoo_move_tbl
	dc.w	sisoomove-sisoo_move_tbl
	dc.w	sisooride-sisoo_move_tbl
	dc.w	sballinit-sisoo_move_tbl
	dc.w	sballwait-sisoo_move_tbl
	dc.w	sballmove-sisoo_move_tbl

sisooinit:
	addq.b	#2,r_no0(a0)
	move.l	#sisoopat,patbase(a0)
	move.w	#$3CE,sproffset(a0)
	bsr.w	dualmodesub
	ori.b	#4,actflg(a0)
	move.b	#4,sprpri(a0)
	move.b	#$30,sprhs(a0)
	move.w	xposi(a0),$30(a0)
	tst.b	userflag(a0)
	bne.s	.worknai
	bsr.w	actwkchk2
	bne.s	.worknai
	move.b	#sisoo_act,actno(a1)
	addq.b	#6,r_no0(a1)
	move.w	xposi(a0),xposi(a1)
	move.w	yposi(a0),yposi(a1)
	move.b	cddat(a0),cddat(a1)
	move.l	a0,$3C(a1)

.worknai:
	btst	#0,cddat(a0)
	beq.s	.jump
	move.b	#2,patno(a0)

.jump:
	move.b	patno(a0),$3A(a0)

sisoomove:
	move.b	$3A(a0),d1
	btst	#3,cddat(a0)
	beq.s	.noride

.rideon:
	moveq	#2,d1
	lea	playerwk,a1
	move.w	xposi(a0),d0
	sub.w	xposi(a1),d0
	bcc.s	.jump
	neg.w	d0
	moveq	#0,d1

.jump:
	cmpi.w	#8,d0
	bcc.s	.jump2
	moveq	#1,d1

.jump2:
	btst	#4,cddat(a0)
	beq.s	.jump6
	moveq	#2,d2
	lea	playerwk2,a1
	move.w	xposi(a0),d0
	sub.w	xposi(a1),d0
	bcc.s	.jump3
	neg.w	d0
	moveq	#0,d2

.jump3:
	cmpi.w	#8,d0
	bcc.s	.jump4
	moveq	#1,d2

.jump4:
	add.w	d2,d1
	cmpi.w	#3,d1
	bne.s	.jump44
	addq.w	#1,d1

.jump44:
	lsr.w	#1,d1
	bra.s	.jump6

.noride:
	btst	#4,cddat(a0)
	beq.s	.jump6
	moveq	#2,d1
	lea	playerwk2,a1
	move.w	xposi(a0),d0
	sub.w	xposi(a1),d0
	bcc.s	.jump5
	neg.w	d0
	moveq	#0,d1

.jump5:
	cmpi.w	#8,d0
	bcc.s	.jump6
	moveq	#1,d1

.jump6:
.jump7:
	bsr.w	sisoosub2
	lea	sisootbl,a2
	btst	#0,patno(a0)
	beq.s	.jump8
	lea	sisootbl2,a2

.jump8:
	lea	playerwk,a1
	move.w	yspeed(a1),$38(a0)
	move.w	xposi(a0),-(sp)
	moveq	#0,d1
	move.b	sprhs(a0),d1
	moveq	#8,d3
	move.w	(sp)+,d4
	bra.w	ridechksub_t

sisooride:
	rts

sisoosub:
	moveq	#2,d1
	lea	playerwk,a1
	move.w	xposi(a0),d0
	sub.w	xposi(a1),d0
	bcc.s	.jump
	neg.w	d0
	moveq	#0,d1

.jump:
	cmpi.w	#8,d0
	bcc.s	.jump2
	moveq	#1,d1

.jump2:

sisoosub2:
	move.b	patno(a0),d0
	cmp.b	d1,d0
	beq.s	.end
	bcc.s	.jump3
	addq.b	#2,d0

.jump3:
	subq.b	#1,d0
	move.b	d0,patno(a0)
	move.b	d1,$3A(a0)
	bclr	#0,actflg(a0)
	btst	#1,patno(a0)
	beq.s	.end
	bset	#0,actflg(a0)

.end:
	rts

sballinit:
	addq.b	#2,r_no0(a0)
	move.l	#sballpat,patbase(a0)
	move.w	#$3CE,sproffset(a0)
	bsr.w	dualmodesub
	ori.b	#4,actflg(a0)
	move.b	#4,sprpri(a0)
	move.b	#$8B,colino(a0)
	move.b	#$C,sprhs(a0)
	move.w	xposi(a0),$30(a0)
	addi.w	#$28,xposi(a0)
	addi.w	#$10,yposi(a0)
	move.w	yposi(a0),$34(a0)
	move.b	#1,patno(a0)
	btst	#0,cddat(a0)
	beq.s	.jump
	subi.w	#$50,xposi(a0)
	move.b	#2,$3A(a0)

.jump:

sballwait:
	movea.l	$3C(a0),a1
	moveq	#0,d0
	move.b	$3A(a0),d0
	sub.b	$3A(a1),d0
	beq.s	.jump4
	bcc.s	.jump
	neg.b	d0

.jump:
	move.w	#-$818,d1
	move.w	#-$114,d2
	cmpi.b	#1,d0
	beq.s	.jump3
	move.w	#-$AF0,d1
	move.w	#-$CC,d2
	cmpi.w	#$A00,$38(a1)
	blt.s	.jump3
	move.w	#-$E00,d1
	move.w	#-$A0,d2

.jump3:
	move.w	d1,yspeed(a0)
	move.w	d2,xspeed(a0)
	move.w	xposi(a0),d0
	sub.w	$30(a0),d0
	bcc.s	.jump2
	neg.w	xspeed(a0)

.jump2:
	addq.b	#2,r_no0(a0)
	bra.s	sballmove

.jump4:
	lea	sballtbl,a2
	moveq	#0,d0
	move.b	patno(a1),d0
	move.w	#$28,d2
	move.w	xposi(a0),d1
	sub.w	$30(a0),d1
	bcc.s	.jump0
	neg.w	d2
	addq.w	#2,d0

.jump0:
	add.w	d0,d0
	move.w	$34(a0),d1
	add.w	(a2,d0.w),d1
	move.w	d1,yposi(a0)
	add.w	$30(a0),d2
	move.w	d2,xposi(a0)
	clr.w	yposi+2(a0)
	clr.w	xposi+2(a0)
	rts

sballmove:
	tst.w	yspeed(a0)
	bpl.s	.down

.up:
	bsr.w	speedset
	move.w	$34(a0),d0
	subi.w	#$2F,d0
	cmp.w	yposi(a0),d0
	bgt.s	.end
	bsr.w	speedset

.end:
	rts

.down:
	bsr.w	speedset
	movea.l	$3C(a0),a1
	lea	sballtbl,a2
	moveq	#0,d0
	move.b	patno(a1),d0
	move.w	xposi(a0),d1
	sub.w	$30(a0),d1
	bcc.s	.jump0
	addq.w	#2,d0

.jump0:
	add.w	d0,d0
	move.w	$34(a0),d1
	add.w	(a2,d0.w),d1
	cmp.w	yposi(a0),d1
	bgt.s	.jump3
	movea.l	$3C(a0),a1
	moveq	#2,d1
	tst.w	xspeed(a0)
	bmi.s	.jump
	moveq	#0,d1

.jump:
	move.b	d1,$3A(a1)
	move.b	d1,$3A(a0)
	cmp.b	patno(a1),d1
	beq.s	.jump2
	lea	playerwk,a2
	bclr	#3,cddat(a1)
	beq.s	.jump1
	bsr.s	.sub

.jump1:
	lea	playerwk2,a2
	bclr	#4,cddat(a1)
	beq.s	.jump2
	bsr.s	.sub

.jump2:
	clr.w	xspeed(a0)
	clr.w	yspeed(a0)
	subq.b	#2,r_no0(a0)

.jump3:
	rts

.sub:
	move.w	yspeed(a0),yspeed(a2)
	neg.w	yspeed(a2)
	bset	#cd_jump,cddat(a2)
	bclr	#3,cddat(a2)
	clr.b	$3C(a2)
	move.b	#$10,mstno(a2)
	move.b	#2,r_no0(a2)
	move.w	#$CC,d0
	jmp	soundset

sballtbl:
	dc.w	-8, -28, -47, -28, -8

sisootbl:
	dc.b	20, 20, 22, 24, 26, 28, 26, 24, 22, 20, 19, 18, 17, 16, 15, 14
	dc.b	13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, -1, -2
	dc.b	-3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -14, -14, -14, -14
	dc.b	-14

sisootbl2:
	dc.b	5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5
	dc.b	5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5
	dc.b	5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5
	dc.b	0

sisoopat:
	dc.w	sisoosp0-sisoopat
	dc.w	sisoosp1-sisoopat
	dc.w	sisoosp0-sisoopat
	dc.w	sisoosp1-sisoopat

sisoosp0:
	dc.w	8
	dc.w	$FC05, $4014, $400A, $FFF8
	dc.w	$C01, $2012, $2009, $FFFC
	dc.w	$E405, $4006, $4003, $FFD0
	dc.w	$EC05, $400A, $4005, $FFE0
	dc.w	$F405, $400A, $4005, $FFF0
	dc.w	$FC05, $400A, $4005, 0
	dc.w	$405, $400A, $4005, $10
	dc.w	$C05, $400E, $4007, $20

sisoosp1:
	dc.w	8
	dc.w	$FC05, $4014, $400A, $FFF8
	dc.w	$C01, $2012, $2009, $FFFC
	dc.w	$F405, $4000, $4000, $FFD0
	dc.w	$F405, $4002, $4001, $FFE0
	dc.w	$F405, $4002, $4001, $FFF0
	dc.w	$F405, $4002, $4001, 0
	dc.w	$F405, $4002, $4001, $10
	dc.w	$F405, $4800, $4800, $20

sballpat:
	dc.w	sballsp0-sballpat
	dc.w	sballsp1-sballpat

sballsp0:
sballsp1:
	dc.w	1
	dc.w	$F805, $4014, $400A, $FFF8

	nop	; Alignment
