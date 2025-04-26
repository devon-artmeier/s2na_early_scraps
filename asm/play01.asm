
	xref	bgmset, soundset, sinset, atan
	xref	ringgetsub, speedset2, actionsub, dualmodesub
	xref	patchgmain, playwrt, scrwkchk, edit
	xref	playpat

	xdef	play01, play02

play01:
	tst.w	editmode
	beq.s	.jump
	bsr.w	playscr
	bra.w	edit

.jump:
	moveq	#0,d0
	move.b	r_no0(a0),d0
	move.w	play01_move_tbl(pc,d0.w),d1
	jmp	play01_move_tbl(pc,d1.w)

play01_move_tbl:
	dc.w	play01init-play01_move_tbl
	dc.w	play01move-play01_move_tbl
	dc.w	play01gole-play01_move_tbl
	dc.w	play01gole2-play01_move_tbl

play01init:
	addq.b	#2,r_no0(a0)
	move.b	#$E,sprvsize(a0)
	move.b	#7,sprhsize(a0)
	move.l	#playpat,patbase(a0)
	move.w	#$780,sproffset(a0)
	bsr.w	dualmodesub
	move.b	#4,actflg(a0)
	move.b	#0,sprpri(a0)
	move.b	#2,mstno(a0)
	bset	#cd_ball,cddat(a0)
	bset	#cd_jump,cddat(a0)

play01move:
	tst.w	debugflag
	beq.s	.jump5
	btst	#4,swdata1+1
	beq.s	.jump5
	move.w	#1,editmode

.jump5:
	move.b	#0,$30(a0)
	moveq	#0,d0
	move.b	cddat(a0),d0
	andi.w	#2,d0
	move.w	play01move_tbl(pc,d0.w),d1
	jsr	play01move_tbl(pc,d1.w)
	jsr	playwrt
	jmp	actionsub

play01move_tbl:
	dc.w	play01walk-play01move_tbl
	dc.w	play01jump-play01move_tbl

play01walk:
	bsr.w	spjumpchk
	bsr.w	splevermove
	bsr.w	rotspdset
	bra.s	play01sub

play01jump:
	bsr.w	spjumpchk2
	bsr.w	splevermove
	bsr.w	rotspdset

play01sub:
	bsr.w	spcol_ev
	bsr.w	bobinchk
	jsr	speedset2
	bsr.w	playscr
	move.w	rotdir,d0
	add.w	rotspd,d0
	move.w	d0,rotdir
	jsr	patchgmain
	rts

splevermove:
	btst	#2,swdata
	beq.s	.jump5
	bsr.w	spplwalk_l

.jump5:
	btst	#3,swdata
	beq.s	.jump6
	bsr.w	spplwalk_r

.jump6:
	move.b	swdata,d0
	andi.b	#$C,d0
	bne.s	.jump7
	move.w	mspeed(a0),d0
	beq.s	.jump7
	bmi.s	.left
	subi.w	#$C,d0
	bcc.s	.right2
	move.w	#0,d0

.right2:
	move.w	d0,mspeed(a0)
	bra.s	.jump7

.left:
	addi.w	#$C,d0
	bcc.s	.left2
	move.w	#0,d0

.left2:
	move.w	d0,mspeed(a0)

.jump7:
	move.b	rotdir,d0
	addi.b	#$20,d0
	andi.b	#$C0,d0
	neg.b	d0
	jsr	sinset
	muls.w	mspeed(a0),d1
	add.l	d1,xposi(a0)
	muls.w	mspeed(a0),d0
	add.l	d0,yposi(a0)
	movem.l	d0-d1,-(sp)
	move.l	yposi(a0),d2
	move.l	xposi(a0),d3
	bsr.w	spcol
	beq.s	.jump
	movem.l	(sp)+,d0-d1
	sub.l	d1,xposi(a0)
	sub.l	d0,yposi(a0)
	move.w	#0,mspeed(a0)
	rts

.jump:
	movem.l	(sp)+,d0-d1
	rts

spplwalk_l:
	bset	#0,cddat(a0)
	move.w	mspeed(a0),d0
	beq.s	.left
	bpl.s	.right

.left:
	subi.w	#$C,d0
	cmpi.w	#-$800,d0
	bgt.s	.left2
	move.w	#-$800,d0

.left2:
	move.w	d0,mspeed(a0)
	rts

.right:
	subi.w	#$40,d0
	bcc.s	.right2
	nop

.right2:
	move.w	d0,mspeed(a0)
	rts

spplwalk_r:
	bclr	#0,cddat(a0)
	move.w	mspeed(a0),d0
	bmi.s	.left

.right:
	addi.w	#$C,d0
	cmpi.w	#$800,d0
	blt.s	.right2
	move.w	#$800,d0

.right2:
	move.w	d0,mspeed(a0)
	bra.s	.rightcol

.left:
	addi.w	#$40,d0
	bcc.s	.left2
	nop

.left2:
	move.w	d0,mspeed(a0)

.rightcol:
	rts

spjumpchk:
	move.b	swdata+1,d0
	andi.b	#$70,d0
	beq.s	.end
	move.b	rotdir,d0
	andi.b	#$FC,d0
	neg.b	d0
	subi.b	#$40,d0
	jsr	sinset
	muls.w	#$680,d1
	asr.l	#8,d1
	move.w	d1,xspeed(a0)
	muls.w	#$680,d0
	asr.l	#8,d0
	move.w	d0,yspeed(a0)
	bset	#cd_jump,cddat(a0)
	move.w	#$A0,d0
	jsr	soundset

.end:
	rts

spjumpchk2:
	rts
	; Dummied out
	move.w	#-$400,d1
	cmp.w	yspeed(a0),d1
	ble.s	.end
	move.b	swdata,d0
	andi.b	#$70,d0
	bne.s	.end
	move.w	d1,yspeed(a0)

.end:
	rts

playscr:
	move.w	yposi(a0),d2
	move.w	xposi(a0),d3
	move.w	scra_h_posit,d0
	subi.w	#$A0,d3
	bcs.s	loc_24E
	sub.w	d3,d0
	sub.w	d0,scra_h_posit

loc_24E:
	move.w	scra_v_posit,d0
	subi.w	#$70,d2
	bcs.s	.jump2
	sub.w	d2,d0
	sub.w	d0,scra_v_posit

.jump2:
	rts

play01gole:
	addi.w	#$40,rotspd
	cmpi.w	#$1800,rotspd
	bne.s	.jump0
	move.b	#gamemd,gmmode

.jump0:
	cmpi.w	#$3000,rotspd
	blt.s	.jump
	move.w	#0,rotspd
	move.w	#$4000,rotdir
	addq.b	#2,r_no0(a0)
	move.w	#60,$38(a0)

.jump:
	move.w	rotdir,d0
	add.w	rotspd,d0
	move.w	d0,rotdir
	jsr	patchgmain
	jsr	playwrt
	bsr.w	playscr
	jmp	actionsub

play01gole2:
	subq.w	#1,$38(a0)
	bne.s	.end
	move.b	#gamemd,gmmode

.end:
	jsr	patchgmain
	jsr	playwrt
	bsr.w	playscr
	jmp	actionsub

rotspdset:
	move.l	yposi(a0),d2
	move.l	xposi(a0),d3
	move.b	rotdir,d0
	andi.b	#$FC,d0
	jsr	sinset
	move.w	xspeed(a0),d4
	ext.l	d4
	asl.l	#8,d4
	muls.w	#$2A,d0
	add.l	d4,d0
	move.w	yspeed(a0),d4
	ext.l	d4
	asl.l	#8,d4
	muls.w	#$2A,d1
	add.l	d4,d1
	add.l	d0,d3
	bsr.w	spcol
	beq.s	.jump2
	sub.l	d0,d3
	moveq	#0,d0
	move.w	d0,xspeed(a0)
	bclr	#cd_jump,cddat(a0)
	add.l	d1,d2
	bsr.w	spcol
	beq.s	.jump3
	sub.l	d1,d2
	moveq	#0,d1
	move.w	d1,yspeed(a0)
	rts

.jump2:
	add.l	d1,d2
	bsr.w	spcol
	beq.s	.jump4
	sub.l	d1,d2
	moveq	#0,d1
	move.w	d1,yspeed(a0)
	bclr	#cd_jump,cddat(a0)

.jump3:
	asr.l	#8,d0
	asr.l	#8,d1
	move.w	d0,xspeed(a0)
	move.w	d1,yspeed(a0)
	rts

.jump4:
	asr.l	#8,d0
	asr.l	#8,d1
	move.w	d0,xspeed(a0)
	move.w	d1,yspeed(a0)
	bset	#cd_jump,cddat(a0)
	rts

spcol:
spcol2:
	lea	$FF0000,a1
	moveq	#0,d4
	swap	d2
	move.w	d2,d4
	swap	d2
	addi.w	#$44,d4
	divu.w	#$18,d4
	mulu.w	#$80,d4
	adda.l	d4,a1
	moveq	#0,d4
	swap	d3
	move.w	d3,d4
	swap	d3
	addi.w	#$14,d4
	divu.w	#$18,d4
	adda.w	d4,a1
	moveq	#0,d5
	move.b	(a1)+,d4
	bsr.s	spcolsub
	move.b	(a1)+,d4
	bsr.s	spcolsub
	adda.w	#$7E,a1
	move.b	(a1)+,d4
	bsr.s	spcolsub
	move.b	(a1)+,d4
	bsr.s	spcolsub
	tst.b	d5
	rts

spcolsub:
	beq.s	.end
	cmpi.b	#$28,d4
	beq.s	.end
	cmpi.b	#$3A,d4
	bcs.s	.jump2
	cmpi.b	#$4B,d4
	bcc.s	.jump2

.end:
	rts

.jump2:
	move.b	d4,$30(a0)
	move.l	a1,$32(a0)
	moveq	#-1,d5
	rts

spcol_ev:
	lea	$FF0000,a1
	moveq	#0,d4
	move.w	yposi(a0),d4
	addi.w	#$50,d4
	divu.w	#$18,d4
	mulu.w	#$80,d4
	adda.l	d4,a1
	moveq	#0,d4
	move.w	xposi(a0),d4
	addi.w	#$20,d4
	divu.w	#$18,d4
	adda.w	d4,a1
	move.b	(a1),d4
	bne.s	spcolsub_ev
	tst.b	$3A(a0)
	bne.w	derusub
	moveq	#0,d4
	rts

spcolsub_ev:
	cmpi.b	#$3A,d4
	bne.s	.jump2
	bsr.w	scrwkchk
	bne.s	.worknai
	move.b	#1,(a2)
	move.l	a1,4(a2)

.worknai:
	jsr	ringgetsub
	cmpi.w	#50,plring
	bcs.s	.jump
	bset	#0,plring_f2
	bne.s	.jump
	addq.b	#1,$FFFE18
	move.w	#$BF,d0
	jsr	bgmset

.jump:
	moveq	#0,d4
	rts

.jump2:
	cmpi.b	#$28,d4
	bne.s	.jump3
	bsr.w	scrwkchk
	bne.s	.worknai2
	move.b	#3,(a2)
	move.l	a1,4(a2)

.worknai2:
	addq.b	#1,pl_suu
	addq.b	#1,pl_suu_f
	move.w	#$88,d0
	jsr	bgmset
	moveq	#0,d4
	rts

.jump3:
	cmpi.b	#$3B,d4
	bcs.s	.jump4
	cmpi.b	#$40,d4
	bhi.s	.jump4
	bsr.w	scrwkchk
	bne.s	.worknai3
	move.b	#5,(a2)
	move.l	a1,4(a2)

.worknai3:
	cmpi.b	#6,$FFFE57
	beq.s	.jump33
	subi.b	#$3B,d4
	moveq	#0,d0
	move.b	$FFFE57,d0
	lea	$FFFE58,a2
	move.b	d4,(a2,d0.w)
	addq.b	#1,$FFFE57

.jump33:
	move.w	#$93,d0
	jsr	soundset
	moveq	#0,d4
	rts

.jump4:
	cmpi.b	#$41,d4
	bne.s	.jump5
	move.b	#1,$3A(a0)

.jump5:
	cmpi.b	#$4A,d4
	bne.s	.jump6
	cmpi.b	#1,$3A(a0)
	bne.s	.jump6
	move.b	#2,$3A(a0)

.jump6:
	moveq	#-1,d4
	rts

derusub:
	cmpi.b	#2,$3A(a0)
	bne.s	.end
	lea	$FF1020,a1
	moveq	#$40-1,d1

.loop1:
	moveq	#$40-1,d2

.loop2:
	cmpi.b	#$41,(a1)
	bne.s	.jump
	move.b	#$2C,(a1)

.jump:
	addq.w	#1,a1
	dbf	d2,.loop2
	lea	$40(a1),a1
	dbf	d1,.loop1

.end:
	clr.b	$3A(a0)
	moveq	#0,d4
	rts

bobinchk:
	move.b	$30(a0),d0
	bne.s	.jump
	subq.b	#1,$36(a0)
	bpl.s	.jmp
	move.b	#0,$36(a0)

.jmp:
	subq.b	#1,$37(a0)
	bpl.s	.jmp2
	move.b	#0,$37(a0)

.jmp2:
	rts

.jump:
	cmpi.b	#$25,d0
	bne.s	.jump2
	move.l	$32(a0),d1
	subi.l	#$FFFF0001,d1
	move.w	d1,d2
	andi.w	#$7F,d1
	mulu.w	#$18,d1
	subi.w	#$14,d1
	lsr.w	#7,d2
	andi.w	#$7F,d2
	mulu.w	#$18,d2
	subi.w	#$44,d2
	sub.w	xposi(a0),d1
	sub.w	yposi(a0),d2
	jsr	atan
	jsr	sinset
	muls.w	#-$700,d1
	asr.l	#8,d1
	move.w	d1,xspeed(a0)
	muls.w	#-$700,d0
	asr.l	#8,d0
	move.w	d0,yspeed(a0)
	bset	#cd_jump,cddat(a0)
	bsr.w	scrwkchk
	bne.s	.worknai
	move.b	#2,(a2)
	move.l	$32(a0),d0
	subq.l	#1,d0
	move.l	d0,4(a2)

.worknai:
	move.w	#$B4,d0
	jmp	soundset

.jump2:
	cmpi.b	#$27,d0
	bne.s	.jump3
	addq.b	#2,r_no0(a0)
	move.w	#$A8,d0
	jsr	soundset
	rts

.jump3:
	cmpi.b	#$29,d0
	bne.s	.jump4
	tst.b	$36(a0)
	bne.w	.jump7
	move.b	#30,$36(a0)
	btst	#6,rotspd+1
	beq.s	.jump33
	asl	rotspd
	movea.l	$32(a0),a1
	subq.l	#1,a1
	move.b	#$2A,(a1)

.jump33:
	move.w	#$A9,d0
	jmp	soundset

.jump4:
	cmpi.b	#$2A,d0
	bne.s	.jump5
	tst.b	$36(a0)
	bne.w	.jump7
	move.b	#$1E,$36(a0)
	btst	#6,rotspd+1
	bne.s	.jump44
	asr	rotspd
	movea.l	$32(a0),a1
	subq.l	#1,a1
	move.b	#$29,(a1)

.jump44:
	move.w	#$A9,d0
	jmp	soundset

.jump5:
	cmpi.b	#$2B,d0
	bne.s	.jump6
	tst.b	$37(a0)
	bne.w	.jump7
	move.b	#$1E,$37(a0)
	bsr.w	scrwkchk
	bne.s	.worknai2
	move.b	#4,(a2)
	move.l	$32(a0),d0
	subq.l	#1,d0
	move.l	d0,4(a2)

.worknai2:
	neg.w	rotspd
	move.w	#$A9,d0
	jmp	soundset

.jump6:
	cmpi.b	#$2D,d0
	beq.s	.jump66
	cmpi.b	#$2E,d0
	beq.s	.jump66
	cmpi.b	#$2F,d0
	beq.s	.jump66
	cmpi.b	#$30,d0
	bne.s	.jump7

.jump66:
	bsr.w	scrwkchk
	bne.s	.worknai3
	move.b	#6,(a2)
	movea.l	$32(a0),a1
	subq.l	#1,a1
	move.l	a1,4(a2)
	move.b	(a1),d0
	addq.b	#1,d0
	cmpi.b	#$30,d0
	bls.s	.jump666
	clr.b	d0

.jump666:
	move.b	d0,4(a2)

.worknai3:
	move.w	#$BA,d0
	jmp	soundset

.jump7:
.end:
	rts

play02:
	rts
