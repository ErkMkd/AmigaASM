;APS0000499F000000000000000000000000000000000000000000000000000000000000000000000000
*****************************************
*					*
*	Editeur Simulateur d'espace	*
*	Revision: 13/5/2001		*
*					*
*****************************************

*****************************************************************************************
*				Travail en cours et travail à prévoir			*
*				(Classement dans l'ordre des priorités)			*
*****************************************************************************************

;	-Extension du logiciel à l'édition de scènes:

;			-Structuration du noyau:
;				-incorporer les tags de rafraichissement
;				 des gadgets au noyau de l'interface

;			-Gestion des différents panneaux:

;				-Rafraichissement des données des panneaux lors de
;				 leur affichage.
;
;			-Developper un peu plus l'éditeur d'images

;			-Etudier l'éditeur de textures

;			-Etudier l'éditeur de mouvements de manière à ce qu'il soit
;			 évolutif (systèmes de pluggins).

;	-Utilisation d'un écran (choix par la reqtools)
;			=>Prévoir un fichier de stockage des paramètres
;			  définis par l'utilisateur (Préférences)

;	-Voir comment accéder aux bitmaps 32bits des images chargées à partir des datatypes.

;	-Optimisation de mémoire en supprimant les images utilisées plusieurs fois.
;	 (Routine "InitScene").
;

;	-Routine "SetObjectSize" à completer:
;			- Calcul de la place occupée par les chaines ascii des noms de
;			  types de texture.

;	-Routines "LoadLWOB" et "RemoveObject" à inclure éventuelement dans "CreateGeometric"
;	 et "RemoveGeometric".

;	-Editer les notes explicatives pour les phases d'init importantes



;*** Obsolète pour le moment:

;	-Affichage des images dans les écrans AGA et modes 8bits (images en niveau de gris)


*****************************************************************************************


*****************************************************************************************
*											*
*					INCLUDES					*
*											*
*****************************************************************************************

	section	Intense,code_f

	bra	Start

	incdir	WorkCode:SubRoutines/
	include	System.s
	include	Files.s
	include	Init_LWOB.i
	include	Structures.i
	include	Maths3d.i
	include	LWOBViewer.i
	include	ImageViewer.i
  
*****************************************************************************************
*			Texte de la fenetre principale					*
*****************************************************************************************

MainWindow.title	STRING	"Developpement 3d - Eric Kernin - 4/12/2000-13/05/2001"

*****************************************************************************************
*					MACROS						*
*****************************************************************************************

STATUS_OK	macro
	lea		Status_OK(pc),a0
	bsr.w		SetStatus
		endm

*****************************************************************************************

Start

	bsr.w	Init	; Initialise l'environnement

******************************************************************************************
******************************************************************************************
**			PROGRAMME PRINCIPAL						**
******************************************************************************************
******************************************************************************************

Main
;	---- Initialisations:
	bsr.w		InitInterface
	bcs.w		End_error
	bsr.w		InitFileRequest
	bcc.s		.ok
	bsr.w		RemoveInterface
	bra.w		End_error
.ok
;	---- Boucle principale:
MainLoop
	tst.l		MainMessage(pc)
	beq.s		.read
	move.l		MainMessage,a1
	CALLGT		GT_ReplyIMsg
	clr.l		MainMessage
.read	move.l		MainWindow(pc),a0
	move.l		wd_UserPort(a0),a0
	move.l		a0,a2
	CALLEXEC	WaitPort
	move.l		a2,a0
	CALLGT		GT_GetIMsg
	move.l		d0,a0
	move.l		d0,MainMessage
;	---- Determine la nature du message:
	cmp.l		#IDCMP_CLOSEWINDOW,im_Class(a0)
	beq.w		CloseGadget
	cmp.l		#IDCMP_GADGETUP,im_Class(a0)
	beq.w		m.GadgetID
	cmp.l		#IDCMP_RAWKEY,im_Class(a0)
	beq.s		.ShortCuts
	bra.s		MainLoop


*********************************
*	Raccourcis clavier	*
*********************************
.ShortCuts
	move.b	_ciaa+ciasdr,d0
	cmp.b	#117,d0
	beq.w	CloseGadget
	bra.s	MainLoop

*********************************
*	Control gadgets		*
*IN:a0=@message intuition	*
*********************************
m.GadgetID
	move.l	im_IAddress(a0),a0
	move.w	gg_GadgetID(a0),d0

;	---- Panneau principal:
.PanelList
	cmp.w	#PanelList_ID,d0
	bne.s	.Panel
	bsr.w	SetPanel

;	---- Détermine le panneau actif:
.Panel	move.l	ik_CurrentPanel(pc),d1
	cmp.l	#PanelID_SE,d1
	beq.s	SceneEditor_GID
	cmp.l	#PanelID_GE,d1
	beq.s	GeometricEditor_GID
	bra.w	MainLoop

;	---- Panneau "SCENE EDITOR":

SceneEditor_GID

.LoadObject
	cmp.w		#LoadObject_ID,d0
	bne.w		MainLoop
	bsr.w		LoadObject
	bsr.w		RefreshDatas
	bsr.w		DisplayObject
	bsr.w		RefreshImage
	bra.w		MainLoop

;	---- Panneau "GEOMETRIC EDITOR":

GeometricEditor_GID

.SurfaceList
	cmp.w		#SurfaceList_GE_ID,d0
	bne.s		.DisplayGeoMode
	bsr.w		RefreshSurface
	bra.w		MainLoop

.DisplayGeoMode
	cmp.w		#DisplayGeo_ID,d0
	bne.s		.DispImage
	bsr.w		TestFPU
	bcs.s		.e_FPU
	bsr.w		InitObjectView
	bsr.w		DisplayObject
	bra.w		MainLoop

.DispImage
;	cmp.w		#DispImage_GE_ID,d0
;	bne.s		.ImageList
;	bsr.w		SetImageView
;	bra.w		MainLoop

.ImageList
;	cmp.w		#ImageList_GE_ID,d0
;	bne.w		MainLoop
;	bsr.w		RefreshImage
	bra.w		MainLoop


******** Erreurs ********

.e_FPU	lea	ErrorsTable(pc),a0
	move.l	No_FPU*4(a0),a0
	bsr.w	SetStatus
	move.l	DisplayGeo.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	DisplayGeo.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA
	bra.w	MainLoop


;	**** Données locales:
MainMessage	dc.l	0


*********************** Procédures finales ******************************


;	---- Cellule de fermeture activée:
CloseGadget
	bsr.w		RemoveImageView
	bsr.w		RemoveObjectView
	bsr.w		RemoveViewerScene
	bsr.w		RemoveInterface
	bsr.w		RemoveFileRequest
;	---- Destruction objet en mémoire:
	bsr.w		RemoveObject
	bsr.w		RemoveSurfacesList
	bsr.w		RemoveImageList
;	----Fin:
Zee_End
	bsr.w	Exit
	clr.l	d0
	rts

;	---- Fin avec erreur:
End_error
	bsr.w	Exit
	clr.l	d0
	rts



******************************************************************************************
******************************************************************************************
**					SOUS PROGRAMMES					**
******************************************************************************************
******************************************************************************************

*************************************************
*	Changement de panneau			*
*************************************************

;	!!! Rafraichire également les données du panneau !!!

SetPanel
	movem.l	d0-d4/a0-a3/a6,-(sp)
;	---- Rafraichissement gadget panelList:
	move.l	ik_CurrentPanel(pc),d2
	move.l	PanelList.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	PanelList.readTags(pc),a3
	CALLGT	GT_GetGadgetAttrsA
;	---- Rafraichissement interface:
	move.l	ik_CurrentPanel(pc),d0
	cmp.l	d0,d2
	beq.s	.end
	bsr.s	.RemovePanel
	lea	Panels_Table(pc),a1
	move.l	(a1,d0.w*4),a1
	bsr.s	.InitPanel
	bra.w	.end

;	---- Zee End:
.end	movem.l	(sp)+,d0-d4/a0-a3/a6
	clc
	rts

******** SOUS-PROGRAMMES  ********

;*--------------------------------------*
;*	Effacement panneau précédent	*
;*--------------------------------------*
.RemovePanel
	move.l	d0,-(sp)
;	---- Sépare le panneau de la liste des gadgets:
	move.l	MainWindow(pc),a0
	move.l	Status.gadget(pc),a1
	move.l	gg_NextGadget(a1),d0
	beq.s	.endRP
	move.l	d0,a1
	moveq	#-1,d0
	CALLINT	RemoveGList
;	---- Effacement fenêtre:
	move.l		MainWindow(pc),a1
	moveq		#4,d0
	moveq		#11,d1
	move.w		wd_Width(a1),d2
	subq.w		#4,d2
	move.w		wd_Height(a1),d3
	subq.w		#4,d3
	move.l		wd_RPort(a1),a1
	CALLGRAF	EraseRect
;	---- Ok:
.endRP	move.l	(sp)+,d0
	rts

;*--------------------------------------*
;*	Affichage nouveau panneau	*
;*IN:	a1=@Panneau (GadgetList)	*
;*--------------------------------------*
.InitPanel
	move.l	a1,a3
;	---- Initialisation panneau:
	move.l	MainWindow(pc),a0
	moveq	#-1,d0
	moveq	#-1,d1
	sub.l	a2,a2
	CALLINT	AddGList
;	---- Rafraichissement gadgets:
	move.l	MainWindow.GList(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	moveq	#-1,d0
	CALLINT	RefreshGList
;	---- Rafraichissement fenetre:
	move.l	MainWindow(pc),a0
	CALLGT	GT_RefreshWindow
	rts


*************************************************
*	Chargement d'un objet			*
*************************************************
LoadObject
	movem.l		d0-a6,-(sp)
;	---- Requester fichier:
	bsr.w		FileRequest_LWOB
	bcc.s		.ok
	cmp.w		#Operation_canceled,d0
	beq.w		.end
.ok	bsr.w		RemoveViewerScene
	bsr.w		RemoveObject
	bsr.w		RemoveImageList
	bsr.w		RemoveSurfacesList
;	---- Chargement fichier:
	move.l		#LWOBCompleteName,d1
	move.l		#MODE_OLDFILE,d2
	CALLDOS		Open
	tst.l		d0
	beq.w		.e_Open
	move.l		d0,.fileHandle
;	Test format:
	move.l		.fileHandle(pc),d1
	move.l		#.LWOBChunk,d2
	moveq		#12,d3
	bsr.w		DataCache_Off
	CALLDOS		Read
	bsr.w		DataCache_On
	lea		.LWOBChunk(pc),a0
	cmp.l		#"FORM",(a0)
	bne.w		.e_format
	cmp.l		#"LWOB",8(a0)
	bne.w		.e_format
;	Allocation mémoire:
	move.l		4(a0),d0
	addq.l		#8,d0
	move.l		d0,.fileSize
	moveq		#MEMF_FAST,d1
	CALLEXEC	AllocVec
	tst.l		d0
	beq.w		.e_Memory
	move.l		d0,LightWaveObject
;	Recalage au début du fichier:
	move.l		.fileHandle(pc),d1
	clr.l		d2
	moveq		#OFFSET_BEGINNING,d3
	CALLDOS		Seek
;	Chargement données:
	move.l		.fileHandle(pc),d1
	move.l		LightWaveObject(pc),d2
	move.l		.fileSize(pc),d3
	bsr.w		DataCache_Off
	CALLDOS		Read
	bsr.w		DataCache_On
;	Fermeture fichier:
	move.l		.fileHandle(pc),d1
	CALLDOS		Close
;	Initialisation de l'objet:
	move.l		LightWaveObject(pc),a0
	bsr.w		CreateGeometric
	bcs.w		.e_error
	move.l		a0,Scene3d.Geometrics
;	Initialisation de la liste des noms des surfaces:
	bsr.w		InitSurfacesList
	bcs.w		.e_error
;	Initialisation de la liste des noms des images:
	bsr.w		InitImageList
	bcs.w		.e_error
;	Initialisation de la scene adaptée au viewer:
	bsr.w	InitViewerScene
	bcs.s	.e_error
;	---- Zee End:
.end	STATUS_OK
	movem.l		(sp)+,d0-a6
	clc
	rts

;	******** Erreurs ********
.e_Open
	bsr.w		ClearObjectName
	lea		STRING_Cant_open_file(pc),a0
	bsr.w		SetStatus
	movem.l		(sp)+,d0-a6
	moveq		#Cant_open_file,d0
	stc
	rts

.e_format
	bsr.w		ClearObjectName
	lea		STRING_Bad_file_format(pc),a0
	bsr.w		SetStatus
	move.l		.fileHandle(pc),d1
	CALLDOS		Close
	movem.l		(sp)+,d0-a6
	moveq		#Bad_file_format,d0
	stc
	rts

.e_Memory
	bsr.w		ClearObjectName
	lea		STRING_Not_enough_memory(pc),a0
	bsr.w		SetStatus
	move.l		.fileHandle(pc),d1
	CALLDOS		Close
	movem.l		(sp)+,d0-a6
	moveq		#Not_enough_memory,d0
	stc
	rts

.e_error
	lea		ErrorsTable(pc),a0
	move.l		(a0,d0.w*4),a0
	bsr.w		SetStatus
	move.l		d0,(sp)

	bsr.w		ClearObjectName
	bsr.w		RemoveViewerScene
	bsr.w		RemoveObject
	bsr.w		RemoveImageList
	bsr.w		RemoveSurfacesList
	move.l	DisplayGeo.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	DisplayGeo.readTags(pc),a3
	CALLGT	GT_GetGadgetAttrsA
	cmp.l	#DispMode_Friendly,DisplayGeo.active
	bne.s	.e_error_end
	bsr.w	Friendly_ClearWindow
.e_error_end
	movem.l		(sp)+,d0-a6
	stc
	rts

;	******** Données ********
.fileHandle	dc.l	0
.fileSize	dc.l	0
.LWOBChunk	dcb.b	12,0

*********************************************************
*	Destruction de l'objet chargé et initialisé	*
*********************************************************
RemoveObject
	movem.l		d0/d1/a0/a1/a6,-(sp)
;	Supprime les données du fichier:
.lwo	tst.l		LightWaveObject(pc)
	beq.s		.vs
	move.l		LightWaveObject(pc),a1
	clr.l		LightWaveObject
	CALLEXEC	FreeVec
;	Supprime la scène adaptée au viewer:
.vs	bsr.w		RemoveViewerScene
;	Supprime l'objet géometrique:
	move.l		Scene3d.Geometrics(pc),d0
	beq.s		.end
	move.l		d0,a0
	clr.l		Scene3d.Geometrics
	bsr.w		RemoveGeometric
.end	movem.l		(sp)+,d0/d1/a0/a1/a6
	clc
	rts


******************************************************************************************
******************************************************************************************
**				Gestion Interface					**
******************************************************************************************
******************************************************************************************


*********************************************************
*	Rafraichissement de l'affichage des données	*
*********************************************************
RefreshDatas
	movem.l		d0/d1/a0-a3/a6,-(sp)
;	---- Rafraichissement gadget "Object name":
	move.l		ObjectName.gadget(pc),a0
	move.l		MainWindow(pc),a1
	sub.l		a2,a2
	lea		ObjectName.refreshTags(pc),a3
	CALLGT		GT_SetGadgetAttrsA
;	---- Données générales:
	bsr.w		SetObjectSize
	bsr.w		SetNbrPoints
	bsr.w		SetNbrPolygons
	bsr.w		SetNbrSurfaces
	bsr.w		RefreshSurfacesList
	bsr.w		RefreshSurface
	bsr.w		RefreshImageNames
;	---- Zee End:
	movem.l		(sp)+,d0/d1/a0-a3/a6
	clc
	rts

*********************************************************
*		Efface le nom de l'objet		*
*********************************************************
ClearObjectName
	movem.l	d0/d1/a0-a3/a6,-(sp)
	lea	Rt_LWOBFileName(pc),a0
	moveq	#108/2-1,d0
.clear	clr.w	(a0)+
	dbra	d0,.clear
	movem.l	(sp)+,d0/d1/a0-a3/a6
	clc
	rts

*********************************************************
*	Affiche un message dans le gadget "Status"	*
*IN:	a0=@message					*
*********************************************************
SetStatus
	movem.l	d0/d1/a0-a3/a6,-(sp)
	move.l	a0,Status.message
	move.l	Status.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	Status.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA
	movem.l	(sp)+,d0/d1/a0-a3/a6
	clc
	rts

*********************************************************
*	Initialise l'affichage de la taille de l'objet	*
*********************************************************
;Note:	Ne calcul pas encore la place occupée en mémoire par:
;	 -les chaines ascii des noms de types de textures (structures "surface")

SetObjectSize
	movem.l	d0-d2/a0-a3/a6,-(sp)

;	---- Calcul la taille de l'objet Geometric:
	move.l	Scene3d.Geometrics(pc),d0
	beq.w	.clr
	move.l	d0,a0

;	---- Taille de la structure Geometric:
	moveq	#Geometric_SIZE,d0	;d0=Compteur de taille

;	---- Place occupée par les points:
.points	move.l	Geo_NbrPoints(a0),d1
	beq.s	.poly
	tst.l	Geo_Points(a0)
	beq.s	.poly
	mulu.l	#12,d1		*** En fonction du type de données utilisé pour les coordonnées
	add.l	d1,d0

;	---- Place occupée par les polygones:
.poly	move.l	Geo_NbrPolygons(a0),d1
	beq.s	.surf
	move.l	Geo_Polygons(a0),d2
	beq.s	.surf
	move.l	d2,a1
	move.l	d1,d2
	lsl.l	#2,d1
	add.l	d1,d0	;Taille de la table des polygones
.vertice	move.l	(a1)+,d3
		beq.s	.nextVertice
		move.l	d3,a2
		add.l	#polygon_SIZE,d0	;Taille d'une structure "polygon"
		clr.l	d3
		move.w	poly_NbrVertices(a2),d3
		beq.s	.nextVertice
		lsl.l	#2,d3
		add.l	d3,d0	;Taille de la table des vertices
.nextVertice	subq.l	#1,d2
		bne.s	.vertice

;	---- Place occupée par les surfaces:
.surf	clr.l	d1
	move.w	Geo_NbrSurfaces(a0),d1
	beq.s	.image
	move.l	Geo_Surfaces(a0),d2
	beq.s	.image
	move.l	d2,a1
	move.w	d1,d2
	lsl.l	#2,d1
	add.l	d1,d0	;Taille de la table des surfaces
	subq.w	#1,d2
.structure	tst.l	(a1)+
		beq.s	.nextSurface
		add.l	#surf_SIZE,d0	;Taille de la structure "surface"
.nextSurface	dbra	d2,.structure

;	---- Place occupée par les images:
.image	clr.l	d1
	move.w	Geo_NbrImages(a0),d1
	beq.s	.fresh
	move.l	Geo_Images(a0),d2
	beq.s	.fresh
	move.l	d2,a1
	move.w	d1,d2
	lsl.l	#2,d1
	add.l	d1,d0	;Taille de la table des images

;	Détermine le format des données bitmap:
	lea	Scene3d(pc),a3
	move.b	scn_Depth(a3),d1
.8bits	cmp.b	#RenderDepth_8bits,d1
	bne.s	.15bits
	moveq	#1,d1
	bra.s	.structure0
.15bits	cmp.b	#RenderDepth_15bits,d1
	bne.s	.16bits
	moveq	#2,d1
	bra.s	.structure0
.16bits	cmp.b	#RenderDepth_16bits,d1
	bne.s	.32bits
	moveq	#2,d1
	bra.s	.structure0
.32bits	moveq	#4,d1

;	Taille des bitmaps:
.structure0	move.l	(a1)+,d2
		beq.s	.nextImage
		move.l	d2,a2
		move.w	id_XSize(a2),d2
		mulu.w	id_YSize(a2),d2
		mulu.l	d1,d2
		add.l	#ImageData_SIZE,d0	;Taille de la structure "ImageData"
		add.l	d2,d0			;Taille du bitmap
.nextImage	dbra	d2,.structure0

	bra.s	.fresh

;	---- Pas d'objet:
.clr	clr.l	d0

;	---- Rafraichissement affichage:
.fresh	move.l	d0,ObjectSize.number
	move.l	ObjectSize.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	ObjectSize.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA
	movem.l	(sp)+,d0-d2/a0-a3/a6
	clc
	rts
	

*********************************************************
*	Initialise l'affichage du nombre de points	*
*********************************************************
SetNbrPoints
	movem.l	d0/d1/a0-a3/a6,-(sp)

		move.l	Scene3d.Geometrics(pc),d0
		beq.s	.end
		move.l	d0,a0

	move.l	Geo_NbrPoints(a0),NumPoints_GE.number
	move.l	NumPoints_GE.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	NumPoints_GE.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA
.end	movem.l	(sp)+,d0/d1/a0-a3/a6
	clc
	rts

*********************************************************
*	Initialise l'affichage du nombre de polygones	*
*********************************************************
SetNbrPolygons
	movem.l	d0/d1/a0-a3/a6,-(sp)

		move.l	Scene3d.Geometrics(pc),d0
		beq.s	.end
		move.l	d0,a0

	move.l	Geo_NbrPolygons(a0),NumPolygons_GE.number
	move.l	NumPolygons_GE.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	NumPolygons_GE.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA
.end	movem.l	(sp)+,d0/d1/a0-a3/a6
	clc
	rts

*********************************************************
*	Initialise l'affichage du nombre de Surfaces	*
*********************************************************
SetNbrSurfaces
	movem.l	d0/d1/a0-a3/a6,-(sp)

		move.l	Scene3d.Geometrics(pc),d0
		beq.s	.end
		move.l	d0,a0

	move.w	Geo_NbrSurfaces(a0),NumSurfaces_GE.number+2
	move.l	NumSurfaces_GE.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	NumSurfaces_GE.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA
.end	movem.l	(sp)+,d0/d1/a0-a3/a6
	clc
	rts

*****************************************************************
*	Rafraichi l'affichage de la liste des noms des surfaces	*
*****************************************************************
RefreshSurfacesList
	movem.l	d0/d1/a0-a3/a6,-(sp)

		move.l	Scene3d.Geometrics(pc),d0
		beq.s	.off
		move.l	d0,a0

	tst.w	Geo_NbrSurfaces(a0)
	bne.s	.on

.off	move.l	#TRUE,SurfaceList_GE.disable
	move.l	#List.empty,SurfaceList_GE.list
	bra.s	.init
.on	move.l	#FALSE,SurfaceList_GE.disable

.init	move.l	SurfaceList_GE.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	SurfaceList_GE.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA
	movem.l	(sp)+,d0/d1/a0-a3/a6
	clc
	rts

*****************************************************************
*	Rafraichi l'affichage de la liste des noms des images	*
*****************************************************************
RefreshImageNames
	movem.l	d0/d1/a0-a3/a6,-(sp)

		move.l	Scene3d.Geometrics(pc),d0
		beq.s	.off
		move.l	d0,a0

	tst.w	Geo_NbrImages(a0)
	bne.s	.on

.off	move.l	#TRUE,ImageList_GE.disable
	move.l	#List.empty,ImageList_GE.list
	bra.s	.init
.on	move.l	#FALSE,ImageList_GE.disable

.init	move.l	ImageList_GE.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	ImageList_GE.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA
	movem.l	(sp)+,d0/d1/a0-a3/a6
	clc
	rts

*************************************************************************
*	Rafraichi l'affichage des données de la surface sélectionnée	*
*************************************************************************
RefreshSurface
	movem.l	d0-d2/a0-a4/a6,-(sp)
;	---- Lecture des données du gadget "SurfaceList":
	move.l	SurfaceList_GE.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	SurfaceList_GE.readTags(pc),a3
	CALLGT	GT_GetGadgetAttrsA
	tst.l	SurfaceList_GE.readDisable(pc)
	beq.s	.ok
	bsr.w	ResetSurface
	bra.w	.end
.ok
		move.l	Scene3d.Geometrics(pc),d0
		beq.w	.end
		move.l	d0,a4

;	---- Saisie adresse de la surface sélectionnée:
	move.l	Geo_Surfaces(a4),a0
	move.l	SurfaceList_GE.readSelected(pc),d0
	move.l	(a0,d0.l*4),a4	;a4=@Surface
;	---- Rafraichissement de la couleur:
;	Red:
	move.l	#FALSE,SurfRed.disable
	move.b	surf_Color(a4),SurfRed.level+3
	move.l	SurfRed.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	SurfRed.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA
;	Green:
	move.l	#FALSE,SurfGreen.disable
	move.b	surf_Color+1(a4),SurfGreen.level+3
	move.l	SurfGreen.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	SurfGreen.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA
;	Blue:
	move.l	#FALSE,SurfBlue.disable
	move.b	surf_Color+2(a4),SurfBlue.level+3
	move.l	SurfBlue.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	SurfBlue.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA
;	---- Rafraichissement des caractéristiques:
	move.w	surf_Flags(a4),d2
;	Luminous:
	move.l	#FALSE,Luminous.checked
	move.l	#FALSE,Luminous.disabled
	btst	#srFlagB_Luminous,d2
	beq.s	.0
	move.l	#TRUE,Luminous.checked
.0	move.l	Luminous.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	Luminous.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA
;	Outline:
	move.l	#FALSE,Outline.checked
	move.l	#FALSE,Outline.disabled
	btst	#srFlagB_Outline,d2
	beq.s	.1
	move.l	#TRUE,Outline.checked
.1	move.l	Outline.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	Outline.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA
;	Smoothing:
	move.l	#FALSE,Smoothing.checked
	move.l	#FALSE,Smoothing.disabled
	btst	#srFlagB_Smoothing,d2
	beq.s	.2
	move.l	#TRUE,Smoothing.checked
.2	move.l	Smoothing.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	Smoothing.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA
;	ColorHL:
	move.l	#FALSE,ColorHL.checked
	move.l	#FALSE,ColorHL.disabled
	btst	#srFlagB_ColorHL,d2
	beq.s	.3
	move.l	#TRUE,ColorHL.checked
.3	move.l	ColorHL.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	ColorHL.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA
;	ColorFilter:
	move.l	#FALSE,ColorFilter.checked
	move.l	#FALSE,ColorFilter.disabled
	btst	#srFlagB_ColorFilter,d2
	beq.s	.4
	move.l	#TRUE,ColorFilter.checked
.4	move.l	ColorFilter.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	ColorFilter.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA
;	OpaqueEdge:
	move.l	#FALSE,OpaqueEdge.checked
	move.l	#FALSE,OpaqueEdge.disabled
	btst	#srFlagB_OpaqueEdge,d2
	beq.s	.5
	move.l	#TRUE,OpaqueEdge.checked
.5	move.l	OpaqueEdge.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	OpaqueEdge.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA
;	TranspEdge:
	move.l	#FALSE,TranspEdge.checked
	move.l	#FALSE,TranspEdge.disabled
	btst	#srFlagB_TranspEdge,d2
	beq.s	.6
	move.l	#TRUE,TranspEdge.checked
.6	move.l	TranspEdge.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	TranspEdge.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA
;	SharpTerm:
	move.l	#FALSE,SharpTerm.checked
	move.l	#FALSE,SharpTerm.disabled
	btst	#srFlagB_SharpTerm,d2
	beq.s	.7
	move.l	#TRUE,SharpTerm.checked
.7	move.l	SharpTerm.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	SharpTerm.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA
;	DoubleSided:
	move.l	#FALSE,DoubleSided.checked
	move.l	#FALSE,DoubleSided.disabled
	btst	#srFlagB_DoubleSided,d2
	beq.s	.8
	move.l	#TRUE,DoubleSided.checked
.8	move.l	DoubleSided.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	DoubleSided.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA
;	Additive:
	move.l	#FALSE,Additive.checked
	move.l	#FALSE,Additive.disabled
	btst	#srFlagB_Additive,d2
	beq.s	.9
	move.l	#TRUE,Additive.checked
.9	move.l	Additive.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	Additive.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA

;	---- Zee End:
.end	movem.l	(sp)+,d0-d2/a0-a4/a6
	clc
	rts

*****************************************************************
*	Réinitialise l'affichage des données de la surface	*
*****************************************************************
ResetSurface
	movem.l	d0/d1/a0-a3/a6,-(sp)
;	---- Rafraichissement de la couleur:
;	Red:
	clr.l	SurfRed.level
	move.l	#TRUE,SurfRed.disable
	move.l	SurfRed.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	SurfRed.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA
;	Green:
	clr.l	SurfGreen.level
	move.l	#TRUE,SurfGreen.disable
	move.l	SurfGreen.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	SurfGreen.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA
;	Blue:
	clr.l	SurfBlue.level
	move.l	#TRUE,SurfBlue.disable
	move.l	SurfBlue.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	SurfBlue.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA
;	---- Reset des caractéristiques:
;	Luminous:
	move.l	#FALSE,Luminous.checked
	move.l	#TRUE,Luminous.disabled
	move.l	Luminous.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	Luminous.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA
;	Outline:
	move.l	#FALSE,Outline.checked
	move.l	#TRUE,Outline.disabled
	move.l	Outline.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	Outline.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA
;	Smoothing:
	move.l	#FALSE,Smoothing.checked
	move.l	#TRUE,Smoothing.disabled
	move.l	Smoothing.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	Smoothing.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA
;	ColorHL:
	move.l	#FALSE,ColorHL.checked
	move.l	#TRUE,ColorHL.disabled
	move.l	ColorHL.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	ColorHL.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA
;	ColorFilter:
	move.l	#FALSE,ColorFilter.checked
	move.l	#TRUE,ColorFilter.disabled
	move.l	ColorFilter.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	ColorFilter.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA
;	OpaqueEdge:
	move.l	#FALSE,OpaqueEdge.checked
	move.l	#TRUE,OpaqueEdge.disabled
	move.l	OpaqueEdge.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	OpaqueEdge.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA
;	TranspEdge:
	move.l	#FALSE,TranspEdge.checked
	move.l	#TRUE,TranspEdge.disabled
	move.l	TranspEdge.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	TranspEdge.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA
;	SharpTerm:
	move.l	#FALSE,SharpTerm.checked
	move.l	#TRUE,SharpTerm.disabled
	move.l	SharpTerm.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	SharpTerm.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA
;	DoubleSided:
	move.l	#FALSE,DoubleSided.checked
	move.l	#TRUE,DoubleSided.disabled
	move.l	DoubleSided.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	DoubleSided.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA
;	Additive:
	move.l	#FALSE,Additive.checked
	move.l	#TRUE,Additive.disabled
	move.l	Additive.gadget(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	lea	Additive.refreshTags(pc),a3
	CALLGT	GT_SetGadgetAttrsA
;	---- Zee End:
.end	movem.l	(sp)+,d0/d1/a0-a3/a6
	clc
	rts

*********************************************************
*	Création de la liste des noms des surfaces	*
*********************************************************
InitSurfacesList
	movem.l		d0-d2/a0-a6,-(sp)

		move.l	Scene3d.Geometrics(pc),d0
		beq.s	.end
		move.l	d0,a4


;	---- Allocation de la liste:
	move.w		Geo_NbrSurfaces(a4),d0
	beq.s		.end
	mulu.w		#LN_SIZE,d0
	add.l		#12,d0
	move.l		#MEMF_FAST!MEMF_CLEAR,d1
	CALLEXEC	AllocVec
	tst.l		d0
	beq.s		.e_Memory
	move.l		d0,SurfaceList_GE.list
;	---- Initialisation de la liste:
	move.l		SurfaceList_GE.list(pc),a2
	move.l		a2,(a2)
	addq.l		#4,(a2)
	move.l		a2,LH_TAILPRED(a2)
	lea		12(a2),a2
	move.l		Geo_Surfaces(a4),a3
	move.w		Geo_NbrSurfaces(a4),d2
	subq.w		#1,d2
.loop	move.l		(a3)+,a5
	move.l		surf_Name(a5),LN_NAME(a2)
	move.l		SurfaceList_GE.list(pc),a0
	move.l		a2,a1
	CALLEXEC	AddTail
	lea		LN_SIZE(a2),a2
	dbra		d2,.loop
;	---- Zee End
.end	movem.l		(sp)+,d0-d2/a0-a6
	clc
	rts

;	******** Erreurs ********

.e_Memory
	movem.l		(sp)+,d0-d2/a0-a6
	moveq		#Not_enough_memory,d0
	stc
	rts

*********************************************************
*	Destruction de la liste des noms des surfaces	*
*********************************************************
RemoveSurfacesList
	movem.l		d0/d1/a0/a1/a6,-(sp)
	move.l		SurfaceList_GE.list(pc),d0
	beq.s		.end
	clr.l		SurfaceList_GE.list
	move.l		d0,a1
	CALLEXEC	FreeVec
.end	movem.l		(sp)+,d0/d1/a0/a1/a6
	clc
	rts


*********************************************************
*	Création de la liste des noms des images	*
*********************************************************
InitImageList
	movem.l		d0-d2/a0-a6,-(sp)

		move.l	Scene3d.Geometrics(pc),d0
		beq.s	.end
		move.l	d0,a4

;	---- Allocation de la liste:
	move.w		Geo_NbrImages(a4),d0
	beq.s		.end
	mulu.w		#LN_SIZE,d0
	add.l		#12,d0
	move.l		#MEMF_FAST!MEMF_CLEAR,d1
	CALLEXEC	AllocVec
	tst.l		d0
	beq.s		.e_Memory
	move.l		d0,ImageList_GE.list
;	---- Initialisation de la liste:
	move.l		ImageList_GE.list(pc),a2
	move.l		a2,(a2)
	addq.l		#4,(a2)
	move.l		a2,LH_TAILPRED(a2)
	lea		12(a2),a2
	move.l		Geo_Images(a4),a3
	move.w		Geo_NbrImages(a4),d2
	subq.w		#1,d2
.loop	move.l		(a3)+,a5
	move.l		id_Name(a5),LN_NAME(a2)
	move.l		ImageList_GE.list(pc),a0
	move.l		a2,a1
	CALLEXEC	AddTail
	lea		LN_SIZE(a2),a2
	dbra		d2,.loop
;	---- Zee End
.end	movem.l		(sp)+,d0-d2/a0-a6
	clc
	rts

;	******** Erreurs ********

.e_Memory
	movem.l		(sp)+,d0-d2/a0-a6
	moveq		#Not_enough_memory,d0
	stc
	rts

*********************************************************
*	Destruction de la liste des noms des images	*
*********************************************************
RemoveImageList
	movem.l		d0/d1/a0/a1/a6,-(sp)
	move.l		ImageList_GE.list(pc),d0
	beq.s		.end
	clr.l		ImageList_GE.list
	move.l		d0,a1
	CALLEXEC	FreeVec
.end	movem.l		(sp)+,d0/d1/a0/a1/a6
	clc
	rts

*************************************************
*		DONNEES INTERFACE		*
*************************************************

VisualInfo	dc.l	0	;Utilisé pour la création des gadgets
LastGadget	dc.l	0	;Dernier gadget créé (sert pour la création d'un nouveau gadget)

******** Fenetre principale ********
MainWindow	dc.l	0

MainWindow.tags
	dc.l	WA_Left,0
	dc.l	WA_Top,11
	dc.l	WA_Width,640
	dc.l	WA_Height,480
	dc.l	WA_IDCMP,IDCMP_CLOSEWINDOW!IDCMP_GADGETUP!IDCMP_GADGETDOWN!IDCMP_RAWKEY
	dc.l	WA_Title,MainWindow.title
	dc.l	WA_MinWidth,640
	dc.l	WA_MinHeight,480
	dc.l	WA_MaxWidth,640
	dc.l	WA_MaxHeight,480
	dc.l	WA_SizeGadget,FALSE
	dc.l	WA_DragBar,TRUE
	dc.l	WA_DepthGadget,TRUE
	dc.l	WA_CloseGadget,TRUE
	dc.l	WA_Backdrop,FALSE
	dc.l	WA_ReportMouse,FALSE
	dc.l	WA_Borderless,FALSE
	dc.l	WA_Activate,TRUE
	dc.l	WA_Gadgets
MainWindow.GList
	dc.l	0
	dc.l	TAG_DONE



;---- Données de gestion des exceptions déclenchées par la tache LWOBViewer.
Main.Task		dc.l	0	;Pointeur sur la tache principale.
Main.LWOBVErrorSig	dc.l	0	;Numéro du signal d'exception d'erreur LWOBViewer.
Main.ExceptionDatas	dc.l	0	;Sert à stocker les données nécessaire au traitement
;					 des exceptions.


;************************** Scène provisoire *********************

Scene3d
	dc.w	1	;scn_NbrGeometrics	;Nombre d'objets géometriques dans la scène
	dc.w	0	;scn_NbrCameras		;Nombre de cameras
	dc.w	0	;scn_NbrLights		;Nombre de sources lumineuses
	dc.w	1	;scn_NbrMotions

	dc.l	0	;scn_NbrPolygons	;Nombre total de polygones dans la scène
	dc.l	0	;scn_NbrSurfaces	;Nombre de surfaces
	dc.l	0	;scn_NbrImages		;Nombre total d'images
	dc.l	0	;scn_NbrPoints		;Nombre total de points dans la scène
	dc.l	Scene3d.Geometrics	;scn_Geometrics		;Table des objets géometriques
	dc.l	0	;scn_Cameras		;Table des caméras
	dc.l	0	;scn_Lights		;Table des sources lumineuses
	dc.l	0	;scn_Images		;Table des images
	dc.l	Scene3d.Motions		;scn_Motions
	dc.l	0	;scn_Polygons		;Table des polygones
	dc.l	0	;scn_Surfaces		;Table des surfaces
	dc.l	0	;scn_Coords		;Table des points
	dc.l	0	;scn_FirstPolygon	;Pointeur pour le tri
	dc.l	0	;scn_Colors		;Palette (Mode 8bits uniquement)
	dc.b	RenderDepth_32bits	;scn_Depth		;Profondeur d'écran
	dc.b	RenderMaths_FPU	;scn_MathsMode	;Méthode de calculs (virgule flottante ou fixe)

Scene3d.Geometrics
	dc.l	0

Geometric.motions
	dc.l	ViewerMotion

Scene3d.Motions
	dc.l	ViewerMotion

ViewerMotion
.MotionID	dc.w	MotionID_absoluteRotation

.NbrObjects	dc.w	1
.Objects	dc.l	Scene3d.Geometrics
.DeltaX		dc.s	0
.DeltaY		dc.s	0
.DeltaZ		dc.s	0


******************************************************************************************
******************************************************************************************
**				Gestion fichiers					**
******************************************************************************************
******************************************************************************************

*************************************************
*	Création des requesters fichier		*
*************************************************
InitFileRequest
	movem.l	d0/d1/a0/a1/a6,-(sp)
;	---- Alloue le requester des fichiers LWOB:
	sub.l	a0,a0
	moveq	#RT_FILEREQ,d0
	CALLRT	rtAllocRequestA
	tst.l	d0
	beq.w	.e_FileReq
	move.l	d0,Rt_ReqLWOB
	movem.l	(sp)+,d0/d1/a0/a1/a6
	clc
	rts

;	******** ERREURS ********
.e_FileReq
	movem.l	(sp)+,d0/d1/a0/a1/a6
	moveq	#Cant_create_fileRequest,d0
	stc
	rts

*************************************************
*	Requester fichier LWOB			*
*************************************************
FileRequest_LWOB
	movem.l	d0/d1/a0-a3/a6,-(sp)
;	---- Affiche le requester LWOB:
	move.l	Rt_ReqLWOB(pc),a1
	lea	Rt_LWOBFileName(pc),a2
	lea	Rt_WindowTitle(pc),a3
	lea	Rt_TagList(pc),a0
	CALLRT	rtFileRequestA
	tst.l	d0
	beq.s	.e_cancel
;	---- Création du nom de fichier complet:
	lea	LWOBCompleteName(pc),a0
	lea	Rt_LWOBFileName(pc),a1
	move.l	Rt_ReqLWOB(pc),a2
	move.l	rtfi_Dir(a2),a2
	tst.b	(a2)
	beq.s	.copyFileName
.copyDir
	move.b	(a2)+,(a0)+
	tst.b	(a2)
	bne.s	.copyDir
	cmp.b	#":",-1(a0)
	beq.s	.copyFileName
	move.b	#"/",(a0)+
.copyFileName
	move.b	(a1)+,(a0)+
	tst.b	(a1)
	bne.s	.copyFileName
	clr.b	(a0)
;	---- Zee End:
	movem.l	(sp)+,d0/d1/a0-a3/a6
	clc
	rts

;	---- Operation est annulée:
.e_cancel
	movem.l	(sp)+,d0/d1/a0-a3/a6
	moveq	#Operation_canceled,d0
	stc
	rts

*************************************************
*	Destruction des requester fichier	*
*************************************************

RemoveFileRequest
	movem.l	d0/d1/a0/a1/a6,-(sp)
;	---- Suppression du requester LWOB:
	move.l	Rt_ReqLWOB(pc),a1
	CALLRT	rtFreeRequest
	movem.l	(sp)+,d0/d1/a0/a1/a6
	clc
	rts

*************************************************
*	DONNEES GESTION FICHIERS		*
*************************************************
LWOBCompleteName	dcb.b	512,0	;Nom du fichier LWOB avec le chemin.
LightWaveObject		dc.l	0	;Adresse des données de l'objet

Rt_ReqLWOB		dc.l	0	;Structure FileRequest pour selection des objets LWOB
Rt_LWOBFileName		dcb.b	108,0	;Nom de fichier LWOB

Rt_WindowTitle	STRING	"Load LightWave object"

Rt_TagList	dc.l	RT_PubScrName,Rt_WbScreen
		dc.l	RT_LeftOffset,100
		dc.l	RT_TopOffset,100
		dc.l	RT_ScreenToFront,TRUE
		dc.l	RTFI_Flags,0
		dc.l	RTFI_Height,400
		dc.l	TAG_DONE

Rt_WbScreen	STRING	"Workbench"


***********************************************************************************
***********************************************************************************
***********************************************************************************
***										***
***			DEFINITION DE L'INTERFACE				***
***										***
***********************************************************************************
***********************************************************************************
***********************************************************************************

			include	Interface.i
