
	xref	buranko0dpat, shimapat2, dai00pat, pltfrmpat
	xref	frntlitpat, kanipat, ringpat, itempat
	xref	fishpat, togepat, jyamapat, dualmodesub
	xref	actionsub, sjumppat, banepat, kamerepat
	xref	kagebpat, musipat, savepat, colichgpat
	xref	kaitenpat, prodaipat, wfallpat, sisoopat
	xref	takipat, stegopat, bfishpat, redzpat
	xref	horsepat, wasppat, octpat, bbatpat
	xref	gatorpat, wfish2pat, snailpat, playpat

	xdef	edit

edit:
	moveq	#0,d0
	move.b	editmode,d0
	move.w	edit_move_tbl(pc,d0.w),d1
	jmp	edit_move_tbl(pc,d1.w)

edit_move_tbl:
	dc.w	editinit-*
	dc.w	editmove-*

editinit:
	addq.b	#2,editmode
	move.w	scralim_up,editstack
	move.w	scralim_n_down,editstack2
	move.w	#0,scralim_up
	move.w	#$720,scralim_n_down
	andi.w	#$7FF,playerwk+yposi
	andi.w	#$7FF,scra_v_posit
	andi.w	#$3FF,scrb_v_posit
	move.b	#0,patno(a0)
	move.b	#0,mstno(a0)
	cmpi.b	#spgamemd,gmmode
	bne.s	.jump0
	moveq	#7-1,d0
	bra.s	.jump1

.jump0:
	moveq	#0,d0
	move.b	stageno,d0

.jump1:
	lea	edittbl,a2
	add.w	d0,d0
	adda.w	(a2,d0.w),a2
	move.w	(a2)+,d6
	cmp.b	editno,d6
	bhi.s	.jump
	move.b	#0,editno

.jump:
	bsr.w	editpatchg
	move.b	#12,edittimer
	move.b	#1,edittimer+1

editmove:
	moveq	#7-1,d0
	cmpi.b	#spgamemd,gmmode
	beq.s	.jump
	moveq	#0,d0
	move.b	stageno,d0

.jump:
	lea	edittbl,a2
	add.w	d0,d0
	adda.w	(a2,d0.w),a2
	move.w	(a2)+,d6
	bsr.w	editwalk
	jmp	actionsub

editwalk:
	moveq	#0,d4
	move.w	#1,d1
	move.b	swdata1+1,d4
	andi.w	#$F,d4
	bne.s	.jump0
	move.b	swdata1,d0
	andi.w	#$F,d0
	bne.s	.jump
	move.b	#12,edittimer
	move.b	#15,edittimer+1
	bra.w	.lend

.jump:
	subq.b	#1,edittimer
	bne.s	.jump1
	move.b	#1,edittimer
	addq.b	#1,edittimer+1
	bne.s	.jump0
	move.b	#255,edittimer+1

.jump0:
	move.b	swdata1,d4

.jump1:
	moveq	#0,d1
	move.b	edittimer+1,d1
	addq.w	#1,d1
	swap	d1
	asr.l	#4,d1
	move.l	yposi(a0),d2
	move.l	xposi(a0),d3
	btst	#0,d4
	beq.s	.jump2
	sub.l	d1,d2
	bcc.s	.jump2
	moveq	#0,d2

.jump2:
	btst	#1,d4
	beq.s	.jump3
	add.l	d1,d2
	cmpi.l	#$7FF0000,d2
	bcs.s	.jump3
	move.l	#$7FF0000,d2

.jump3:
	btst	#2,d4
	beq.s	.jump4
	sub.l	d1,d3
	bcc.s	.jump4
	moveq	#0,d3

.jump4:
	btst	#3,d4
	beq.s	.jump5
	add.l	d1,d3

.jump5:
	move.l	d2,yposi(a0)
	move.l	d3,xposi(a0)

.lend:
	btst	#6,swdata1
	beq.s	.jump7
	btst	#5,swdata1+1
	beq.s	.jump77
	subq.b	#1,editno
	bcc.s	.jump6
	add.b	d6,editno
	bra.s	.jump6

.jump77:
	btst	#6,swdata1+1
	beq.s	.jump7
	addq.b	#1,editno
	cmp.b	editno,d6
	bhi.s	.jump6
	move.b	#0,editno

.jump6:
	bra.w	editpatchg

.jump7:
	btst	#5,swdata1+1
	beq.s	.jump8
	jsr	actwkchk
	bne.s	.worknai
	move.w	xposi(a0),xposi(a1)
	move.w	yposi(a0),yposi(a1)
	move.b	patbase(a0),actno(a1)
	move.b	actflg(a0),actflg(a1)
	move.b	actflg(a0),cddat(a1)
	andi.b	#$7F,cddat(a1)
	moveq	#0,d0
	move.b	editno,d0
	lsl.w	#3,d0
	move.b	4(a2,d0.w),userflag(a1)
	rts

.worknai:
.jump8:
	btst	#4,swdata1+1
	beq.s	.jump9
	moveq	#0,d0
	move.w	d0,editmode
	move.l	#playpat,playerwk+patbase
	move.w	#$780,playerwk+sproffset
	tst.w	dualmode
	beq.s	.end
	move.w	#$780/2,playerwk+sproffset

.end:
	move.b	d0,playerwk+mstno
	move.w	d0,xposi+2(a0)
	move.w	d0,yposi+2(a0)
	move.w	editstack,scralim_up
	move.w	editstack2,scralim_n_down
	cmpi.b	#spgamemd,gmmode
	bne.s	.jump9
	move.b	#2,playerwk+mstno
	bset	#cd_ball,playerwk+cddat
	bset	#cd_jump,playerwk+cddat

.jump9:
	rts

editpatchg:
	moveq	#0,d0
	move.b	editno,d0
	lsl.w	#3,d0
	move.l	(a2,d0.w),patbase(a0)
	move.w	6(a2,d0.w),sproffset(a0)
	move.b	5(a2,d0.w),patno(a0)
	bsr.w	dualmodesub
	rts

dcblw macro
	dc.l	((\1)<<24)|(\2)
	dc.b	\5, \4
	dc.w	\3
	endm

edittbl:
	dc.w	edit1tbl-edittbl
	dc.w	edit2tbl-edittbl
	dc.w	edit3tbl-edittbl
	dc.w	edit4tbl-edittbl
	dc.w	edit5tbl-edittbl
	dc.w	edit6tbl-edittbl
	dc.w	edit7tbl-edittbl

edit1tbl:
	dc.w	$E
	dcblw	ring_act, ringpat, $26BC, 0, 0
	dcblw	item_act, itempat, $680, 0, 0
	dcblw	kani_act, kanipat, $400, 0, 0
	dcblw	hachi_act, hachipat, $444, 0, 0
	dcblw	fish_act, fishpat, $470, 0, 0
	dcblw	toge_act, togepat, $4A0, 0, 0
	dcblw	shima_act, shimapat2, $4000, 0, 0
	dcblw	jyama_act, jyamapat, $66C0, 0, 0
	dcblw	musi_act, musipat, $4E0, 0, 0
	dcblw	sjump_act, sjumppat, $4A8, 0, 0
	dcblw	kamere_act, kamerepat, $249B, 0, 0
	dcblw	kageb_act, kagebpat, $434C, 0, 0
	dcblw	save_act, savepat, $26BC, 0, 1
	dcblw	colichg_act, colichgpat, $26BC, 0, 0

edit2tbl:
	dc.w	7
	dcblw	ring_act, ringpat, $26BC, 0, 0
	dcblw	item_act, itempat, $680, 0, 0
	dcblw	sjump_act, sjumppat, $4A8, 0, 0
	dcblw	colichg_act, colichgpat, $7BC, 0, 0
	dcblw	kaiten_act, kaitenpat, $E000, 0, 0
	dcblw	prodai_act, prodaipat, $E418, 0, 0
	dcblw	buranko_act, buranko0dpat, $2418, 0, 8

edit4tbl:
	dc.w	$12
	dcblw	ring_act, ringpat, $26BC, 0, 0
	dcblw	item_act, itempat, $680, 0, 0
	dcblw	save_act, savepat, $47C, 0, 1
	dcblw	colichg_act, colichgpat, $26BC, 0, 0
	dcblw	taki_act, takipat, $23AE, 0, 0
	dcblw	taki_act, takipat, $23AE, 3, $2
	dcblw	shima_act, dai00pat, $4000, 0, 1
	dcblw	shima_act, dai00pat, $4000, 1, $A
	dcblw	toge_act, togepat, $2434, 0, 0
	dcblw	sisoo_act, sisoopat, $3CE, 0, 0
	dcblw	sjump_act, banepat, $45C, 0, $80
	dcblw	sjump_act, banepat, $470, 3, $90
	dcblw	sjump_act, banepat, $45C, 6, $A0
	dcblw	sjump_act, banepat, $43C, 7, $30
	dcblw	sjump_act, banepat, $43C, 10, $40
	dcblw	wasp_act, wasppat, $3E6, 0, 0
	dcblw	snail_act, snailpat, $402, 0, 0
	dcblw	wfish2_act, wfish2pat, $41C, 0, 0
	dcblw	redz_act, redzpat, $500, 0, 0
	dcblw	bfish_act, bfishpat, $2530, 0, 0
	dcblw	seahorse_act, horsepat, $2570, 0, 0
	dcblw	skyhorse_act, horsepat, $2570, 0, 0
	dcblw	stego_act, stegopat, $23C4, 0, 0
	dcblw	wasp_act, wasppat, $32C, 0, 0
	dcblw	gator_act, gatorpat, $2300, 0, 0
	dcblw	bbat_act, bbatpat, $2350, 0, 0
	dcblw	oct_act, octpat, $238A, 0, 0

edit5tbl:
	dc.w	$F
	dcblw	ring_act, ringpat, $26BC, 0, 0
	dcblw	item_act, itempat, $680, 0, 0
	dcblw	bgspr_act, frntlitpat, $E485, 3, $21
	dcblw	wfall_act, wfallpat, $E415, 4, $4
	dcblw	break_act, pltfrmpat, $4475, 0, 0
	dcblw	colichg_act, colichgpat, $26BC, 0, 0
	dcblw	redz_act, redzpat, $500, 0, 0
	dcblw	bfish_act, bfishpat, $2530, 0, 0
	dcblw	seahorse_act, horsepat, $2570, 0, 0
	dcblw	skyhorse_act, horsepat, $2570, 0, 0
	dcblw	stego_act, stegopat, $23C4, 0, 0
	dcblw	wasp_act, wasppat, $32C, 0, 0
	dcblw	gator_act, gatorpat, $2300, 0, 0
	dcblw	bbat_act, bbatpat, $2350, 0, 0
	dcblw	oct_act, octpat, $238A, 0, 0

	nop	; Alignment
