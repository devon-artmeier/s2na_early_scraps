
	xref	ascii, bgmset, actionsub, dualmodesub
	xref	playdieset

	xdef	score, scoreup, scoreset, scoreinit
	xdef	contwrt

score:
	moveq	#0,d0
	move.b	r_no0(a0),d0
	move.w	score_move_tbl(pc,d0.w),d1
	jmp	score_move_tbl(pc,d1.w)

score_move_tbl:
	dc.w	score_init-score_move_tbl
	dc.w	score_move-score_move_tbl

score_init:
	addq.b	#2,r_no0(a0)
	move.w	#$10+$80,xposi(a0)
	move.w	#$88+$80,$A(a0)
	move.l	#scorepat,patbase(a0)
	move.w	#$6CA,sproffset(a0)
	bsr.w	dualmodesub
	move.b	#0,actflg(a0)
	move.b	#0,sprpri(a0)

score_move:
	tst.w	plring
	beq.s	.jump
	moveq	#0,d0
	btst	#3,gametimer+1
	bne.s	.jump0
	cmpi.b	#9,pltime+1
	bne.s	.jump0
	addq.w	#2,d0

.jump0:
	move.b	d0,patno(a0)
	jmp	actionsub

.jump:
	moveq	#0,d0
	btst	#3,gametimer+1
	bne.s	.jump2
	addq.w	#1,d0
	cmpi.b	#9,pltime+1
	bne.s	.jump2
	addq.w	#2,d0

.jump2:
	move.b	d0,patno(a0)
	jmp	actionsub

scorepat:
	dc.w	scoresp0-scorepat
	dc.w	scoresp1-scorepat
	dc.w	scoresp2-scorepat
	dc.w	scoresp3-scorepat

scoresp0:
	dc.w	$A
	dc.w	$800D, $A000, $A000, 0
	dc.w	$800D, $A018, $A00C, $20
	dc.w	$800D, $A020, $A010, $40
	dc.w	$900D, $A010, $A008, 0
	dc.w	$900D, $A028, $A014, $28
	dc.w	$A00D, $A008, $A004, 0
	dc.w	$A001, $A000, $A000, $20
	dc.w	$A009, $A030, $A018, $30
	dc.w	$4005, $810A, $8085, 0
	dc.w	$400D, $A10E, $A087, $10

scoresp1:
	dc.w	$A
	dc.w	$800D, $A000, $A000, 0
	dc.w	$800D, $A018, $A00C, $20
	dc.w	$800D, $A020, $A010, $40
	dc.w	$900D, $A010, $A008, 0
	dc.w	$900D, $A028, $A014, $28
	dc.w	$A00D, $8008, $8004, 0
	dc.w	$A001, $8000, $8000, $20
	dc.w	$A009, $A030, $A018, $30
	dc.w	$4005, $810A, $8085, 0
	dc.w	$400D, $A10E, $A087, $10

scoresp2:
	dc.w	$A
	dc.w	$800D, $A000, $A000, 0
	dc.w	$800D, $A018, $A00C, $20
	dc.w	$800D, $A020, $A010, $40
	dc.w	$900D, $8010, $8008, 0
	dc.w	$900D, $A028, $A014, $28
	dc.w	$A00D, $A008, $A004, 0
	dc.w	$A001, $A000, $A000, $20
	dc.w	$A009, $A030, $A018, $30
	dc.w	$4005, $810A, $8085, 0
	dc.w	$400D, $A10E, $A087, $10

scoresp3:
	dc.w	$A
	dc.w	$800D, $A000, $A000, 0
	dc.w	$800D, $A018, $A00C, $20
	dc.w	$800D, $A020, $A010, $40
	dc.w	$900D, $8010, $8008, 0
	dc.w	$900D, $A028, $A014, $28
	dc.w	$A00D, $8008, $8004, 0
	dc.w	$A001, $8000, $8000, $20
	dc.w	$A009, $A030, $A018, $30
	dc.w	$4005, $810A, $8085, 0
	dc.w	$400D, $A10E, $A087, $10

scoreup:
	move.b	#1,plscore_f
	lea	plscore,a3
	add.l	d0,(a3)
	move.l	#999999,d1
	cmp.l	(a3),d1
	bhi.s	.jump
	move.l	d1,(a3)

.jump:
	move.l	(a3),d0
	cmp.l	extrascore,d0
	bcs.s	.jump0
	addi.l	#5000,extrascore
	tst.b	mdstatus
	bmi.s	.jumpus
	addq.b	#1,pl_suu
	addq.b	#1,pl_suu_f
	move.w	#$88,d0
	jmp	bgmset

.jump0:
.jumpus:
	rts

scoreset:
	nop
	lea	$C00000,a6
	tst.w	debugflag
	bne.w	scoreset2
	tst.b	plscore_f
	beq.s	.jump
	clr.b	plscore_f
	move.l	#$5C800003,d0
	move.l	plscore,d1
	bsr.w	scorewrt

.jump:
	tst.b	plring_f
	beq.s	.jump2
	bpl.s	.jump1
	bsr.w	ringinit

.jump1:
	clr.b	plring_f
	move.l	#$5F400003,d0
	moveq	#0,d1
	move.w	plring,d1
	bsr.w	ringwrt

.jump2:
	tst.b	pltime_f
	beq.s	.jump4
	tst.w	pauseflag
	bne.s	.jump4
	lea	pltime,a1
	cmpi.l	#(9<<16)|(59<<8)|59,(a1)+
	nop
	addq.b	#1,-(a1)
	cmpi.b	#60,(a1)
	bcs.s	.jump4
	move.b	#0,(a1)
	addq.b	#1,-(a1)
	cmpi.b	#60,(a1)
	bcs.s	.jump3
	move.b	#0,(a1)
	addq.b	#1,-(a1)
	cmpi.b	#9,(a1)
	bcs.s	.jump3
	move.b	#9,(a1)

.jump3:
	move.l	#$5E400003,d0
	moveq	#0,d1
	move.b	pltime+1,d1
	bsr.w	timewrt1
	move.l	#$5EC00003,d0
	moveq	#0,d1
	move.b	pltime+2,d1
	bsr.w	timewrt

.jump4:
	tst.b	pl_suu_f
	beq.s	.jump5
	clr.b	pl_suu_f
	bsr.w	playsuuwrt

.jump5:
	tst.b	bonus_f
	beq.s	.jump6
	clr.b	bonus_f
	move.l	#$6E000002,$C00004
	moveq	#0,d1
	move.w	timebonus,d1
	bsr.w	bonuswrt
	moveq	#0,d1
	move.w	ringbonus,d1
	bsr.w	bonuswrt

.jump6:
	rts

.timeover:
	clr.b	pltime_f
	lea	playerwk,a0
	movea.l	a0,a2
	bsr.w	playdieset
	move.b	#1,pltimeover_f
	rts

scoreset2:
	bsr.w	posiwrt
	tst.b	plring_f
	beq.s	.jump2
	bpl.s	.jump1
	bsr.w	ringinit

.jump1:
	clr.b	plring_f
	move.l	#$5F400003,d0
	moveq	#0,d1
	move.w	plring,d1
	bsr.w	ringwrt

.jump2:
	move.l	#$5EC00003,d0
	moveq	#0,d1
	move.b	linkdata,d1
	bsr.w	timewrt

.jump3:
	tst.b	pl_suu_f
	beq.s	.jump4
	clr.b	pl_suu_f
	bsr.w	playsuuwrt

.jump4:
	tst.b	bonus_f
	beq.s	.jump5
	clr.b	bonus_f
	move.l	#$6E000002,$C00004
	moveq	#0,d1
	move.w	timebonus,d1
	bsr.w	bonuswrt
	moveq	#0,d1
	move.w	ringbonus,d1
	bsr.w	bonuswrt

.jump5:
	rts

ringinit:
	move.l	#$5F400003,$C00004
	lea	ringinittbl(pc),a2
	move.w	#3-1,d2
	bra.s	scoreinitsub

scoreinit:
	lea	$C00000,a6
	bsr.w	playsuuwrt
	move.l	#$5C400003,$C00004
	lea	scoreinittbl(pc),a2
	move.w	#$F-1,d2

scoreinitsub:
	lea	scorewrtcg(pc),a1

.loop:
	move.w	#$10-1,d1
	move.b	(a2)+,d0
	bmi.s	.spaceset
	ext.w	d0
	lsl.w	#5,d0
	lea	(a1,d0.w),a3

.loop1:
	move.l	(a3)+,(a6)
	dbf	d1,.loop1

.jump:
	dbf	d2,.loop
	rts

.spaceset:
.loop2:
	move.l	#0,(a6)
	dbf	d1,.loop2
	bra.s	.jump

scoreinittbl:
	dc.b	$16, $FF, $FF, $FF, $FF, $FF, $FF, 0
	dc.b	0, $14, 0, 0

ringinittbl:
	dc.b	$FF, $FF, 0
	even

posiwrt:
	move.l	#$5C400003,$C00004
	move.w	scra_h_posit,d1
	move.w	$FFFFEC,d1
	swap	d1
	move.w	playerwk+xposi,d1
	bsr.s	hexwrtw
	move.w	scra_v_posit,d1
	move.w	$FFFFEE,d1
	swap	d1
	move.w	playerwk+yposi,d1

hexwrtw:
	moveq	#8-1,d6
	lea	ascii,a1

.loop:
	rol.w	#4,d1
	move.w	d1,d2
	andi.w	#$F,d2
	cmpi.w	#$A,d2
	bcs.s	.jump
	addi.w	#7,d2

.jump:
	lsl.w	#5,d2
	lea	(a1,d2.w),a3
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)

.jump5:
	swap	d1
	dbf	d6,.loop
	rts

ringwrt:
	lea	subtbl3,a2
	moveq	#3-1,d6
	bra.s	scorewrt2

scorewrt:
	lea	subtbl,a2
	moveq	#6-1,d6

scorewrt2:
	moveq	#0,d4
	lea	scorewrtcg(pc),a1

.loop:
	moveq	#0,d2
	move.l	(a2)+,d3

.jump2:
	sub.l	d3,d1
	bcs.s	.jump3
	addq.w	#1,d2
	bra.s	.jump2

.jump3:
	add.l	d3,d1
	tst.w	d2
	beq.s	.jump4
	move.w	#1,d4

.jump4:
	tst.w	d4
	beq.s	.jump5
	lsl.w	#6,d2
	move.l	d0,4(a6)
	lea	(a1,d2.w),a3
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)

.jump5:
	addi.l	#$400000,d0
	dbf	d6,.loop
	rts

contwrt:
	move.l	#$5F800003,$C00004
	lea	$C00000,a6
	lea	subtbl2,a2
	moveq	#2-1,d6
	moveq	#0,d4
	lea	scorewrtcg(pc),a1

.loop:
	moveq	#0,d2
	move.l	(a2)+,d3

.jump2:
	sub.l	d3,d1
	bcs.s	.jump3
	addq.w	#1,d2
	bra.s	.jump2

.jump3:
	add.l	d3,d1
	lsl.w	#6,d2
	lea	(a1,d2.w),a3
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	dbf	d6,.loop
	rts

subtbl:
	dc.l	100000
	dc.l	10000
subtbl4:
	dc.l	1000
subtbl3:
	dc.l	100
subtbl2:
	dc.l	10
subtbl1:
	dc.l	1

timewrt1:
	lea	subtbl1(pc),a2
	moveq	#1-1,d6
	bra.s	timewrt0

timewrt:
	lea	subtbl2(pc),a2
	moveq	#2-1,d6

timewrt0:
	moveq	#0,d4
	lea	scorewrtcg(pc),a1

.loop:
	moveq	#0,d2
	move.l	(a2)+,d3

.jump2:
	sub.l	d3,d1
	bcs.s	.jump3
	addq.w	#1,d2
	bra.s	.jump2

.jump3:
	add.l	d3,d1
	tst.w	d2
	beq.s	.jump4
	move.w	#1,d4

.jump4:
	lsl.w	#6,d2
	move.l	d0,4(a6)
	lea	(a1,d2.w),a3
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	addi.l	#$400000,d0
	dbf	d6,.loop
	rts

bonuswrt:
	lea	subtbl4(pc),a2
	moveq	#4-1,d6
	moveq	#0,d4
	lea	scorewrtcg(pc),a1

.loop:
	moveq	#0,d2
	move.l	(a2)+,d3

.jump2:
	sub.l	d3,d1
	bcs.s	.jump3
	addq.w	#1,d2
	bra.s	.jump2

.jump3:
	add.l	d3,d1
	tst.w	d2
	beq.s	.jump4
	move.w	#1,d4

.jump4:
	tst.w	d4
	beq.s	.jump7
	lsl.w	#6,d2
	lea	(a1,d2.w),a3
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)

.jump5:
	dbf	d6,.loop
	rts

.jump7:
	moveq	#$10-1,d5

.loop2:
	move.l	#0,(a6)
	dbf	d5,.loop2
	bra.s	.jump5

playsuuwrt:
	move.l	#$7BA00003,d0
	moveq	#0,d1
	move.b	pl_suu,d1
	lea	subtbl2(pc),a2
	moveq	#2-1,d6
	moveq	#0,d4
	lea	playsuucg(pc),a1

.loop:
	move.l	d0,4(a6)
	moveq	#0,d2
	move.l	(a2)+,d3

.jump2:
	sub.l	d3,d1
	bcs.s	.jump3
	addq.w	#1,d2
	bra.s	.jump2

.jump3:
	add.l	d3,d1
	tst.w	d2
	beq.s	.jump4
	move.w	#1,d4

.jump4:
	tst.w	d4
	beq.s	.jump7

.jump5:
	lsl.w	#5,d2
	lea	(a1,d2.w),a3
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)
	move.l	(a3)+,(a6)

.jump6:
	addi.l	#$400000,d0
	dbf	d6,.loop
	rts

.jump7:
	tst.w	d6
	beq.s	.jump5
	moveq	#8-1,d5

.loop2:
	move.l	#0,(a6)
	dbf	d5,.loop2
	bra.s	.jump6

scorewrtcg:
	dc.b	0, 0, 0, 0, 0, $66, $66, $10, 6, $66, $66, $61, 6, $61, $16, $61
	dc.b	6, $61, 6, $61, $76, $61, $76, $61, $66, $10, $66, $10, $66, $10, $66, $10
	dc.b	$66, $10, $66, $10, $66, $66, $66, $10, 6, $66, $61, 0, 1, $11, $10, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 6, $61, 0, 0, $66, $61, 0, 0, 6, $61, 0
	dc.b	0, 6, $61, 0, 0, $76, $61, 0, 0, $66, $10, 0, 0, $66, $10, 0
	dc.b	0, $66, $10, 0, 0, $66, $10, 0, 0, $66, $10, 0, 0, $11, $10, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, $66, $66, $10, 6, $66, $66, $61, 6, $61, $16, $61
	dc.b	1, $11, $66, $61, 0, 6, $66, $10, 7, $66, $10, 0, $76, $61, 0, 0
	dc.b	$66, $61, 0, 0, $66, $66, $66, $10, $66, $66, $66, $10, $11, $11, $11, $10
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, $66, $66, $10, 6, $66, $66, $61, 6, $61, $16, $61
	dc.b	1, $11, 6, $61, 0, 6, $66, $10, 0, $66, $61, 0, 0, $11, $66, $10
	dc.b	$66, $10, $66, $10, $66, $66, $66, $10, 6, $66, $61, 0, 1, $11, $10, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, $66, $10, 0, 6, $66, $10, 0, $76, $66, $10
	dc.b	0, $66, $66, $10, 6, $61, $66, $10, $76, $16, $61, 0, $66, $66, $66, $10
	dc.b	$66, $66, $66, $10, $11, $16, $61, $10, 0, 6, $61, 0, 0, 1, $11, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 6, $66, $66, $61, 6, $66, $66, $61, 6, $61, $11, $11
	dc.b	6, $61, 0, 0, $76, $66, $67, $10, $66, $66, $66, $10, $11, $11, $66, $10
	dc.b	$66, $10, $66, $10, $66, $66, $66, $10, $16, $66, $61, 0, 1, $11, $10, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, $66, $66, $10, 6, $66, $66, $61, 6, $61, $16, $61
	dc.b	6, $61, 1, $11, $76, $66, $78, $10, $66, $66, $67, $10, $66, $11, $66, $10
	dc.b	$66, $10, $66, $10, $66, $66, $66, $10, 6, $66, $61, 0, 1, $11, $10, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 6, $66, $66, $61, 6, $66, $66, $61, 1, $11, $16, $61
	dc.b	0, 0, $76, $10, 0, 7, $66, $10, 0, 6, $61, 0, 0, $66, $10, 0
	dc.b	0, $66, $10, 0, 6, $67, $10, 0, 6, $67, $10, 0, 0, $11, $10, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, $66, $66, $10, 6, $66, $66, $61, 6, $61, $16, $61
	dc.b	6, $61, 6, $61, 0, $66, $66, $10, 6, $66, $61, 0, $66, $11, $66, $10
	dc.b	$66, $10, $66, $10, $66, $66, $66, $10, 6, $66, $61, 0, 1, $11, $10, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, $66, $66, $10, 6, $66, $66, $61, 6, $61, $16, $61
	dc.b	6, $61, 6, $61, 6, $66, $66, $61, 8, $66, $66, $71, 1, $11, $66, $10
	dc.b	$66, $10, $66, $10, $66, $66, $66, $10, 6, $66, $61, 0, 1, $11, $10, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, $61, 0
	dc.b	0, 6, $61, 0, 0, 1, $11, 0, 0, 0, 0, 0, 0, 6, $61, 0
	dc.b	0, 6, $61, 0, 0, 1, $11, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	dc.b	0, 0, 0, 0, $C, $CC, $CC, $C1, $C, $CC, $CC, $C1, $C, $C1, $11, $11
	dc.b	$C, $C1, 0, 0, $C, $CC, $CC, $10, $CC, $CC, $C1, 0, $CC, $11, $11, 0
	dc.b	$CC, $10, 0, 0, $CC, $CC, $CC, $10, $CC, $CC, $CC, $10, $11, $11, $11, $10
	dc.b	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

playsuucg:
	dc.b	0, 0, 0, 0, 0, $66, $66, $10, 6, $61, $16, $61, 6, $61, 6, $61
	dc.b	6, $61, 6, $61, 6, $61, 6, $61, 0, $66, $66, $10, 0, $11, $11, 0
	dc.b	0, 0, 0, 0, 0, 6, $61, 0, 0, $66, $61, 0, 0, $16, $61, 0
	dc.b	0, 6, $61, 0, 0, 6, $61, 0, 0, 6, $61, 0, 0, 1, $11, 0
	dc.b	0, 0, 0, 0, 0, $66, $66, $10, 0, $11, $16, $61, 0, 0, $66, $11
	dc.b	0, 6, $61, $10, 0, $66, $11, $10, 6, $66, $66, $61, 1, $11, $11, $11
	dc.b	0, 0, 0, 0, 0, $66, $66, $10, 0, $11, $16, $61, 0, 6, $66, $10
	dc.b	0, 1, $16, $61, 6, $61, 6, $61, 0, $66, $66, $10, 0, $11, $11, 0
	dc.b	0, 0, 0, 0, 0, 0, $66, $10, 0, 6, $66, $10, 0, $61, $66, $10
	dc.b	6, $61, $66, $10, 6, $66, $66, $61, 1, $11, $66, $11, 0, 0, $11, $10
	dc.b	0, 0, 0, 0, 6, $66, $66, $61, 6, $61, $11, $11, 6, $66, $66, $10
	dc.b	1, $11, $16, $61, 6, $61, 6, $61, 0, $66, $66, $10, 0, $11, $11, 0
	dc.b	0, 0, 0, 0, 0, $66, $66, $10, 6, $61, $11, $10, 6, $66, $66, $10
	dc.b	6, $61, $16, $61, 6, $61, 6, $61, 0, $66, $66, $10, 0, $11, $11, 0
	dc.b	0, 0, 0, 0, 6, $66, $66, $61, 1, $11, $16, $61, 0, 0, $66, $10
	dc.b	0, 6, $61, 0, 0, $66, $10, 0, 0, $66, $10, 0, 0, $11, $10, 0
	dc.b	0, 0, 0, 0, 0, $66, $66, $10, 6, $61, $16, $61, 0, $66, $66, $10
	dc.b	6, $61, $16, $61, 6, $61, 6, $61, 0, $66, $66, $10, 0, $11, $11, 0
	dc.b	0, 0, 0, 0, 0, $66, $66, $10, 6, $61, $16, $61, 6, $61, 6, $61
	dc.b	0, $66, $66, $61, 0, $11, $16, $61, 0, $66, $66, $10, 0, $11, $11, 0

	nop	; Alignment
