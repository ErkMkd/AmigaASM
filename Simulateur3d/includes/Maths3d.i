;APS0000F42D00009FDD00009FDD00009FDD00009FDD00009FDD00009FDD00009FDD00009FDD00009FDD
*********************************************************
*							*
*		Mathematiques spaciales			*
*		Revision:20/3/2001			*
*							*
*********************************************************

*********************************************************************************
*	Transformation des points des objets geometriques par leur vecteur	*
*	"CurrentVector"								*
*IN: a0=@Scene									*
*********************************************************************************

VectorTranslation
	movem.l	d0-a6,-(sp)
	fmovem	fp0-fp7,-(sp)

;	---- Init boucle objets:
	move.w	scn_NbrGeometrics(a0),d0
	beq.w	.end
	move.w	d0,a6	;a6=compteur objets

	move.l	scn_Geometrics(a0),d0
	beq.w	.end
	move.l	d0,a1	;a1=table des objets

	move.l	scn_Coords(a0),d0
	beq.w	.end
	move.l	d0,a3	;a3=table des coordonnées finales

;	----Boucle traitement des objets:
.geo	move.l	(a1)+,d0
	beq.w	.nextGeo
	move.l	d0,a0

	move.l	Geo_NbrPoints(a0),d0
	beq.w	.nextGeo
	lea	obj_sr(a0),a4
	move.l	Geo_Points(a0),a5

;	---- Pour éviter trop d'accès mémoire:
	move.l	sr_XPos(a4),d1		;d1=XPos
	move.l	sr_YAxisXPos(a4),d2	;d2=xOB
	move.l	sr_ZAxisXPos(a4),d3	;d3=xOC

	move.l	sr_YPos(a4),d4		;d4=YPos
	move.l	sr_YAxisYPos(a4),d5	;d5=yOB
	move.l	sr_ZAxisYPos(a4),d6	;d6=yOC

	move.l	sr_ZPos(a4),d7		;d7=ZPos
	fmove.s	sr_YAxisZPos(a4),fp6	;fp6=zOB
	fmove.s	sr_ZAxisZPos(a4),fp7	;fp7=zOC

;	---- Rotation + translation:
.loop
	fmove.s	(a5)+,fp0	;fp0=xOM
	fmove.s	(a5)+,fp1	;fp1=yOM
	fmove.s	(a5)+,fp2	;fp2=zOM
;	X:
	fmove.s	d2,fp4		;fp4=xOB
	fmove.s	d3,fp5		;fp5=xOC
	fmove.s	sr_XAxisXPos(a4),fp3		;fp3=xOA
	fmul	fp1,fp4
	fmul	fp2,fp5
	fmul	fp0,fp3
	fadd	fp5,fp4
	fadd	fp4,fp3		;fp3=xOM'
	fadd.s	d1,fp3
	fmove.s	fp3,(a3)+
;	Y:
	fmove.s	d5,fp4		;fp4=yOB
	fmove.s	d6,fp5		;fp5=yOC
	fmove.s	sr_XAxisYPos(a4),fp3		;fp3=yOA
	fmul	fp1,fp4
	fmul	fp2,fp5
	fmul	fp0,fp3
	fadd	fp5,fp4
	fadd	fp4,fp3		;fp3=yOM'
	fadd.s	d4,fp3
	fmove.s	fp3,(a3)+
;	Z:
	fmove	fp6,fp4		;fp4=zOB
	fmove	fp7,fp5		;fp5=zOC
	fmove.s	sr_XAxisZPos(a4),fp3		;fp3=zOA
	fmul	fp1,fp4
	fmul	fp2,fp5
	fmul	fp0,fp3
	fadd	fp5,fp4
	fadd	fp4,fp3		;fp3=zOM'
	fadd.s	d7,fp3
	fmove.s	fp3,(a3)+

	subq.l	#1,d0
	bne.w	.loop
.nextGeo
	subq.w	#1,a6
	cmp.w	#0,a6
	bne.w	.geo

;	---- Zee End:

.end	fmovem	(sp)+,fp0-fp7
	movem.l	(sp)+,d0-a6
	clc
	rts

*************************************************
*	Rotation à partir de 3 angles absolus	*
*IN: 	a0=@absoluteRotation			*
*************************************************

;Nota: Les formules brutes sont utilisées. Pas
;	d'optim.

AbsoluteRotation

	movem.l	d0-a6,-(sp)
	fmovem	fp0-fp7,-(sp)

;	---- Init boucle objets:

	move.w	mh_NbrObjects(a0),d1
	subq.w	#1,d1
	move.l	mh_Objects(a0),a3

;	---- Init sinus et cosinus:
	fmove.s	ar_DeltaX(a0),fp0	;fp0=AlphaX
	fmove.s	ar_DeltaY(a0),fp1	;fp1=AlphaY
	fmove.s	ar_DeltaZ(a0),fp2	;fp2=AlphaZ

	fcos	fp0,fp3
	fmove.d	fp3,.cosAx
	fsin	fp0,fp3
	fmove.d	fp3,.sinAx

	fcos	fp1,fp3
	fmove.d	fp3,.cosAy
	fsin	fp1,fp3
	fmove.d	fp3,.sinAy

	fcos	fp2,fp3
	fmove.d	fp3,.cosAz
	fsin	fp2,fp3
	fmove.d	fp3,.sinAz

;	---- Boucle de traitement des objets:
.object
;	---- Init pointeurs:
	move.l	(a3)+,a4
	lea	obj_sr+sr_InitialVector(a4),a1
	lea	obj_sr+sr_CurrentVector(a4),a2
	moveq	#2,d0

;	---- Boucle de rotation:
.loop	fmove.s	(a1)+,fp0
	fmove.s	(a1)+,fp1
	fmove.s	(a1)+,fp2
;	Rotation sur Z:
	fmove	fp0,fp3
	fmove	fp1,fp4
	fmul.d	.cosAz(pc),fp0
	fmul.d	.sinAz(pc),fp1
	fsub	fp1,fp0		;fp0=x'
	fmul.d	.sinAz(pc),fp3
	fmul.d	.cosAz(pc),fp4
	fadd	fp4,fp3		;fp3=y'

;	Rotation sur Y:
	fmove	fp0,fp1	;x'
	fmove	fp2,fp4	;z
	fmul.d	.cosAy(pc),fp0
	fmul.d	.sinAy(pc),fp2
	fsub	fp2,fp0		;fp0=x''
	fmul.d	.sinAy(pc),fp1
	fmul.d	.cosAy(pc),fp4
	fadd	fp4,fp1		;fp1=z'

;	Rotation sur X:
	fmove	fp1,fp2
	fmove	fp3,fp4
	fmul.d	.cosAx(pc),fp1
	fmul.d	.sinAx(pc),fp3
	fsub	fp3,fp1		;fp1=z''
	fmul.d	.sinAx(pc),fp2
	fmul.d	.cosAx(pc),fp4
	fadd	fp4,fp2		;fp2=y''

	fmove.s	fp0,(a2)+
	fmove.s	fp2,(a2)+
	fmove.s	fp1,(a2)+

	dbra	d0,.loop
.NxtObj
	dbra	d1,.object

;	---- Zee End:
.end	fmovem	(sp)+,fp0-fp7
	movem.l	(sp)+,d0-a6
	clc
	rts

******** Données ********

.cosAx	dc.d	0
.sinAx	dc.d	0
.cosAy	dc.d	0
.sinAy	dc.d	0
.cosAz	dc.d	0
.sinAz	dc.d	0
