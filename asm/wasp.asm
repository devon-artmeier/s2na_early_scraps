
	xref	speedset2, frameoutchkd, frameout, patchg
	xref	actwkchk2

	xdef	wasp, wasppat, waspchg

wasp:
	bra.w	frameout
	; Dummied out
	moveq	#0,d0
	move.b	r_no0(a0),d0
	move.w	wasp_move_tbl(pc,d0.w),d1
	jmp	wasp_move_tbl(pc,d1.w)

wasp_move_tbl:
	dc.w	waspinit-wasp_move_tbl
	dc.w	waspmove-wasp_move_tbl
	dc.w	waspafterb-wasp_move_tbl
	dc.w	waspshot-wasp_move_tbl

waspshot:
	bsr.w	speedset2
	lea	waspchg,a1
	bsr.w	patchg
	bra.w	frameoutchkd

waspafterb:
	movea.l	$2A(a0),a1
	tst.b	(a1)
	beq.w	frameout
	tst.w	$30(a1)
	bmi.s	.cnt
	rts

.cnt:
	move.w	xposi(a1),xposi(a0)
	move.w	yposi(a1),yposi(a0)
	move.b	cddat(a1),cddat(a0)
	move.b	actflg(a1),actflg(a0)
	lea	waspchg,a1
	bsr.w	patchg
	bra.w	frameoutchkd

waspinit:
	move.l	#wasppat,patbase(a0)
	move.w	#$3E6,sproffset(a0)
	ori.b	#4,actflg(a0)
	move.b	#$A,colino(a0)
	move.b	#4,sprpri(a0)
	move.b	#$10,sprhs(a0)
	move.b	#$10,sprvsize(a0)
	move.b	#$18,sprhsize(a0)
	move.b	#3,sprpri(a0)
	addq.b	#2,r_no0(a0)
	bsr.w	actwkchk2
	bne.s	.done
	move.b	#wasp_act,actno(a1)
	move.b	#4,r_no0(a1)
	move.l	#wasppat,patbase(a1)
	move.w	#$3E6,sproffset(a1)
	move.b	#4,sprpri(a1)
	move.b	#$10,sprhs(a1)
	move.b	cddat(a0),cddat(a1)
	move.b	actflg(a0),actflg(a1)
	move.b	#1,mstno(a1)
	move.l	a0,$2A(a1)
	move.w	xposi(a0),xposi(a1)
	move.w	yposi(a0),yposi(a1)
	move.w	#$100,$2E(a0)
	move.w	#-$100,xspeed(a0)
	btst	#0,actflg(a0)
	beq.s	.done
	neg.w	xspeed(a0)

.done:
	rts

waspmove:
	moveq	#0,d0
	move.b	r_no1(a0),d0
	move.w	waspmove_tbl(pc,d0.w),d1
	jsr	waspmove_tbl(pc,d1.w)
	lea	waspchg,a1
	bsr.w	patchg
	bra.w	frameoutchkd

waspmove_tbl:
	dc.w	waspfly-waspmove_tbl
	dc.w	waspshoot-waspmove_tbl

waspfly:
	bsr.w	checkshoot
	subq.w	#1,$30(a0)
	move.w	$30(a0),d0
	cmpi.w	#$F,d0
	beq.s	.here2
	tst.w	d0
	bpl.s	.end
	subq.w	#1,$2E(a0)
	bgt.w	speedset2
	move.w	#30,$30(a0)

.end:
	rts

.here2:
	sf	$32(a0)
	neg.w	xspeed(a0)
	bchg	#0,actflg(a0)
	bchg	#0,cddat(a0)
	move.w	#$100,$2E(a0)
	rts

checkshoot:
	tst.b	$32(a0)
	bne.w	.out
	move.w	xposi(a0),d0
	sub.w	playerwk+xposi,d0
	move.w	d0,d1
	bpl.s	.cnt
	neg.w	d0

.cnt:
	cmpi.w	#$28,d0
	blt.s	.out
	cmpi.w	#$30,d0
	bgt.s	.out
	tst.w	d1
	bpl.s	.toleft
	btst	#0,actflg(a0)
	beq.s	.out
	bra.s	.sht

.toleft:
	btst	#0,actflg(a0)
	bne.s	.out

.sht:
	st	$32(a0)
	addq.b	#2,r_no1(a0)
	move.b	#3,mstno(a0)
	move.w	#50,$34(a0)

.out:
	rts

waspshoot:
	move.w	$34(a0),d0
	subq.w	#1,d0
	blt.s	.done
	move.w	d0,$34(a0)
	cmpi.w	#20,d0
	beq.s	.here
	rts

.done:
	subq.b	#2,r_no1(a0)
	rts

.here:
	jsr	actwkchk2
	bne.s	.out
	move.b	#wasp_act,actno(a1)
	move.b	#6,r_no0(a1)
	move.l	#wasppat,patbase(a1)
	move.w	#$3E6,sproffset(a1)
	move.b	#4,sprpri(a1)
	move.b	#$10,sprhs(a1)
	move.b	cddat(a0),cddat(a1)
	move.b	actflg(a0),actflg(a1)
	move.b	#2,mstno(a1)
	move.w	xposi(a0),xposi(a1)
	move.w	yposi(a0),yposi(a1)
	move.w	#$180,yspeed(a1)
	move.w	#-$180,xspeed(a1)
	btst	#0,actflg(a1)
	beq.s	.out
	neg.w	xspeed(a1)

.out:
	rts

waspchg:
	dc.w	waspchg00-waspchg
	dc.w	waspchg01-waspchg
	dc.w	waspchg02-waspchg
	dc.w	waspchg03-waspchg

waspchg00:
	dc.b	$F, 0, $FF

waspchg01:
	dc.b	2, 3, 4, $FF

waspchg02:
	dc.b	3, 5, 6, $FF

waspchg03:
	dc.b	9, 1, 1, 1, 1, 1, $FD, 0
	even

wasppat:
	dc.w	waspsp00-wasppat
	dc.w	waspsp01-wasppat
	dc.w	waspsp02-wasppat
	dc.w	waspsp03-wasppat
	dc.w	waspsp04-wasppat
	dc.w	waspsp05-wasppat
	dc.w	waspsp06-wasppat

waspsp00:
	dc.w	2
	dc.w	$F809, 0, 0, $FFE8
	dc.w	$F809, 6, 3, 0

waspsp01:
	dc.w	3
	dc.w	$F809, 0, 0, $FFE8
	dc.w	$F805, $C, 6, 0
	dc.w	$805, $10, 8, 2

waspsp02:
	dc.w	3
	dc.w	$F809, 0, 0, $FFE8
	dc.w	$F805, $C, 6, 0
	dc.w	$805, $14, $A, 2

waspsp03:
	dc.w	1
	dc.w	$F001, $14, $A, 4

waspsp04:
	dc.w	1
	dc.w	$F001, $16, $B, 4

waspsp05:
	dc.w	1
	dc.w	$1001, $18, $C, 9

waspsp06:
	dc.w	1
	dc.w	$1001, $1A, $D, 9
