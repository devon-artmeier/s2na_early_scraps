
	xref	soundset, random, speedset, actionsub
	xref	frameoutchk, frameout, patchg, actwkchk2
	xref	emycol_d, bossbomb, explode, scoreup

	xdef	bossdriller, driller, drillerguy

bossdriller:
	moveq	#0,d0
	move.b	r_no1(a0),d0
	move.w	bossdrillmove_tbl(pc,d0.w),d1
	jmp	bossdrillmove_tbl(pc,d1.w)

bossdrillmove_tbl:
	dc.w	moveonscreen-bossdrillmove_tbl
	dc.w	joincar-bossdrillmove_tbl
	dc.w	movecar-bossdrillmove_tbl
	dc.w	deathstart-bossdrillmove_tbl
	dc.w	deathdrop-bossdrillmove_tbl
	dc.w	flyaway-bossdrillmove_tbl

moveonscreen:
	move.b	#0,colino(a0)
	cmpi.w	#$29B0,xposi(a0)
	ble.s	.done
	subi.w	#1,xposi(a0)
	bra.w	actionsub

.done:
	move.w	#$29B0,xposi(a0)
	addq.b	#2,r_no1(a0)
	bra.w	actionsub

joincar:
	moveq	#0,d0
	move.b	$2C(a0),d0
	move.w	join_tbl(pc,d0.w),d1
	jmp	join_tbl(pc,d1.w)

join_tbl:
	dc.w	joinland-join_tbl
	dc.w	joinadjust-join_tbl

joinland:
	cmpi.w	#$3DE,yposi(a0)
	bge.s	.joined
	addi.w	#1,yposi(a0)
	bra.w	actionsub

.joined:
	addq.b	#2,$2C(a0)
	bset	#0,$2D(a0)
	move.w	#60,$2A(a0)
	bra.w	actionsub

joinadjust:
	subi.w	#1,$2A(a0)
	bpl.w	actionsub
	move.w	#-$200,xspeed(a0)
	addq.b	#2,r_no1(a0)
	move.b	#$F,colino(a0)
	bset	#1,$2D(a0)
	bra.w	actionsub

movecar:
	bsr.w	checkhit
	bsr.w	checkflip
	move.l	xposi(a0),d1
	move.w	xspeed(a0),d0
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d1
	move.l	d1,xposi(a0)
	move.b	systemtimer+3,d0
	andi.b	#$F,d0
	bne.w	actionsub
	bsr.w	random
	andi.w	#3,d0
	move.b	tbl(pc,d0.w),d0
	ext.w	d0
	add.w	$38(a0),d0
	move.w	d0,yposi(a0)
	bra.w	actionsub

tbl:
	dc.b	-1, 2, -2, 1

deathstart:
	subq.w	#1,$3C(a0)
	bpl.w	bossbomb

.jump:
	bset	#0,cddat(a0)
	bclr	#7,cddat(a0)
	clr.w	xspeed(a0)
	addq.b	#2,r_no1(a0)
	move.w	#-$26,$3C(a0)
	move.w	#12,$2A(a0)
	tst.b	bossflag
	bne.s	.end
	move.b	#1,bossflag

.end:
	rts

deathdrop:
	addq.w	#1,yposi(a0)
	subq.w	#1,$2A(a0)
	bpl.w	actionsub
	addq.b	#2,r_no1(a0)
	move.b	#0,$2C(a0)
	bra.w	actionsub

flyaway:
	moveq	#0,d0
	move.b	$2C(a0),d0
	move.w	flyaway_tbl(pc,d0.w),d1
	jsr	flyaway_tbl(pc,d1.w)
	bra.w	actionsub

flyaway_tbl:
	dc.w	initrotors-flyaway_tbl
	dc.w	takeoff-flyaway_tbl
	dc.w	runaway-flyaway_tbl

initrotors:
	bclr	#0,$2D(a0)
	bsr.w	actwkchk2
	bne.w	actionsub
	move.b	#driller_act,actno(a1)
	move.l	a0,$34(a1)
	move.l	#bosshelipat,patbase(a1)
	move.w	#$2540,sproffset(a1)
	move.b	#4,actflg(a1)
	move.b	#$20,sprhs(a1)
	move.b	#4,sprpri(a1)
	move.l	xposi(a0),xposi(a1)
	move.l	yposi(a0),yposi(a1)
	addi.w	#$C,yposi(a1)
	move.b	cddat(a0),cddat(a1)
	move.b	actflg(a0),actflg(a1)
	move.b	#8,r_no0(a1)
	move.b	#2,mstno(a1)
	move.w	#$10,$2A(a1)
	move.w	#50,$2A(a0)
	addq.b	#2,$2C(a0)
	rts

takeoff:
	subi.w	#1,$2A(a0)
	bpl.s	.end
	bset	#2,$2D(a0)
	move.w	#$30,$2A(a0)
	addq.b	#2,$2C(a0)

.end:
	rts

runaway:
	subq.w	#1,yposi(a0)
	subi.w	#1,$2A(a0)
	bpl.s	.out
	addq.w	#1,yposi(a0)
	addq.w	#2,xposi(a0)

.out:
	rts

checkflip:
	move.w	xposi(a0),d0
	cmpi.w	#$2780,d0
	ble.s	.off
	cmpi.w	#$2A08,d0
	blt.s	.done

.off:
	bchg	#0,cddat(a0)
	bchg	#0,actflg(a0)
	neg.w	xspeed(a0)

.done:
	rts

checkhit:
	cmpi.b	#6,r_no1(a0)
	bcc.s	.jump2
	tst.b	cddat(a0)
	bmi.s	.die
	tst.b	colino(a0)
	bne.s	.jump2
	tst.b	$3E(a0)
	bne.s	.jump
	move.b	#$20,$3E(a0)
	move.w	#$AC,d0
	jsr	soundset

.jump:
	lea	colorwk+($11*2),a1
	moveq	#0,d0
	tst.w	(a1)
	bne.s	.jump1
	move.w	#$EEE,d0

.jump1:
	move.w	d0,(a1)
	subq.b	#1,$3E(a0)
	bne.s	.jump2
	move.b	#$F,colino(a0)

.jump2:
	rts

.die:
	moveq	#100,d0
	bsr.w	scoreup
	move.b	#6,r_no1(a0)
	move.w	#180-1,$3C(a0)
	bset	#3,$2D(a0)
	rts

driller:
	moveq	#0,d0
	move.b	r_no0(a0),d0
	move.w	driller_tbl(pc,d0.w),d1
	jmp	driller_tbl(pc,d1.w)

driller_tbl:
	dc.w	sticktoboss-driller_tbl
	dc.w	carbody-driller_tbl
	dc.w	tiremove-driller_tbl
	dc.w	drill-driller_tbl
	dc.w	growrotors-driller_tbl

growrotors:
	subi.w	#1,yposi(a0)
	subi.w	#1,$2A(a0)
	bpl.w	actionsub
	move.b	#0,r_no0(a0)
	lea	bosshelichg,a1
	bsr.w	patchg
	bra.w	actionsub

sticktoboss:
	moveq	#0,d0
	move.b	r_no1(a0),d0
	move.w	stick_tbl(pc,d0.w),d1
	jmp	stick_tbl(pc,d1.w)

stick_tbl:
	dc.w	normal-stick_tbl
	dc.w	retract-stick_tbl

normal:
	movea.l	$34(a0),a1
	cmpi.b	#bossba_act,(a1)
	bne.w	frameout
	btst	#0,$2D(a1)
	beq.s	.cnt
	move.b	#1,mstno(a0)
	move.w	#24,$2A(a0)
	addq.b	#2,r_no1(a0)

.cnt:
	move.w	xposi(a1),xposi(a0)
	move.w	yposi(a1),yposi(a0)
	move.b	cddat(a1),cddat(a0)
	move.b	actflg(a1),actflg(a0)
	lea	bosshelichg,a1
	bsr.w	patchg
	bra.w	actionsub

retract:
	subi.w	#1,$2A(a0)
	bpl.s	.done
	cmpi.w	#-$10,$2A(a0)
	ble.w	frameout
	addi.w	#1,yposi(a0)
	bra.w	actionsub

.done:
	lea	bosshelichg,a1
	bsr.w	patchg
	bra.w	actionsub

carbody:
	movea.l	$34(a0),a1
	cmpi.b	#bossba_act,(a1)
	bne.w	frameout
	btst	#1,$2D(a1)
	beq.w	actionsub
	btst	#2,$2D(a1)
	bne.w	actionsub
	move.w	xposi(a1),xposi(a0)
	move.w	yposi(a1),yposi(a0)
	addi.w	#8,yposi(a0)
	move.b	cddat(a1),cddat(a0)
	move.b	actflg(a1),actflg(a0)
	bra.w	actionsub

tiremove:
	moveq	#0,d0
	move.b	r_no1(a0),d0
	move.w	tiremove_tbl(pc,d0.w),d1
	jmp	tiremove_tbl(pc,d1.w)

tiremove_tbl:
	dc.w	tiresit-tiremove_tbl
	dc.w	tireroll-tiremove_tbl
	dc.w	tireexplode-tiremove_tbl
	dc.w	tirebounce-tiremove_tbl

tiresit:
	movea.l	$34(a0),a1
	cmpi.b	#bossba_act,(a1)
	bne.w	frameout
	btst	#1,$2D(a1)
	beq.w	actionsub
	addq.b	#2,r_no1(a0)
	bra.w	actionsub

tireroll:
	movea.l	$34(a0),a1
	cmpi.b	#bossba_act,(a1)
	bne.w	frameout
	move.b	cddat(a1),cddat(a0)
	move.b	actflg(a1),actflg(a0)
	tst.b	cddat(a0)
	bpl.s	.cnt
	addq.b	#2,r_no1(a0)

.cnt:
	bsr.w	checkflip
	bsr.w	speedset2
	lea	bossdrillchg,a1
	bsr.w	patchg
	bra.w	actionsub

tireexplode:
	subi.w	#1,$2A(a0)
	bpl.w	actionsub
	addq.b	#2,r_no1(a0)
	move.w	#10,$2A(a0)
	move.w	#-$300,yspeed(a0)
	bsr.w	explode			; Note: Assembled as 6000 0000
	cmpi.b	#1,sprpri(a0)
	beq.w	actionsub
	neg.w	xspeed(a0)
	bra.w	actionsub

tirebounce:
	subq.w	#1,$2A(a0)
	bpl.w	actionsub
	bsr.w	speedset
	bsr.w	emycol_d
	tst.w	d1
	bpl.s	.end
	move.w	#-$200,yspeed(a0)
	add.w	d1,yposi(a0)

.end:
	bra.w	frameoutchk

drill:
	movea.l	$34(a0),a1
	cmpi.b	#bossba_act,(a1)
	bne.w	frameout
	btst	#3,$2D(a1)
	bne.s	.movedrill
	bsr.w	checkshoot
	btst	#1,$2D(a1)
	beq.w	actionsub
	move.w	xposi(a1),xposi(a0)
	move.w	yposi(a1),yposi(a0)
	move.b	cddat(a1),cddat(a0)
	move.b	actflg(a1),actflg(a0)
	addi.w	#$10,yposi(a0)
	move.w	#-$36,d0
	btst	#0,cddat(a0)
	beq.s	.cnt
	neg.w	d0

.cnt:
	add.w	d0,xposi(a0)
	lea	bossdrillchg,a1
	bsr.w	patchg
	bra.w	actionsub

.movedrill:
	move.w	#-3,d0
	btst	#0,cddat(a0)
	beq.s	.cnt3
	neg.w	d0

.cnt3:
	add.w	d0,xposi(a0)
	lea	bossdrillchg,a1
	bsr.w	patchg
	bra.w	actionsub

checkshoot:
	cmpi.b	#1,colicnt(a1)
	beq.s	.chkset
	rts

.chkset:
	move.w	xposi(a0),d0
	sub.w	playerwk+xposi,d0
	bpl.s	.left

.right:
	btst	#0,cddat(a1)
	bne.s	.set
	rts

.left:
	btst	#0,cddat(a1)
	beq.s	.set
	rts

.set:
	bset	#3,$2D(a1)
	rts

makewheels:
	jsr	actwkchk2
	bne.s	.worknai1
	move.b	#driller_act,actno(a1)
	move.l	a0,$34(a1)
	move.l	#bossdrillpat,patbase(a1)
	move.w	#$24C0,sproffset(a1)
	move.b	#4,actflg(a1)
	move.b	#$10,sprhs(a1)
	move.b	#1,sprpri(a1)
	move.b	#$10,sprvsize(a1)
	move.b	#$10,sprhsize(a1)
	move.l	xposi(a0),xposi(a1)
	move.l	yposi(a0),yposi(a1)
	addi.w	#$1C,xposi(a1)
	addi.w	#$C,yposi(a1)
	move.w	#-$200,xspeed(a1)
	move.b	#4,r_no0(a1)
	move.b	#4,patno(a1)
	move.b	#1,mstno(a1)
	move.w	#40,$2A(a1)

.worknai1:
	jsr	actwkchk2
	bne.s	.worknai2
	move.b	#driller_act,actno(a1)
	move.l	a0,$34(a1)
	move.l	#bossdrillpat,patbase(a1)
	move.w	#$24C0,sproffset(a1)
	move.b	#4,actflg(a1)
	move.b	#$10,sprhs(a1)
	move.b	#1,sprpri(a1)
	move.b	#$10,sprvsize(a1)
	move.b	#$10,sprhsize(a1)
	move.l	xposi(a0),xposi(a1)
	move.l	yposi(a0),yposi(a1)
	addi.w	#-$C,xposi(a1)
	addi.w	#$C,yposi(a1)
	move.w	#-$200,xspeed(a1)
	move.b	#4,r_no0(a1)
	move.b	#4,patno(a1)
	move.b	#1,mstno(a1)
	move.w	#20,$2A(a1)

.worknai2:
	jsr	actwkchk2
	bne.s	.worknai3
	move.b	#driller_act,actno(a1)
	move.l	a0,$34(a1)
	move.l	#bossdrillpat,patbase(a1)
	move.w	#$24C0,sproffset(a1)
	move.b	#4,actflg(a1)
	move.b	#$10,sprhs(a1)
	move.b	#2,sprpri(a1)
	move.b	#$10,sprvsize(a1)
	move.b	#$10,sprhsize(a1)
	move.l	xposi(a0),xposi(a1)
	move.l	yposi(a0),yposi(a1)
	addi.w	#-$2C,xposi(a1)
	addi.w	#$C,yposi(a1)
	move.w	#-$200,xspeed(a1)
	move.b	#4,r_no0(a1)
	move.b	#6,patno(a1)
	move.b	#2,mstno(a1)
	move.w	#30,$2A(a1)

.worknai3:
	jsr	actwkchk2
	bne.s	.worknai4
	move.b	#driller_act,actno(a1)
	move.l	a0,$34(a1)
	move.l	#bossdrillpat,patbase(a1)
	move.w	#$24C0,sproffset(a1)
	move.b	#4,actflg(a1)
	move.b	#$10,sprhs(a1)
	move.b	#1,sprpri(a1)
	move.l	xposi(a0),xposi(a1)
	move.l	yposi(a0),yposi(a1)
	addi.w	#-$36,xposi(a1)
	addi.w	#8,yposi(a1)
	move.b	#6,r_no0(a1)
	move.b	#1,patno(a1)
	move.b	#0,mstno(a1)

.worknai4:
	rts

drillerguy:
	jsr	actwkchk2
	bne.s	.worknai
	move.b	#driller_act,actno(a1)
	move.l	a0,$34(a1)
	move.l	#bossdrillpat,patbase(a1)
	move.w	#$4C0,sproffset(a1)
	move.b	#4,actflg(a1)
	move.b	#$20,sprhs(a1)
	move.b	#2,sprpri(a1)
	move.l	xposi(a0),xposi(a1)
	move.l	yposi(a0),yposi(a1)
	move.b	#2,r_no0(a1)

.worknai:
	bsr.w	makewheels
	subi.w	#8,$38(a0)
	move.w	#$2A00,xposi(a0)
	move.w	#$2C0,yposi(a0)
	jsr	actwkchk2
	bne.s	.worknai2
	move.b	#driller_act,actno(a1)
	move.l	a0,$34(a1)
	move.l	#bosshelipat,patbase(a1)
	move.w	#$2540,sproffset(a1)
	move.b	#4,actflg(a1)
	move.b	#$20,sprhs(a1)
	move.b	#4,sprpri(a1)
	move.l	xposi(a0),xposi(a1)
	move.l	yposi(a0),yposi(a1)
	move.w	#$1E,$2A(a1)
	move.b	#0,r_no0(a1)

.worknai2:
	rts

bosshelichg:
	dc.w	bosshelichg0-bosshelichg
	dc.w	bosshelichg1-bosshelichg
	dc.w	bosshelichg2-bosshelichg

bosshelichg0:
	dc.b	1, 5, 6, $FF

bosshelichg1:
	dc.b	1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, $FF

bosshelichg2:
	dc.b	1, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 4, 3, 3, 3, 2
	dc.b	2, 2, 1, 1, 1, 5, 6, $FE, 2
	even

bosshelipat:
	dc.w	bosshelisp00-bosshelipat
	dc.w	bosshelisp01-bosshelipat
	dc.w	bosshelisp02-bosshelipat
	dc.w	bosshelisp03-bosshelipat
	dc.w	bosshelisp04-bosshelipat
	dc.w	bosshelisp05-bosshelipat
	dc.w	bosshelisp06-bosshelipat

bosshelisp00:
	dc.w	1
	dc.w	$D805, 0, 0, 2

bosshelisp01:
	dc.w	5
	dc.w	$D805, 4, 2, 2
	dc.w	$D80D, $C, 6, $12
	dc.w	$D80D, $C, 6, $32
	dc.w	$D80D, $C, 6, $FFE2
	dc.w	$D80D, $C, 6, $FFC2

bosshelisp02:
	dc.w	5
	dc.w	$D805, 4, 2, 2
	dc.w	$D80D, $C, 6, $12
	dc.w	$D805, 8, 4, $32
	dc.w	$D80D, $C, 6, $FFE2
	dc.w	$D805, 8, 4, $FFD2

bosshelisp03:
	dc.w	3
	dc.w	$D805, 4, 2, 2
	dc.w	$D80D, $C, 6, $12
	dc.w	$D80D, $C, 6, $FFE2

bosshelisp04:
	dc.w	3
	dc.w	$D805, 4, 2, 2
	dc.w	$D805, 8, 4, $12
	dc.w	$D805, 8, 4, $FFF2

bosshelisp05:
	dc.w	3
	dc.w	$D805, 0, 0, 2
	dc.w	$D80D, $C, 6, $12
	dc.w	$D80D, $C, 6, $32

bosshelisp06:
	dc.w	3
	dc.w	$D805, 4, 2, 2
	dc.w	$D80D, $C, 6, $FFE2
	dc.w	$D80D, $C, 6, $FFC2

bossdrillchg:
	dc.w	bossdrillchg0-bossdrillchg
	dc.w	bossdrillchg1-bossdrillchg
	dc.w	bossdrillchg2-bossdrillchg

bossdrillchg0:
	dc.b	5, 1, 2, 3, $FF

bossdrillchg1:
	dc.b	1, 4, 5, $FF

bossdrillchg2:
	dc.b	1, 6, 7, $FF
	even

bossdrillpat:
	dc.w	bossdrillsp0-bossdrillpat
	dc.w	bossdrillsp1-bossdrillpat
	dc.w	bossdrillsp2-bossdrillpat
	dc.w	bossdrillsp3-bossdrillpat
	dc.w	bossdrillsp4-bossdrillpat
	dc.w	bossdrillsp5-bossdrillpat
	dc.w	bossdrillsp6-bossdrillpat
	dc.w	bossdrillsp7-bossdrillpat

bossdrillsp0:
	dc.w	3
	dc.w	$F00F, 0, 0, $FFD0
	dc.w	$F00F, $10, 8, $FFF0
	dc.w	$F00F, $20, $10, $10

bossdrillsp1:
	dc.w	1
	dc.w	$F00F, $30, $18, $FFF0

bossdrillsp2:
	dc.w	1
	dc.w	$F00F, $40, $20, $FFF0

bossdrillsp3:
	dc.w	1
	dc.w	$F00F, $50, $28, $FFF0

bossdrillsp4:
	dc.w	1
	dc.w	$F00F, $60, $30, $FFF0

bossdrillsp5:
	dc.w	1
	dc.w	$F00F, $1060, $1030, $FFF0

bossdrillsp6:
	dc.w	1
	dc.w	$F00F, $70, $38, $FFF0

bossdrillsp7:
	dc.w	1
	dc.w	$F00F, $1070, $1038, $FFF0
