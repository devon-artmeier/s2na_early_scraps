
	xref	patchg, speedset2, dualmodesub, frameoutchk

	xdef	wfish2, wfish2pat

wfish2:
	moveq	#0,d0
	move.b	r_no0(a0),d0
	move.w	wfish_move_tbl(pc,d0.w),d1
	jsr	wfish_move_tbl(pc,d1.w)
	bra.w	frameoutchk

wfish_move_tbl:
	dc.w	wfishinit-wfish_move_tbl
	dc.w	wfishmove-wfish_move_tbl

wfishinit:
	addq.b	#2,r_no0(a0)
	move.l	#wfish2pat,patbase(a0)
	move.w	#$41C,sproffset(a0)
	bsr.w	dualmodesub
	move.b	#4,actflg(a0)
	move.b	#4,sprpri(a0)
	move.b	#9,colino(a0)
	move.b	#$10,sprhs(a0)
	move.w	#-$400,yspeed(a0)
	move.w	yposi(a0),$30(a0)

wfishmove:
	lea	wfishchg,a1
	bsr.w	patchg
	bsr.w	speedset2
	addi.w	#$18,yspeed(a0)
	move.w	$30(a0),d0
	cmp.w	yposi(a0),d0
	bcc.s	.jump
	move.w	d0,yposi(a0)
	move.w	#-$500,yspeed(a0)

.jump:
	move.b	#1,mstno(a0)
	subi.w	#$C0,d0
	cmp.w	yposi(a0),d0
	bcc.s	.jump2
	move.b	#0,mstno(a0)
	tst.w	yspeed(a0)
	bmi.s	.jump2
	move.b	#2,mstno(a0)

.jump2:
	rts

wfishchg:
	dc.w	wfishchg0-wfishchg
	dc.w	wfishchg1-wfishchg
	dc.w	wfishchg2-wfishchg

wfishchg0:
	dc.b	7, 0, 1, $FF

wfishchg1:
	dc.b	3, 0, 1, $FF

wfishchg2:
	dc.b	7, 0, $FF
	even

wfish2pat:
	dc.w	fishsp0-wfish2pat
	dc.w	fishsp1-wfish2pat

fishsp0:
	dc.w	3
	dc.w	$F005, 0, 0, $FFF4
	dc.w	$F001, 4, 2, 4
	dc.w	9, $A, 5, $FFF4

fishsp1:	
	dc.w	3
	dc.w	$F005, 0, 0, $FFF4
	dc.w	$F005, 6, 3, 2
	dc.w	9, $10, 8, $FFF4
	
	dc.w	0	; Alignment
