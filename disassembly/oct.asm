
	xref	speedset, actionsub, frameoutchk, frameout
	xref	patchg, actwkchk, emycol_d

	xdef	oct, octpat

oct:
	moveq	#0,d0
	move.b	r_no0(a0),d0
	move.w	oct_move_tbl(pc,d0.w),d1
	jmp	oct_move_tbl(pc,d1.w)

oct_move_tbl:
	dc.w	octinit-oct_move_tbl
	dc.w	octmove-oct_move_tbl
	dc.w	octeye-oct_move_tbl
	dc.w	octshot-oct_move_tbl

octshot:
	subi.w	#1,$2C(a0)
	bmi.s	.cnt
	rts

.cnt:
	bsr.w	speedset
	lea	octchg,a1
	bsr.w	patchg
	bra.w	frameoutchk

octeye:
	subq.w	#1,$2C(a0)
	beq.w	frameout
	bra.w	actionsub

octinit:
	move.l	#octpat,patbase(a0)
	move.w	#$238A,sproffset(a0)
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
	move.w	xposi(a0),d0
	sub.w	playerwk+xposi,d0
	bpl.s	.end
	bchg	#0,cddat(a0)

.end:
	move.w	yposi(a0),$2A(a0)
	rts

octmove:
	moveq	#0,d0
	move.b	r_no1(a0),d0
	move.w	octmove_tbl(pc,d0.w),d1
	jsr	octmove_tbl(pc,d1.w)
	lea	octchg,a1
	bsr.w	patchg
	bra.w	frameoutchk

octmove_tbl:
	dc.w	octstand-octmove_tbl
	dc.w	octfly-octmove_tbl
	dc.w	octshoot-octmove_tbl
	dc.w	octleave-octmove_tbl

octstand:
	move.w	xposi(a0),d0
	sub.w	playerwk+xposi,d0
	cmpi.w	#$80,d0
	bgt.s	.done
	cmpi.w	#-$80,d0
	blt.s	.done
	addq.b	#2,r_no1(a0)
	move.b	#1,mstno(a0)

.done:
	rts

octfly:
	subi.l	#$18000,yposi(a0)
	move.w	$2A(a0),d0
	sub.w	yposi(a0),d0
	cmpi.w	#$20,d0
	ble.s	.end
	addq.b	#2,r_no1(a0)
	move.w	#0,$2C(a0)

.end:
	rts

octshoot:
	subi.w	#1,$2C(a0)
	beq.w	.out
	bpl.w	.end
	move.w	#30,$2C(a0)
	jsr	actwkchk
	bne.s	.end0
	move.b	#oct_act,actno(a1)
	move.b	#4,r_no0(a1)
	move.l	#octpat,patbase(a1)
	move.b	#4,patno(a1)
	move.w	#$24C6,sproffset(a1)
	move.b	#3,sprpri(a1)
	move.b	#$10,sprhs(a1)
	move.w	xposi(a0),xposi(a1)
	move.w	yposi(a0),yposi(a1)
	move.w	#30,$2C(a1)
	move.b	actflg(a0),actflg(a1)
	move.b	cddat(a0),cddat(a1)

.end0:
	jsr	actwkchk
	bne.s	.end
	move.b	#oct_act,actno(a1)
	move.b	#6,r_no0(a1)
	move.l	#octpat,patbase(a1)
	move.w	#$24C6,sproffset(a1)
	move.b	#4,sprpri(a1)
	move.b	#$10,sprhs(a1)
	move.w	xposi(a0),xposi(a1)
	move.w	yposi(a0),yposi(a1)
	move.w	#15,$2C(a1)
	move.b	actflg(a0),actflg(a1)
	move.b	cddat(a0),cddat(a1)
	move.b	#2,mstno(a1)
	move.w	#-$580,xspeed(a1)
	btst	#0,actflg(a1)
	beq.s	.end
	neg.w	xspeed(a1)

.end:
	rts

.out:
	addq.b	#2,r_no1(a0)
	rts

octleave:
	move.w	#-6,d0
	btst	#0,actflg(a0)
	beq.s	.cnt
	neg.w	d0

.cnt:
	add.w	d0,xposi(a0)
	bra.w	frameoutchk

octchg:
	dc.w	octchg00-octchg
	dc.w	octchg01-octchg
	dc.w	octchg02-octchg

octchg00:
	dc.b	$F, 0, $FF

octchg01:
	dc.b	3, 1, 2, 3, $FF

octchg02:
	dc.b	2, 5, 6, $FF

octpat:
	dc.w	octsp00-octpat
	dc.w	octsp01-octpat
	dc.w	octsp02-octpat
	dc.w	octsp03-octpat
	dc.w	octsp04-octpat
	dc.w	octsp05-octpat
	dc.w	octsp06-octpat

octsp00:
	dc.w	2
	dc.w	$F00D, 0, 0, $FFF0
	dc.w	$D, 8, 4, $FFF0

octsp01:
	dc.w	3
	dc.w	$F00D, 0, 0, $FFF0
	dc.w	9, $10, 8, $FFE8
	dc.w	9, $16, $B, 0

octsp02:
	dc.w	3
	dc.w	$F00D, 0, 0, $FFF0
	dc.w	9, $1C, $E, $FFE8
	dc.w	9, $22, $11, 0

octsp03:
	dc.w	3
	dc.w	$F00D, 0, 0, $FFF0
	dc.w	9, $28, $14, $FFE8
	dc.w	9, $2E, $17, 0

octsp04:
	dc.w	1
	dc.w	$F001, $34, $1A, $FFF7

octsp05:
	dc.w	1
	dc.w	$F201, $36, $1B, $FFF0

octsp06:
	dc.w	1
	dc.w	$F201, $38, $1C, $FFF0
