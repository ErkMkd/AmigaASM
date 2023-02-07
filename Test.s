;APS00000000000000000000000000000000000000000000000000000000000000000000000000000000
Start
	fmove.b	#2,fp1
.sync
	cmp.w	#50,$dff005
	bne.s	.sync

	fmove.s	#2000000,fp0

	move.w	#$f,$dff180

	rept	2000
	fdiv.s	#2,fp0
	endr

	move.w	#$f88,$dff180
	fmove.s	#2000000,fp0

	rept	2000
	fdiv	fp1,fp0
	endr

	move.w	#$aaa,$dff180

	btst	#6,$bfe001
	bne.l	.sync

	clr.l	d0
	rts
