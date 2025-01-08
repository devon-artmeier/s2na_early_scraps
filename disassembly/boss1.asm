
	xref	bgmset, soundset, random, sinset
	xref	burankoposiset, burankoposiset2, burankopat, ballpat
	xref	actionsub, frameout, patchg, dualmodesub
	xref	dualmodesub2, actwkchk, actwkchk2, scoreup

	xdef	boss1, boss_ysub, bossbomb, speedset_m
	xdef	boss1oyaji, boss1fire, btama, boss1chg
	xdef	boss1pat, boss1sp3, boss1sp4, boss2pat

boss1:
	moveq	#0,d0
	move.b	r_no0(a0),d0
	move.w	boss1_move_tbl(pc,d0.w),d1
	jmp	boss1_move_tbl(pc,d1.w)

boss1_move_tbl:
	dc.w	boss1init-boss1_move_tbl
	dc.w	boss1move-boss1_move_tbl
	dc.w	boss1oyaji-boss1_move_tbl
	dc.w	boss1fire-boss1_move_tbl

boss1tbl:
	dc.b	2, 0
	dc.b	4, 1
	dc.b	6, 7

boss1init:
	lea	boss1tbl(pc),a2
	movea.l	a0,a1
	moveq	#3-1,d1
	bra.s	.jump

.loop:
	jsr	actwkchk2
	bne.s	.worknai

.jump:
	move.b	(a2)+,r_no0(a1)
	move.b	#boss1_act,actno(a1)
	move.w	xposi(a0),xposi(a1)
	move.w	yposi(a0),yposi(a1)
	move.l	#boss1pat,patbase(a1)
	move.w	#$400,sproffset(a1)
	bsr.w	dualmodesub2
	move.b	#4,actflg(a1)
	move.b	#$20,sprhs(a1)
	move.b	#3,sprpri(a1)
	move.b	(a2)+,mstno(a1)
	move.l	a0,$34(a1)
	dbf	d1,.loop

.worknai:
	move.w	xposi(a0),$30(a0)
	move.w	yposi(a0),$38(a0)
	move.b	#$F,colino(a0)
	move.b	#8,colicnt(a0)

boss1move:
	moveq	#0,d0
	move.b	r_no1(a0),d0
	move.w	boss1move_tbl(pc,d0.w),d1
	jsr	boss1move_tbl(pc,d1.w)
	lea	boss1chg,a1
	jsr	patchg
	move.b	cddat(a0),d0
	andi.b	#3,d0
	andi.b	#$FC,actflg(a0)
	or.b	d0,actflg(a0)
	jmp	actionsub

boss1move_tbl:
	dc.w	boss1_0-boss1move_tbl
	dc.w	boss1_1-boss1move_tbl
	dc.w	boss1_2-boss1move_tbl
	dc.w	boss1_3-boss1move_tbl
	dc.w	boss1_4-boss1move_tbl
	dc.w	boss1_5-boss1move_tbl
	dc.w	boss1_6-boss1move_tbl

boss1_0:
	move.w	#$100,yspeed(a0)
	bsr.w	speedset_m
	cmpi.w	#$338,$38(a0)
	bne.s	.end
	move.w	#0,yspeed(a0)
	addq.b	#2,r_no1(a0)

.end:

boss_ysub:
	move.b	$3F(a0),d0
	jsr	sinset
	asr.w	#6,d0
	add.w	$38(a0),d0
	move.w	d0,yposi(a0)
	move.w	$30(a0),xposi(a0)
	addq.b	#2,$3F(a0)
	cmpi.b	#8,r_no1(a0)
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
	move.b	#8,r_no1(a0)
	move.w	#180-1,$3C(a0)
	rts

bossbomb:
	move.b	systemtimer+3,d0
	andi.b	#7,d0
	bne.s	.jump
	jsr	actwkchk
	bne.s	.worknai
	move.b	#$3F,actno(a1)
	move.w	xposi(a0),xposi(a1)
	move.w	yposi(a0),yposi(a1)
	jsr	random
	move.w	d0,d1
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
	rts

speedset_m:
	move.l	$30(a0),d2
	move.l	$38(a0),d3
	move.w	xspeed(a0),d0
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d2
	move.w	yspeed(a0),d0
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d3
	move.l	d2,$30(a0)
	move.l	d3,$38(a0)
	rts

boss1_1:
	move.w	#-$100,xspeed(a0)
	move.w	#-$40,yspeed(a0)
	bsr.w	speedset_m
	cmpi.w	#$2A00,$30(a0)
	bne.s	.end
	move.w	#0,xspeed(a0)
	move.w	#0,yspeed(a0)
	addq.b	#2,r_no1(a0)
	jsr	actwkchk2
	bne.s	.worknai
	move.b	#btama_act,actno(a1)
	move.w	$30(a0),xposi(a1)
	move.w	$38(a0),yposi(a1)
	move.l	a0,$34(a1)

.worknai:
	move.w	#120-1,$3C(a0)

.end:
	bra.w	boss_ysub

boss1_2:
	subq.w	#1,$3C(a0)
	bpl.s	.jump
	addq.b	#2,r_no1(a0)
	move.w	#$40-1,$3C(a0)
	move.w	#$100,xspeed(a0)
	cmpi.w	#$2A00,$30(a0)
	bne.s	.jump
	move.w	#$80-1,$3C(a0)
	move.w	#$40,xspeed(a0)

.jump:
	btst	#0,cddat(a0)
	bne.s	.jump2
	neg.w	xspeed(a0)

.jump2:
	bra.w	boss_ysub

boss1_3:
	subq.w	#1,$3C(a0)
	bmi.s	.jump2
	bsr.w	speedset_m
	bra.s	.end

.jump2:
	bchg	#0,cddat(a0)
	move.w	#$40-1,$3C(a0)
	subq.b	#2,r_no1(a0)
	move.w	#0,xspeed(a0)

.end:
	bra.w	boss_ysub

boss1_4:
	subq.w	#1,$3C(a0)
	bmi.s	.jump
	bra.w	bossbomb

.jump:
	bset	#0,cddat(a0)
	bclr	#7,cddat(a0)
	clr.w	xspeed(a0)
	addq.b	#2,r_no1(a0)
	move.w	#-$26,$3C(a0)
	tst.b	bossflag
	bne.s	.end
	move.b	#1,bossflag

.end:
	rts

boss1_5:
	addq.w	#1,$3C(a0)
	beq.s	.turn
	bpl.s	.rise_up

.falling:
	addi.w	#$18,yspeed(a0)
	bra.s	.exit

.turn:
	clr.w	yspeed(a0)
	bra.s	.exit

.rise_up:
	cmpi.w	#$30,$3C(a0)
	bcs.s	.go_up
	beq.s	.fire
	cmpi.w	#$38,$3C(a0)
	bcs.s	.exit
	addq.b	#2,r_no1(a0)
	bra.s	.exit

.go_up:
	subi.w	#8,yspeed(a0)
	bra.s	.exit

.fire:
	clr.w	yspeed(a0)
	move.w	#$81,d0
	jsr	bgmset

.exit:
	bsr.w	speedset_m
	bra.w	boss_ysub

boss1_6:
	move.w	#$400,xspeed(a0)
	move.w	#-$40,yspeed(a0)
	cmpi.w	#$2AC0,scralim_right
	beq.s	.jump
	addq.w	#2,scralim_right
	bra.s	.jump2

.jump:
	tst.b	1(a0)
	bpl.s	.frameout

.jump2:
	bsr.w	speedset_m
	bra.w	boss_ysub

.frameout:
	addq.l	#4,sp
	jmp	frameout

boss1oyaji:
	moveq	#0,d0
	moveq	#1,d1
	movea.l	$34(a0),a1
	move.b	r_no1(a1),d0
	subq.b	#4,d0
	bne.s	.pass0
	cmpi.w	#$2A00,$30(a1)
	bne.s	.pass1
	moveq	#4,d1

.pass0:
	subq.b	#6,d0
	bmi.s	.pass1
	moveq	#$A,d1
	bra.s	.jump

.pass1:
	tst.b	colino(a1)
	bne.s	.pass2
	moveq	#5,d1
	bra.s	.jump

.pass2:
	cmpi.b	#4,playerwk+r_no0
	bcs.s	.jump
	moveq	#4,d1

.jump:
	move.b	d1,mstno(a0)
	subq.b	#2,d0
	bne.s	.jump0
	move.b	#6,mstno(a0)
	tst.b	actflg(a0)
	bpl.s	.frameout

.jump0:
	bra.s	boss1sub

.frameout:
	jmp	frameout

boss1fire:
	move.b	#7,mstno(a0)
	movea.l	$34(a0),a1
	cmpi.b	#$C,r_no1(a1)
	bne.s	.jump0
	move.b	#$B,mstno(a0)
	tst.b	actflg(a0)
	bpl.s	.frameout
	bra.s	.jump

.jump0:
	move.w	xspeed(a1),d0
	beq.s	.jump
	move.b	#8,mstno(a0)

.jump:
	bra.s	boss1sub

.frameout:
	jmp	frameout

boss1sub:
	movea.l	$34(a0),a1
	move.w	xposi(a1),xposi(a0)
	move.w	yposi(a1),yposi(a0)
	move.b	cddat(a1),cddat(a0)
	lea	boss1chg,a1
	jsr	patchg
	move.b	cddat(a0),d0
	andi.b	#3,d0
	andi.b	#$FC,actflg(a0)
	or.b	d0,actflg(a0)
	jmp	actionsub

btama:
	moveq	#0,d0
	move.b	r_no0(a0),d0
	move.w	btama_move_tbl(pc,d0.w),d1
	jmp	btama_move_tbl(pc,d1.w)

btama_move_tbl:
	dc.w	btamainit-btama_move_tbl
	dc.w	btamamove-btama_move_tbl
	dc.w	btamamove2-btama_move_tbl
	dc.w	btamakusari-btama_move_tbl
	dc.w	btamatama-btama_move_tbl

btamainit:
	addq.b	#2,r_no0(a0)
	move.w	#$4080,direc(a0)
	move.w	#-$200,$3E(a0)
	move.l	#boss2pat_,patbase(a0)
	move.w	#$46C,sproffset(a0)
	bsr.w	dualmodesub
	lea	userflag(a0),a2
	move.b	#0,(a2)+
	moveq	#6-1,d1
	movea.l	a0,a1
	bra.s	.jump

.loop:
	jsr	actwkchk2
	bne.s	.worknai
	move.w	xposi(a0),xposi(a1)
	move.w	yposi(a0),yposi(a1)
	move.b	#btama_act,actno(a1)
	move.b	#6,r_no0(a1)
	move.l	#burankopat,patbase(a1)
	move.w	#$380,sproffset(a1)
	bsr.w	dualmodesub2
	move.b	#1,patno(a1)
	addq.b	#1,userflag(a0)

.jump:
	move.w	a1,d5
	subi.w	#actwk,d5
	lsr.w	#6,d5
	andi.w	#$7F,d5
	move.b	d5,(a2)+
	move.b	#4,actflg(a1)
	move.b	#8,sprhs(a1)
	move.b	#6,sprpri(a1)
	move.l	$34(a0),$34(a1)
	dbf	d1,.loop

.worknai:
	move.b	#8,r_no0(a1)
	move.l	#ballpat,patbase(a1)
	move.w	#$43AA,sproffset(a1)
	bsr.w	dualmodesub2
	move.b	#1,patno(a1)
	move.b	#5,sprpri(a1)
	move.b	#$81,colino(a1)
	rts

btamalentbl:
	dc.b	0, $10, $20, $30, $40, $60

btamamove:
	lea	btamalentbl(pc),a3
	lea	userflag(a0),a2
	moveq	#0,d6
	move.b	(a2)+,d6

.loop:
	moveq	#0,d4
	move.b	(a2)+,d4
	lsl.w	#6,d4
	addi.l	#actwk,d4
	movea.l	d4,a1
	move.b	(a3)+,d0
	cmp.b	$3C(a1),d0
	beq.s	.jump
	addq.b	#1,$3C(a1)

.jump:
	dbf	d6,.loop
	cmp.b	$3C(a1),d0
	bne.s	.jump2
	movea.l	$34(a0),a1
	cmpi.b	#6,r_no1(a1)
	bne.s	.jump2
	addq.b	#2,r_no0(a0)

.jump2:
	cmpi.w	#$20,$32(a0)
	beq.s	.jump3
	addq.w	#1,$32(a0)

.jump3:
	bsr.w	btamasub
	move.b	direc(a0),d0
	jsr	burankoposiset2
	jmp	actionsub

btamamove2:
	bsr.w	btamasub
	jsr	burankoposiset
	jmp	actionsub

btamasub:
	movea.l	$34(a0),a1
	addi.b	#$20,patcnt(a0)
	bcc.s	.pass
	bchg	#0,patno(a0)

.pass:
	move.w	xposi(a1),$3A(a0)
	move.w	yposi(a1),d0
	add.w	$32(a0),d0
	move.w	d0,$38(a0)
	move.b	cddat(a1),cddat(a0)
	tst.b	cddat(a1)
	bpl.s	.jump
	move.b	#$3F,actno(a0)
	move.b	#0,r_no0(a0)

.jump:
	rts

btamakusari:
	movea.l	$34(a0),a1
	tst.b	cddat(a1)
	bpl.s	.jump
	move.b	#$3F,actno(a0)
	move.b	#0,r_no0(a0)

.jump:
	jmp	actionsub

btamatama:
	moveq	#0,d0
	tst.b	patno(a0)
	bne.s	.jump0
	addq.b	#1,d0

.jump0:
	move.b	d0,patno(a0)
	movea.l	$34(a0),a1
	tst.b	cddat(a1)
	bpl.s	.jump
	move.b	#0,colino(a0)
	bsr.w	bossbomb
	subq.b	#1,$3C(a0)
	bpl.s	.jump
	move.b	#$3F,(a0)
	move.b	#0,r_no0(a0)

.jump:
	jmp	actionsub

boss1chg:
	dc.w	boss1chg0-boss1chg
	dc.w	boss1chg1-boss1chg
	dc.w	boss1chg2-boss1chg
	dc.w	boss1chg3-boss1chg
	dc.w	boss1chg4-boss1chg
	dc.w	boss1chg5-boss1chg
	dc.w	boss1chg6-boss1chg
	dc.w	boss1chg7-boss1chg
	dc.w	boss1chg8-boss1chg
	dc.w	boss1chg9-boss1chg
	dc.w	boss1chg10-boss1chg
	dc.w	boss1chg11-boss1chg

boss1chg0:
	dc.b	$F, 0, $FF

boss1chg1:
	dc.b	5, 1, 2, $FF

boss1chg2:
	dc.b	3, 1, 2, $FF

boss1chg3:
	dc.b	1, 1, 2, $FF

boss1chg4:
	dc.b	4, 3, 4, $FF

boss1chg5:
	dc.b	$1F, 5, 1, $FF

boss1chg6:
	dc.b	3, 6, 1, $FF

boss1chg7:
	dc.b	$F, $A, $FF

boss1chg8:
	dc.b	3, 8, 9, $FF

boss1chg9:
	dc.b	1, 8, 9, $FF

boss1chg10:
	dc.b	$F, 7, $FF

boss1chg11:
	dc.b	2, 9, 8, $B, $C, $B, $C, 9, 8, $FE, 2

boss1pat:
	dc.w	boss1sp0-boss1pat
	dc.w	boss1sp1-boss1pat
	dc.w	boss1sp2-boss1pat
	dc.w	boss1sp3-boss1pat
	dc.w	boss1sp4-boss1pat
	dc.w	boss1sp5-boss1pat
	dc.w	boss1sp6-boss1pat
	dc.w	boss1sp7-boss1pat
	dc.w	boss1sp8-boss1pat
	dc.w	boss1sp9-boss1pat
	dc.w	boss1sp10-boss1pat
	dc.w	boss1sp11-boss1pat
	dc.w	boss1sp12-boss1pat

boss1sp0:
	dc.w	6
	dc.w	$EC01, $A, 5, $FFE4
	dc.w	$EC05, $C, 6, $C
	dc.w	$FC0E, $2010, $2008, $FFE4
	dc.w	$FC0E, $201C, $200E, 4
	dc.w	$140C, $2028, $2014, $FFEC
	dc.w	$1400, $202C, $2016, $C

boss1sp1:
	dc.w	2
	dc.w	$E404, 0, 0, $FFF4
	dc.w	$EC0D, 2, 1, $FFEC

boss1sp2:
	dc.w	2
	dc.w	$E404, 0, 0, $FFF4
	dc.w	$EC0D, $35, $1A, $FFEC

boss1sp3:
	dc.w	3
	dc.w	$E408, $3D, $1E, $FFF4
	dc.w	$EC09, $40, $20, $FFEC
	dc.w	$EC05, $46, $23, 4

boss1sp4:
	dc.w	3
	dc.w	$E408, $4A, $25, $FFF4
	dc.w	$EC09, $4D, $26, $FFEC
	dc.w	$EC05, $53, $29, 4

boss1sp5:
	dc.w	3
	dc.w	$E408, $57, $2B, $FFF4
	dc.w	$EC09, $5A, $2D, $FFEC
	dc.w	$EC05, $60, $30, 4

boss1sp6:
	dc.w	3
	dc.w	$E404, $64, $32, 4
	dc.w	$E404, 0, 0, $FFF4
	dc.w	$EC0D, $35, $1A, $FFEC

boss1sp7:
	dc.w	4
	dc.w	$E409, $66, $33, $FFF4
	dc.w	$E408, $57, $2B, $FFF4
	dc.w	$EC09, $5A, $2D, $FFEC
	dc.w	$EC05, $60, $30, 4

boss1sp8:
	dc.w	1
	dc.w	$405, $2D, $16, $22

boss1sp9:
	dc.w	1
	dc.w	$405, $31, $18, $22

boss1sp10:
	dc.w	0

boss1sp11:
	dc.w	2
	dc.w	8, $12A, $195, $22
	dc.w	$808, $112A, $1995, $22

boss1sp12:
	dc.w	2
	dc.w	$F80B, $12D, $199, $22
	dc.w	1, $139, $1AB, $3A

boss2pat:
	dc.w	boss2sp0-boss2pat
	dc.w	boss2sp1-boss2pat
	dc.w	boss2sp2-boss2pat
	dc.w	boss2sp3-boss2pat
	dc.w	boss2sp4-boss2pat
	dc.w	boss2sp5-boss2pat
	dc.w	boss2sp6-boss2pat
	dc.w	boss2sp7-boss2pat

boss2sp0:
	dc.w	1
	dc.w	$F805, 0, 0, $FFF8

boss2sp1:
	dc.w	2
	dc.w	$FC04, 4, 2, $FFF8
	dc.w	$F805, 0, 0, $FFF8

boss2sp2:
	dc.w	1
	dc.w	$FC00, 6, 3, $FFFC

boss2sp3:
	dc.w	1
	dc.w	$1409, 7, 3, $FFF4

boss2sp4:
	dc.w	1
	dc.w	$1405, $D, 6, $FFF8

boss2sp5:
	dc.w	4
	dc.w	$F004, $11, 8, $FFF8
	dc.w	$F801, $13, 9, $FFF8
	dc.w	$F801, $813, $809, 0
	dc.w	$804, $15, $A, $FFF8

boss2sp6:
	dc.w	2
	dc.w	5, $17, $B, 0
	dc.w	0, $1B, $D, $10

boss2sp7:
	dc.w	2
	dc.w	$1804, $1C, $E, 0
	dc.w	$B, $1E, $F, $10
