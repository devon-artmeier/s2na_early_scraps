
	xref	actionsub, frameout, dualmodesub

	xdef	staff

staff:
	moveq	#0,d0
	move.b	r_no0(a0),d0
	move.w	staff_move_tbl(pc,d0.w),d1
	jmp	staff_move_tbl(pc,d1.w)

staff_move_tbl:
	dc.w	staff_init-staff_move_tbl
	dc.w	staff_move-staff_move_tbl

staff_init:
	addq.b	#2,r_no0(a0)
	move.w	#$A0+$80,xposi(a0)
	move.w	#$70+$80,$A(a0)
	move.l	#staffpat,patbase(a0)
	move.w	#$5A0,sproffset(a0)
	bsr.w	dualmodesub
	move.w	$FFFFF4,d0
	move.b	d0,patno(a0)
	move.b	#0,actflg(a0)
	move.b	#0,sprpri(a0)
	cmpi.b	#4,gmmode
	bne.s	.jump
	move.w	#$300,sproffset(a0)
	bsr.w	dualmodesub
	move.b	#$A,patno(a0)
	tst.b	$FFFFE3
	beq.s	.jump
	cmpi.b	#$72,swdata1
	bne.s	.jump
	move.w	#$EEE,colorwk2+($20*2)
	move.w	#$880,colorwk2+($21*2)
	jmp	frameout

.jump:

staff_move:
	jmp	actionsub

staffpat:
	dc.w	staffsp00-staffpat
	dc.w	staffsp01-staffpat
	dc.w	staffsp02-staffpat
	dc.w	staffsp03-staffpat
	dc.w	staffsp04-staffpat
	dc.w	staffsp05-staffpat
	dc.w	staffsp06-staffpat
	dc.w	staffsp07-staffpat
	dc.w	staffsp08-staffpat
	dc.w	staffsp09-staffpat
	dc.w	staffsp10-staffpat

staffsp00:
	dc.w	$E
	dc.w	$F805, $2E, $17, $FF88
	dc.w	$F805, $26, $13, $FF98
	dc.w	$F805, $1A, $D, $FFA8
	dc.w	$F801, $46, $23, $FFB8
	dc.w	$F805, $1E, $F, $FFC0
	dc.w	$F805, $3E, $1F, $FFD8
	dc.w	$F805, $E, 7, $FFE8
	dc.w	$F805, 4, 2, $FFF8
	dc.w	$F809, 8, 4, 8
	dc.w	$F805, $2E, $17, $28
	dc.w	$F805, $3E, $1F, $38
	dc.w	$F805, 4, 2, $48
	dc.w	$F805, $5C, $2E, $58
	dc.w	$F805, $5C, $2E, $68

staffsp01:
	dc.w	$10
	dc.w	$D805, 0, 0, $FF80
	dc.w	$D805, 4, 2, $FF90
	dc.w	$D809, 8, 4, $FFA0
	dc.w	$D805, $E, 7, $FFB4
	dc.w	$D805, $12, 9, $FFD0
	dc.w	$D805, $16, $B, $FFE0
	dc.w	$D805, 4, 2, $FFF0
	dc.w	$D805, $1A, $D, 0
	dc.w	$805, $1E, $F, $FFC8
	dc.w	$805, 4, 2, $FFD8
	dc.w	$805, $22, $11, $FFE8
	dc.w	$805, $26, $13, $FFF8
	dc.w	$805, $16, $B, 8
	dc.w	$805, $2A, $15, $20
	dc.w	$805, 4, 2, $30
	dc.w	$805, $2E, $17, $44

staffsp02:
	dc.w	$A
	dc.w	$D805, $12, 9, $FF80
	dc.w	$D805, $22, $11, $FF90
	dc.w	$D805, $26, $13, $FFA0
	dc.w	$D805, 0, 0, $FFB0
	dc.w	$D805, $22, $11, $FFC0
	dc.w	$D805, 4, 2, $FFD0
	dc.w	$D809, 8, 4, $FFE0
	dc.w	$805, $2A, $15, $FFE8
	dc.w	$805, $32, $19, $FFF8
	dc.w	$805, $36, $1B, 8

staffsp03:
	dc.w	$18
	dc.w	$D805, $1E, $F, $FF88
	dc.w	$D805, $3A, $1D, $FF98
	dc.w	$D805, 4, 2, $FFA8
	dc.w	$D805, $22, $11, $FFB8
	dc.w	$D805, 4, 2, $FFC8
	dc.w	$D805, $1E, $F, $FFD8
	dc.w	$D805, $3E, $1F, $FFE8
	dc.w	$D805, $E, 7, $FFF8
	dc.w	$D805, $22, $11, 8
	dc.w	$D805, $42, $21, $20
	dc.w	$D805, $E, 7, $30
	dc.w	$D805, $2E, $17, $40
	dc.w	$D801, $46, $23, $50
	dc.w	$D805, 0, 0, $58
	dc.w	$D805, $1A, $D, $68
	dc.w	$805, $48, $24, $FFC0
	dc.w	$801, $46, $23, $FFD0
	dc.w	$805, 0, 0, $FFD8
	dc.w	$801, $46, $23, $FFE8
	dc.w	$805, $2E, $17, $FFF0
	dc.w	$805, $16, $B, 0
	dc.w	$805, 4, 2, $10
	dc.w	$805, $1A, $D, $20
	dc.w	$805, $42, $21, $30

staffsp04:
	dc.w	$14
	dc.w	$D005, $42, $21, $FFA0
	dc.w	$D005, $E, 7, $FFB0
	dc.w	$D005, $2E, $17, $FFC0
	dc.w	$D001, $46, $23, $FFD0
	dc.w	$D005, 0, 0, $FFD8
	dc.w	$D005, $1A, $D, $FFE8
	dc.w	5, $4C, $26, $FFE8
	dc.w	1, $46, $23, $FFF8
	dc.w	5, $1A, $D, 4
	dc.w	5, $2A, $15, $14
	dc.w	5, 4, 2, $24
	dc.w	$2005, $12, 9, $FFD0
	dc.w	$2005, $3A, $1D, $FFE0
	dc.w	$2005, $E, 7, $FFF0
	dc.w	$2005, $1A, $D, 0
	dc.w	$2001, $46, $23, $10
	dc.w	$2005, $50, $28, $18
	dc.w	$2005, $22, $11, $30
	dc.w	$2001, $46, $23, $40
	dc.w	$2005, $E, 7, $48

staffsp05:
	dc.w	$1A
	dc.w	$D805, $2E, $17, $FF98
	dc.w	$D805, $26, $13, $FFA8
	dc.w	$D805, $32, $19, $FFB8
	dc.w	$D805, $1A, $D, $FFC8
	dc.w	$D805, $54, $2A, $FFD8
	dc.w	$D805, $12, 9, $FFF8
	dc.w	$D805, $22, $11, 8
	dc.w	$D805, $26, $13, $18
	dc.w	$D805, $42, $21, $28
	dc.w	$D805, $32, $19, $38
	dc.w	$D805, $1E, $F, $48
	dc.w	$D805, $E, 7, $58
	dc.w	$809, 8, 4, $FF88
	dc.w	$805, 4, 2, $FF9C
	dc.w	$805, $2E, $17, $FFAC
	dc.w	$805, 4, 2, $FFBC
	dc.w	$805, $3E, $1F, $FFCC
	dc.w	$805, $26, $13, $FFDC
	dc.w	$805, $1A, $D, $FFF8
	dc.w	$805, 4, 2, 8
	dc.w	$805, $58, $2C, $18
	dc.w	$805, 4, 2, $28
	dc.w	$809, 8, 4, $38
	dc.w	$805, $32, $19, $4C
	dc.w	$805, $22, $11, $5C
	dc.w	$805, 4, 2, $6C

staffsp06:
	dc.w	$17
	dc.w	$D005, $2E, $17, $FF98
	dc.w	$D005, $26, $13, $FFA8
	dc.w	$D005, $32, $19, $FFB8
	dc.w	$D005, $1A, $D, $FFC8
	dc.w	$D005, $54, $2A, $FFD8
	dc.w	$D005, $12, 9, $FFF8
	dc.w	$D005, $22, $11, 8
	dc.w	$D005, $26, $13, $18
	dc.w	$D005, 0, 0, $28
	dc.w	$D005, $22, $11, $38
	dc.w	$D005, 4, 2, $48
	dc.w	$D009, 8, 4, $58
	dc.w	5, $4C, $26, $FFD0
	dc.w	1, $46, $23, $FFE0
	dc.w	9, 8, 4, $FFE8
	dc.w	1, $46, $23, $FFFC
	dc.w	5, $3E, $1F, 4
	dc.w	5, 4, 2, $14
	dc.w	$2009, 8, 4, $FFD0
	dc.w	$2005, 4, 2, $FFE4
	dc.w	$2005, $1E, $F, $FFF4
	dc.w	$2005, $58, $2C, 4
	dc.w	$2005, $2A, $15, $14

staffsp07:
	dc.w	$1F
	dc.w	$D805, $2E, $17, $FF80
	dc.w	$D805, $12, 9, $FF90
	dc.w	$D805, $E, 7, $FFA0
	dc.w	$D805, $1E, $F, $FFB0
	dc.w	$D801, $46, $23, $FFC0
	dc.w	$D805, 4, 2, $FFC8
	dc.w	$D805, $16, $B, $FFD8
	dc.w	$D805, $3E, $1F, $FFF8
	dc.w	$D805, $3A, $1D, 8
	dc.w	$D805, 4, 2, $18
	dc.w	$D805, $1A, $D, $28
	dc.w	$D805, $58, $2C, $38
	dc.w	$D805, $2E, $17, $48
	dc.w	5, $5C, $2E, $FFB0
	dc.w	5, $32, $19, $FFC0
	dc.w	5, $4C, $26, $FFD0
	dc.w	1, $46, $23, $FFE0
	dc.w	5, $26, $13, $FFE8
	dc.w	9, 8, 4, 0
	dc.w	1, $46, $23, $14
	dc.w	5, $1A, $D, $1C
	dc.w	5, $E, 7, $2C
	dc.w	5, 0, 0, $3C
	dc.w	1, $46, $23, $4C
	dc.w	5, $2E, $17, $54
	dc.w	5, $3A, $1D, $64
	dc.w	1, $46, $23, $74
	dc.w	$2005, $12, 9, $FFF8
	dc.w	$2005, 4, 2, 8
	dc.w	$2005, $12, 9, $18
	dc.w	$2005, 4, 2, $28

staffsp08:
	dc.w	$F
	dc.w	$F805, $12, 9, $FF80
	dc.w	$F805, $22, $11, $FF90
	dc.w	$F805, $E, 7, $FFA0
	dc.w	$F805, $2E, $17, $FFB0
	dc.w	$F805, $E, 7, $FFC0
	dc.w	$F805, $1A, $D, $FFD0
	dc.w	$F805, $3E, $1F, $FFE0
	dc.w	$F805, $E, 7, $FFF0
	dc.w	$F805, $42, $21, 0
	dc.w	$F805, $48, $24, $18
	dc.w	$F805, $2A, $15, $28
	dc.w	$F805, $2E, $17, $40
	dc.w	$F805, $E, 7, $50
	dc.w	$F805, 0, 0, $60
	dc.w	$F805, 4, 2, $70

staffsp09:
	dc.w	8
	dc.w	$3005, $3E, $1F, $FFC0
	dc.w	$3005, $22, $11, $FFD0
	dc.w	$3005, $2A, $15, $FFE0
	dc.w	$3005, 4, 2, $FFF8
	dc.w	$3005, 0, 0, 8
	dc.w	$3005, 4, 2, $18
	dc.w	$3001, $46, $23, $28
	dc.w	$3005, $1A, $D, $30

staffsp10:
	dc.w	$11
	dc.w	$E805, $2E, $17, $FFB4
	dc.w	$E805, $26, $13, $FFC4
	dc.w	$E805, $1A, $D, $FFD4
	dc.w	$E801, $46, $23, $FFE4
	dc.w	$E805, $1E, $F, $FFEC
	dc.w	$E805, $3E, $1F, 4
	dc.w	$E805, $E, 7, $14
	dc.w	$E805, 4, 2, $24
	dc.w	$E809, 8, 4, $34
	dc.w	5, $12, 9, $FFC0
	dc.w	5, $22, $11, $FFD0
	dc.w	5, $E, 7, $FFE0
	dc.w	5, $2E, $17, $FFF0
	dc.w	5, $E, 7, 0
	dc.w	5, $1A, $D, $10
	dc.w	5, $3E, $1F, $20
	dc.w	5, $2E, $17, $30
	
	nop	; Alignment
