;APS00003FBB000000000000000000000000000000000000000000000000000000000000000000000000
*****************************************
*					*
*	Editeur Simulateur d'espace	*
*	Revision: 15/5/2001		*
*					*
*****************************************

*****************************************************************************************
*				Travail en cours et travail à prévoir			*
*				(Classement dans l'ordre des priorités)			*
*****************************************************************************************

;	-Extension du logiciel à l'édition de scènes:

;			-Adaptation du gestionnaire de programmation orientée objet
;			 développé pour OzOS.

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

	incdir	WorkCode:backup/SubRoutines/
	include	System.s
	include	Files.s
	include	Structures.i
  
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

	bra.w		MainLoop

;	---- Panneau "GEOMETRIC EDITOR":

GeometricEditor_GID

.SurfaceList
	cmp.w		#SurfaceList_GE_ID,d0
	bne.s		.DisplayGeoMode
	bra.w		MainLoop

.DisplayGeoMode
	cmp.w		#DisplayGeo_ID,d0
	bne.w		MainLoop
	bra.w		MainLoop


;	**** Données locales:
MainMessage	dc.l	0


*********************** Procédures finales ******************************


;	---- Cellule de fermeture activée:
CloseGadget
	bsr.w		RemoveInterface
	bsr.w		RemoveFileRequest

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
