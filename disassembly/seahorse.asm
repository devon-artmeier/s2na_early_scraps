
	xref	speedset, speedset2, actwkchk, actionsub
	xref	frameoutchk, frameout, patchg, emycol_d

	xdef	seahorse, skyhorse, horsepat

seahorse:
	moveq	#0,d0
	move.b	r_no0(a0),d0
	move.w	seahorse_move_tbl(pc,d0.w),d1
	jmp	seahorse_move_tbl(pc,d1.w)

seahorse_move_tbl:
	dc.w	seahorseinit-seahorse_move_tbl
	dc.w	seahorsemove-seahorse_move_tbl
	dc.w	seahorsewings-seahorse_move_tbl
	dc.w	seahorseshot-seahorse_move_tbl
	dc.w	shotdrops-seahorse_move_tbl
	dc.w	oilslip-seahorse_move_tbl

seahorseinit:
	addq.b	#2,r_no0(a0)
	move.l	#horsepat,patbase(a0)
	move.w	#$2570,sproffset(a0)
	ori.b	#4,actflg(a0)
	move.b	#$A,colino(a0)
	move.b	#4,sprpri(a0)
	move.b	#$10,sprhs(a0)
	move.w	#-$100,xspeed(a0)
	move.b	userflag(a0),d0
	move.b	d0,d1
	andi.w	#$F0,d1
	lsl.w	#4,d1
	move.w	d1,$2E(a0)
	move.w	d1,$30(a0)
	andi.w	#$F,d0
	lsl.w	#4,d0
	subq.w	#1,d0
	move.w	d0,$32(a0)
	move.w	d0,$34(a0)
	move.w	yposi(a0),$2A(a0)
	bsr.w	actwkchk
	bne.s	.worknai
	move.b	#seahorse_act,actno(a1)
	move.b	#4,r_no0(a1)
	move.w	xposi(a0),xposi(a1)
	move.w	yposi(a0),yposi(a1)
	addi.w	#$A,xposi(a1)
	addi.w	#-6,yposi(a1)
	move.l	#horsepat,patbase(a1)
	move.w	#$24E0,sproffset(a1)
	ori.b	#4,actflg(a1)
	move.b	#3,sprpri(a1)
	move.b	cddat(a0),cddat(a1)
	move.b	#3,mstno(a1)
	move.l	a1,$36(a0)
	move.l	a0,$36(a1)
	bset	#6,cddat(a0)

.worknai:

seahorsemove:
	lea	horsechg,a1
	bsr.w	patchg
	move.w	#$39C,waterposi
	moveq	#0,d0
	move.b	r_no1(a0),d0
	move.w	seahorsemove_tbl(pc,d0.w),d1
	jsr	seahorsemove_tbl(pc,d1.w)
	bsr.w	fixwings
	bra.w	frameoutchk

seahorsemove_tbl:
	dc.w	seahorseswim-seahorsemove_tbl
	dc.w	seahorsefloat-seahorsemove_tbl
	dc.w	seahorseattack-seahorsemove_tbl

seahorsewings:
	movea.l	$36(a0),a1
	tst.b	(a1)
	beq.w	frameout
	cmpi.b	#seahorse_act,(a1)
	bne.w	frameout
	btst	#7,cddat(a1)
	bne.w	frameout
	lea	horsechg,a1
	bsr.w	patchg
	bra.w	actionsub

seahorseshot:
	bsr.w	chkhit
	bsr.w	speedset2
	lea	horsechg,a1
	bsr.w	patchg
	bra.w	frameoutchk

seahorseswim:
	bsr.w	speedset2
	bsr.w	chkflip
	bsr.w	chkfloat
	bsr.w	chkatack
	rts

seahorsefloat:
	bsr.w	speedset2
	bsr.w	chkflip
	bsr.w	chkfltdone
	rts

seahorseattack:
	bsr.w	speedset
	bsr.w	chkflip
	bsr.w	chkshot
	bsr.w	chkatkdone
	rts

chkshot:
	tst.b	$2D(a0)
	bne.s	.end
	tst.w	yspeed(a0)
	bpl.s	.makeshot

.end:
	rts

.makeshot:
	st	$2D(a0)
	bsr.w	actwkchk
	bne.s	.worknai
	move.b	#seahorse_act,actno(a1)
	move.b	#6,r_no0(a1)
	move.w	xposi(a0),xposi(a1)
	move.w	yposi(a0),yposi(a1)
	move.l	#horsepat,patbase(a1)
	move.w	#$24E0,sproffset(a1)
	ori.b	#4,actflg(a1)
	move.b	#3,sprpri(a1)
	move.b	#$E5,colino(a1)
	move.b	#2,mstno(a1)
	move.w	#$C,d0
	move.w	#$10,d1
	move.w	#-$300,d2
	btst	#0,cddat(a0)
	beq.s	.ok
	neg.w	d1
	neg.w	d2

.ok:
	sub.w	d0,yposi(a1)
	sub.w	d1,xposi(a1)
	move.w	d2,xspeed(a1)

.worknai:
	rts

chkatkdone:
	move.w	yposi(a0),d0
	cmp.w	waterposi,d0
	blt.s	.end
	move.b	#2,r_no1(a0)
	move.b	#0,mstno(a0)
	move.w	$30(a0),$2E(a0)
	move.w	#$40,yspeed(a0)
	sf	$2D(a0)

.end:
	rts

chkatack:
	tst.b	$2C(a0)
	beq.s	.end
	move.w	playerwk+xposi,d0
	move.w	playerwk+yposi,d1
	sub.w	yposi(a0),d1
	bpl.s	.end
	cmpi.w	#-$30,d1
	blt.s	.end
	sub.w	xposi(a0),d0
	cmpi.w	#$48,d0
	bgt.s	.end
	cmpi.w	#-$48,d0
	blt.s	.end
	tst.w	d0
	bpl.s	.toright

.toleft:
	cmpi.w	#-$28,d0
	bgt.s	.end
	btst	#0,cddat(a0)
	bne.s	.end
	bra.s	.edge

.toright:
	cmpi.w	#$28,d0
	blt.s	.end
	btst	#0,cddat(a0)
	beq.s	.end

.edge:
	moveq	#$20,d0
	cmp.w	$32(a0),d0
	bgt.s	.end
	move.b	#4,r_no1(a0)
	move.b	#1,mstno(a0)
	move.w	#-$400,yspeed(a0)

.end:
	rts

chkfloat:
	subq.w	#1,$2E(a0)
	bne.s	.end
	move.w	$30(a0),$2E(a0)
	addq.b	#2,r_no1(a0)
	move.w	#-$40,d0
	tst.b	$2C(a0)
	beq.s	.vel
	neg.w	d0

.vel:
	move.w	d0,yspeed(a0)

.end:
	rts

chkfltdone:
	move.w	yposi(a0),d0
	tst.b	$2C(a0)
	bne.s	.down
	cmp.w	waterposi,d0
	bgt.s	.end
	subq.b	#2,r_no1(a0)
	st	$2C(a0)
	clr.w	yspeed(a0)

.end:
	rts

.down:
	cmp.w	$2A(a0),d0
	blt.s	.end
	subq.b	#2,r_no1(a0)
	sf	$2C(a0)
	clr.w	yspeed(a0)
	rts

fixwings:
	moveq	#$A,d0
	moveq	#-6,d1
	movea.l	$36(a0),a1
	move.w	xposi(a0),xposi(a1)
	move.w	yposi(a0),yposi(a1)
	move.b	cddat(a0),cddat(a1)
	move.b	cdsts(a0),cdsts(a1)
	move.b	actflg(a0),actflg(a1)
	btst	#0,cddat(a1)
	beq.s	.normal
	neg.w	d0

.normal:
	add.w	d0,xposi(a1)
	add.w	d1,yposi(a1)
	rts

shotdrops:
	bsr.w	speedset
	bsr.w	hitground
	lea	horsechg,a1
	bsr.w	patchg
	bra.w	frameoutchk

hitground:
	jsr	emycol_d
	tst.w	d1
	bpl.s	.end
	add.w	d1,yposi(a0)
	move.w	yspeed(a0),d0
	asr.w	#1,d0
	neg.w	d0
	move.w	d0,yspeed(a0)

.end:
	subi.b	#1,colicnt(a0)
	beq.w	frameout
	rts

oilslip:
	bsr.w	landedyet

updatoil:
	tst.b	r_no1(a0)
	beq.s	.end
	subi.w	#1,$2C(a0)
	beq.w	frameout
	move.w	playerwk+xposi,xposi(a0)
	move.w	playerwk+yposi,yposi(a0)
	addi.w	#$C,yposi(a0)
	subi.b	#1,$2A(a0)
	bne.s	.done
	move.b	#3,$2A(a0)
	bchg	#0,cddat(a0)
	bchg	#0,actflg(a0)

.end:
	rts

.done:
	lea	horsechg,a1
	bsr.w	patchg
	bra.w	actionsub

landedyet:
	tst.b	r_no1(a0)
	bne.s	.end
	move.b	playerwk+r_no0,d0
	cmpi.b	#2,d0
	bne.s	.end
	move.w	playerwk+xposi,xposi(a0)
	move.w	playerwk+yposi,yposi(a0)
	ori.b	#4,actflg(a0)
	move.b	#1,sprpri(a0)
	move.b	#5,mstno(a0)
	st	r_no1(a0)
	move.w	#300,$2C(a0)
	move.b	#3,$2A(a0)

.end:
	rts

chkflip:
	subq.w	#1,$32(a0)
	bpl.s	.jump
	move.w	$34(a0),$32(a0)
	neg.w	xspeed(a0)
	bchg	#0,cddat(a0)
	move.b	#1,mstno+1(a0)

.jump:
	rts

chkhit:
	tst.b	colicnt(a0)
	beq.w	.end
	moveq	#3-1,d3

.loop:
	bsr.w	actwkchk
	bne.s	.worknai
	move.b	actno(a0),actno(a1)
	move.b	#8,r_no0(a1)
	move.w	xposi(a0),xposi(a1)
	move.w	yposi(a0),yposi(a1)
	move.l	patbase(a0),patbase(a1)
	move.w	#$24E0,sproffset(a1)
	ori.b	#4,actflg(a1)
	move.b	#3,sprpri(a1)
	move.w	#-$100,yspeed(a1)
	move.b	#4,mstno(a1)
	move.b	#$78,colicnt(a1)
	cmpi.w	#1,d3
	beq.s	.r1
	blt.s	.left
	move.w	#$C0,xspeed(a1)
	addi.w	#-$C0,yspeed(a1)
	bra.s	.worknai

.left:
	move.w	#-$100,xspeed(a1)
	addi.w	#-$40,yspeed(a1)
	bra.s	.worknai

.r1:
	move.w	#$40,xspeed(a1)

.worknai:
	dbf	d3,.loop
	bsr.w	actwkchk
	bne.s	.out
	move.b	actno(a0),actno(a1)
	move.b	#$A,r_no0(a1)
	move.l	patbase(a0),patbase(a1)
	move.w	#$24E0,sproffset(a1)

.out:
	bra.w	frameout

.end:
	rts

horsechg:
	dc.w	seahorsechg0-horsechg
	dc.w	seahorsechg1-horsechg
	dc.w	horsechg2-horsechg
	dc.w	seahorsechg3-horsechg
	dc.w	seahorsechg4-horsechg
	dc.w	seahorsechg5-horsechg
	dc.w	skyhorsechg0-horsechg
	dc.w	skyhorsechg1-horsechg

seahorsechg0:
	dc.b	$E, 0, $FF

seahorsechg1:
	dc.b	5, 3, 4, 3, 4, 3, 4, $FF
	
horsechg2:
	dc.b	3, 5, 6, 7, 6, $FF

seahorsechg3:
	dc.b	3, 1, 2, $FF

seahorsechg4:
	dc.b	1, 5, $FF

seahorsechg5:
	dc.b	$E, 8, $FF

skyhorsechg0:
	dc.b	1, 9, $A, $FF

skyhorsechg1:
	dc.b	5, $B, $C, $B, $C, $B, $C, $FF
	even

horsepat:
	dc.w	seahorsesp00-horsepat
	dc.w	seahorsesp01-horsepat
	dc.w	seahorsesp02-horsepat
	dc.w	seahorsesp03-horsepat
	dc.w	seahorsesp04-horsepat
	dc.w	horsesp05-horsepat
	dc.w	horsesp06-horsepat
	dc.w	horsesp07-horsepat
	dc.w	horsesp08-horsepat
	dc.w	skyhorsesp00-horsepat
	dc.w	skyhorsesp01-horsepat
	dc.w	skyhorsesp02-horsepat
	dc.w	skyhorsesp03-horsepat

seahorsesp00:
	dc.w	3
	dc.w	$E80D, 0, 0, $FFF0
	dc.w	$F809, $16, $B, $FFF8
	dc.w	$805, $24, $12, $FFF8

seahorsesp01:
	dc.w	1
	dc.w	$F805, $28, $14, $FFF8

seahorsesp02:
	dc.w	1
	dc.w	$F805, $2C, $16, $FFF8

seahorsesp03:
	dc.w	4
	dc.w	$E809, 8, 4, $FFF0
	dc.w	$E801, $E, 7, 8
	dc.w	$F809, $16, $B, $FFF8
	dc.w	$805, $24, $12, $FFF8

seahorsesp04:
	dc.w	4
	dc.w	$E809, $10, 8, $FFF0
	dc.w	$E801, $E, 7, 8
	dc.w	$F809, $16, $B, $FFF8
	dc.w	$805, $24, $12, $FFF8

horsesp05:
	dc.w	1
	dc.w	$F801, $30, $18, $FFFC

horsesp06:
	dc.w	1
	dc.w	$F801, $32, $19, $FFFC

horsesp07:
	dc.w	1
	dc.w	$F801, $34, $1A, $FFFC

horsesp08:
	dc.w	1
	dc.w	$F80D, $36, $1B, $FFF0

skyhorsesp00:
	dc.w	4
	dc.w	$E80D, 0, 0, $FFF0
	dc.w	$F805, $1C, $E, $FFF8
	dc.w	$F801, $20, $10, 8
	dc.w	$805, $24, $12, $FFF8

skyhorsesp01:
	dc.w	4
	dc.w	$E80D, 0, 0, $FFF0
	dc.w	$F805, $1C, $E, $FFF8
	dc.w	$F801, $22, $11, 8
	dc.w	$805, $24, $12, $FFF8

skyhorsesp02:
	dc.w	5
	dc.w	$E809, 8, 4, $FFF0
	dc.w	$E801, $E, 7, 8
	dc.w	$F805, $1C, $E, $FFF8
	dc.w	$F801, $20, $10, 8
	dc.w	$805, $24, $12, $FFF8

skyhorsesp03:
	dc.w	5
	dc.w	$E809, $10, 8, $FFF0
	dc.w	$E801, $E, 7, 8
	dc.w	$F805, $1C, $E, $FFF8
	dc.w	$F801, $22, $11, 8
	dc.w	$805, $24, $12, $FFF8

skyhorse:
	moveq	#0,d0
	move.b	r_no0(a0),d0
	move.w	skyhorse_move_tbl(pc,d0.w),d1
	jmp	skyhorse_move_tbl(pc,d1.w)

skyhorse_move_tbl:
	dc.w	skyhorseinit-skyhorse_move_tbl
	dc.w	skyhorsemove-skyhorse_move_tbl
	dc.w	skyhorseshot-skyhorse_move_tbl
	dc.w	skyhorse_move_tbl-skyhorse_move_tbl
	dc.w	shotdrops-skyhorse_move_tbl
	dc.w	oilslip-skyhorse_move_tbl

skyhorseinit:
	addq.b	#2,r_no0(a0)
	move.l	#horsepat,patbase(a0)
	move.w	#$2570,sproffset(a0)
	ori.b	#4,actflg(a0)
	move.b	#$A,colino(a0)
	move.b	#4,sprpri(a0)
	move.b	#$10,sprhs(a0)
	move.b	#6,mstno(a0)
	move.b	userflag(a0),d0
	andi.w	#$F,d0
	move.w	d0,d1
	lsl.w	#5,d1
	subq.w	#1,d1
	move.w	d1,$32(a0)
	move.w	d1,$34(a0)
	move.w	yposi(a0),$2A(a0)
	move.w	yposi(a0),$2E(a0)
	addi.w	#$60,$2E(a0)
	move.w	#-$100,xspeed(a0)

skyhorsemove:
	lea	horsechg(pc),a1
	bsr.w	patchg
	move.w	#$39C,waterposi
	moveq	#0,d0
	move.b	r_no1(a0),d0
	move.w	skyhorsemove_tbl(pc,d0.w),d1
	jsr	skyhorsemove_tbl(pc,d1.w)
	bra.w	frameoutchk

skyhorsemove_tbl:
	dc.w	skyhorsefly-skyhorsemove_tbl
	dc.w	skyhorseattack-skyhorsemove_tbl

skyhorseshot:
	bsr.w	chkhit
	bsr.w	speedset2
	lea	horsechg(pc),a1
	bsr.w	patchg
	bra.w	frameoutchk

skyhorsefly:
	bsr.w	speedset2
	bsr.w	chkflip
	bsr.w	getposition
	bsr.w	seeksonic
	bsr.w	chkshoot
	rts

skyhorseattack:
	bsr.w	speedset2
	bsr.w	chkflip
	bsr.w	getposition
	bsr.w	seeksonic
	bsr.w	shotstatus
	rts

shotstatus:
	subq.w	#1,$30(a0)
	beq.s	.done
	move.w	$30(a0),d0
	cmpi.w	#$12,d0
	beq.w	makeshot
	rts

.done:
	subq.b	#2,r_no1(a0)
	move.b	#6,mstno(a0)
	move.w	#180,$30(a0)
	rts

getposition:
	sf	$2D(a0)
	sf	$2C(a0)
	sf	$36(a0)
	move.w	playerwk+xposi,d0
	sub.w	xposi(a0),d0
	bpl.s	.toleft
	btst	#0,cddat(a0)
	bne.s	.setbehind
	bra.s	.next

.toleft:
	btst	#0,cddat(a0)
	bne.s	.next

.setbehind:
	st	$2C(a0)

.next:
	move.w	playerwk+yposi,d0
	sub.w	yposi(a0),d0
	cmpi.w	#-4,d0
	blt.s	.out
	cmpi.w	#4,d0
	bgt.s	.above
	st	$2D(a0)
	move.w	#0,yspeed(a0)
	rts

.above:
	st	$36(a0)

.out:
	rts

chkshoot:
	tst.b	$2C(a0)
	bne.s	.end
	subq.w	#1,$30(a0)
	bgt.s	.end
	tst.b	$2D(a0)
	beq.s	.end
	move.b	#7,mstno(a0)
	move.w	#$24,$30(a0)
	addi.b	#2,r_no1(a0)

.end:
	rts

makeshot:
	bsr.w	actwkchk
	bne.s	.worknai
	move.b	#skyhorse_act,actno(a1)
	move.b	#4,r_no0(a1)
	move.w	xposi(a0),xposi(a1)
	move.w	yposi(a0),yposi(a1)
	move.l	#horsepat,patbase(a1)
	move.w	#$24E0,sproffset(a1)
	ori.b	#4,actflg(a1)
	move.b	#3,sprpri(a1)
	move.b	#2,mstno(a1)
	move.b	#$E5,colino(a1)
	move.w	#$C,d0
	move.w	#$10,d1
	move.w	#-$300,d2
	btst	#0,cddat(a0)
	beq.s	.ok
	neg.w	d1
	neg.w	d2

.ok:
	sub.w	d0,yposi(a1)
	sub.w	d1,xposi(a1)
	move.w	d2,xspeed(a1)

.worknai:
	rts

seeksonic:
	tst.b	$2D(a0)
	bne.s	.out
	tst.b	$36(a0)
	beq.s	.below

.above:
	move.w	$2E(a0),d0
	cmp.w	yposi(a0),d0
	ble.s	.end
	tst.b	$2C(a0)
	beq.s	.speed
	move.w	$2A(a0),d0
	cmp.w	yposi(a0),d0
	bge.s	.end
	rts

.speed:
	move.w	#$180,yspeed(a0)
	rts

.below:
	move.w	$2A(a0),d0
	cmp.w	yposi(a0),d0
	bge.s	.end
	tst.b	$2C(a0)
	beq.s	.negspeed
	move.w	$2E(a0),d0
	cmp.w	yposi(a0),d0
	ble.s	.end
	rts

.negspeed:
	move.w	#-$180,yspeed(a0)
	rts

.end:
	move.w	d0,yposi(a0)
	move.w	#0,yspeed(a0)

.out:
	rts
