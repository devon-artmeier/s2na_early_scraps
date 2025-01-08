
	xref	bariacg, mutekicg, burankocg, hashicg
	xref	jyamacg, fire00cg, taki00cg, hashi00cg
	xref	cso00cg, brig08cg, falls08cg, gem08cg
	xref	pltfrm08cg, frntlite08cg, cork08cg, kemuri0dcg
	xref	dai0dcg, nami0dcg, banevcg, banehcg
	xref	bane45cg, scorecg, playnocg, ringcg
	xref	itemcg, togecg, tencg, savecg
	xref	gatorcg, waspcg, bbatcg, stegocg
	xref	redzcg, billfishcg, snailcg, bfishcg
	xref	bossbacg, zdbcg, bossafbcg, bosssmcg
	xref	boss00cg, bosshcg, fishcg, musicg
	xref	zonecg. yararecg, overcg, jumpcg
	xref	jump2cg, golecg, ebigringcg, btencg
	xref	usagicg, niwacg, pengcg, azarcg
	xref	fbutacg, fliccg, risucg, zone00blk
	xref	zone00cg, zone00map, zone08blk, zone08cg
	xref	zone08map, zone0dblk, zone0dcg, zone0dpccg
	xref	zone0dmap, zone1blk, zone1cg, zone1map

	xdef	mapinittbl, divdevtbl

map macro	; Unofficial
	dc.l	((\7)<<24)|(\1), ((\8)<<24)|(\2), \3
	dc.w	\4
	dc.b	\5, \6
	endm

mapinittbl:
	map	zone1cg, zone1blk, zone1map, $81, 4, 4, 4, 5
	map	zone0dcg, zone0dblk, zone0dmap, $82, 5, 5, 6, 7
	map	zone0dcg, zone0dblk, zone0dmap, $83, 6, 6, 8, 9
	map	zone00cg, zone00blk, zone00map, $84, 7, 7, $A, $B
	map	zone08cg, zone08blk, zone08map, $85, 8, 8, $C, $D
	map	zone0dcg, zone0dblk, zone0dmap, $86, 9, 9, $E, $F
	map	zone1cg, zone1blk, zone1map, $86, $13, $13, 0, 0

ddev macro	; Unofficial
	dc.l	\1
	dc.w	\2
	endm

divdevtbl:
	dc.w	ddev00-divdevtbl
	dc.w	ddev01-divdevtbl
	dc.w	ddev02-divdevtbl
	dc.w	ddev03-divdevtbl
	dc.w	ddev04-divdevtbl
	dc.w	ddev05-divdevtbl
	dc.w	ddev06-divdevtbl
	dc.w	ddev07-divdevtbl
	dc.w	ddev08-divdevtbl
	dc.w	ddev09-divdevtbl
	dc.w	ddev10-divdevtbl
	dc.w	ddev11-divdevtbl
	dc.w	ddev12-divdevtbl
	dc.w	ddev13-divdevtbl
	dc.w	ddev14-divdevtbl
	dc.w	ddev15-divdevtbl
	dc.w	ddev16-divdevtbl
	dc.w	ddev17-divdevtbl
	dc.w	ddev18-divdevtbl
	dc.w	ddev19-divdevtbl
	dc.w	ddev20-divdevtbl
	dc.w	ddev21-divdevtbl
	dc.w	ddev22-divdevtbl
	dc.w	ddev23-divdevtbl
	dc.w	ddev24-divdevtbl
	dc.w	ddev25-divdevtbl
	dc.w	ddev26-divdevtbl
	dc.w	ddev27-divdevtbl
	dc.w	ddev28-divdevtbl
	dc.w	ddev29-divdevtbl
	dc.w	ddev30-divdevtbl
	dc.w	ddev31-divdevtbl

ddev00:
	dc.w	5-1
	ddev	savecg, $8F80
	ddev	scorecg, $D940
	ddev	playnocg, $FA80
	ddev	ringcg, $D780
	ddev	tencg, $9580

ddev01:
	dc.w	3-1
	ddev	itemcg, $D000
	ddev	bariacg, $97C0
	ddev	mutekicg, $9BC0

ddev02:
	dc.w	1-1
	ddev	yararecg, $B400

ddev03:
	dc.w	1-1
	ddev	overcg, $ABC0

ddev04:
	dc.w	9-1
	ddev	zone1cg, 0
	ddev	fishcg, $8E00
	ddev	togecg, $9400
	ddev	jumpcg, $9500
	ddev	jump2cg, $9700
	ddev	hashicg, $98C0
	ddev	burankocg, $9A00
	ddev	musicg, $9C00
	ddev	jyamacg, $D800

ddev05:
	dc.w	1-1
	ddev	fishcg, $8E00

ddev06:
ddev08:
ddev14:
	dc.w	5-1
	ddev	zone0dcg, 0
	ddev	zone0dpccg, $7A00
	ddev	kemuri0dcg, $8000
	ddev	dai0dcg, $8300
	ddev	nami0dcg, $8800

ddev10:
	dc.w	9-1
	ddev	zone00cg, 0
	ddev	fire00cg, $73C0
	ddev	taki00cg, $75C0
	ddev	hashi00cg, $78C0
	ddev	cso00cg, $79C0
	ddev	togecg, $8680
	ddev	bane45cg, $8780
	ddev	banevcg, $8B80
	ddev	banehcg, $8E00

ddev11:
	dc.w	3-1
	ddev	waspcg, $7CC0
	ddev	snailcg, $8040
	ddev	bfishcg, $8380

ddev12:
	dc.w	8-1
	ddev	zone08cg, 0
	ddev	brig08cg, $6000
	ddev	falls08cg, $62A0
	ddev	pltfrm08cg, $6940
	ddev	frntlite08cg, $6B40
	ddev	cork08cg, $6F80
	ddev	gem08cg, $7240
	ddev	nami0dcg, $8000

ddev13:
	dc.w	2-1
	ddev	redzcg, $A000
	ddev	bbatcg, $A600
	; Dummied out
	ddev	gatorcg, $6000
	ddev	waspcg, $6580
	ddev	bbatcg, $6A00
	ddev	stegocg, $7880
	ddev	redzcg, $A000
	ddev	billfishcg, $A600

ddev07:
ddev09:
ddev15:
	dc.w	3-1
	ddev	togecg, $9400
	ddev	jumpcg, $9500
	ddev	jump2cg, $9700

ddev16:
	dc.w	1-1
	ddev	zonecg, $B000

ddev17:
	dc.w	3-1
	ddev	bossbacg, $8C00
	ddev	boss00cg, $9800
	ddev	bosshcg, $A800
	; Dummied out
	ddev	bossbacg, $8000
	ddev	zdbcg, $8C00
	ddev	bossafbcg, $9A00
	ddev	bosssmcg, $9B00
	ddev	boss00cg, $9D00
	ddev	bosshcg, $AD00

ddev18:
	dc.w	3-1
	ddev	golecg, $D000
	ddev	btencg, $96C0
	ddev	ebigringcg, $8C40

ddev19:
ddev20:
	dc.w	$11-1
	; Missing entires

ddev21:
	dc.w	2-1
	ddev	usagicg, $B000
	ddev	fliccg, $B240

ddev22:
	dc.w	2-1
	ddev	pengcg, $B000
	ddev	azarcg, $B240

ddev23:
	dc.w	2-1
	ddev	risucg, $B000
	ddev	azarcg, $B240

ddev24:
	dc.w	2-1
	ddev	fbutacg, $B000
	ddev	fliccg, $B240

ddev25:
	dc.w	2-1
	ddev	fbutacg, $B000
	ddev	niwacg, $B240

ddev26:
	dc.w	2-1
	ddev	usagicg, $B000
	ddev	niwacg, $B240

ddev27:
	dc.w	2-1
	; Missing entries

ddev28:
	dc.w	$E-1
	; Missing entries

ddev29:
	dc.w	3-1
	; Missing entries

ddev30:
	dc.w	3-1
	; Missing entries

ddev31:
	dc.w	5-1
	; Missing entries
