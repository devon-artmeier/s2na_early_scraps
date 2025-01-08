
	xref	dmactrset, efect00acg, efect00bcg, efect00ccg
	xref	efect00dcg, efect00ecg, efect08bcg, efect0dacg
	xref	efect0dbcg, efect0dccg, efect0ddcg, efect0decg
	xref	efect0dfcg, efect0dgcg, efect0dhcg

	xdef	efectwrt, efectblockset

efectwrt:
	bsr.w	efectmove
	moveq	#0,d0
	move.b	stageno,d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	efecttbl+2(pc,d0.w),d1
	lea	efecttbl(pc,d1.w),a2
	move.w	efecttbl(pc,d0.w),d0
	jmp	efecttbl(pc,d0.w)

.end:
	rts

efecttbl:
	dc.w	efstage0-efecttbl, efecttbl0-efecttbl
	dc.w	efstage1-efecttbl, efecttbl1-efecttbl
	dc.w	efstage2-efecttbl, efecttbl2-efecttbl
	dc.w	efstage3-efecttbl, efecttbl3-efecttbl
	dc.w	efstage4-efecttbl, efecttbl4-efecttbl
	dc.w	efstage5-efecttbl, efecttbl5-efecttbl
	dc.w	efstage6-efecttbl, efecttbl6-efecttbl
	dc.w	efstage7-efecttbl, efecttbl7-efecttbl
	dc.w	efstage8-efecttbl, efecttbl8-efecttbl
	dc.w	efstage9-efecttbl, efecttbl9-efecttbl
	dc.w	efstagea-efecttbl, efecttbla-efecttbl
	dc.w	efstageb-efecttbl, efecttblb-efecttbl
	dc.w	efstagec-efecttbl, efecttblc-efecttbl
	dc.w	efstaged-efecttbl, efecttbld-efecttbl
	dc.w	efstagee-efecttbl, efecttble-efecttbl
	dc.w	efstagef-efecttbl, efecttblf-efecttbl

efstage1:
efstage5:
efstage6:
efstage7:
efstage9:
efstagea:
efstageb:
efstagec:
efstagee:
efstagef:
	rts

efstage0:
	rts

efstage2:
efstage3:
efstage4:
efstage8:
efstaged:
	lea	$FFF7F0,a3
	move.w	(a2)+,d6

.loop:
	subq.b	#1,(a3)
	bpl.s	.jump2
	moveq	#0,d0
	move.b	1(a3),d0
	cmp.b	6(a2),d0
	bcs.s	.jump
	moveq	#0,d0
	move.b	d0,1(a3)

.jump:
	addq.b	#1,1(a3)
	move.b	(a2),(a3)
	bpl.s	.jump1
	add.w	d0,d0
	move.b	9(a2,d0.w),(a3)

.jump1:
	move.b	8(a2,d0.w),d0
	lsl.w	#5,d0
	move.w	4(a2),d2
	move.l	(a2),d1
	andi.l	#$FFFFFF,d1
	add.l	d0,d1
	moveq	#0,d3
	move.b	7(a2),d3
	lsl.w	#4,d3
	jsr	dmactrset

.jump2:
	move.b	6(a2),d0
	tst.b	(a2)
	bpl.s	.jump3
	add.b	d0,d0

.jump3:
	addq.b	#1,d0
	andi.w	#$FE,d0
	lea	8(a2,d0.w),a2
	addq.w	#2,a3
	dbf	d6,.loop
	rts

efect macro	; Unofficial
	dc.l	((\1)<<24)|(\2)
	dc.w	\3
	dc.b	\4, \5
	endm

efecttbl0:
efecttbl3:
	dc.w	5-1

	efect	-1, efect00acg, $7280, 6, 2
	dc.b	0, $7F
	dc.b	2, $13
	dc.b	0, 7
	dc.b	2, 7
	dc.b	0, 7
	dc.b	2, 7

	efect	-1, efect00bcg, $72C0, 8, 2
	dc.b	2, $7F
	dc.b	0, $B
	dc.b	2, $B
	dc.b	0, $B
	dc.b	2, 5
	dc.b	0, 5
	dc.b	2, 5
	dc.b	0, 5

	efect	7, efect00ccg, $7300, 2, 2
	dc.b	0
	dc.b	2

	efect	-1, efect00dcg, $7340, 8, 2
	dc.b	0, $7F
	dc.b	2, 7
	dc.b	0, 7
	dc.b	2, 7
	dc.b	0, 7
	dc.b	2, $B
	dc.b	0, $B
	dc.b	2, $B

	efect	1, efect00ecg, $7380, 6, 2
	dc.b	0
	dc.b	2
	dc.b	4
	dc.b	6
	dc.b	4
	dc.b	2

efecttbl4:
efecttbl8:
	dc.w	3-1

	efect	8, efect08bcg, $5D00, 6, 8
	dc.b	0
	dc.b	0
	dc.b	8
	dc.b	$10
	dc.b	$10
	dc.b	8

	efect	8, efect08bcg, $5E00, 6, 8
	dc.b	8
	dc.b	$10
	dc.b	$10
	dc.b	8
	dc.b	0
	dc.b	0

	efect	8, efect08bcg, $5F00, 6, 8
	dc.b	$10
	dc.b	8
	dc.b	0
	dc.b	0
	dc.b	8
	dc.b	$10

efecttbl1:
efecttbl2:
efecttbl5:
efecttbl6:
efecttbl7:
efecttbl9:
efecttbla:
efecttblb:
efecttblc:
efecttbld:
efecttble:
efecttblf:
	dc.w	8-1

	efect	7, efect0dacg, $9000, 2, 4
	dc.b	0
	dc.b	4

	efect	7, efect0dbcg, $9080, 3, 8
	dc.b	0
	dc.b	8
	dc.b	$10
	even

	efect	7, efect0dccg, $9180, 4, 2
	dc.b	0
	dc.b	2
	dc.b	0
	dc.b	4

	efect	$B, efect0ddcg, $91C0, 4, 2
	dc.b	0
	dc.b	2
	dc.b	4
	dc.b	2

	efect	$F, efect0decg, $9200, $A, 1
	dc.b	0
	dc.b	0
	dc.b	1
	dc.b	2
	dc.b	3
	dc.b	4
	dc.b	5
	dc.b	4
	dc.b	5
	dc.b	4

	efect	3, efect0dfcg, $9220, 4, 4
	dc.b	0
	dc.b	4
	dc.b	8
	dc.b	4

	efect	7, efect0dgcg, $92A0, 6, 3
	dc.b	0
	dc.b	3
	dc.b	6
	dc.b	9
	dc.b	$C
	dc.b	$F

	efect	7, efect0dhcg, $9300, 4, 1
	dc.b	0
	dc.b	1
	dc.b	2
	dc.b	3

efectmove:
	cmpi.b	#2,stageno
	beq.s	.jump

.end:
	rts

.jump:
	move.w	scra_h_posit,d0
	cmpi.w	#$1940,d0
	bcs.s	.end
	cmpi.w	#$1F80,d0
	bcc.s	.end
	subq.b	#1,$FFF721
	bpl.s	.end
	move.b	#7,$FFF721
	move.b	#1,$FFF720
	lea	mapwk+($EA*$80),a1
	bsr.s	.sub
	lea	mapwk+($FA*$80),a1

.sub:
	move.w	#8-1,d1

.loop:
	move.w	(a1),d0
	move.w	2(a1),(a1)+
	move.w	2(a1),(a1)+
	move.w	2(a1),(a1)+
	move.w	2(a1),(a1)+
	move.w	2(a1),(a1)+
	move.w	2(a1),(a1)+
	move.w	2(a1),(a1)+
	move.w	$72(a1),(a1)+
	adda.w	#$70,a1
	move.w	2(a1),(a1)+
	move.w	2(a1),(a1)+
	move.w	2(a1),(a1)+
	move.w	2(a1),(a1)+
	move.w	2(a1),(a1)+
	move.w	2(a1),(a1)+
	move.w	2(a1),(a1)+
	move.w	$72(a1),(a1)+
	adda.w	#$70,a1
	move.w	2(a1),(a1)+
	move.w	2(a1),(a1)+
	move.w	2(a1),(a1)+
	move.w	2(a1),(a1)+
	move.w	2(a1),(a1)+
	move.w	2(a1),(a1)+
	move.w	2(a1),(a1)+
	move.w	$72(a1),(a1)+
	adda.w	#$70,a1
	move.w	2(a1),(a1)+
	move.w	2(a1),(a1)+
	move.w	2(a1),(a1)+
	move.w	2(a1),(a1)+
	move.w	2(a1),(a1)+
	move.w	2(a1),(a1)+
	move.w	2(a1),(a1)+
	move.w	d0,(a1)+
	suba.w	#$180,a1
	dbf	d1,.loop
	rts

efectblockset:
	moveq	#0,d0
	move.b	stageno,d0
	add.w	d0,d0
	move.w	efectblocktbl(pc,d0.w),d0
	lea	efectblocktbl(pc,d0.w),a0
	tst.w	(a0)
	beq.s	.end
	lea	blockwk,a1
	adda.w	(a0)+,a1
	move.w	(a0)+,d1
	tst.w	dualmode
	bne.s	.loop2

.loop:
	move.w	(a0)+,(a1)+
	dbf	d1,.loop

.end:
	rts

.loop2:
	move.w	(a0)+,d0
	move.w	d0,d1
	andi.w	#$F800,d0
	andi.w	#$7FF,d1
	lsr.w	#1,d1
	or.w	d1,d0
	move.w	d0,(a1)+
	dbf	d1,.loop2
	rts

efectblocktbl:
	dc.w	zone00pcblk-efectblocktbl
	dc.w	zone01pcblk-efectblocktbl
	dc.w	zone02pcblk-efectblocktbl
	dc.w	zone03pcblk-efectblocktbl
	dc.w	zone04pcblk-efectblocktbl
	dc.w	zone05pcblk-efectblocktbl
	dc.w	zone06pcblk-efectblocktbl
	dc.w	zone07pcblk-efectblocktbl
	dc.w	zone08pcblk-efectblocktbl
	dc.w	zone09pcblk-efectblocktbl
	dc.w	zone0apcblk-efectblocktbl
	dc.w	zone0bpcblk-efectblocktbl
	dc.w	zone0cpcblk-efectblocktbl
	dc.w	zone0dpcblk-efectblocktbl
	dc.w	zone0epcblk-efectblocktbl
	dc.w	zone0fpcblk-efectblocktbl

zone00pcblk:
zone03pcblk:
	dc.w	$17C8
	dc.w	$1C-1
	dc.w	$439C, $4B9C, $439D, $4B9D, $4158, $439C, $4159, $439D
	dc.w	$4B9C, $4958, $4B9D, $4959, $6394, $6B94, $6395, $6B95
	dc.w	$E396, $EB96, $E397, $EB97, $6398, $6B98, $6399, $6B99
	dc.w	$E39A, $EB9A, $E39B, $EB9B

zone01pcblk:
zone05pcblk:
zone06pcblk:
zone07pcblk:
zone09pcblk:
zone0apcblk:
zone0bpcblk:
zone0cpcblk:
zone0epcblk:
zone0fpcblk:
	dc.w	0
	; Dummied out
	dc.w	$C80
	dc.w	$9C-1
	dc.w	$43A1, $43A2, $43A3, $43A4, $43A5, $43A6, $43A7, $43A8
	dc.w	$43A9, $43AA, $43AB, $43AC, $43AD, $43AE, $43AF, $43B0
	dc.w	$43B1, $43B2, $43B3, $43B4, $43B5, $43B6, $43B7, $43B8
	dc.w	$43B9, $43BA, $43BB, $43BC, $43BD, $43BE, $43BF, $43C0
	dc.w	$43C1, $43C2, $43C3, $43C4, $63A0, $63A0, $63A0, $63A0
	dc.w	$63A0, $63A0, $63A0, $63A0, 0, 0, $6340, $6344
	dc.w	0, 0, $6348, $634C, $6341, $6345, $6342, $6346
	dc.w	$6349, $634D, $634A, $634E, $6343, $6347, $4358, $4359
	dc.w	$634B, $634F, $435A, $435B, $6380, $6384, $6381, $6385
	dc.w	$6388, $638C, $6389, $638D, $6382, $6386, $6383, $6387
	dc.w	$638A, $638E, $638B, $638F, $6390, $6394, $6391, $6395
	dc.w	$6398, $639C, $6399, $639D, $6392, $6396, $6393, $6397
	dc.w	$639A, $639E, $639B, $639F, $4378, $4379, $437A, $437B
	dc.w	$437C, $437D, $437E, $437F, $235C, $235D, $235E, $235F
	dc.w	$2360, $2361, $2362, $2363, $2364, $2365, $2366, $2367
	dc.w	$2368, $2369, $236A, $236B, 0, 0, $636C, $636D
	dc.w	0, 0, $636E, 0, $636F, $6370, $6371, $6372
	dc.w	$6373, 0, $6374, 0, $6375, $6376, $4358, $4359
	dc.w	$6377, 0, $435A, $435B, $C378, $C379, $C37A, $C37B
	dc.w	$C37C, $C37D, $C37E, $C37F

zone02pcblk:
zone0dpcblk:
	dc.w	$1708
	dc.w	$70-1
	dc.w	$448F, $43D2, $43D3, $43D2, $43D4, $43D5, $4480, $4481
	dc.w	$4BD5, $4BD4, $4482, $4483, $4484, $4485, $4486, $4487
	dc.w	$4488, $4489, $448A, $448B, $E48C, $E48D, $E3DE, $E3DF
	dc.w	$4498, $4C98, $4498, $4C98, $43E1, $448D, $43E1, $43DF
	dc.w	$448C, $448D, $43DE, $43DF, $E3D4, $E3D5, $E480, $E481
	dc.w	$EBD5, $EBD4, $E482, $E483, $E484, $E485, $E486, $E487
	dc.w	$E48C, $E48D, $E3DE, $E3DF, $E3E2, $E48E, $E3E4, $EBD3
	dc.w	$E48F, $E3D2, $E3D3, $E3D2, $E3E5, $E3E6, $E3E7, $E490
	dc.w	$E3E7, $F490, $E3E5, $E3E6, $E3E5, $E3E6, $E3E9, $E48E
	dc.w	$EBE6, $E3EA, $E48F, $E3E9, $E491, $E492, $E3D0, $E3ED
	dc.w	$E493, $E494, $EBED, $E3D0, $E488, $E489, $E48A, $E48B
	dc.w	$43E2, $448E, $43E4, $4BD3, $E495, $E496, $E3F2, $E3F2
	dc.w	$E497, $E3F3, $E3F2, $E3F4, $43E5, $43E6, $43E9, $448E
	dc.w	$4BE6, $43EA, $448F, $43E9, $E3E1, $E48D, $E3E1, $E3DF

zone04pcblk:
zone08pcblk:
	dc.w	$1710
	dc.w	$78-1
	dc.w	$62E8, $62E9, $62EA, $62EB, $62EC, $62ED, $62EE, $62EF
	dc.w	$62F0, $62F1, $62F2, $62F3, $62F4, $62F5, $62F6, $62F7
	dc.w	$62F8, $62F9, $62FA, $62FB, $62FC, $62FD, $62FE, $62FF
	dc.w	$42E8, $42E9, $42EA, $42EB, $42EC, $42ED, $42EE, $42EF
	dc.w	$42F0, $42F1, $42F2, $42F3, $42F4, $42F5, $42F6, $42F7
	dc.w	$42F8, $42F9, $42FA, $42FB, $42FC, $42FD, $42FE, $42FF
	dc.w	0, $62E8, 0, $62EA, $62E9, $62EC, $62EB, $62EE
	dc.w	$62ED, 0, $62EF, 0, 0, $62F0, 0, $62F2
	dc.w	$62F1, $62F4, $62F3, $62F6, $62F5, 0, $62F7, 0
	dc.w	0, $62F8, 0, $62FA, $62F9, $62FC, $62FB, $62FE
	dc.w	$62FD, 0, $62FF, 0, 0, $42E8, 0, $42EA
	dc.w	$42E9, $42EC, $42EB, $42EE, $42ED, 0, $42EF, 0
	dc.w	0, $42F0, 0, $42F2, $42F1, $42F4, $42F3, $42F6
	dc.w	$42F5, 0, $42F7, 0, 0, $42F8, 0, $42FA
	dc.w	$42F9, $42FC, $42FB, $42FE, $42FD, 0, $42FF, 0

	nop	; Alignment
