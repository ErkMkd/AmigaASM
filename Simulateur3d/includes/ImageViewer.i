;APS00000000000000000000000000000000000000000000000000000000000000000000000000000000
******************************************************************************************
******************************************************************************************
**											**
**					Viewer d'images					**
**	 				8/4/2001					**
**											**
**											**
******************************************************************************************
******************************************************************************************

*********************************************************
*	Activation/Désactivation du viewer d'image	*
*							*
*********************************************************
SetImageView
	movem.l	d0/d1/a0-a3/a6,-(sp)
;	---- Test l'état du gadget "DispImage":
;	move.l	DispImage_GE.gadget(pc),a0
;	move.l	MainWindow(pc),a1
;	sub.l	a2,a2
;	lea	DispImage_GE.readTags(pc),a3
;	CALLGT	GT_GetGadgetAttrsA
;	tst.l	DispImage_GE.readChecked(pc)
;	beq.s	.remove
;	---- Activation:
	bsr.w	InitImageView
	bcs.s	.e_error
	bra.s	.end
;	---- Désactivation:
.remove	bsr.w	RemoveImageView
;	---- Zee End:
.end	movem.l	(sp)+,d0/d1/a0-a3/a6
	clc
	rts

******** ERREURS ********
.e_error
	move.l	d0,(sp)
;	move.l	DispImage_GE.gadget(pc),a0
;	move.l	MainWindow(pc),a1
;	sub.l	a2,a2
;	lea	DispImage_GE.refreshTags(pc),a3
;	CALLGT	GT_SetGadgetAttrsA
	move.l	ErrorsTable(pc),a0
	move.l	(a0,d0.l*4),a0
	bsr.w	SetStatus
	movem.l	(sp)+,d0/d1/a0-a3/a6
	stc
	rts

*********************************************************
*	Initialisation du viewer d'images		*
*********************************************************
InitImageView
	movem.l	d0-a6,-(sp)
	tst.l	ImageWindow(pc)
	bne.s	.end

;	---- Ouverture fenêtre:
	sub.l	a0,a0
	lea	ImageWindow.tags(pc),a1
	CALLINT	OpenWindowTagList
	tst.l	d0
	beq.s	.e_imageWindow
	move.l	d0,ImageWindow
;	---- Initialisation palette niveau de gris:
;	(Seulement si l'écran est de type AGA ou 8bits)
	move.l		#FALSE,iv.grey
	move.l		WbScreen(pc),a0
	lea		sc_RastPort(a0),a0
	move.l		rp_BitMap(a0),a0
	move.l		a0,a4
	move.l		#CYBRMATTR_ISCYBERGFX,d0
	CALLCYBERGFX	GetCyberMapAttr
	tst.l		d0
	beq.s		.aga

;	Test si on est en mode 8bits:
.8bits	move.l		a4,a0
	move.l		#CYBRMATTR_DEPTH,d0
	CALLCYBERGFX	GetCyberMapAttr
	cmp.b		#8,d0
	bne.s		.rfresh

;	Aga ou 8bits:
.aga	move.w	#TRUE,iv.grey
	
;	---- Rafraichissement affichage:
.rfresh	bsr.w	RefreshImage

;	---- Zee End:
.end	movem.l	(sp)+,d0-a6
	clc
	rts


******** ERREURS ********

.e_imageWindow
	movem.l	(sp)+,d0-a6
	moveq	#Cant_open_window,d0
	stc
	rts

*********************************************************
*	Rafraichissement de l'affichage de l'image	*
*********************************************************
RefreshImage
	movem.l	d0-d3/a0-a3/a6,-(sp)
	tst.l	ImageWindow(pc)
	beq.s	.end
;	---- Saisie des données:
	move.l	ImageList_GE.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	ImageList_GE.readTags(pc),a3
	CALLGT	GT_GetGadgetAttrsA
	tst.l	ImageList_GE.readDisable(pc)
	bne.s	.clear
;	---- Saisie ImageData:
	move.w	ImageList_GE.readSelected+2(pc),d0
	move.l	Scene3d.Geometrics(pc),a0
	move.l	Geo_Images(a0),a0
	move.l	(a0,d0.w*4),a0
;	---- Affichage:
	bsr.w	DisplayImage
	bcs.s	.e_error
	bra.s	.end
;	---- Effacement image:
.clear	move.l		ImageWindow(pc),a1
	moveq		#4,d0
	moveq		#11,d1
	move.w		wd_Width(a1),d2
	subq.w		#4,d2
	move.w		wd_Height(a1),d3
	subq.w		#4,d3
	move.l		wd_RPort(a1),a1
	CALLGRAF	EraseRect
;	---- Zee End:
.end	movem.l	(sp)+,d0-d3/a0-a3/a6
	clc
	rts


******** ERREURS ********

.e_error
	move.l	d0,(sp)
	lea	ErrorsTable(pc),a0
	move.l	(a0,d0.w*4),a0
	bsr.w	SetStatus
	movem.l	(sp)+,d0-d3/a0-a3/a6
	stc
	rts


*********************************************************
*		Affichage d'une image			*
*IN:	a0=@ImageData					*
*********************************************************
;Note: L'image est affichée en niveaux de gris dans les
;	écrans 8bits et moin (AGA ou mode 8bits cyberGfx)

DisplayImage
	movem.l	d0-a6,-(sp)
	move.l	ImageWindow(pc),d0
	beq.w	iv.end
	move.l	d0,a3
	move.l	a0,a2

;	---- Redimensionne la fenetre:
	clr.l	d1
	move.w	id_XSize(a2),d1
	move.l	#ImageWindow_Width*$10000,d4
	divu.l	d1,d4		;d4=coeff. de multiplication d'échelle (virgule fixe 16bits)
	move.l	d4,iv.coeff
	clr.w	d0
	clr.l	d1
	move.w	id_YSize(a2),d1
	mulu.l	d4,d1
	swap	d1
	sub.w	wd_Height(a3),d1
	move.l	a3,a0
	CALLINT	SizeWindow

;	Attente du redimensionnement effectif:
iv.wt	move.l		wd_UserPort(a3),a0
	move.l		a0,a4
	CALLEXEC	WaitPort
	move.l		a4,a0
	CALLGT		GT_GetIMsg
	move.l		d0,a0
	cmp.l		#IDCMP_NEWSIZE,im_Class(a0)
	bne.s		iv.wt
	move.l		a0,a1
	CALLEXEC	ReplyMsg

;	---- Détermine le mode de rendu:
iv.trueColors
	move.b		Scene3d+scn_Depth(pc),d0
.8bits	cmp.b		#RenderDepth_8bits,d0
	bne.s		.15bits
	bsr.s		iv.i_8bits
	bcs.s		iv.e_error
	bra.s		iv.end
.15bits	cmp.b		#RenderDepth_15bits,d0
	bne.s		.16bits
	bsr.w		iv.i_15bits
	bcs.s		iv.e_error
	bra.s		iv.end
.16bits	cmp.b		#RenderDepth_16bits,d0
	bne.s		.32bits
	bsr.w		iv.i_16bits
	bcs.s		iv.e_error
	bra.s		iv.end
.32bits	cmp.b		#RenderDepth_32bits,d0
	bne.s		iv.e_BadRenderDepth
	bsr.w		iv.i_32bits
	bcs.s		iv.e_error

;	---- Zee End:
iv.end	movem.l	(sp)+,d0-a6
	clc
	rts

******** ERREURS ********

iv.e_BadRenderDepth
	movem.l	(sp)+,d0-a6
	move.l	#Invalid_render_depth,d0
	stc
	rts

iv.e_error
	move.l	d0,(sp)
	movem.l	(sp)+,d0-a6
	stc
	rts

******** SOUS-ROUTINES ********

;------------------------------
; 	RenderMode_8bits
;IN: a2=@ImageData
;    a3=@ImageWindow
;------------------------------
iv.i_8bits
	tst.w	iv.grey(pc)
	bne.s	.end
;	---- Allocation buffer d'affichage:
	moveq	#4,d2
	bsr.w	iv.AllocDisplayBuffer
	bcs.w	iv.e_AllocDB
;	---- Redimensionnement image:
	move.l	id_Buffer(a2),a0
	move.l	iv.DisplayBuffer(pc),a1
	move.w	wd_Height(a3),d0
	sub.w	#13+1,d0
	clr.l	d3			;d3=Pointeur Y sur Image
	clr.l	d4
	move.w	id_XSize(a2),d4
	move.w	d4,d6
	swap	d4
	divu.l	#ImageWindow_Width,d4	;d4=step (X et Y)
	move.l	id_Palette(a2),a5
	clr.w	d7

;	Boucle:
.Y	move.l	d3,d5
	swap	d5
	mulu.w	d6,d5
	lea	(a0,d5.l),a4
	move.w	wd_Width(a3),d1
	sub.w	#8+1,d1
	clr.l	d2	;d2=Pointeur X sur Image
.X		move.b	(a4,d2.w),d7
		move.l	(a5,d7.w*4),(a1)+
		swap	d2
		add.l	d4,d2
		swap	d2
		dbra	d1,.X
	add.l	d4,d3
	dbra	d0,.Y

;	---- Affichage:
	moveq	#4,d2
	move.l	#RECTFMT_ARGB,d7
	bsr.w	iv.DisplayImage_CyberGFX
;	---- Destruction du buffer d'affichage:
	move.l	iv.DisplayBuffer(pc),a1
	CALLEXEC	FreeVec

;	---- Zee End:
.end	clc
	rts


;------------------------------
; 	RenderMode_15bits
;IN: a2=@ImageData
;    a3=@ImageWindow
;------------------------------
iv.i_15bits
	tst.w	iv.grey(pc)
	bne.s	.end
;	---- Allocation buffer d'affichage:
	moveq	#4,d2
	bsr.w	iv.AllocDisplayBuffer
	bcs.w	iv.e_AllocDB
;	---- Redimensionnement image:
	move.l	id_Buffer(a2),a0
	move.l	iv.DisplayBuffer(pc),a1
	move.w	wd_Height(a3),d0
	sub.w	#13+1,d0
	clr.l	d3			;d3=Pointeur Y sur Image
	clr.l	d4
	move.w	id_XSize(a2),d4
	move.w	d4,d6
	swap	d4
	divu.l	#ImageWindow_Width,d4	;d4=step (X et Y)
	lsl.w	d6			;d6=Octets par ligne

;	Boucle:
.Y	move.l	d3,d5
	swap	d5
	mulu.w	d6,d5
	lea	(a0,d5.l),a4
	move.w	wd_Width(a3),d1
	sub.w	#8+1,d1
	clr.l	d2	;d2=Pointeur X sur Image
.X		move.w	(a4,d2.w*2),d5	;%00000000 0rrrrrgg gggbbbbb
		lsl.l	#6,d5	;%000rrrrr gggggbbb bb000000
		lsr.w	#3,d5	;%000rrrrr 000ggggg bbbbb000
		lsr.b	#3,d5	;%000rrrrr 000ggggg 000bbbbb
		lsl.l	#3,d5	;%rrrrr000 ggggg000 bbbbb000
		move.l	d5,(a1)+
		swap	d2
		add.l	d4,d2
		swap	d2
		dbra	d1,.X
	add.l	d4,d3
	dbra	d0,.Y

;	---- Affichage:
	moveq	#4,d2
	move.l	#RECTFMT_ARGB,d7
	bsr.w	iv.DisplayImage_CyberGFX
;	---- Destruction du buffer d'affichage:
	move.l	iv.DisplayBuffer(pc),a1
	CALLEXEC	FreeVec

;	---- Zee End:
.end	clc
	rts

;------------------------------
; 	RenderMode_16bits
;IN: a2=@ImageData
;    a3=@ImageWindow
;------------------------------
iv.i_16bits
	tst.w	iv.grey(pc)
	bne.w	.end
;	---- Allocation buffer d'affichage:
	moveq	#4,d2
	bsr.w	iv.AllocDisplayBuffer
	bcs.w	iv.e_AllocDB
;	---- Redimensionnement image:
	move.l	id_Buffer(a2),a0
	move.l	iv.DisplayBuffer(pc),a1
	move.w	wd_Height(a3),d0
	sub.w	#13+1,d0
	clr.l	d3			;d3=Pointeur Y sur Image
	clr.l	d4
	move.w	id_XSize(a2),d4
	move.w	d4,d6
	swap	d4
	divu.l	#ImageWindow_Width,d4	;d4=step (X et Y)
	lsl.w	d6			;d6=Octets par ligne

;	Boucle:
.Y	move.l	d3,d5
	swap	d5
	mulu.w	d6,d5
	lea	(a0,d5.l),a4
	move.w	wd_Width(a3),d1
	sub.w	#8+1,d1
	clr.l	d2	;d2=Pointeur X sur Image
.X		move.w	(a4,d2.w*2),d5	;%00000000 rrrrrggg gggbbbbb
		lsl.l	#5,d5	;%000rrrrr ggggggbb bbb00000
		lsr.w	#1,d5	;%000rrrrr 0ggggggb bbbb0000
		lsl.l	#1,d5	;%00rrrrr0 ggggggbb bbb00000
		lsr.w	#2,d5	;%00rrrrr0 00gggggg bbbbb000
		lsr.b	#2,d5	;%00rrrrr0 00gggggg 00bbbbb0
		lsl.l	#2,d5	;%rrrrr000 gggggg00 bbbbb000
		move.l	d5,(a1)+
		swap	d2
		add.l	d4,d2
		swap	d2
		dbra	d1,.X
	add.l	d4,d3
	dbra	d0,.Y

;	---- Affichage:
	moveq	#4,d2
	move.l	#RECTFMT_ARGB,d7
	bsr.w	iv.DisplayImage_CyberGFX
;	---- Destruction du buffer d'affichage:
	move.l	iv.DisplayBuffer(pc),a1
	CALLEXEC	FreeVec

;	---- Zee End:
.end	clc
	rts


;------------------------------
; 	RenderMode_32bits
;IN: a2=@ImageData
;    a3=@ImageWindow
;------------------------------
iv.i_32bits
	tst.w	iv.grey(pc)
	bne.s	.end
;	---- Allocation buffer d'affichage:
	moveq	#4,d2
	bsr.w	iv.AllocDisplayBuffer
	bcs.w	iv.e_AllocDB
;	---- Redimensionnement image:
	move.l	id_Buffer(a2),a0
	move.l	iv.DisplayBuffer(pc),a1
	move.w	wd_Height(a3),d0
	sub.w	#13+1,d0
	clr.l	d3			;d3=Pointeur Y sur Image
	clr.l	d4
	move.w	id_XSize(a2),d4
	move.w	d4,d6
	swap	d4
	divu.l	#ImageWindow_Width,d4	;d4=step (X et Y)
	lsl.w	#2,d6			;d6=Octets par ligne

;	Boucle:
.Y	move.l	d3,d5
	swap	d5
	mulu.w	d6,d5
	lea	(a0,d5.l),a4
	move.w	wd_Width(a3),d1
	sub.w	#8+1,d1
	clr.l	d2	;d2=Pointeur X sur Image
.X		move.l	(a4,d2.w*4),(a1)+
		swap	d2
		add.l	d4,d2
		swap	d2
		dbra	d1,.X
	add.l	d4,d3
	dbra	d0,.Y

;	---- Affichage:
	moveq	#4,d2
	move.l	#RECTFMT_ARGB,d7
	bsr.w	iv.DisplayImage_CyberGFX
;	---- Destruction du buffer d'affichage:
	move.l	iv.DisplayBuffer(pc),a1
	CALLEXEC	FreeVec

;	---- Zee End:
.end	clc
	rts


;	---- ERREURS ----
iv.e_AllocDB
	stc
	rts

;---------------------------------------------------------
; Allocation du buffer de redimensionnement de l'image
;IN:	a3=@ImageWindow
;	d2=taille d'un pixel en octets
;OUT:	iv.DisplayBuffer initialisé
;CRASH: d0,d1,a0,a1,a6
;---------------------------------------------------------
iv.AllocDisplayBuffer
	move.w	wd_Width(a3),d0
	move.w	wd_Height(a3),d1
	sub.w	#8,d0
	sub.w	#13,d1
	mulu.w	d1,d0
	mulu.l	d2,d0
	move.l	#MEMF_FAST!MEMF_CLEAR,d1
	CALLEXEC	AllocVec
	tst.l	d0
	beq.w	.e_memory
	move.l	d0,iv.DisplayBuffer
	clc
	rts

.e_memory
	move.l	#Not_enough_memory,d0
	stc
	rts

;-----------------------------------------------------------
;	Affichage de l'image (cyberGFX)
;IN: d2=Taille d'un pixel en octets
;    d7=Format de l'image
;    a3=@ImageWindow
;       (cf. autodocs sur "CyberGraphics/WritePixelArray")
;CRASH: d0,d1,d2,d3,d4,d5,d6,d7,a0,a1,a6
;-----------------------------------------------------------
iv.DisplayImage_CyberGFX
	move.l	iv.DisplayBuffer(pc),a0
	clr.l	d0
	clr.l	d1
	move.l	wd_RPort(a3),a1
	move.w	#4,d3
	move.w	#11,d4
	move.w	wd_Width(a3),d5
	move.w	wd_Height(a3),d6
	sub.w	#8,d5
	sub.w	#13,d6
	mulu.w	d5,d2
	CALLCYBERGFX	WritePixelArray
	rts

*********************************************************
*	Suppression du viewer d'images			*
*********************************************************
RemoveImageView
	movem.l	d0/d1/a0/a1/a6,-(sp)
;	---- Fermeture fenetre:
	move.l	ImageWindow(pc),d0
	beq.s	.end
	move.l	d0,a0
	move.w	wd_TopEdge(a0),ImageWindow.Top+2
	move.w	wd_LeftEdge(a0),ImageWindow.Left+2
	move.w	wd_Height(a0),ImageWindow.Height+2
	clr.l	ImageWindow
	CALLINT	CloseWindow
;	---- Zee End:
.end	movem.l	(sp)+,d0/d1/a0/a1/a6
	clc
	rts

******** DONNEES ********
iv.DisplayBuffer	dc.l	0	;Pointeur sur l'image convertie pour l'affichage
iv.coeff		dc.l	0	;Coefficient multiplicateur pour le changement
;					;d'échelle de l'image (virgule fixe 16 bits)
iv.grey		dc.w	0	;Flag (TRUE: Image en niveau de gris, FALSE: image en couleurs)
iv.SaveColorMap	dc.l	0	;Sauvegarde de la palette du system

;Palette en niveaux de gris pour les modes d'écran 8bits et AGA:
iv.GreyColors
	dc.w	252	;Nombre de couleurs à changer
	dc.w	4	;Première couleur à changer
	ds.l	3*4*252

;----Fenetre:
	ImageWindow_Width=200
	ImageWindow_Height=(ImageWindow_Width/4)*3

ImageWindow	dc.l	0

ImageWindow.tags
			dc.l	WA_Left
ImageWindow.Left	dc.l	50
			dc.l	WA_Top
ImageWindow.Top		dc.l	50
	dc.l	WA_Width
ImageWindow.Width
	dc.l	ImageWindow_Width+8
	dc.l	WA_Height
ImageWindow.Height
	dc.l	ImageWindow_Height+13
	dc.l	WA_IDCMP,IDCMP_NEWSIZE
	dc.l	WA_Title,ImageWindow.title
	dc.l	WA_MinWidth,100
	dc.l	WA_MinHeight,100
	dc.l	WA_MaxWidth,100
	dc.l	WA_MaxHeight,100
	dc.l	WA_SizeGadget,FALSE
	dc.l	WA_DragBar,TRUE
	dc.l	WA_DepthGadget,TRUE
	dc.l	WA_CloseGadget,FALSE
	dc.l	WA_Backdrop,FALSE
	dc.l	WA_ReportMouse,FALSE
	dc.l	WA_Borderless,FALSE
	dc.l	WA_Activate,TRUE
	dc.l	TAG_DONE

ImageWindow.title	STRING	"Image view"
