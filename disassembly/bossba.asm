
	xref	actionsub, frameout, patchg, actwkchk2
	xref	bossvac, bossdriller, vacumeguy, drillerguy

	xdef	bossba, billbomb

bossba:
	moveq	#0,d0
	move.b	r_no0(a0),d0
	move.w	bossba_move_tbl(pc,d0.w),d1
	jmp	bossba_move_tbl(pc,d1.w)

bossba_move_tbl:
	dc.w	bossbainit-bossba_move_tbl
	dc.w	bossbamove-bossba_move_tbl
	dc.w	bossbatop-bossba_move_tbl
	dc.w	bossafb-bossba_move_tbl
	dc.w	bosssm-bossba_move_tbl

bossbainit:
	move.l	#bossbapat,patbase(a0)
	move.w	#$2400,sproffset(a0)
	ori.b	#4,actflg(a0)
	move.b	#$20,sprhs(a0)
	move.b	#3,sprpri(a0)
	move.b	#$F,colino(a0)
	move.b	#2,colicnt(a0)
	addq.b	#2,r_no0(a0)
	move.w	xposi(a0),$30(a0)
	move.w	yposi(a0),$38(a0)
	move.b	userflag(a0),d0
	cmpi.b	#$81,d0
	bne.s	.cnt
	addi.w	#$60,sproffset(a0)

.cnt:
	jsr	actwkchk2
	bne.w	.worknai
	move.b	#bossba_act,actno(a1)
	move.l	a0,$34(a1)
	move.l	a1,$34(a0)
	move.l	#bossbapat,patbase(a1)
	move.w	#$400,sproffset(a1)
	move.b	#4,actflg(a1)
	move.b	#$20,sprhs(a1)
	move.b	#3,sprpri(a1)
	move.l	xposi(a0),xposi(a1)
	move.l	yposi(a0),yposi(a1)
	addq.b	#4,r_no0(a1)
	move.b	#1,mstno(a1)
	move.b	actflg(a0),actflg(a1)
	move.b	userflag(a0),d0
	cmpi.b	#$81,d0
	bne.s	.cnt2
	addi.w	#$60,sproffset(a1)

.cnt2:
	tst.b	userflag(a0)
	bmi.s	.worknai
	jsr	actwkchk2
	bne.s	.worknai
	move.b	#bossba_act,actno(a1)
	move.l	a0,$34(a1)
	move.l	#bossafbpat,patbase(a1)
	move.w	#$4D0,sproffset(a1)
	move.b	#1,pattim(a0)
	move.b	#4,actflg(a1)
	move.b	#$20,sprhs(a1)
	move.b	#3,sprpri(a1)
	move.l	xposi(a0),xposi(a1)
	move.l	yposi(a0),yposi(a1)
	addq.b	#6,r_no0(a1)
	move.b	actflg(a0),actflg(a1)

.worknai:
	move.b	userflag(a0),d0
	andi.w	#$7F,d0
	add.w	d0,d0
	add.w	d0,d0
	movea.l	bossbaappendage(pc,d0.w),a1
	jmp	(a1)

bossbaappendage:
	dc.l	vacumeguy	; Note: Assembled as 0000 0000
	dc.l	drillerguy

bossbamove:
	move.b	userflag(a0),d0
	andi.w	#$7F,d0
	add.w	d0,d0
	add.w	d0,d0
	movea.l	bossbamove_tbl(pc,d0.w),a1
	jsr	(a1)
	lea	bossbachg,a1
	jsr	patchg
	move.b	cddat(a0),d0
	andi.b	#3,d0
	andi.b	#$FC,actflg(a0)
	or.b	d0,actflg(a0)
	jmp	actionsub

bossbamove_tbl:
	dc.l	bossvac		; Note: Assembled as 0000 0000
	dc.l	bossdriller

bossbatop:
	movea.l	$34(a0),a1
	move.l	xposi(a1),xposi(a0)
	move.l	yposi(a1),yposi(a0)
	move.b	cddat(a1),cddat(a0)
	move.b	actflg(a1),actflg(a0)
	movea.l	#bossbachg,a1
	jsr	patchg
	jmp	actionsub

afbtbl:
	dc.b	0, -1, 1, 0

bossafb:
	btst	#7,cddat(a0)
	bne.s	.hurt
	movea.l	$34(a0),a1
	move.l	xposi(a1),xposi(a0)
	move.l	yposi(a1),yposi(a0)
	move.b	cddat(a1),cddat(a0)
	move.b	actflg(a1),actflg(a0)
	subq.b	#1,pattim(a0)
	bpl.s	.jump
	move.b	#1,pattim(a0)
	move.b	$2A(a0),d0
	addq.b	#1,d0
	cmpi.b	#2,d0
	ble.s	.cnt
	moveq	#0,d0

.cnt:
	move.b	afbtbl(pc,d0.w),patno(a0)
	move.b	d0,$2A(a0)

.jump:
	cmpi.b	#$FF,patno(a0)
	bne.w	actionsub
	rts

.hurt:
	movea.l	$34(a0),a1
	btst	#6,$2E(a1)
	bne.s	.here
	rts

.here:
	addq.b	#2,r_no0(a0)
	move.l	#bosssmpat,patbase(a0)
	move.w	#$4D8,sproffset(a0)
	move.b	#0,patno(a0)
	move.b	#5,pattim(a0)
	movea.l	$34(a0),a1
	move.w	xposi(a1),xposi(a0)
	move.w	yposi(a1),yposi(a0)
	addi.w	#4,yposi(a0)
	subi.w	#$28,xposi(a0)
	rts

bosssm:
	subq.b	#1,pattim(a0)
	bpl.s	.jump
	move.b	#5,pattim(a0)
	addq.b	#1,patno(a0)
	cmpi.b	#4,patno(a0)
	bne.w	.jump
	move.b	#0,patno(a0)
	movea.l	$34(a0),a1
	move.b	(a1),d0
	beq.w	frameout
	move.w	xposi(a1),xposi(a0)
	move.w	yposi(a1),yposi(a0)
	addi.w	#4,yposi(a0)
	subi.w	#$28,xposi(a0)

.jump:
	bra.w	actionsub

billbomb:
	moveq	#0,d0
	move.b	r_no0(a0),d0
	move.w	billbomb_tbl(pc,d0.w),d1
	jmp	billbomb_tbl(pc,d1.w)

billbomb_tbl:
	dc.w	billbombinit-billbomb_tbl
	dc.w	billbombmove-billbomb_tbl

billbombinit:
	addq.b	#2,r_no0(a0)
	move.l	#billbombpat,patbase(a0)
	move.w	#$5A0,sproffset(a0)
	move.b	#4,actflg(a0)
	move.b	#1,sprpri(a0)
	move.b	#0,colino(a0)
	move.b	#$C,sprhs(a0)
	move.b	#7,pattim(a0)
	move.b	#0,patno(a0)
	rts

billbombmove:
	subq.b	#1,pattim(a0)
	bpl.s	.jump
	move.b	#7,pattim(a0)
	addq.b	#1,patno(a0)
	cmpi.b	#7,patno(a0)
	beq.w	frameout

.jump:
	bra.w	actionsub

bossafbpat:
	dc.w	afbsp00-bossafbpat
	dc.w	afbsp01-bossafbpat

afbsp00:
	dc.w	1
	dc.w	$5, 0, 0, $1C

afbsp01:
	dc.w	1
	dc.w	$5, 4, 2, $1C

bosssmpat:
	dc.w	smbsp00-bosssmpat
	dc.w	smbsp01-bosssmpat
	dc.w	smbsp02-bosssmpat
	dc.w	smbsp03-bosssmpat

smbsp00:
	dc.w	1
	dc.w	$F805, 0, 0, $FFF8
smbsp01:
	dc.w	1
	dc.w	$F805, 4, 2, $FFF8
smbsp02:
	dc.w	1
	dc.w	$F805, 8, 4, $FFF8
smbsp03:
	dc.w	1
	dc.w	$F805, $C, 6, $FFF8

billbombpat:
	dc.w	bossbmsp00-billbombpat
	dc.w	bossbmsp01-billbombpat
	dc.w	bossbmsp02-billbombpat
	dc.w	bossbmsp03-billbombpat
	dc.w	bossbmsp04-billbombpat
	dc.w	bossbmsp05-billbombpat
	dc.w	bossbmsp06-billbombpat

bossbmsp00:
	dc.w	1
	dc.w	$F805, 0, 0, $FFF8

bossbmsp01:
	dc.w	1
	dc.w	$F00F, 4, 2, $FFF0

bossbmsp02:
	dc.w	1
	dc.w	$F00F, $14, $A, $FFF0

bossbmsp03:
	dc.w	1
	dc.w	$F00F, $24, $12, $FFF0

bossbmsp04:
	dc.w	1
	dc.w	$F00F, $34, $1A, $FFF0

bossbmsp05:
	dc.w	1
	dc.w	$F00F, $44, $22, $FFF0

bossbmsp06:
	dc.w	1
	dc.w	$F00F, $54, $2A, $FFF0

bossbachg:
	dc.w	bossbachg1-bossbachg
	dc.w	bossbachg2-bossbachg

bossbachg1:
	dc.b	$F, 0, $FF

bossbachg2:
	dc.b	7, 1, 2, $FF, 0

bossbapat:
	dc.w	bossbasp00-bossbapat
	dc.w	bossbasp01-bossbapat
	dc.w	bossbasp02-bossbapat

bossbasp00:
	dc.w	4
	dc.w	$F805, 0, 0, $FFE0
	dc.w	$805, 4, 2, $FFE0
	dc.w	$F80F, 8, 4, $FFF0
	dc.w	$F807, $18, $C, $10

bossbasp01:
	dc.w	4
	dc.w	$E805, $28, $14, $FFE0
	dc.w	$E80D, $30, $18, $FFF0
	dc.w	$E805, $24, $12, $10
	dc.w	$D805, $20, $10, 2

bossbasp02:
	dc.w	4
	dc.w	$E805, $28, $14, $FFE0
	dc.w	$E80D, $38, $1C, $FFF0
	dc.w	$E805, $24, $12, $10
	dc.w	$D805, $20, $10, 2

	nop	; Alignment
