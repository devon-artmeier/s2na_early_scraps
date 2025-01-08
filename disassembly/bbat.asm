
	xref	random, sinset, speedset2, frameoutchk
	xref	patchg

	xdef	bbat, bbatpat

bbat:
	moveq	#0,d0
	move.b	r_no0(a0),d0
	move.w	bat_move_tbl(pc,d0.w),d1
	jmp	bat_move_tbl(pc,d1.w)

bat_move_tbl:
	dc.w	batinit-bat_move_tbl
	dc.w	batmove-bat_move_tbl
	dc.w	batattack-bat_move_tbl

batinit:
	move.l	#bbatpat,patbase(a0)
	move.w	#$2530,sproffset(a0)
	ori.b	#4,actflg(a0)
	move.b	#$A,colino(a0)
	move.b	#4,sprpri(a0)
	move.b	#$10,sprhs(a0)
	move.b	#$10,sprvsize(a0)
	move.b	#8,sprhsize(a0)
	addq.b	#2,r_no0(a0)
	move.w	yposi(a0),$2E(a0)
	rts

batmove:
	moveq	#0,d0
	move.b	r_no1(a0),d0
	move.w	batmove_tbl(pc,d0.w),d1
	jsr	batmove_tbl(pc,d1.w)
	bsr.w	setposi
	lea	batchg,a1
	bsr.w	patchg
	bra.w	frameoutchk

batmove_tbl:
	dc.w	bathover-batmove_tbl
	dc.w	batflap-batmove_tbl
	dc.w	batseek-batmove_tbl

setposi:
	move.b	$3F(a0),d0
	jsr	sinset
	asr.w	#6,d0
	add.w	$2E(a0),d0
	move.w	d0,yposi(a0)
	addq.b	#4,$3F(a0)
	rts

seekchk:
	move.w	xposi(a0),d0
	sub.w	playerwk+xposi,d0
	cmpi.w	#$80,d0
	bgt.s	.end
	cmpi.w	#-$80,d0
	blt.s	.end
	move.b	#4,r_no1(a0)
	move.b	#2,mstno(a0)
	move.w	#8,$2A(a0)
	move.b	#0,$3E(a0)

.end:
	rts

batattack:
	bsr.w	moveset
	bsr.w	direcchg
	bsr.w	fixme
	bsr.w	speedset2
	lea	batchg,a1
	bsr.w	patchg
	bra.w	frameoutchk
	rts

fixme:
	tst.b	$3D(a0)
	beq.s	.end
	bset	#0,actflg(a0)
	bset	#0,cddat(a0)

.end:
	rts

attackchk:
	subi.w	#1,$2C(a0)
	bpl.s	.end
	move.w	xposi(a0),d0
	sub.w	playerwk+xposi,d0
	cmpi.w	#$60,d0
	bgt.s	.gone
	cmpi.w	#-$60,d0
	blt.s	.gone
	tst.w	d0
	bpl.s	.cnt
	st	$3D(a0)

.cnt:
	move.b	#$40,$3F(a0)
	move.w	#$400,mspeed(a0)
	move.b	#4,r_no0(a0)
	move.b	#3,mstno(a0)
	move.w	#12,$2A(a0)
	move.b	#1,$3E(a0)
	moveq	#0,d0

.end:
	rts

.gone:
	cmpi.w	#$80,d0
	bgt.s	.norm
	cmpi.w	#-$80,d0
	bgt.s	.end

.norm:
	move.b	#1,mstno(a0)
	move.b	#0,r_no1(a0)
	move.w	#24,$2A(a0)
	rts

direcchg:
	tst.b	$3D(a0)
	bne.s	.rt
	moveq	#0,d0
	move.b	$3F(a0),d0
	cmpi.w	#$C0,d0
	bge.s	.done
	addq.b	#2,d0
	move.b	d0,$3F(a0)

.end:
	rts

.rt:
	moveq	#0,d0
	move.b	$3F(a0),d0
	cmpi.w	#$C0,d0
	beq.s	.done
	subq.b	#2,d0
	move.b	d0,$3F(a0)
	rts

.done:
	sf	$3D(a0)
	move.b	#0,mstno(a0)
	move.b	#2,r_no0(a0)
	move.b	#0,r_no1(a0)
	move.w	#24,$2A(a0)
	move.b	#1,mstno(a0)
	bclr	#0,actflg(a0)
	bclr	#0,cddat(a0)
	rts

moveset:
	move.b	$3F(a0),d0
	jsr	sinset
	muls.w	mspeed(a0),d1
	asr.l	#8,d1
	move.w	d1,xspeed(a0)
	muls.w	mspeed(a0),d0
	asr.l	#8,d0
	move.w	d0,yspeed(a0)
	rts

bathover:
	subi.w	#1,$2A(a0)
	bpl.s	.end
	bsr.w	seekchk
	beq.s	.end
	jsr	random
	andi.b	#$FF,d0
	bne.s	.end
	move.w	#24,$2A(a0)
	move.w	#30,$2C(a0)
	addq.b	#2,r_no1(a0)
	move.b	#1,mstno(a0)
	move.b	#0,$3E(a0)

.end:
	rts

batflap:
	subq.b	#1,$2A(a0)
	bpl.s	.end
	subq.b	#2,r_no1(a0)

.end:
	rts

batseek:
	bsr.w	attackchk
	beq.s	.cnt
	subi.w	#1,$2A(a0)
	bne.s	.cnt
	move.b	$3E(a0),d0
	beq.s	.here
	move.b	#0,$3E(a0)
	move.w	#8,$2A(a0)
	bset	#0,actflg(a0)
	bset	#0,cddat(a0)
	rts

.here:
	move.b	#1,$3E(a0)
	move.w	#12,$2A(a0)
	bclr	#0,actflg(a0)
	bclr	#0,cddat(a0)

.cnt:
	rts

batchg:
	dc.w	batchg00-batchg
	dc.w	batchg01-batchg
	dc.w	batchg02-batchg
	dc.w	batchg03-batchg

batchg00:
	dc.b	1, 0, 5, $FF

batchg01:
	dc.b	1, 1, 6, 1, 6, 2, 7, 2, 7, 1, 6, 1, 6, $FD, 0

batchg02:
	dc.b	1, 1, 6, 1, 6, 2, 7, 3, 8, 4, 9, 4, 9, 3, 8, $FE, $A

batchg03:
	dc.b	3, $A, $B, $C, $D, $E, $FF
	even

bbatpat:
	dc.w	batsp00-bbatpat
	dc.w	batsp01-bbatpat
	dc.w	batsp02-bbatpat
	dc.w	batsp03-bbatpat
	dc.w	batsp04-bbatpat
	dc.w	batsp05-bbatpat
	dc.w	batsp06-bbatpat
	dc.w	batsp07-bbatpat
	dc.w	batsp08-bbatpat
	dc.w	batsp09-bbatpat
	dc.w	batsp10-bbatpat
	dc.w	batsp11-bbatpat
	dc.w	batsp12-bbatpat
	dc.w	batsp13-bbatpat
	dc.w	batsp14-bbatpat

batsp00:
	dc.w	4
	dc.w	$F005, 0, 0, $FFF8
	dc.w	5, 4, 2, $FFF8
	dc.w	$F00B, 8, 4, 5
	dc.w	$F00B, $808, $804, $FFE3

batsp01:
	dc.w	4
	dc.w	$F005, 0, 0, $FFF8
	dc.w	5, 4, 2, $FFF8
	dc.w	$F60D, $14, $A, 5
	dc.w	$F60D, $814, $80A, $FFDB

batsp02:
	dc.w	4
	dc.w	$F005, 0, 0, $FFF8
	dc.w	5, 4, 2, $FFF8
	dc.w	$F80D, $1C, $E, 4
	dc.w	$F80D, $81C, $80E, $FFDC

batsp03:
	dc.w	4
	dc.w	$F005, 0, 0, $FFF8
	dc.w	5, 4, 2, $FFF8
	dc.w	$F805, $24, $12, $FFEC
	dc.w	$F805, $28, $14, 4

batsp04:
	dc.w	3
	dc.w	$F801, $2C, $16, 0
	dc.w	$F005, 0, 0, $FFF8
	dc.w	5, 4, 2, $FFF8

batsp05:
	dc.w	4
	dc.w	$F005, 0, 0, $FFF8
	dc.w	5, $2E, $17, $FFF8
	dc.w	$F00B, 8, 4, 5
	dc.w	$F00B, $808, $804, $FFE3

batsp06:
	dc.w	4
	dc.w	$F005, 0, 0, $FFF8
	dc.w	5, $2E, $17, $FFF8
	dc.w	$F60D, $14, $A, 5
	dc.w	$F60D, $814, $80A, $FFDB

batsp07:
	dc.w	4
	dc.w	$F005, 0, 0, $FFF8
	dc.w	5, $2E, $17, $FFF8
	dc.w	$F80D, $1C, $E, 4
	dc.w	$F80D, $81C, $80E, $FFDC

batsp08:
	dc.w	4
	dc.w	$F005, 0, 0, $FFF8
	dc.w	5, $2E, $17, $FFF8
	dc.w	$F805, $28, $14, 4
	dc.w	$F805, $24, $12, $FFEC

batsp09:
	dc.w	3
	dc.w	$F801, $2C, $16, 0
	dc.w	$F005, 0, 0, $FFF8
	dc.w	5, $2E, $17, $FFF8

batsp10:
	dc.w	3
	dc.w	$F007, $32, $19, $FFF8
	dc.w	$F80D, $1C, $E, 4
	dc.w	$F80D, $81C, $80E, $FFDC

batsp11:
	dc.w	3
	dc.w	$F007, $32, $19, $FFF8
	dc.w	$F805, $28, $14, 4
	dc.w	$F805, $24, $12, $FFEC

batsp12:
	dc.w	2
	dc.w	$F801, $2C, $16, 0
	dc.w	$F007, $32, $19, $FFF8

batsp13:
	dc.w	2
	dc.w	$F801, $82C, $816, $FFF8
	dc.w	$F007, $32, $19, $FFF8

batsp14:
	dc.w	3
	dc.w	$F007, $32, $19, $FFF8
	dc.w	$F805, $828, $814, $FFEC
	dc.w	$F805, $824, $812, 4

	dc.w	0	; Alignment
