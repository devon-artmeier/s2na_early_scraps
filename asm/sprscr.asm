
	xref	soundset, mapdevr, sinset, ringpat
	xref	spatsetsub, bobinpat, rotmaptbl0, rotmaptbl1
	xref	rotmaptbl2, rotmaptbl3, rotmaptbl4, rotmaptbl5

	xdef	sprscr, sprscre, scrwkchk, sprmapset

sprscr:
	bsr.w	sprscractcnt
	bsr.w	scrcnt
	move.w	d5,-(sp)
	lea	$FF8000,a1
	move.b	rotdir,d0
	andi.b	#$FC,d0
	jsr	sinset
	move.w	d0,d4
	move.w	d1,d5
	muls.w	#$18,d4
	muls.w	#$18,d5
	moveq	#0,d2
	move.w	scra_h_posit,d2
	divu.w	#$18,d2
	swap	d2
	neg.w	d2
	addi.w	#-$B4,d2
	moveq	#0,d3
	move.w	scra_v_posit,d3
	divu.w	#$18,d3
	swap	d3
	neg.w	d3
	addi.w	#-$B4,d3
	move.w	#$10-1,d7

.loop:
	movem.w	d0-d2,-(sp)
	movem.w	d0-d1,-(sp)
	neg.w	d0
	muls.w	d2,d1
	muls.w	d3,d0
	move.l	d0,d6
	add.l	d1,d6
	movem.w	(sp)+,d0-d1
	muls.w	d2,d0
	muls.w	d3,d1
	add.l	d0,d1
	move.l	d6,d2
	move.w	#$10-1,d6

.loop2:
	move.l	d2,d0
	asr.l	#8,d0
	move.w	d0,(a1)+
	move.l	d1,d0
	asr.l	#8,d0
	move.w	d0,(a1)+
	add.l	d5,d2
	add.l	d4,d1
	dbf	d6,.loop2
	movem.w	(sp)+,d0-d2
	addi.w	#$18,d3
	dbf	d7,.loop
	move.w	(sp)+,d5

sprscre:
sprscrset:
	lea	$FF0000,a0
	moveq	#0,d0
	move.w	scra_v_posit,d0
	divu.w	#$18,d0
	mulu.w	#$80,d0
	adda.l	d0,a0
	moveq	#0,d0
	move.w	scra_h_posit,d0
	divu.w	#$18,d0
	adda.w	d0,a0
	lea	$FF8000,a4
	move.w	#$10-1,d7

.loop:
	move.w	#$10-1,d6

.loop2:
	moveq	#0,d0
	move.b	(a0)+,d0
	beq.s	.jump
	cmpi.b	#$4E,d0
	bhi.s	.jump
	move.w	(a4),d3
	addi.w	#$120,d3
	cmpi.w	#$70,d3
	bcs.s	.jump
	cmpi.w	#$1D0,d3
	bcc.s	.jump
	move.w	2(a4),d2
	addi.w	#$F0,d2
	cmpi.w	#$70,d2
	bcs.s	.jump
	cmpi.w	#$170,d2
	bcc.s	.jump
	lea	$FF4000,a5
	lsl.w	#3,d0
	lea	(a5,d0.w),a5
	movea.l	(a5)+,a1
	move.w	(a5)+,d1
	add.w	d1,d1
	adda.w	(a1,d1.w),a1
	movea.w	(a5)+,a3
	moveq	#0,d1
	move.b	(a1)+,d1
	subq.b	#1,d1
	bmi.s	.jump
	jsr	spatsetsub

.jump:
	addq.w	#4,a4
	dbf	d6,.loop2
	lea	$70(a0),a0
	dbf	d7,.loop
	move.b	d5,linkdata
	cmpi.b	#$50,d5
	beq.s	.end
	move.l	#0,(a2)
	rts

.end:
	move.b	#0,-5(a2)
	rts

sprscractcnt:
	lea	$FF400C,a1
	moveq	#0,d0
	move.b	rotdir,d0
	lsr.b	#2,d0
	andi.w	#$F,d0
	moveq	#$24-1,d1

.loop:
	move.w	d0,(a1)
	addq.w	#8,a1
	dbf	d1,.loop
	lea	$FF4005,a1
	subq.b	#1,sys_pattim2
	bpl.s	.jump2
	move.b	#7,sys_pattim2
	addq.b	#1,sys_patno2
	andi.b	#3,sys_patno2

.jump2:
	move.b	sys_patno2,$1D0(a1)
	subq.b	#1,sys_pattim3
	bpl.s	.jump4
	move.b	#7,sys_pattim3
	addq.b	#1,sys_patno3
	andi.b	#1,sys_patno3

.jump4:
	move.b	sys_patno3,d0
	move.b	d0,$138(a1)
	move.b	d0,$160(a1)
	move.b	d0,$148(a1)
	move.b	d0,$150(a1)
	move.b	d0,$1D8(a1)
	move.b	d0,$1E0(a1)
	move.b	d0,$1E8(a1)
	move.b	d0,$1F0(a1)
	move.b	d0,$1F8(a1)
	move.b	d0,$200(a1)
	subq.b	#1,sys_pattim4
	bpl.s	.jump5
	move.b	#4,sys_pattim4
	addq.b	#1,sys_patno4
	andi.b	#3,sys_patno4

.jump5:
	move.b	sys_patno4,d0
	move.b	d0,$168(a1)
	move.b	d0,$170(a1)
	move.b	d0,$178(a1)
	move.b	d0,$180(a1)
	subq.b	#1,sys_pattim
	bpl.s	.jump3
	move.b	#7,sys_pattim
	subq.b	#1,sys_patno
	andi.b	#7,sys_patno

.jump3:
	lea	$FF4016,a1
	lea	scractofftbl,a0
	moveq	#0,d0
	move.b	sys_patno,d0
	add.w	d0,d0
	lea	(a0,d0.w),a0
	move.w	(a0),(a1)
	move.w	2(a0),8(a1)
	move.w	4(a0),$10(a1)
	move.w	6(a0),$18(a1)
	move.w	8(a0),$20(a1)
	move.w	$A(a0),$28(a1)
	move.w	$C(a0),$30(a1)
	move.w	$E(a0),$38(a1)
	adda.w	#$20,a0
	adda.w	#$48,a1
	move.w	(a0),(a1)
	move.w	2(a0),8(a1)
	move.w	4(a0),$10(a1)
	move.w	6(a0),$18(a1)
	move.w	8(a0),$20(a1)
	move.w	$A(a0),$28(a1)
	move.w	$C(a0),$30(a1)
	move.w	$E(a0),$38(a1)
	adda.w	#$20,a0
	adda.w	#$48,a1
	move.w	(a0),(a1)
	move.w	2(a0),8(a1)
	move.w	4(a0),$10(a1)
	move.w	6(a0),$18(a1)
	move.w	8(a0),$20(a1)
	move.w	$A(a0),$28(a1)
	move.w	$C(a0),$30(a1)
	move.w	$E(a0),$38(a1)
	adda.w	#$20,a0
	adda.w	#$48,a1
	move.w	(a0),(a1)
	move.w	2(a0),8(a1)
	move.w	4(a0),$10(a1)
	move.w	6(a0),$18(a1)
	move.w	8(a0),$20(a1)
	move.w	$A(a0),$28(a1)
	move.w	$C(a0),$30(a1)
	move.w	$E(a0),$38(a1)
	adda.w	#$20,a0
	adda.w	#$48,a1
	rts

scractofftbl:
	dc.w	$142, $6142, $142, $142, $142, $142, $142, $6142
	dc.w	$142, $6142, $142, $142, $142, $142, $142, $6142
	dc.w	$2142, $142, $2142, $2142, $2142, $2142, $2142, $142
	dc.w	$2142, $142, $2142, $2142, $2142, $2142, $2142, $142
	dc.w	$4142, $2142, $4142, $4142, $4142, $4142, $4142, $2142
	dc.w	$4142, $2142, $4142, $4142, $4142, $4142, $4142, $2142
	dc.w	$6142, $4142, $6142, $6142, $6142, $6142, $6142, $4142
	dc.w	$6142, $4142, $6142, $6142, $6142, $6142, $6142, $4142

scrwkchk:
	lea	$FF4400,a2
	move.w	#$20-1,d0

.loop:
	tst.b	(a2)
	beq.s	.jump
	addq.w	#8,a2
	dbf	d0,.loop

.jump:
	rts

scrcnt:
	lea	$FF4400,a0
	move.w	#$20-1,d7

.loop:
	moveq	#0,d0
	move.b	(a0),d0
	beq.s	.jump
	lsl.w	#2,d0
	movea.l	scracttbl-4(pc,d0.w),a1
	jsr	(a1)

.jump:
	addq.w	#8,a0
	dbf	d7,.loop
	rts

scracttbl:
	dc.l	scr_ring
	dc.l	scr_bobin
	dc.l	scr_1up
	dc.l	scr_revers
	dc.l	scr_houseki
	dc.l	scr_break

scr_ring:
	subq.b	#1,2(a0)
	bpl.s	.end
	move.b	#5,2(a0)
	moveq	#0,d0
	move.b	3(a0),d0
	addq.b	#1,3(a0)
	movea.l	4(a0),a1
	move.b	scr_ringtbl(pc,d0.w),d0
	move.b	d0,(a1)
	bne.s	.jump
	clr.l	(a0)
	clr.l	4(a0)

.end:
.jump:
	rts

scr_ringtbl:
	dc.b	$42, $43, $44, $45, 0, 0

scr_bobin:
	subq.b	#1,2(a0)
	bpl.s	.end
	move.b	#7,2(a0)
	moveq	#0,d0
	move.b	3(a0),d0
	addq.b	#1,3(a0)
	movea.l	4(a0),a1
	move.b	scr_bobintbl(pc,d0.w),d0
	bne.s	.jump
	clr.l	(a0)
	clr.l	4(a0)
	move.b	#$25,(a1)
	rts

.jump:
	move.b	d0,(a1)

.end:
	rts

scr_bobintbl:
	dc.b	$32, $33, $32, $33, 0, 0

scr_1up:
	subq.b	#1,2(a0)
	bpl.s	.end
	move.b	#5,2(a0)
	moveq	#0,d0
	move.b	3(a0),d0
	addq.b	#1,3(a0)
	movea.l	4(a0),a1
	move.b	scr_1uptbl(pc,d0.w),d0
	move.b	d0,(a1)
	bne.s	.jump
	clr.l	(a0)
	clr.l	4(a0)

.end:
.jump:
	rts

scr_1uptbl:
	dc.b	$46, $47, $48, $49, 0, 0

scr_revers:
	subq.b	#1,2(a0)
	bpl.s	.end
	move.b	#7,2(a0)
	moveq	#0,d0
	move.b	3(a0),d0
	addq.b	#1,3(a0)
	movea.l	4(a0),a1
	move.b	scr_reverstbl(pc,d0.w),d0
	bne.s	.jump
	clr.l	(a0)
	clr.l	4(a0)
	move.b	#$2B,(a1)
	rts

.jump:
	move.b	d0,(a1)

.end:
	rts

scr_reverstbl:
	dc.b	$2B, $31, $2B, $31, 0, 0

scr_houseki:
	subq.b	#1,2(a0)
	bpl.s	.end
	move.b	#5,2(a0)
	moveq	#0,d0
	move.b	3(a0),d0
	addq.b	#1,3(a0)
	movea.l	4(a0),a1
	move.b	scr_housekitbl(pc,d0.w),d0
	move.b	d0,(a1)
	bne.s	.jump
	clr.l	(a0)
	clr.l	4(a0)
	move.b	#4,playerwk+r_no0
	move.w	#$A8,d0
	jsr	soundset

.end:
.jump:
	rts

scr_housekitbl:
	dc.b	$46, $47, $48, $49, 0, 0

scr_break:
	subq.b	#1,2(a0)
	bpl.s	.end
	move.b	#1,2(a0)
	moveq	#0,d0
	move.b	3(a0),d0
	addq.b	#1,3(a0)
	movea.l	4(a0),a1
	move.b	scr_breaktbl(pc,d0.w),d0
	move.b	d0,(a1)
	bne.s	.jump
	move.b	4(a0),(a1)
	clr.l	(a0)
	clr.l	4(a0)

.end:
.jump:
	rts

scr_breaktbl:
	dc.b	$4B, $4C, $4D, $4E, $4B, $4C, $4D, $4E, 0, 0

sprmapsettbl:
	dc.l	rotmaptbl0
	dc.l	rotmaptbl1
	dc.l	rotmaptbl2
	dc.l	rotmaptbl3
	dc.l	rotmaptbl4
	dc.l	rotmaptbl5

sprplaypositbl:
	dc.w	$3D0, $2E0
	dc.w	$328, $574
	dc.w	$4E4, $2E0
	dc.w	$3AD, $2E0
	dc.w	$340, $6B8
	dc.w	$49B, $358

sprmapset:
	moveq	#0,d0
	move.b	$FFFE16,d0
	addq.b	#1,$FFFE16
	cmpi.b	#6,$FFFE16
	bcs.s	.jump
	move.b	#0,$FFFE16

.jump:
	cmpi.b	#6,$FFFE57
	beq.s	.jump2
	moveq	#0,d1
	move.b	$FFFE57,d1
	subq.b	#1,d1
	bcs.s	.jump2
	lea	$FFFE58,a3

.loop0:
	cmp.b	(a3,d1.w),d0
	bne.s	.jump0
	bra.s	sprmapset

.jump0:
	dbf	d1,.loop0

.jump2:
	lsl.w	#2,d0
	lea	sprplaypositbl(pc,d0.w),a1
	move.w	(a1)+,playerwk+xposi
	move.w	(a1)+,playerwk+yposi
	movea.l	sprmapsettbl(pc,d0.w),a0
	lea	$FF4000,a1
	move.w	#0,d0
	jsr	mapdevr
	lea	$FF0000,a1
	move.w	#$1000-1,d0

.loop:
	clr.l	(a1)+
	dbf	d0,.loop
	lea	$FF1020,a1
	lea	$FF4000,a0
	moveq	#$40-1,d1

.loop1:
	moveq	#$40-1,d2

.loop2:
	move.b	(a0)+,(a1)+
	dbf	d2,.loop2
	lea	$40(a1),a1
	dbf	d1,.loop1

scrpatset:
	lea	$FF4008,a1
	lea	scrpattbl,a0
	moveq	#$4E-1,d1

.loop:
	move.l	(a0)+,(a1)+
	move.w	#0,(a1)+
	move.b	-4(a0),-1(a1)
	move.w	(a0)+,(a1)+
	dbf	d1,.loop

scrcntclr:
	lea	$FF4400,a1
	move.w	#$40-1,d1

.loop:
	clr.l	(a1)+
	dbf	d1,.loop
	rts

scrpat macro	; Unofficial
	dc.l	((\2)<<24)|(\1)
	dc.w	\3
	endm

scrpattbl:
	scrpat	metpat, 0, $142
	scrpat	metpat, 0, $142
	scrpat	metpat, 0, $142
	scrpat	metpat, 0, $142
	scrpat	metpat, 0, $142
	scrpat	metpat, 0, $142
	scrpat	metpat, 0, $142
	scrpat	metpat, 0, $142
	scrpat	metpat, 0, $142
	scrpat	metpat, 0, $2142
	scrpat	metpat, 0, $2142
	scrpat	metpat, 0, $2142
	scrpat	metpat, 0, $2142
	scrpat	metpat, 0, $2142
	scrpat	metpat, 0, $2142
	scrpat	metpat, 0, $2142
	scrpat	metpat, 0, $2142
	scrpat	metpat, 0, $2142
	scrpat	metpat, 0, $4142
	scrpat	metpat, 0, $4142
	scrpat	metpat, 0, $4142
	scrpat	metpat, 0, $4142
	scrpat	metpat, 0, $4142
	scrpat	metpat, 0, $4142
	scrpat	metpat, 0, $4142
	scrpat	metpat, 0, $4142
	scrpat	metpat, 0, $4142
	scrpat	metpat, 0, $6142
	scrpat	metpat, 0, $6142
	scrpat	metpat, 0, $6142
	scrpat	metpat, 0, $6142
	scrpat	metpat, 0, $6142
	scrpat	metpat, 0, $6142
	scrpat	metpat, 0, $6142
	scrpat	metpat, 0, $6142
	scrpat	metpat, 0, $6142
	scrpat	bobinpat, 0, $23B
	scrpat	warppat, 0, $570
	scrpat	golepat, 0, $251
	scrpat	sp1uppat, 0, $370
	scrpat	spuppat, 0, $263
	scrpat	spdownpat, 0, $263
	scrpat	sprevpat, 0, $22F0
	scrpat	breakpat, 0, $470
	scrpat	breakpat, 0, $5F0
	scrpat	breakpat, 0, $65F0
	scrpat	breakpat, 0, $25F0
	scrpat	breakpat, 0, $45F0
	scrpat	sprevpat, 0, $2F0
	scrpat	bobinpat, 1, $23B
	scrpat	bobinpat, 2, $23B
	scrpat	zonepat, 0, $797
	scrpat	zonepat, 0, $7A0
	scrpat	zonepat, 0, $7A9
	scrpat	zonepat, 0, $797
	scrpat	zonepat, 0, $7A0
	scrpat	zonepat, 0, $7A9
	scrpat	ringpat, 0, $27B2
	scrpat	hous2pat, 0, $770
	scrpat	hous2pat, 0, $2770
	scrpat	hous2pat, 0, $4770
	scrpat	hous2pat, 0, $6770
	scrpat	hous0pat, 0, $770
	scrpat	hous1pat, 0, $770
	scrpat	derupat, 0, $4F0
	scrpat	ringpat, 4, $27B2
	scrpat	ringpat, 5, $27B2
	scrpat	ringpat, 6, $27B2
	scrpat	ringpat, 7, $27B2
	scrpat	koukapat, 0, $23F0
	scrpat	koukapat, 1, $23F0
	scrpat	koukapat, 2, $23F0
	scrpat	koukapat, 3, $23F0
	scrpat	derupat, 2, $4F0
	scrpat	breakpat, 0, $5F0
	scrpat	breakpat, 0, $65F0
	scrpat	breakpat, 0, $25F0
	scrpat	breakpat, 0, $45F0

metpat:
	; Missing data

golepat:
derupat:
sprevpat:
zonepat:
sp1uppat:
warppat:
	dc.w	golesp0-golepat
	dc.w	golesp1-golepat
	dc.w	derusp2-derupat

golesp0:
	dc.b	1
	dc.b	$F4, $A, 0, 0, $F4

golesp1:
	dc.b	1
	dc.b	$F4, $A, 0, 9, $F4

derusp2:
	dc.w	0

sphashpat:
koukapat:
breakpat:
	dc.w	sphashsp0-sphashpat
	dc.w	sphashsp1-sphashpat
	dc.w	koukasp2-koukapat
	dc.w	koukasp3-koukapat

sphashsp0:
koukasp0:
	dc.b	1
	dc.b	$F4, $A, 0, 0, $F4

sphashsp1:
koukasp1:
	dc.b	1
	dc.b	$F4, $A, 8, 0, $F4

koukasp2:
	dc.b	1
	dc.b	$F4, $A, $18, 0, $F4

koukasp3:
	dc.b	1
	dc.b	$F4, $A, $10, 0, $F4

spuppat:
	dc.w	spupsp0-spuppat
	dc.w	spupsp1-spuppat

spupsp0:
	dc.b	1
	dc.b	$F4, $A, 0, 0, $F4

spupsp1:
	dc.b	1
	dc.b	$F4, $A, 0, $12, $F4

spdownpat:
	dc.w	spdownsp0-spdownpat
	dc.w	spdownsp1-spdownpat

spdownsp0:
	dc.b	1
	dc.b	$F4, $A, 0, 9, $F4

spdownsp1:
	dc.b	1
	dc.b	$F4, $A, 0, $12, $F4

hous0pat:
	dc.w	sphoussp0-hous0pat
	dc.w	sphoussp3-hous0pat

hous1pat:
	dc.w	sphoussp1-hous1pat
	dc.w	sphoussp3-hous1pat

hous2pat:
	dc.w	sphoussp2-hous2pat
	dc.w	sphoussp3-hous2pat

sphoussp0:
	dc.b	1
	dc.b	$F8, 5, 0, 0, $F8

sphoussp1:
	dc.b	1
	dc.b	$F8, 5, 0, 4, $F8

sphoussp2:
	dc.b	1
	dc.b	$F8, 5, 0, 8, $F8

sphoussp3:
	dc.b	1
	dc.b	$F8, 5, 0, $C, $F8

	nop	; Alignment
