
	xref	soundset, actwkchk, ringcolchk, jumpcolsub
	xref	scoreup

	xdef	pcol, pcole, playdamageset, playdieset

pcol:
	nop
	bsr.w	ringcolchk
	move.w	xposi(a0),d2
	move.w	yposi(a0),d3
	subi.w	#8,d2
	moveq	#0,d5
	move.b	sprvsize(a0),d5
	subq.b	#3,d5
	sub.w	d5,d3
	cmpi.b	#$39,patno(a0)
	bne.s	.jump0
	addi.w	#$C,d3
	moveq	#$A,d5

.jump0:
	move.w	#$10,d4
	add.w	d5,d5
	lea	actwk+($20*$40),a1
	move.w	#$60-1,d6

.loop:
	move.b	colino(a1),d0
	bne.s	.jump2

.jump:
	lea	$40(a1),a1
	dbf	d6,.loop
	moveq	#0,d0
	rts
	
.colitbl:
	dc.b	$14, $14
	dc.b	$C, $14
	dc.b	$14, $C
	dc.b	4, $10
	dc.b	$C, $12
	dc.b	$10, $10
	dc.b	6, 6
	dc.b	$18, $C
	dc.b	$C, $10
	dc.b	$10, $C
	dc.b	8, 8
	dc.b	$14, $10
	dc.b	$14, 8
	dc.b	$E, $E
	dc.b	$18, $18
	dc.b	$28, $10
	dc.b	$10, $18
	dc.b	8, $10
	dc.b	$20, $70
	dc.b	$40, $20
	dc.b	$80, $20
	dc.b	$20, $20
	dc.b	8, 8
	dc.b	4, 4
	dc.b	$20, 8
	dc.b	$C, $C
	dc.b	8, 4
	dc.b	$18, 4
	dc.b	$28, 4
	dc.b	4, 8
	dc.b	4, $18
	dc.b	4, $28
	dc.b	4, $20
	dc.b	$18, $18
	dc.b	$C, $18
	dc.b	$48, 8

.jump2:
	andi.w	#$3F,d0
	add.w	d0,d0
	lea	.colitbl-2(pc,d0.w),a2
	moveq	#0,d1
	move.b	(a2)+,d1
	move.w	xposi(a1),d0
	sub.w	d1,d0
	sub.w	d2,d0
	bcc.s	.jump3
	add.w	d1,d1
	add.w	d1,d0
	bcs.s	.jump4
	bra.w	.jump

.jump3:
	cmp.w	d4,d0
	bhi.w	.jump

.jump4:
	moveq	#0,d1
	move.b	(a2)+,d1
	move.w	yposi(a1),d0
	sub.w	d1,d0
	sub.w	d3,d0
	bcc.s	.jump5
	add.w	d1,d1
	add.w	d1,d0
	bcs.s	.atari
	bra.w	.jump

.jump5:
	cmp.w	d5,d0
	bhi.w	.jump

.atari:
	move.b	colino(a1),d1
	andi.b	#$C0,d1
	beq.w	pcolnomal
	cmpi.b	#$C0,d1
	beq.w	pcolspecial
	tst.b	d1
	bmi.w	pcolplay

pcolitem:
	move.b	colino(a1),d0
	andi.b	#$3F,d0
	cmpi.b	#6,d0
	beq.s	.item

.ring:
	cmpi.w	#90,$30(a0)
	bcc.w	.ringe
	move.b	#4,r_no0(a1)

.ringe:
	rts

.item:
	tst.w	yspeed(a0)
	bpl.s	.item2
	move.w	yposi(a0),d0
	subi.w	#$10,d0
	cmp.w	yposi(a1),d0
	bcs.s	.iteme
	neg.w	yspeed(a0)
	move.w	#-$180,yspeed(a1)
	tst.b	r_no1(a1)
	bne.s	.iteme
	move.b	#4,r_no1(a1)
	rts

.item2:
	cmpi.b	#2,mstno(a0)
	bne.s	.iteme
	neg.w	yspeed(a0)
	move.b	#4,r_no0(a1)

.iteme:
	rts

pcolnomal:
	tst.b	plpower_m
	bne.s	.jump
	cmpi.b	#9,mstno(a0)
	beq.s	.jump
	cmpi.b	#2,mstno(a0)
	bne.w	pcolplay

.jump:
	tst.b	colicnt(a1)
	beq.s	.jump0
	neg.w	xspeed(a0)
	neg.w	yspeed(a0)
	asr	xspeed(a0)
	asr	yspeed(a0)
	move.b	#0,colino(a1)
	subq.b	#1,colicnt(a1)
	bne.s	.jump4
	bset	#7,cddat(a1)

.jump4:
	rts

.jump0:
	bset	#7,cddat(a1)
	moveq	#0,d0
	move.w	emyscorecnt,d0
	addq.w	#2,emyscorecnt
	cmpi.w	#6,d0
	bcs.s	.jump5
	moveq	#6,d0

.jump5:
	move.w	d0,$3E(a1)
	move.w	escoretbl(pc,d0.w),d0
	cmpi.w	#$20,emyscorecnt
	bcs.s	.jump6
	move.w	#1000,d0
	move.w	#$A,$3E(a1)

.jump6:
	bsr.w	scoreup
	move.b	#$27,actno(a1)
	move.b	#0,r_no0(a1)

.jump3:
	tst.w	yspeed(a0)
	bmi.s	.jump1
	move.w	yposi(a0),d0
	cmp.w	yposi(a1),d0
	bcc.s	.jump2
	neg.w	yspeed(a0)
	rts

.jump1:
	addi.w	#$100,yspeed(a0)
	rts

.jump2:
	subi.w	#$100,yspeed(a0)
	rts

escoretbl:
	dc.w	10, 20, 50, 100

pcolplay2:
	bset	#7,cddat(a1)

pcolplay:
	tst.b	plpower_m
	beq.s	pcole

pcolend:
	moveq	#-1,d0
	rts

pcole:
	nop
	tst.w	$30(a0)
	bne.s	pcolend
	movea.l	a1,a2

playdamageset:
	tst.b	plpower_b
	bne.s	.damage
	tst.w	plring
	beq.w	.die
	jsr	actwkchk
	bne.s	.worknai
	move.b	#flyring_act,actno(a1)
	move.w	xposi(a0),xposi(a1)
	move.w	yposi(a0),yposi(a1)

.damage:
.worknai:
	move.b	#0,plpower_b
	move.b	#4,r_no0(a0)
	bsr.w	jumpcolsub
	bset	#cd_jump,cddat(a0)
	move.w	#-$400,yspeed(a0)
	move.w	#-$200,xspeed(a0)
	btst	#6,cddat(a0)
	beq.s	.jump0
	move.w	#-$200,yspeed(a0)
	move.w	#-$100,xspeed(a0)

.jump0:
	move.w	xposi(a0),d0
	cmp.w	xposi(a2),d0
	bcs.s	.jump
	neg.w	xspeed(a0)

.jump:
	move.w	#0,mspeed(a0)
	move.b	#$1A,mstno(a0)
	move.w	#120,$30(a0)
	move.w	#$A3,d0
	cmpi.b	#toge_act,(a2)
	bne.s	.jump2
	cmpi.b	#yari_act,(a2)
	bne.s	.jump2
	move.w	#$A6,d0

.jump2:
	jsr	soundset

.end:
	moveq	#-1,d0
	rts

.die:
	tst.w	debugflag
	bne.w	.damage

playdieset:
	tst.w	editmode
	bne.s	.end
	move.b	#0,plpower_m
	move.b	#6,r_no0(a0)
	bsr.w	jumpcolsub
	bset	#cd_jump,cddat(a0)
	move.w	#-$700,yspeed(a0)
	move.w	#0,xspeed(a0)
	move.w	#0,mspeed(a0)
	move.w	yposi(a0),$38(a0)
	move.b	#$18,mstno(a0)
	bset	#7,sproffset(a0)
	move.w	#$A3,d0
	cmpi.b	#toge_act,(a2)
	bne.s	.jump2
	move.w	#$A6,d0

.jump2:
	jsr	soundset

.end:
	moveq	#-1,d0
	rts

pcolspecial:
	move.b	colino(a1),d1
	andi.b	#$3F,d1
	cmpi.b	#$B,d1
	beq.s	.imo
	cmpi.b	#$C,d1
	beq.s	.yado
	cmpi.b	#$17,d1
	beq.s	.bobin
	cmpi.b	#$21,d1
	beq.s	.bou
	rts

.imo:
	bra.w	pcolplay2

.yado:
	sub.w	d0,d5
	cmpi.w	#8,d5
	bcc.s	.yado4
	move.w	xposi(a1),d0
	subq.w	#4,d0
	btst	#0,cddat(a1)
	beq.s	.yado1
	subi.w	#$10,d0

.yado1:
	sub.w	d2,d0
	bcc.s	.yado2
	addi.w	#$18,d0
	bcs.s	.yado3
	bra.s	.yado4

.yado2:
	cmp.w	d4,d0
	bhi.s	.yado4

.yado3:
	bra.w	pcolplay

.yado4:
	bra.w	pcolnomal

.bobin:
	move.w	a0,d1
	subi.w	#playerwk,d1
	beq.s	.bobin2
	addq.b	#1,colicnt(a1)

.bobin2:
	addq.b	#1,colicnt(a1)
	rts

.bou:
	addq.b	#1,colicnt(a1)
	rts

	nop	; Alignment
