
	xref	speedset, speedset2, frameoutchkd, frameout
	xref	patchg, actwkchk2, emycol_d, waspchg
	xref	wasppat

	xdef	snail, snailpat

snail:
	bra.w	frameout
	; Dummied out
	moveq	#0,d0
	move.b	r_no0(a0),d0
	move.w	snail_move_tbl(pc,d0.w),d1
	jmp	snail_move_tbl(pc,d1.w)

snail_move_tbl:
	dc.w	snailinit-snail_move_tbl
	dc.w	snailmove-snail_move_tbl
	dc.w	snailturn-snail_move_tbl
	dc.w	updateparts-snail_move_tbl
	dc.w	afbupdate-snail_move_tbl

snailinit:
	move.l	#snailpat,patbase(a0)
	move.w	#$402,sproffset(a0)
	ori.b	#4,actflg(a0)
	move.b	#$A,colino(a0)
	move.b	#4,sprpri(a0)
	move.b	#$10,sprhs(a0)
	move.b	#$10,sprvsize(a0)
	move.b	#$E,sprhsize(a0)
	bsr.w	actwkchk2
	bne.s	.out1
	move.b	#snail_act,actno(a1)
	move.b	#6,r_no0(a1)
	move.l	#snailpat,patbase(a1)
	move.w	#$2402,sproffset(a1)
	move.b	#3,sprpri(a1)
	move.b	#$10,sprhs(a1)
	move.b	cddat(a0),cddat(a1)
	move.b	actflg(a0),actflg(a1)
	move.l	a0,$2A(a1)
	move.w	xposi(a0),xposi(a1)
	move.w	yposi(a0),yposi(a1)
	move.b	#2,patno(a1)

.out1:
	addq.b	#2,r_no0(a0)
	move.w	#-$80,d0
	btst	#0,cddat(a0)
	beq.s	.cnt
	neg.w	d0

.cnt:
	move.w	d0,xspeed(a0)
	rts

snailmove:
	bsr.w	chkcharge
	bsr.w	speedset2
	jsr	emycol_d
	cmpi.w	#-8,d1
	blt.s	.jump
	cmpi.w	#$C,d1
	bge.s	.jump
	add.w	d1,yposi(a0)
	lea	snailchg,a1
	bsr.w	patchg
	bra.w	frameoutchkd

.jump:
	addq.b	#2,r_no0(a0)
	move.w	#20,$30(a0)
	st	$34(a0)
	lea	snailchg,a1
	bsr.w	patchg
	bra.w	frameoutchkd

chkcharge:
	tst.b	$35(a0)
	bne.s	.done
	move.w	playerwk+xposi,d0
	sub.w	xposi(a0),d0
	cmpi.w	#100,d0
	bgt.s	.done
	cmpi.w	#-100,d0
	blt.s	.done
	tst.w	d0
	bmi.s	.toright

.toleft:
	btst	#0,cddat(a0)
	beq.s	.done
	bra.s	.doit

.toright:
	btst	#0,cddat(a0)
	bne.s	.done

.doit:
	move.w	xspeed(a0),d0
	asl.w	#2,d0
	move.w	d0,xspeed(a0)
	st	$35(a0)
	bsr.w	makeafb

.done:
	rts

makeafb:
	bsr.w	actwkchk2
	bne.s	.out
	move.b	#snail_act,actno(a1)
	move.b	#8,r_no0(a1)
	move.l	#wasppat,patbase(a1)
	move.w	#$3E6,sproffset(a1)
	move.b	#4,sprpri(a1)
	move.b	#$10,sprhs(a1)
	move.b	cddat(a0),cddat(a1)
	move.b	actflg(a0),actflg(a1)
	move.l	a0,$2A(a1)
	move.w	xposi(a0),xposi(a1)
	move.w	yposi(a0),yposi(a1)
	addq.w	#7,yposi(a1)
	addi.w	#$D,xposi(a1)
	move.b	#1,mstno(a1)

.out:
	rts

afbupdate:
	movea.l	$2A(a0),a1
	tst.b	$34(a1)
	bne.w	frameout
	move.w	xposi(a1),xposi(a0)
	move.w	yposi(a1),yposi(a0)
	addq.w	#7,yposi(a0)
	moveq	#$D,d0
	btst	#0,cddat(a0)
	beq.s	.cnt
	neg.w	d0

.cnt:
	add.w	d0,xposi(a0)
	lea	waspchg,a1
	bsr.w	patchg
	bra.w	frameoutchkd

snailturn:
	subi.w	#1,$30(a0)
	bpl.w	frameoutchkd
	neg.w	xspeed(a0)
	bsr.w	speedset
	move.w	xspeed(a0),d0
	asr.w	#2,d0
	move.w	d0,xspeed(a0)
	bchg	#0,cddat(a0)
	bchg	#0,actflg(a0)
	subq.b	#2,r_no0(a0)
	sf	$34(a0)
	sf	$35(a0)
	bra.w	frameoutchkd

updateparts:
	movea.l	$2A(a0),a1
	cmpi.b	#snail_act,(a1)
	bne.w	frameout
	move.w	xposi(a1),xposi(a0)
	move.w	yposi(a1),yposi(a0)
	move.b	cddat(a1),cddat(a0)
	move.b	actflg(a1),actflg(a0)
	bra.w	frameoutchkd

snailchg:
	dc.w	snailchg0-snailchg
	dc.w	snailchg1-snailchg

snailchg0:
	dc.b	5, 0, 1, $FF

snailchg1:
	dc.b	1, 0, 1, $FF

snailpat:
	dc.w	snailsp0-snailpat
	dc.w	snailsp1-snailpat
	dc.w	snailsp2-snailpat

snailsp0:
	dc.w	2
	dc.w	$F00F, 0, 0, $FFF0
	dc.w	$109, $14, $A, $FFF4

snailsp1:
	dc.w	2
	dc.w	$F00F, 0, 0, $FFF0
	dc.w	$109, $1014, $100A, $FFF4

snailsp2:
	dc.w	1
	dc.w	$FA05, $10, 8, $FFE9
