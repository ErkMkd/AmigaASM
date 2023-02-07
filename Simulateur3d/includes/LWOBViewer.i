;APS00000000000000000000000000000000000000000000000000000000000000000000000000000000
******************************************************************************************
******************************************************************************************
**											**
**					Viewer LWOB 					**
**	 				7/4/2001					**
**											**
**											**
******************************************************************************************
******************************************************************************************

*************************************************
*	Initialisation du viewer d'objet	*
*************************************************

InitObjectView
	movem.l	d0/d1/a0-a3/a6,-(sp)
;	---- Test le mode d'affichage:
	move.l	DisplayGeo.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	DisplayGeo.readTags(pc),a3
	CALLGT	GT_GetGadgetAttrsA
	cmp.l	#DispMode_NoDisplay,DisplayGeo.active
	bne.s	.open
	bsr.w	RemoveObjectView
	bra.s	.end
;	---- Ouverture de la fenetre:
.open	tst.l	LWOBWindow(pc)
	bne.s	.end
	sub.l	a0,a0
	lea	LWOBWindow.tags(pc),a1
	CALLINT	OpenWindowTagList
	tst.l	d0
	beq.w	.e_LWOBWindow
	move.l	d0,LWOBWindow
;	---- Zee End:
.end	movem.l	(sp)+,d0/d1/a0-a3/a6
	clc
	rts

******** Erreurs ********

.e_LWOBWindow
	lea	STRING_Cant_open_window(pc),a0
	bsr.w	SetStatus
	movem.l	(sp)+,d0/d1/a0-a3/a6
	moveq	#Cant_open_window,d0
	stc
	rts

*************************************************
*	Destruction du viewer d'objet		*
*************************************************
RemoveObjectView
	movem.l	d0/d1/a0/a1/a6,-(sp)
;	---- Fermeture fenetre:
	move.l	LWOBWindow(pc),d0
	beq.s	.end
	move.l	d0,a0
	move.w	wd_TopEdge(a0),LWOBWindow.Top+2
	move.w	wd_LeftEdge(a0),LWOBWindow.Left+2
	move.w	wd_Width(a0),LWOBWindow.Width+2
	move.w	wd_Height(a0),LWOBWindow.Height+2
	CALLINT	CloseWindow
	clr.l	LWOBWindow
.end	movem.l	(sp)+,d0/d1/a0/a1/a6
	clc
	rts


*********************************************************
*	Initialisation de la scene adaptée au viewer	*
*********************************************************
InitViewerScene
	movem.l	d0/d1/a0-a3/a6,-(sp)
;	---- On efface la précédente:
	bsr.w	RemoveViewerScene
;	---- Création de la scène:
	tst.l	Scene3d.Geometrics(pc)
	beq.s	.end
	lea	Scene3d(pc),a0
	jsr	InitScene
	bcs.s	.e_error
;	---- Initialisation de la position de l'objet
	bsr.w	ResetObjectPosition
;	---- Zee End:
.end	movem.l	(sp)+,d0/d1/a0-a3/a6
	clc
	rts

******** Erreurs ********

.e_error
	move.l	d0,(sp)	
	movem.l	(sp)+,d0/d1/a0-a3/a6
	stc
	rts

.e_memory
	movem.l	(sp)+,d0/d1/a0-a3/a6
	moveq	#Not_enough_memory,d0
	stc
	rts

*****************************************************************
*	Calcul la position de l'objet pour qu'il tienne dans	*
*	la fenetre LWOBWindow.					*
*****************************************************************

;---- Format écran de référence:
	XDim=320
	YDim=240
	Marge=40	;Marge entre l'objet et les extrémités de la fenêtre.

ResetObjectPosition
	movem.l		d0/d1/a0-a2,-(sp)
	fmovem		fp0-fp2,-(sp)
;	---- Determine quelle est la coordonnée la plus éloignée du centre de l'objet:

		move.l	Scene3d.Geometrics(pc),d0
		beq.s	.end
		move.l	d0,a0

	move.l		Geo_NbrPoints(a0),d0
	beq.w		.end
	mulu.w		#3,d0
	move.l		Geo_Points(a0),a1
	fsub		fp0,fp0		;fp0=coordonnée en question
.loop	fmove.s		(a1)+,fp1
	fabs		fp1
	fcmp		fp0,fp1
	fble		.next
	fmove		fp1,fp0
.next	subq.l		#1,d0
	bne.s		.loop
;	---- Centrage (en fonction du plus petit coté de la fenêtre):
	ifge	XDim-YDim
	move.w	#YDim/2,d0
	else
	move.w	#XDim/2,d0	;d0=centrage
	endc
;	---- Détermine la distance ZPos de l'objet:
;	Equation:
;	ZPos=(fp0*persp)/(Marge-d0)
.zPos	fmove.w	#Marge,fp1
	fsub.w	d0,fp1
	fmul.d	LWOBViewer.persp(pc),fp0
	fdiv	fp1,fp0
	fmove.s	fp0,obj_sr+sr_ZPos(a0)
;	---- Autres inits:
	fmove.b	#0,fp0
	fmove.s	fp0,obj_sr+sr_XPos(a0)
	fmove.s	fp0,obj_sr+sr_YPos(a0)
	lea	ViewerMotion(pc),a0
	fmove.s	fp0,ar_DeltaX(a0)
	fmove.s	fp0,ar_DeltaY(a0)
	fmove.s	fp0,ar_DeltaZ(a0)
;	---- Zee End:
.end	fmovem	(sp)+,fp0-fp2
	movem.l	(sp)+,d0/d1/a0-a2
	clc
	rts

*********************************************************
*	Destruction de la scène adaptée au viewer	*
*********************************************************
RemoveViewerScene
	movem.l		d0/d1/a0/a1/a6,-(sp)
	lea		Scene3d(pc),a0
	jsr		RemoveScene
	movem.l		(sp)+,d0/d1/a0/a1/a6
	clc
	rts

*********************************************************
*	Conversion 3d=>2d d'un objet simple		*
*********************************************************
BasicConversion
	movem.l	d0-d4/a0-a2,-(sp)

		move.l	Scene3d.Geometrics(pc),a0

	move.l	Geo_NbrPoints(a0),d0
	move.l	Scene3d+scn_Coords(pc),a1
	move.l	obj_sr+sr_XPos(a0),d1
	move.l	obj_sr+sr_YPos(a0),d2
	move.l	obj_sr+sr_ZPos(a0),d3
	move.l	a1,a2
	bsr.w	ProportionalConvertion
	movem.l	(sp)+,d0-d4/a0-a2
	clc
	rts


*************************************************
*	Convertion proportionnelle		*
*IN:	d0=Nombre de points			*
*	d1=XPos					*
*	d2=YPos					*
*	d3=ZPos					*
*	a1=@Coordonnées 3d			*
*	a2=@Coordonnées 2d			*
*************************************************

ProportionalConvertion
	movem.l	d0/a0-a2,-(sp)
	fmovem	fp0-fp7,-(sp)
;	---- Offsets centrage:
	move.l	LWOBWindow(pc),a0
	cmp.l	#0,a0
	beq.s	.closed
	fmove.w	wd_Width(a0),fp0
	fmove.w	wd_Height(a0),fp1
	bra.s	.ok
.closed	fmove.w	LWOBWindow.Width+2(pc),fp0
	fmove.w	LWOBWindow.Height+2(pc),fp1
.ok	fmove	fp0,fp5
	fmove	fp1,fp6
	fdiv	#2,fp5	;fp5=centrage X
	fdiv	#2,fp6	;fp6=centrage Y
;	---- Coeffs déformation:
	fmove.w	#XDim,fp2
	fmove.w	#YDim,fp3
	fdiv	fp2,fp0
	fdiv	fp3,fp1
	fmul.d	LWOBViewer.persp(pc),fp0	;fp0=coeff X
	fmul.d	LWOBViewer.persp(pc),fp1	;fp1=coeff Y
;	---- Init boucle:
	subq.w	#1,d0
	blt.s	.end
;	---- Boucle:
.loop	fmove.s	(a1)+,fp2
	fmove.s	(a1)+,fp3
	fmove.s	(a1)+,fp4
	fmul	fp0,fp2
	fmul	fp1,fp3
	fdiv	fp4,fp2
	fdiv	fp4,fp3
	fadd	fp5,fp2
	fadd	fp6,fp3
	fmove.l	fp2,(a2)+
	fmove.l	fp3,(a2)+
	dbra	d0,.loop
;	---- Zee End:
.end	fmovem	(sp)+,fp0-fp7
	movem.l	(sp)+,d0/a0-a2
	clc
	rts

*********************************************************
*	Affichage de l'objet				*
*********************************************************
DisplayObject
	movem.l	d0/d1/a0-a4/a6,-(sp)

		move.l	Scene3d.Geometrics(pc),d0
		beq.w	.end
		move.l	d0,a4

;	---- Test si l'objet est valide:
	tst.l	Geo_NbrPoints(a4)
	beq.s	.end
;	---- Test si l'affichage est possible:
	tst.l	LWOBWindow(pc)
	beq.s	.end
;	---- Test le mode d'affichage:
	move.l	DisplayGeo.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	DisplayGeo.readTags(pc),a3
	CALLGT	GT_GetGadgetAttrsA
	cmp.l	#DispMode_Friendly,DisplayGeo.active
	beq.s	.friendly
	cmp.l	#DispMode_Internal,DisplayGeo.active
	beq.s	.internal
;	---- Pas d'affichage:
	movem.l	(sp)+,d0/d1/a0-a4/a6
	clc
	rts
;	---- Affichage en friendly:
.friendly
;	Couleur:
	move.l		LWOBWindow(pc),a1
	move.l		wd_RPort(a1),a1
	moveq		#1,d0
	CALLGRAF	SetAPen
;	Calculs/Affichage:
	lea	ViewerMotion(pc),a0
	bsr.w	AbsoluteRotation
	lea	Scene3d(pc),a0
	bsr.w	VectorTranslation
	bsr.w	BasicConversion
	bsr.w	Friendly_ClearWindow
	bsr.w	Friendly_DisplayDots
	bra.s	.end

;	---- Affichage en interne:
.internal
	nop
;	---- Zee End:
.end
	movem.l	(sp)+,d0/d1/a0-a4/a6
	clc
	rts

*********************************************************
*	Affichage des points en friendly		*
*********************************************************
Friendly_DisplayDots
	movem.l	d0-d2/a0-a3/a6,-(sp)

		move.l	Scene3d.Geometrics(pc),d0
		beq.s	.end
		move.l	d0,a2

;	---- Init loop:
	move.l	Geo_NbrPoints(a2),d2
	subq.l	#1,d2
	blt.s	.end
;	---- Init pointeurs:
	move.l	Scene3d+scn_Coords(pc),a2
	move.l	LWOBWindow(pc),a1
	move.l	wd_RPort(a1),a1
	move.l	a1,a3
;	---- Affichage:
.loop	movem.l		(a2)+,d0/d1
	move.l		a3,a1
	CALLGRAF	WritePixel
	dbra		d2,.loop
;	---- Zee End:
.end	movem.l	(sp)+,d0-d2/a0-a3/a6
	clc
	rts

*********************************************************
*	Effacement de la fenetre LWOBWindow en friendly	*
*********************************************************
Friendly_ClearWindow
	movem.l		d0/d1/a0/a1/a6,-(sp)
	move.l		LWOBWindow(pc),a1
	moveq		#4,d0
	moveq		#11,d1
	move.w		wd_Width(a1),d2
	subq.w		#4,d2
	move.w		wd_Height(a1),d3
	subq.w		#4,d3
	move.l		wd_RPort(a1),a1
	CALLGRAF	EraseRect
.end	movem.l		(sp)+,d0/d1/a0/a1/a6
	clc
	rts

*********************************************************************************
*			DONNEES RELATIVES AU VIEWER D'OBJETS			*
*********************************************************************************

;---- Variable du viewer:
LWOBViewer.persp	dc.d	256	; Taille du champ de vision (taux de perspective)
LWOBViewer.lock		dc.w	0


;---- Fenetre:

LWOBWindow	dc.l	0

LWOBWindow.tags
	dc.l	WA_Left
LWOBWindow.Left
	dc.l	0
	dc.l	WA_Top
LWOBWindow.Top
	dc.l	11+256
	dc.l	WA_Width
LWOBWindow.Width
	dc.l	320
	dc.l	WA_Height
LWOBWindow.Height
	dc.l	240
	dc.l	WA_IDCMP,0
	dc.l	WA_Title,LWOBWindow.title
	dc.l	WA_MinWidth,64
	dc.l	WA_MinHeight,64
	dc.l	WA_MaxWidth,640
	dc.l	WA_MaxHeight,480
	dc.l	WA_SizeGadget,TRUE
	dc.l	WA_DragBar,TRUE
	dc.l	WA_DepthGadget,TRUE
	dc.l	WA_CloseGadget,FALSE
	dc.l	WA_Backdrop,FALSE
	dc.l	WA_ReportMouse,FALSE
	dc.l	WA_Borderless,FALSE
	dc.l	WA_Activate,TRUE
	dc.l	TAG_DONE

LWOBWindow.title	STRING	"Object view"

