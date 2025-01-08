
	xref	random, actionsub, frameout, patchg
	xref	dualmodesub, actwkchk, goleset, atariridesub

	xdef	masin, masinpat

masin:
	moveq	#0,d0
	move.b	r_no0(a0),d0
	move.w	masin_move_tbl(pc,d0.w),d1
	jsr	masin_move_tbl(pc,d1.w)
	move.w	xposi(a0),d0
	andi.w	#$FF80,d0
	sub.w	$FFF7DA,d0
	cmpi.w	#$280,d0
	bhi.s	.frameout
	jmp	actionsub

.frameout:
	jmp	frameout

masin_move_tbl:
	dc.w	masininit-masin_move_tbl
	dc.w	masinmove-masin_move_tbl
	dc.w	masinswitch-masin_move_tbl
	dc.w	masincenter-masin_move_tbl
	dc.w	masincenter2-masin_move_tbl
	dc.w	masinbomb-masin_move_tbl
	dc.w	masinusagi-masin_move_tbl
	dc.w	masinclear-masin_move_tbl

masintbl:
	dc.b	2, $20, 4, 0
	dc.b	4, $C, 5, 1
	dc.b	6, $10, 4, 3
	dc.b	8, $10, 3, 5

masininit:
	move.l	#masinpat,patbase(a0)
	move.w	#$49D,sproffset(a0)
	bsr.w	dualmodesub
	move.b	#4,actflg(a0)
	move.w	yposi(a0),$30(a0)
	moveq	#0,d0
	move.b	userflag(a0),d0
	lsl.w	#2,d0
	lea	masintbl(pc,d0.w),a1
	move.b	(a1)+,r_no0(a0)
	move.b	(a1)+,sprhs(a0)
	move.b	(a1)+,sprpri(a0)
	move.b	(a1)+,patno(a0)
	cmpi.w	#8,d0
	bne.s	.end
	move.b	#6,colino(a0)
	move.b	#8,colicnt(a0)

.end:
	rts

masinmove:
	cmpi.b	#2,bossflag
	beq.s	.jump
	move.w	#$2B,d1
	move.w	#$18,d2
	move.w	#$18,d3
	move.w	xposi(a0),d4
	jmp	atariridesub

.jump:
	tst.b	r_no1(a0)
	beq.s	.jump2
	clr.b	r_no1(a0)
	bclr	#3,playerwk+cddat
	bset	#cd_jump,playerwk+cddat

.jump2:
	move.b	#2,patno(a0)
	rts

masinswitch:
	move.w	#$17,d1
	move.w	#8,d2
	move.w	#8,d3
	move.w	xposi(a0),d4
	jsr	atariridesub
	lea	masinchg,a1
	jsr	patchg
	move.w	$30(a0),yposi(a0)
	move.b	cddat(a0),d0
	andi.b	#$18,d0
	beq.s	.jump
	addq.w	#8,yposi(a0)
	move.b	#$A,r_no0(a0)
	move.w	#60,pattim(a0)
	clr.b	pltime_f
	clr.b	bossstart
	move.b	#1,plautoflag
	move.w	#$800,swdata
	clr.b	r_no1(a0)
	bclr	#3,playerwk+cddat
	bset	#cd_jump,playerwk+cddat

.jump:
	rts

masincenter
	; Missing code

masincenter2:
	; Missing code

masinbomb:
	moveq	#7,d0
	and.b	systemtimer+3,d0
	bne.s	.jump
	jsr	actwkchk
	bne.s	.worknai
	move.b	#$3F,0(a1)
	move.w	xposi(a0),xposi(a1)
	move.w	yposi(a0),yposi(a1)
	jsr	random
	moveq	#0,d1
	move.b	d0,d1
	lsr.b	#2,d1
	subi.w	#$20,d1
	add.w	d1,xposi(a1)
	lsr.w	#8,d0
	lsr.b	#3,d0
	add.w	d0,yposi(a1)

.jump:
.worknai:
	subq.w	#1,pattim(a0)
	beq.s	.bombend

.end:
	rts

.bombend:
	move.b	#2,bossflag
	move.b	#$C,r_no0(a0)
	move.b	#6,patno(a0)
	move.w	#$96,pattim(a0)
	addi.w	#$20,yposi(a0)
	moveq	#8-1,d6
	move.w	#$9A,d5
	moveq	#-$1C,d4

.lp:
	jsr	actwkchk
	bne.s	.no_work_left
	move.b	#usagi_act,actno(a1)
	move.w	xposi(a0),xposi(a1)
	move.w	yposi(a0),yposi(a1)
	add.w	d4,xposi(a1)
	addq.w	#7,d4
	move.w	d5,$36(a1)
	subq.w	#8,d5
	dbf	d6,.lp

.no_work_left:
	rts

masinusagi:
	moveq	#7,d0
	and.b	systemtimer+3,d0
	bne.s	.jump
	jsr	actwkchk
	bne.s	.worknai
	move.b	#usagi_act,actno(a1)
	move.w	xposi(a0),xposi(a1)
	move.w	yposi(a0),yposi(a1)
	jsr	random
	andi.w	#$1F,d0
	subq.w	#6,d0
	tst.w	d1
	bpl.s	.pass
	neg.w	d0

.pass:
	add.w	d0,xposi(a1)
	move.w	#$C,$36(a1)

.jump:
.worknai:
	subq.w	#1,pattim(a0)
	bne.s	.end
	addq.b	#2,r_no0(a0)
	move.w	#180,pattim(a0)

.end:
	rts

masinclear:
	moveq	#$3F-1,d0
	moveq	#usagi_act,d1
	moveq	#$40,d2
	lea	actwk+$40,a1

.lp:
	cmp.b	(a1),d1
	beq.s	.end
	adda.w	d2,a1
	dbf	d0,.lp
	jsr	goleset
	jmp	frameout

.end:
	rts

masinchg:
	dc.w	masinchg0-masinchg
	dc.w	masinchg1-masinchg

masinchg0:
masinchg1:
	dc.b	2, 1, 3, $FF

masinpat:
	dc.w	masinsp0-masinpat
	dc.w	masinsp1-masinpat
	dc.w	masinsp2-masinpat
	dc.w	masinsp3-masinpat
	dc.w	masinsp4-masinpat
	dc.w	masinsp5-masinpat
	dc.w	masinsp6-masinpat

masinsp0:
	dc.w	7
	dc.w	$E00C, $2000, $2000, $FFF0
	dc.w	$E80D, $2004, $2002, $FFE0
	dc.w	$E80D, $200C, $2006, 0
	dc.w	$F80E, $2014, $200A, $FFE0
	dc.w	$F80E, $2020, $2010, 0
	dc.w	$100D, $202C, $2016, $FFE0
	dc.w	$100D, $2034, $201A, 0

masinsp1:
	dc.w	1
	dc.w	$F809, $3C, $1E, $FFF4

masinsp2:
	dc.w	6
	dc.w	8, $2042, $2021, $FFE0
	dc.w	$80C, $2045, $2022, $FFE0
	dc.w	4, $2049, $2024, $10
	dc.w	$80C, $204B, $2025, 0
	dc.w	$100D, $202C, $2016, $FFE0
	dc.w	$100D, $2034, $201A, 0

masinsp3:
	dc.w	1
	dc.w	$F809, $4F, $27, $FFF4

masinsp4:
	dc.w	2
	dc.w	$E80E, $2055, $202A, $FFF0
	dc.w	$E, $2061, $2030, $FFF0

masinsp5:
	dc.w	1
	dc.w	$F007, $206D, $2036, $FFF8

masinsp6:
	dc.w	0
