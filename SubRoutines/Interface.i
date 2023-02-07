;APS0000DADE000060C00000000000000000000000000000000000000000000000000000000000000000
*********************************************************
*							*
*		Définition de l'interface		*
*							*
*		Révision: 15/5/2001			*
*							*
*********************************************************

*****************************************************************************************
*											*
*					MACROS						*
*											*
*****************************************************************************************

;---- Création d'identité:

PANELFUNC	macro	;\1=Nom du gadget
\1_ID	equ	gadget_ID
gadget_ID	set	gadget_ID+1

		endm

gadget_ID	set	1


;---- Définition de la structure NewGadget:

DefineGadget	macro	;\1=Nom du gadget, \2=position du texte
;			;\3=LeftEdge, \4=TopEdge, \5=Width, \6=Height

\1_LeftEdge	equ	\3
\1_TopEdge	equ	\4
\1_Width	equ	\5
\1_Height	equ	\6

\1.gadget	dc.l	0
\1.ng
.LeftEdge	dc.w	\1_LeftEdge
.TopEdge	dc.w	\1_TopEdge		; gadget position
.Width		dc.w	\1_Width
.Height		dc.w	\1_Height		;  gadget size
.GadgetText	dc.l	\1.text	; gadget label
.TextAttr	dc.l	0		; desired font for gadget label
.GadgetID	dc.w	\1_ID	; gadget ID
.Flags		dc.l	\2
\1.vi		dc.l	0		; Set to retval of GetVisualInfo()
.UserData	dc.l	0

		endm


;---- Création d'un gadget:

CreateGadget	macro	;\1=Gadget_KIND, \2=nom du gadget

	move.l	#\1,d0
	move.l	LastGadget(pc),a0
	lea	\2.ng(pc),a1
	lea	\2.tags(pc),a2
	move.l	VisualInfo(pc),\2.vi
	CALLGT	CreateGadgetA
	tst.l	d0
	beq.w	e_CreateGadget
	move.l	d0,\2.gadget
	move.l	d0,LastGadget
		endm

*****************************************************************************************
*											*
*			DEFINITION DES IDENTIFICATEURS DE GADGETS			*
*											*
*****************************************************************************************

*************************************************
*	Panneau principal (Toujours actif)	*
*************************************************

	PANELFUNC	PanelList	;Liste des panneaux
	PANELFUNC	Status		;Affichage des messages d'erreur ou autres

*************************************************
*	Panneau "Scene editor"			*
*************************************************

;Note: Les surfaces ne sont pas sélectionnables à
;	partir du panneau de l'éditeur de scène.

;Fonctions:
	PANELFUNC	LoadScene	;Chargement d'une scène
	PANELFUNC	SaveScene	;Sauvegarde de la scène
	PANELFUNC	LoadObject	;Chargement d'un nouvel objet
	PANELFUNC	RemoveGeo	;Suppression d'un objet géométrique de la scène
	PANELFUNC	RemoveCam	;Suppression d'un objet géométrique de la scène
	PANELFUNC	RemoveLight	;Suppression d'une camera de la scène
	PANELFUNC	RemoveMotion	;Suppression d'un mouvement de la scène
	PANELFUNC	LoadPalette	;Chargement d'un palette (mode de rendu 8bits uniquement)
;Informations:
	PANELFUNC	SceneName	;Nom de la scène
	PANELFUNC	SceneSize	;Place occupée en mémoire par la scène
	PANELFUNC	NumGeo		;Nombre d'objets géométriques
	PANELFUNC	NumCameras	;Nombre de caméras
	PANELFUNC	NumLights	;Nombre de sources lumineuses
	PANELFUNC	NumMotions	;Nombre de mouvements
	PANELFUNC	NumPoints_SE	;Nombre total de points
	PANELFUNC	NumPolygons_SE	;Nombre total de polygones
	PANELFUNC	NumSurfaces_SE	;Nombre total de surfaces
	PANELFUNC	NumImages_SE	;Nombre total d'images
;Listes:
	PANELFUNC	GeometricList_SE	;Liste des objets géometriques
	PANELFUNC	CameraList_SE	;Liste des cameras
	PANELFUNC	LightList_SE	;Liste des sources lumineuses
	PANELFUNC	MotionList_SE	;Liste des mouvements

;Fonctions du viewer de scenes:
	PANELFUNC	DisplayScene	;Affichage de la scène (OFF,Friendly,Internal)
	PANELFUNC	RenderDepth	;Profondeur de rendu (8bits,15bits,16bits,32bits)

**** On verra plus tard pour la gestion du viewer de scènes ****
;	PANELFUNC	PlayScene	;Ecoulement du temps ON/OFF

*************************************************
*	Panneau "Geometric editor"		*
*************************************************

;Fonctions:
	PANELFUNC	ChangeGeo	;Remplacement par un autre objet
	PANELFUNC	SaveGeo		;Sauvegarde objet
	PANELFUNC	RemoveSurface	;Suppression d'une surface
;Informations:
	PANELFUNC	ObjectName	;Nom de l'objet
	PANELFUNC	ObjectSize	;Place occupé par l'objet en mémoire
	PANELFUNC	NumPoints_GE	;Nombre de points
	PANELFUNC	NumPolygons_GE	;Nombre de polygones
	PANELFUNC	NumSurfaces_GE	;Nombre de surfaces
	PANELFUNC	NumImages_GE	;Nombre d'images
;Listes:
	PANELFUNC	GeometricList_GE	;Liste des objets géométriques
	PANELFUNC	SurfaceList_GE	;Liste des surfaces
	PANELFUNC	ImageList_GE	;Liste des images
;Fonctions du viewer d'objet:
	PANELFUNC	DisplayGeo	;Affichage individuel (OFF,Friendly,Internal)
	PANELFUNC	AlphaX		;Réglage angle de rotation axe X
	PANELFUNC	AlphaY		;Réglage angle de rotation axe Y
	PANELFUNC	AlphaZ		;Réglage angle de rotation axe Z
	PANELFUNC	AutoRotation	;Rotation automatique ON/OFF

*************************************************
*	Panneau "Camera editor"			*
*************************************************
;Fonctions:
	PANELFUNC	ChangeCam	;Remplacement par une autre caméra
	PANELFUNC	SaveCam		;Sauvegarde caméra
	PANELFUNC	XRadius		;Réglage angle horizontal
	PANELFUNC	YRadius		;Réglage angle vertical
;Informations:
	PANELFUNC	CameraName	;Nom de la caméra
;Listes:
	PANELFUNC	CameraList_CE	;Liste des caméras

*************************************************
*	Panneau "Light editor"			*
*************************************************
;Fonctions:
	PANELFUNC	ChangeLight	;Remplacement par une autre source lumineuse
	PANELFUNC	SaveLight	;Sauvegarde source lumineuse
	PANELFUNC	LightRadius	;Réglage de l'angle du faisceau
	PANELFUNC	LightColor	;Texte "Light color"
	PANELFUNC	LightRed	;Réglage composante rouge
	PANELFUNC	LightGreen	;Réglage composante verte
	PANELFUNC	LightBlue	;Réglage composante bleue
	PANELFUNC	Intensity	;Réglage de l'intensité lumineuse
;Informations:
	PANELFUNC	LightName	;Nom de la source lumineuse
;Listes:
	PANELFUNC	LightList_LE	;Liste des sources lumineuses

*************************************************
*	Panneau "Motion editor"
*************************************************
;Fonctions:
	PANELFUNC	ChangeMotion	;Remplacement par un autre mouvement
	PANELFUNC	SaveMotion	;Sauvegarde mouvement
;Informations:
	PANELFUNC	MotionName	;Nom du mouvement
	PANELFUNC	MotionType	;Nature du mouvement
;Listes:
	PANELFUNC	MotionTypeList	;Liste des types de mouvements
	PANELFUNC	MotionList_ME	;Liste des mouvements

*************************************************
*	Panneau "Surface editor"		*
*************************************************

;Fonction:
	PANELFUNC	ChangeSurf	;Remplacement parune autre surface
	PANELFUNC	SaveSurf	;Sauvegarde de la surface
	PANELFUNC	SurfColor	;Texte "Surface color"
	PANELFUNC	SurfRed		;Réglage composante rouge
	PANELFUNC	SurfGreen	;Réglage composante verte
	PANELFUNC	SurfBlue	;Réglage composante bleue
	PANELFUNC	Luminous	;Flag
	PANELFUNC	Outline		;Flag
	PANELFUNC	Smoothing	;Flag
	PANELFUNC	ColorHL		;Flag
	PANELFUNC	ColorFilter	;Flag
	PANELFUNC	OpaqueEdge	;Flag
	PANELFUNC	TranspEdge	;Flag
	PANELFUNC	SharpTerm	;Flag
	PANELFUNC	DoubleSided	;Flag
	PANELFUNC	Additive	;Flag
;Informations:
	PANELFUNC	SurfName	;Nom de la surface sélectionnée
	PANELFUNC	SurfSize	;Place occupé en mémoire par la surface

;Listes:
	PANELFUNC	SurfaceList_SU	;Liste des surfaces

*************************************************
*	Panneau "Image editor"			*
*************************************************

;Fonctions
	PANELFUNC	ImageWidth	;Taille de l'image sélectionnée
	PANELFUNC	ImageHeight
;Liste:
	PANELFUNC	ImageList_IE	;Liste des images


*****************************************************************************************
*											*
*			DEFINITIONS DES CONSTANTES					*
*											*
*****************************************************************************************

;---- Identité des panneaux (correspond au numéro dans la liste des panneaux du
;			     gadget "PanelList"):

	PanelID_SE=0	;Scene Editor
	PanelID_GE=1	;Geometric Editor
	PanelID_CE=2	;Camera Editor
	PanelID_LE=3	;Light Editor
	PanelID_ME=4	;Motion Editor
	PanelID_SU=5	;Surface Editor
	PanelID_TE=6	;Texture Editor
	PanelID_IE=7	;Image Editor


;---- Modes d'affichage (Utilisés par les gadgets "DisplayXXX"):

	DispMode_NoDisplay=0
	DispMode_Friendly=1
	DispMode_Internal=2

;---- Modes de rendus (Gadget "RenderDepth"):

	UserRDepth_8bits=RenderDepth_8bits-1
	UserRDepth_15bits=RenderDepth_15bits-1
	UserRDepth_16bits=RenderDepth_16bits-1
	UserRDepth_32bits=RenderDepth_32bits-1


*****************************************************************************************
*											*
*				APPARENCE DES GADGETS					*
*											*
*****************************************************************************************


;---- Panneau principal:
	DefineGadget	PanelList,PLACETEXT_ABOVE,4,13,8*20,8*10
	DefineGadget	Status,PLACETEXT_LEFT,70+PanelList_Width,13,566-PanelList_Width,16

;---- Panneau "SCENE EDITOR":
;	Listes:
	DefineGadget	GeometricList_SE,PLACETEXT_ABOVE,4,13+PanelList_Height+8*2,PanelList_Width-2,8*10
	DefineGadget	CameraList_SE,PLACETEXT_ABOVE,GeometricList_SE_LeftEdge+GeometricList_SE_Width,GeometricList_SE_TopEdge,GeometricList_SE_Width,GeometricList_SE_Height
	DefineGadget	LightList_SE,PLACETEXT_ABOVE,CameraList_SE_LeftEdge+CameraList_SE_Width,CameraList_SE_TopEdge,GeometricList_SE_Width,GeometricList_SE_Height
	DefineGadget	MotionList_SE,PLACETEXT_ABOVE,LightList_SE_LeftEdge+LightList_SE_Width,LightList_SE_TopEdge,GeometricList_SE_Width,GeometricList_SE_Height

;	Fonctions:
	DefineGadget	LoadScene,PLACETEXT_IN,4+8*20,13+16*2,118,16
	DefineGadget	SaveScene,PLACETEXT_IN,LoadScene_LeftEdge+LoadScene_Width,LoadScene_TopEdge,LoadScene_Width,LoadScene_Height
	DefineGadget	LoadObject,PLACETEXT_IN,SaveScene_LeftEdge+SaveScene_Width,LoadScene_TopEdge,LoadScene_Width,LoadScene_Height

	DefineGadget	RemoveGeo,PLACETEXT_IN,GeometricList_SE_LeftEdge,GeometricList_SE_TopEdge+GeometricList_SE_Height-4,GeometricList_SE_Width,16
	DefineGadget	RemoveCam,PLACETEXT_IN,CameraList_SE_LeftEdge,CameraList_SE_TopEdge+CameraList_SE_Height-4,CameraList_SE_Width,16
	DefineGadget	RemoveLight,PLACETEXT_IN,LightList_SE_LeftEdge,LightList_SE_TopEdge+LightList_SE_Height-4,LightList_SE_Width,16
	DefineGadget	RemoveMotion,PLACETEXT_IN,MotionList_SE_LeftEdge,MotionList_SE_TopEdge+MotionList_SE_Height-4,MotionList_SE_Width,16

	DefineGadget	LoadPalette,PLACETEXT_IN,LoadObject_LeftEdge+LoadObject_Width,LoadScene_TopEdge,LoadScene_Width,LoadScene_Height
;	Informations:
	DefineGadget	SceneName,PLACETEXT_LEFT,LoadScene_LeftEdge+16*6+4,LoadScene_TopEdge+LoadScene_Height,25*8,LoadScene_Height
	DefineGadget	SceneSize,PLACETEXT_LEFT,SceneName_LeftEdge+SceneName_Width+13*8+4,SceneName_TopEdge,8*8,SceneName_Height

	DefineGadget	NumGeo,PLACETEXT_LEFT,4+172,GeometricList_SE_TopEdge+GeometricList_SE_Height+8*5,SceneSize_Width,SceneSize_Height
	DefineGadget	NumCameras,PLACETEXT_LEFT,NumGeo_LeftEdge,NumGeo_TopEdge+NumGeo_Height,NumGeo_Width,NumGeo_Height
	DefineGadget	NumLights,PLACETEXT_LEFT,NumGeo_LeftEdge,NumCameras_TopEdge+NumCameras_Height,NumGeo_Width,NumGeo_Height
	DefineGadget	NumMotions,PLACETEXT_LEFT,NumGeo_LeftEdge,NumLights_TopEdge+NumLights_Height,NumGeo_Width,NumGeo_Height
	DefineGadget	NumPoints_SE,PLACETEXT_LEFT,NumGeo_LeftEdge,NumMotions_TopEdge+NumMotions_Height,NumGeo_Width,NumGeo_Height
	DefineGadget	NumPolygons_SE,PLACETEXT_LEFT,NumGeo_LeftEdge,NumPoints_SE_TopEdge+NumPoints_SE_Height,NumGeo_Width,NumGeo_Height
	DefineGadget	NumSurfaces_SE,PLACETEXT_LEFT,NumGeo_LeftEdge,NumPolygons_SE_TopEdge+NumPolygons_SE_Height,NumGeo_Width,NumGeo_Height
	DefineGadget	NumImages_SE,PLACETEXT_LEFT,NumGeo_LeftEdge,NumSurfaces_SE_TopEdge+NumSurfaces_SE_Height,NumGeo_Width,NumGeo_Height

;	Viewer de scène:
	DefineGadget	DisplayScene,PLACETEXT_LEFT,130,NumImages_SE_TopEdge+8*8,14*8,16
	DefineGadget	RenderDepth,PLACETEXT_LEFT,DisplayScene_LeftEdge,DisplayScene_TopEdge+16,DisplayScene_Width,16

;---- Panneau "GEOMETRIC EDITOR":

;	Listes:
	DefineGadget	GeometricList_GE,PLACETEXT_ABOVE,4,13+PanelList_Height+8*2,(PanelList_Width*4)/3-2,8*10
	DefineGadget	SurfaceList_GE,PLACETEXT_ABOVE,GeometricList_GE_LeftEdge+GeometricList_GE_Width,GeometricList_GE_TopEdge,GeometricList_GE_Width,GeometricList_GE_Height
	DefineGadget	ImageList_GE,PLACETEXT_ABOVE,SurfaceList_GE_LeftEdge+SurfaceList_GE_Width,SurfaceList_GE_TopEdge,SurfaceList_GE_Width,SurfaceList_GE_Height

;	Fonctions:
	DefineGadget	ChangeGeo,PLACETEXT_IN,LoadScene_LeftEdge,LoadScene_TopEdge,15*8,16
	DefineGadget	SaveGeo,PLACETEXT_IN,ChangeGeo_LeftEdge+ChangeGeo_Width,ChangeGeo_TopEdge,13*8,16

	DefineGadget	RemoveSurface,PLACETEXT_IN,SurfaceList_GE_LeftEdge,SurfaceList_GE_TopEdge+SurfaceList_GE_Height-4,SurfaceList_GE_Width,16

;	Informations:
	DefineGadget	ObjectName,PLACETEXT_LEFT,SceneName_LeftEdge+8,SceneName_TopEdge,SceneName_Width-8,SceneName_Height
	DefineGadget	ObjectSize,PLACETEXT_LEFT,SceneSize_LeftEdge,SceneSize_TopEdge,SceneSize_Width,SceneSize_Height

	DefineGadget	NumPoints_GE,PLACETEXT_LEFT,DisplayScene_LeftEdge,NumGeo_TopEdge,80,16
	DefineGadget	NumPolygons_GE,PLACETEXT_LEFT,NumPoints_GE_LeftEdge,NumPoints_GE_TopEdge+NumPoints_GE_Height,NumPoints_GE_Width,NumPoints_GE_Height
	DefineGadget	NumSurfaces_GE,PLACETEXT_LEFT,NumPolygons_GE_LeftEdge,NumPolygons_GE_TopEdge+NumPolygons_GE_Height,NumPolygons_GE_Width,NumPolygons_GE_Height
	DefineGadget	NumImages_GE,PLACETEXT_LEFT,NumSurfaces_GE_LeftEdge,NumSurfaces_GE_TopEdge+NumSurfaces_GE_Height,NumSurfaces_GE_Width,NumSurfaces_GE_Height


;	Viewer d'objet:
	DefineGadget	DisplayGeo,PLACETEXT_LEFT,DisplayScene_LeftEdge,DisplayScene_TopEdge,DisplayScene_Width,16
	DefineGadget	AlphaX,PLACETEXT_LEFT,DisplayGeo_LeftEdge,DisplayGeo_TopEdge+DisplayGeo_Height,360,DisplayGeo_Height
	DefineGadget	AlphaY,PLACETEXT_LEFT,AlphaX_LeftEdge,AlphaX_TopEdge+AlphaX_Height,AlphaX_Width,AlphaX_Height
	DefineGadget	AlphaZ,PLACETEXT_LEFT,AlphaY_LeftEdge,AlphaY_TopEdge+AlphaY_Height,AlphaY_Width,AlphaY_Height
	DefineGadget	AutoRotation,PLACETEXT_LEFT,AlphaX_LeftEdge+AlphaX_Width-22,DisplayGeo_TopEdge,22,16

;---- Panneau "CAMERA EDITOR":

;	Liste:
	DefineGadget	CameraList_CE,PLACETEXT_ABOVE,GeometricList_GE_LeftEdge,GeometricList_GE_TopEdge,GeometricList_GE_Width,GeometricList_GE_Height

;	Fonctions:
	DefineGadget	ChangeCam,PLACETEXT_IN,ChangeGeo_LeftEdge,ChangeGeo_TopEdge,15*8,16
	DefineGadget	SaveCam,PLACETEXT_IN,ChangeCam_LeftEdge+ChangeCam_Width,ChangeCam_TopEdge,13*8,16

	DefineGadget	XRadius,PLACETEXT_LEFT,CameraList_CE_LeftEdge+CameraList_CE_Width+11*8,CameraList_CE_TopEdge+8*2,90,16
	DefineGadget	YRadius,PLACETEXT_LEFT,XRadius_LeftEdge,XRadius_TopEdge+XRadius_Height,XRadius_Width,XRadius_Height

;	Informations:
	DefineGadget	CameraName,PLACETEXT_LEFT,ObjectName_LeftEdge,ObjectName_TopEdge,ObjectName_Width,ObjectName_Height


;---- Panneau "LIGHT EDITOR":

;	Liste:
	DefineGadget	LightList_LE,PLACETEXT_ABOVE,GeometricList_GE_LeftEdge,GeometricList_GE_TopEdge,GeometricList_GE_Width,GeometricList_GE_Height

;	Fonctions:
	DefineGadget	ChangeLight,PLACETEXT_IN,ChangeGeo_LeftEdge,ChangeGeo_TopEdge,14*8,16
	DefineGadget	SaveLight,PLACETEXT_IN,ChangeLight_LeftEdge+ChangeLight_Width,ChangeLight_TopEdge,12*8,16

	DefineGadget	LightColor,PLACETEXT_IN,LightList_LE_LeftEdge+LightList_LE_Width+8*4,LightList_LE_TopEdge,8*8,16
	DefineGadget	LightRed,PLACETEXT_LEFT,LightColor_LeftEdge,LightColor_TopEdge+LightColor_Height,256,16
	DefineGadget	LightGreen,PLACETEXT_LEFT,LightColor_LeftEdge,LightRed_TopEdge+LightRed_Height,LightRed_Width,LightRed_Height
	DefineGadget	LightBlue,PLACETEXT_LEFT,LightColor_LeftEdge,LightGreen_TopEdge+LightGreen_Height,LightRed_Width,LightRed_Height

	DefineGadget	LightRadius,PLACETEXT_LEFT,LightColor_LeftEdge,LightList_LE_TopEdge+LightList_LE_Height+8*2,180,16
	DefineGadget	Intensity,PLACETEXT_LEFT,LightRadius_LeftEdge,LightRadius_TopEdge+LightRadius_Height,100,LightRadius_Height

;	Information:
	DefineGadget	LightName,PLACETEXT_LEFT,ObjectName_LeftEdge,ObjectName_TopEdge,ObjectName_Width-8,ObjectName_Height


;---- Panneau "MOTION EDITOR":

;	Liste:
	DefineGadget	MotionList_ME,PLACETEXT_ABOVE,GeometricList_GE_LeftEdge,GeometricList_GE_TopEdge,GeometricList_GE_Width,GeometricList_GE_Height
	DefineGadget	MotionTypeList,PLACETEXT_ABOVE,MotionList_ME_LeftEdge,MotionList_ME_TopEdge+MotionList_ME_Height+8*3,MotionList_ME_Width,8*8

;	Fonctions:
	DefineGadget	ChangeMotion,PLACETEXT_IN,ChangeGeo_LeftEdge,ChangeGeo_TopEdge,15*8,16
	DefineGadget	SaveMotion,PLACETEXT_IN,ChangeMotion_LeftEdge+ChangeMotion_Width,ChangeMotion_TopEdge,13*8,16

;	Informations:
	DefineGadget	MotionName,PLACETEXT_LEFT,ObjectName_LeftEdge,ObjectName_TopEdge,ObjectName_Width,ObjectName_Height
	DefineGadget	MotionType,PLACETEXT_ABOVE,MotionTypeList_LeftEdge,MotionTypeList_TopEdge+MotionTypeList_Height+8*2,MotionTypeList_Width,MotionName_Height

;---- Panneau "SURFACE EDITOR":

;	Liste:
	DefineGadget	SurfaceList_SU,PLACETEXT_ABOVE,GeometricList_GE_LeftEdge,GeometricList_GE_TopEdge,GeometricList_GE_Width,GeometricList_GE_Height

;	Fonctions:
	DefineGadget	ChangeSurf,PLACETEXT_IN,ChangeGeo_LeftEdge,ChangeGeo_TopEdge,16*8,16
	DefineGadget	SaveSurf,PLACETEXT_IN,ChangeSurf_LeftEdge+ChangeSurf_Width,ChangeSurf_TopEdge,14*8,16

	DefineGadget	Luminous,PLACETEXT_RIGHT,4,SurfaceList_SU_TopEdge+SurfaceList_SU_Height+8*2,8,11
	DefineGadget	Outline,PLACETEXT_RIGHT,Luminous_LeftEdge,Luminous_TopEdge+Luminous_Height,Luminous_Width,Luminous_Height
	DefineGadget	Smoothing,PLACETEXT_RIGHT,Luminous_LeftEdge,Outline_TopEdge+Luminous_Height,Luminous_Width,Luminous_Height
	DefineGadget	ColorHL,PLACETEXT_RIGHT,Luminous_LeftEdge,Smoothing_TopEdge+Luminous_Height,Luminous_Width,Luminous_Height
	DefineGadget	ColorFilter,PLACETEXT_RIGHT,Luminous_LeftEdge,ColorHL_TopEdge+Luminous_Height,Luminous_Width,Luminous_Height
	DefineGadget	OpaqueEdge,PLACETEXT_RIGHT,Luminous_LeftEdge,ColorFilter_TopEdge+Luminous_Height,Luminous_Width,Luminous_Height
	DefineGadget	TranspEdge,PLACETEXT_RIGHT,Luminous_LeftEdge,OpaqueEdge_TopEdge+Luminous_Height,Luminous_Width,Luminous_Height
	DefineGadget	SharpTerm,PLACETEXT_RIGHT,Luminous_LeftEdge,TranspEdge_TopEdge+Luminous_Height,Luminous_Width,Luminous_Height
	DefineGadget	DoubleSided,PLACETEXT_RIGHT,Luminous_LeftEdge,SharpTerm_TopEdge+Luminous_Height,Luminous_Width,Luminous_Height
	DefineGadget	Additive,PLACETEXT_RIGHT,Luminous_LeftEdge,DoubleSided_TopEdge+Luminous_Height,Luminous_Width,Luminous_Height

	DefineGadget	SurfColor,PLACETEXT_IN,SurfaceList_SU_LeftEdge+SurfaceList_SU_Width+8*4,SurfaceList_SU_TopEdge,8*8,16
	DefineGadget	SurfRed,PLACETEXT_LEFT,SurfColor_LeftEdge,SurfColor_TopEdge+SurfColor_Height,256,16
	DefineGadget	SurfGreen,PLACETEXT_LEFT,SurfColor_LeftEdge,SurfRed_TopEdge+SurfRed_Height,SurfRed_Width,SurfRed_Height
	DefineGadget	SurfBlue,PLACETEXT_LEFT,SurfColor_LeftEdge,SurfGreen_TopEdge+SurfGreen_Height,SurfRed_Width,SurfRed_Height

;	Informations:

	DefineGadget	SurfName,PLACETEXT_LEFT,ObjectName_LeftEdge+8,ObjectName_TopEdge,ObjectName_Width-8*3,ObjectName_Height
	DefineGadget	SurfSize,PLACETEXT_LEFT,SurfName_LeftEdge+SurfName_Width+15*8,SurfName_TopEdge,ObjectSize_Width,SurfName_Height


;---- Panneau "IMAGE EDITOR":

;	Liste:
	DefineGadget	ImageList_IE,PLACETEXT_ABOVE,GeometricList_GE_LeftEdge,GeometricList_GE_TopEdge,GeometricList_GE_Width,GeometricList_GE_Height

;	Informations:
	DefineGadget	ImageWidth,PLACETEXT_LEFT,ImageList_IE_LeftEdge+9*8,ImageList_IE_TopEdge+ImageList_IE_Height+8*2,8*8,16
	DefineGadget	ImageHeight,PLACETEXT_LEFT,ImageWidth_LeftEdge,ImageWidth_TopEdge+ImageWidth_Height,ImageWidth_Width,ImageWidth_Height

*****************************************************************************************
*											*
*			INITIALISATION DE L'INTERFACE					*
*											*
*****************************************************************************************
InitInterface
	movem.l	d0-a6,-(sp)
;	---- Donnée "Visual Info":
	move.l	WbScreen,a0
	CALLGT	GetVisualInfoA
	move.l	d0,VisualInfo	
;	---- Initialisation des panneaux:
	bsr.w	InitPanels
	bcs.w	e_Error
;	---- Ouverture fenetre:
ii.openWin
	sub.l	a0,a0
	lea	MainWindow.tags(pc),a1
	CALLINT	OpenWindowTagList
	tst.l	d0
	beq.w	e_MainWindow
	move.l	d0,MainWindow
;	---- Initialisation panneau actif au départ:
	move.l	#PanelID_SE,ik_CurrentPanel
	move.l	MainWindow(pc),a0
	move.l	GadgetList_SceneEditor(pc),a1
	moveq	#-1,d0
	moveq	#-1,d1
	sub.l	a2,a2
	CALLINT	AddGList
;	---- Rafraichissement gadgets:
	move.l	GadgetList_SceneEditor(pc),a0
	move.l	MainWindow(pc),a1
	sub.l	a2,a2
	moveq	#-1,d0
	CALLINT	RefreshGList
;	---- Rafraichissement fenetre:
	move.l	MainWindow(pc),a0
	CALLGT	GT_RefreshWindow
;	---- Zee End:
	movem.l	(sp)+,d0-a6
	clc
	rts

;	******** ERREURS ********

e_Error	move.l	d0,(sp)
	movem.l	(sp)+,d0-a6
	stc
	rts

e_MainWindow
	movem.l	(sp)+,d0-a6
	moveq	#Cant_open_main_window,d0
	stc
	rts

;	******** SOUS-PROGRAMMES ********

;*----------------------------------------------*
;*	   Initialisation des panneaux		*
;*----------------------------------------------*

InitPanels

******** Panneau principal:

;	---- Tete de liste:
	lea	MainWindow.GList(pc),a0
	CALLGT	CreateContext
	tst.l	d0
	beq.w	e_GadgetContext
	move.l	d0,LastGadget

;	---- Gadgets:
	CreateGadget	LISTVIEW_KIND,PanelList
	CreateGadget	TEXT_KIND,Status

******** Panneau "SceneEditor":
.scene
;	---- Tete de liste:
	lea	GadgetList_SceneEditor(pc),a0
	CALLGT	CreateContext
	tst.l	d0
	beq.w	e_GadgetContext
	move.l	d0,LastGadget
;	---- Gadgets:
	CreateGadget	BUTTON_KIND,LoadScene
	CreateGadget	BUTTON_KIND,SaveScene
	CreateGadget	BUTTON_KIND,LoadObject
	CreateGadget	BUTTON_KIND,RemoveGeo
	CreateGadget	BUTTON_KIND,RemoveCam
	CreateGadget	BUTTON_KIND,RemoveLight
	CreateGadget	BUTTON_KIND,RemoveMotion
	CreateGadget	BUTTON_KIND,LoadPalette
	CreateGadget	TEXT_KIND,SceneName
	CreateGadget	NUMBER_KIND,SceneSize
	CreateGadget	NUMBER_KIND,NumGeo
	CreateGadget	NUMBER_KIND,NumCameras
	CreateGadget	NUMBER_KIND,NumLights
	CreateGadget	NUMBER_KIND,NumMotions
	CreateGadget	NUMBER_KIND,NumPoints_SE
	CreateGadget	NUMBER_KIND,NumPolygons_SE
	CreateGadget	NUMBER_KIND,NumSurfaces_SE
	CreateGadget	NUMBER_KIND,NumImages_SE
	CreateGadget	LISTVIEW_KIND,GeometricList_SE
	CreateGadget	LISTVIEW_KIND,CameraList_SE
	CreateGadget	LISTVIEW_KIND,LightList_SE
	CreateGadget	LISTVIEW_KIND,MotionList_SE
	CreateGadget	CYCLE_KIND,DisplayScene
	CreateGadget	CYCLE_KIND,RenderDepth


******** Panneau "GeometricEditor":
.geometric
;	---- Tete de liste:
	lea	GadgetList_GeometricEditor(pc),a0
	CALLGT	CreateContext
	tst.l	d0
	beq.w	e_GadgetContext
	move.l	d0,LastGadget

;	---- Gadgets:
	CreateGadget	BUTTON_KIND,ChangeGeo
	CreateGadget	BUTTON_KIND,SaveGeo
	CreateGadget	BUTTON_KIND,RemoveSurface
	CreateGadget	SLIDER_KIND,AlphaX
	CreateGadget	SLIDER_KIND,AlphaY
	CreateGadget	SLIDER_KIND,AlphaZ
	CreateGadget	CHECKBOX_KIND,AutoRotation
	CreateGadget	TEXT_KIND,ObjectName
	CreateGadget	NUMBER_KIND,ObjectSize
	CreateGadget	NUMBER_KIND,NumPoints_GE
	CreateGadget	NUMBER_KIND,NumPolygons_GE
	CreateGadget	NUMBER_KIND,NumSurfaces_GE
	CreateGadget	NUMBER_KIND,NumImages_GE
	CreateGadget	LISTVIEW_KIND,GeometricList_GE
	CreateGadget	LISTVIEW_KIND,SurfaceList_GE
	CreateGadget	LISTVIEW_KIND,ImageList_GE
	CreateGadget	CYCLE_KIND,DisplayGeo

******** Panneau "Camera Editor":

;	---- Tete de liste:
	lea	GadgetList_CameraEditor(pc),a0
	CALLGT	CreateContext
	tst.l	d0
	beq.w	e_GadgetContext
	move.l	d0,LastGadget

;	---- Gadgets:
	CreateGadget	BUTTON_KIND,ChangeCam
	CreateGadget	BUTTON_KIND,SaveCam
	CreateGadget	SLIDER_KIND,XRadius
	CreateGadget	SLIDER_KIND,YRadius
	CreateGadget	TEXT_KIND,CameraName
	CreateGadget	LISTVIEW_KIND,CameraList_CE

******** Panneau "Light Editor":

;	---- Tete de liste:
	lea	GadgetList_LightEditor(pc),a0
	CALLGT	CreateContext
	tst.l	d0
	beq.w	e_GadgetContext
	move.l	d0,LastGadget

;	---- Gadgets:
	CreateGadget	BUTTON_KIND,ChangeLight
	CreateGadget	BUTTON_KIND,SaveLight
	CreateGadget	TEXT_KIND,LightName
	CreateGadget	LISTVIEW_KIND,LightList_LE
	CreateGadget	TEXT_KIND,LightColor
	CreateGadget	SLIDER_KIND,LightRed
	CreateGadget	SLIDER_KIND,LightGreen
	CreateGadget	SLIDER_KIND,LightBlue
	CreateGadget	SLIDER_KIND,LightRadius
	CreateGadget	SLIDER_KIND,Intensity

******** Panneau "Motion Editor":

;	---- Tete de liste:
	lea	GadgetList_MotionEditor(pc),a0
	CALLGT	CreateContext
	tst.l	d0
	beq.w	e_GadgetContext
	move.l	d0,LastGadget

;	---- Gadgets:
	CreateGadget	BUTTON_KIND,ChangeMotion
	CreateGadget	BUTTON_KIND,SaveMotion
	CreateGadget	TEXT_KIND,MotionName
	CreateGadget	TEXT_KIND,MotionType
	CreateGadget	LISTVIEW_KIND,MotionList_ME
	CreateGadget	LISTVIEW_KIND,MotionTypeList


******** Panneau "SurfaceEditor":

;	---- Tete de liste:
	lea	GadgetList_SurfaceEditor(pc),a0
	CALLGT	CreateContext
	tst.l	d0
	beq.w	e_GadgetContext
	move.l	d0,LastGadget

;	---- Gadgets:
	CreateGadget	BUTTON_KIND,ChangeSurf
	CreateGadget	BUTTON_KIND,SaveSurf
	CreateGadget	LISTVIEW_KIND,SurfaceList_SU
	CreateGadget	TEXT_KIND,SurfColor
	CreateGadget	SLIDER_KIND,SurfRed
	CreateGadget	SLIDER_KIND,SurfGreen
	CreateGadget	SLIDER_KIND,SurfBlue
	CreateGadget	CHECKBOX_KIND,Luminous
	CreateGadget	CHECKBOX_KIND,Outline
	CreateGadget	CHECKBOX_KIND,Smoothing
	CreateGadget	CHECKBOX_KIND,ColorHL
	CreateGadget	CHECKBOX_KIND,ColorFilter
	CreateGadget	CHECKBOX_KIND,OpaqueEdge
	CreateGadget	CHECKBOX_KIND,TranspEdge
	CreateGadget	CHECKBOX_KIND,SharpTerm
	CreateGadget	CHECKBOX_KIND,DoubleSided
	CreateGadget	CHECKBOX_KIND,Additive
	CreateGadget	TEXT_KIND,SurfName
	CreateGadget	NUMBER_KIND,SurfSize


******** Panneau "Texture Editor":

;	---- Tete de liste:
	lea	GadgetList_TextureEditor(pc),a0
	CALLGT	CreateContext
	tst.l	d0
	beq.w	e_GadgetContext
	move.l	d0,LastGadget

******** Panneau "Image Editor":

;	---- Tete de liste:
	lea	GadgetList_ImageEditor(pc),a0
	CALLGT	CreateContext
	tst.l	d0
	beq.w	e_GadgetContext
	move.l	d0,LastGadget

;	---- Gadgets:
	CreateGadget	LISTVIEW_KIND,ImageList_IE
	CreateGadget	NUMBER_KIND,ImageWidth
	CreateGadget	NUMBER_KIND,ImageHeight

******** Zee End:
	clc
	rts



;	******** ERREURS ********

e_GadgetContext
	moveq	#Cant_create_gadget_context,d0
	stc
	rts

e_CreateGadget
	moveq	#Cant_create_gadget,d0
	stc
	rts

;	******** DONNEES ********

Panels_Table
GadgetList_SceneEditor		dc.l	0
GadgetList_GeometricEditor	dc.l	0
GadgetList_CameraEditor		dc.l	0
GadgetList_LightEditor		dc.l	0
GadgetList_MotionEditor		dc.l	0
GadgetList_SurfaceEditor	dc.l	0
GadgetList_TextureEditor	dc.l	0
GadgetList_ImageEditor		dc.l	0
				dc.l	0	;Tableau terminé par un 0


*************************************************
*	Suppression de l'interface		*
*************************************************
RemoveInterface
	movem.l	d0-a6,-(sp)
	bsr.s	CloseMainWindow
	bsr.s	RemoveGadgets
	move.l	VisualInfo(pc),a0
	CALLGT	FreeVisualInfo
;	---- Zee End:
	movem.l	(sp)+,d0-a6
	clc
	rts

;	---- Fermeture fenetre:
CloseMainWindow
	move.l	MainWindow(pc),a0
	CALLINT	CloseWindow
	clc
	rts

;	---- Destruction des gadgets:
RemoveGadgets
;	Séparation de la liste principal:
	move.l	MainWindow(pc),a0
	move.l	Status.gadget(pc),a1
	move.l	gg_NextGadget(a1),d0
	beq.w	.removePanels
	move.l	d0,a1
	moveq	#-1,d0
	CALLINT	RemoveGList
;	Destruction panneaux:
.removePanels
	lea	Panels_Table(pc),a2
.loop	move.l	(a2)+,d0
	beq.s	.Main
	move.l	d0,a0
	CALLGT	FreeGadgets
	bra.s	.loop
;	Destruction panneau principal:
.Main	move.l	MainWindow.GList(pc),a0
	CALLGT	FreeGadgets
	clc
	rts



*****************************************************************************************
*											*
*			DONNEES D'INITIALISATION DES GADGETS				*
*											*
*****************************************************************************************

*************************** PANNEAU PRINCIPAL ***************************************

* ----------------------------- *
*	Liste "Panels"		*
* ----------------------------- *

PanelList.text	STRING	" "

PanelList.tags
		dc.l	GA_Disabled,FALSE
		dc.l	GTLV_Labels,PanelList.List
		dc.l	GTLV_ReadOnly,FALSE
		dc.l	GTLV_ScrollWidth,16
		dc.l	GTLV_ShowSelected,0
		dc.l	GTLV_Selected,0
		dc.l	TAG_DONE

PanelList.readTags
		dc.l	GA_Disabled
		dc.l	ik_PanelDisable
		dc.l	GTLV_Selected
		dc.l	ik_CurrentPanel
		dc.l	TAG_DONE

PanelList.List
.header	dc.l	.node1
.tail	dc.l	0
	dc.l	.node7

.node1	dc.l	.node2
	dc.l	.header
	dc.b	0
	dc.b	0
	dc.l	.Scene

.node2	dc.l	.node3
	dc.l	.node1
	dc.b	0
	dc.b	0
	dc.l	.Geometric

.node3	dc.l	.node4
	dc.l	.node2
	dc.b	0
	dc.b	0
	dc.l	.Camera

.node4	dc.l	.node5
	dc.l	.node3
	dc.b	0
	dc.b	0
	dc.l	.Light

.node5	dc.l	.node6
	dc.l	.node4
	dc.b	0
	dc.b	0
	dc.l	.Motion

.node6	dc.l	.node7
	dc.l	.node5
	dc.b	0
	dc.b	0
	dc.l	.Surface

.node7	dc.l	.node8
	dc.l	.node6
	dc.b	0
	dc.b	0
	dc.l	.Texture

.node8	dc.l	.tail
	dc.l	.node7
	dc.b	0
	dc.b	0
	dc.l	.Image

.Scene		STRING	"Scene"
.Geometric	STRING	"Geometric"
.Camera		STRING	"Camera"
.Light		STRING	"LightSource"
.Motion		STRING	"Motion"
.Surface	STRING	"Surface"
.Texture	STRING	"Texture"
.Image		STRING	"Image"


* ----------------------------- *
* 	Texte "Status"		*
* ----------------------------- *

Status.text		STRING	"Status:"

Status.tags
		dc.l	GTTX_Text,Status_OK
		dc.l	GTTX_Border,TRUE
		dc.l	TAG_DONE
Status.refreshTags
		dc.l	GTTX_Text
Status.message	dc.l	Status_OK
		dc.l	TAG_DONE

;	Messages system:
Status_OK	STRING	"Ok"




*************************** PANNEAU "SCENE EDITOR" ***************************************

* ----------------------------- *
*	Bouton "Load scene"	*
* ----------------------------- *

LoadScene.text		STRING	"Load scene"

LoadScene.tags
		dc.l	GA_Disabled,FALSE
		dc.l	GA_Immediate,FALSE
		dc.l	TAG_DONE

* ----------------------------- *
*	Bouton "Save scene"	*
* ----------------------------- *

SaveScene.text		STRING	"Save scene"

SaveScene.tags
		dc.l	GA_Disabled,FALSE
		dc.l	GA_Immediate,FALSE
		dc.l	TAG_DONE


* ----------------------------- *
*	Bouton "Load object"	*
* ----------------------------- *

LoadObject.text		STRING	"Load object"

LoadObject.tags
		dc.l	GA_Disabled,FALSE
		dc.l	GA_Immediate,FALSE
		dc.l	TAG_DONE

* ----------------------------- *
*   Bouton "Remove geometric"	*
* ----------------------------- *

RemoveGeo.text	STRING	"Remove geometric"

RemoveGeo.tags
		dc.l	GA_Disabled,FALSE
		dc.l	GA_Immediate,FALSE
		dc.l	TAG_DONE

* ----------------------------- *
*   Bouton "Remove camera"	*
* ----------------------------- *

RemoveCam.text	STRING	"Remove camera"

RemoveCam.tags
		dc.l	GA_Disabled,FALSE
		dc.l	GA_Immediate,FALSE
		dc.l	TAG_DONE

* ----------------------------- *
*   Bouton "Remove light"	*
* ----------------------------- *

RemoveLight.text	STRING	"Remove light"

RemoveLight.tags
		dc.l	GA_Disabled,FALSE
		dc.l	GA_Immediate,FALSE
		dc.l	TAG_DONE

* ----------------------------- *
*   Bouton "Remove motion"	*
* ----------------------------- *

RemoveMotion.text		STRING	"Remove motion"

RemoveMotion.tags
		dc.l	GA_Disabled,FALSE
		dc.l	GA_Immediate,FALSE
		dc.l	TAG_DONE

* ----------------------------- *
*	Bouton "Load palette"	*
* ----------------------------- *

LoadPalette.text		STRING	"Load Palette"

LoadPalette.tags
		dc.l	GA_Disabled,FALSE
		dc.l	GA_Immediate,FALSE
		dc.l	TAG_DONE

* ----------------------------- *
* 	Texte "Scene name"	*
* ----------------------------- *

SceneName.text		STRING	"Scene name:"

SceneName.tags
		dc.l	GTTX_Text,ik_SceneName
		dc.l	GTTX_Border,TRUE
		dc.l	TAG_DONE

SceneName.refreshTags
		dc.l	GTTX_Text,ik_SceneName
		dc.l	TAG_DONE

* ----------------------------- *
* 	Numéro "Scene Size"	*
* ----------------------------- *

SceneSize.text		STRING	"Scene size:"

SceneSize.tags
		dc.l	GTNM_Number,0
		dc.l	GTNM_Border,TRUE
		dc.l	TAG_DONE
SceneSize.refreshTags
			dc.l	GTNM_Number
SceneSize.number	dc.l	0
			dc.l	TAG_DONE

* ----------------------------- *
* 	Numéro "Geometrics"	*
* ----------------------------- *

NumGeo.text		STRING	"Geometrics:"

NumGeo.tags
		dc.l	GTNM_Number,0
		dc.l	GTNM_Border,TRUE
		dc.l	TAG_DONE

NumGeo.refreshTags
		dc.l	GTNM_Number
NumGeo.number	dc.l	0
		dc.l	TAG_DONE

* ----------------------------- *
* 	Numéro "Cameras"	*
* ----------------------------- *

NumCameras.text		STRING	"Cameras:"

NumCameras.tags
		dc.l	GTNM_Number,0
		dc.l	GTNM_Border,TRUE
		dc.l	TAG_DONE

NumCameras.refreshTags
			dc.l	GTNM_Number
NumCameras.number	dc.l	0
			dc.l	TAG_DONE

* ----------------------------- *
* 	Numéro "LightSources"	*
* ----------------------------- *

NumLights.text		STRING	"Lights:"

NumLights.tags
		dc.l	GTNM_Number,0
		dc.l	GTNM_Border,TRUE
		dc.l	TAG_DONE

NumLights.refreshTags
			dc.l	GTNM_Number
NumLights.number	dc.l	0
			dc.l	TAG_DONE

* ----------------------------- *	
* 	Numéro "Motions"	*
* ----------------------------- *

NumMotions.text		STRING	"Motions:"

NumMotions.tags
		dc.l	GTNM_Number,0
		dc.l	GTNM_Border,TRUE
		dc.l	TAG_DONE

NumMotions.refreshTags
			dc.l	GTNM_Number
NumMotions.number	dc.l	0
			dc.l	TAG_DONE

* ----------------------------- *
* 	Numéro "Points"		*
* ----------------------------- *

NumPoints_SE.text		STRING	"Points:"

NumPoints_SE.tags
		dc.l	GTNM_Number,0
		dc.l	GTNM_Border,TRUE
		dc.l	TAG_DONE

NumPoints_SE.refreshTags
			dc.l	GTNM_Number
NumPoints_SE.number	dc.l	0
			dc.l	TAG_DONE

* ----------------------------- *
* 	Numéro "Polygons"	*
* ----------------------------- *

NumPolygons_SE.text		STRING	"Polygons:"

NumPolygons_SE.tags
		dc.l	GTNM_Number,0
		dc.l	GTNM_Border,TRUE
		dc.l	TAG_DONE

NumPolygons_SE.refreshTags
			dc.l	GTNM_Number
NumPolygons_SE.number	dc.l	0
			dc.l	TAG_DONE

* ----------------------------- *
* 	Numéro "Surfaces"	*
* ----------------------------- *

NumSurfaces_SE.text		STRING	"Surfaces:"

NumSurfaces_SE.tags
		dc.l	GTNM_Number,0
		dc.l	GTNM_Border,TRUE
		dc.l	TAG_DONE

NumSurfaces_SE.refreshTags
			dc.l	GTNM_Number
NumSurfaces_SE.number	dc.l	0
			dc.l	TAG_DONE


* ----------------------------- *
* 	Numéro "Images:"	*
* ----------------------------- *

NumImages_SE.text	STRING	"Images:"

NumImages_SE.tags
		dc.l	GTNM_Number,0
		dc.l	GTNM_Border,TRUE
		dc.l	TAG_DONE

NumImages_SE.refreshTags
			dc.l	GTNM_Number
NumImages_SE.number	dc.l	0
			dc.l	TAG_DONE


* ----------------------------- *
*    Liste "Geometrics list"	*
* ----------------------------- *

GeometricList_SE.text	STRING	"Geometrics list"

GeometricList_SE.tags
		dc.l	GA_Disabled,TRUE
		dc.l	GTLV_Labels,ik_EmptyList
		dc.l	GTLV_ReadOnly,FALSE
		dc.l	GTLV_ScrollWidth,16
		dc.l	GTLV_ShowSelected,0
		dc.l	GTLV_Selected,0
		dc.l	TAG_DONE

GeometricList_SE.refreshTags
				dc.l	GA_Disabled
GeometricList_SE.disable	dc.l	FALSE
				dc.l	GTLV_Top,0
				dc.l	GTLV_Selected,0
				dc.l	GTLV_Labels
GeometricList_SE.list		dc.l	0
				dc.l	TAG_DONE

GeometricList_SE.readTags
		dc.l	GA_Disabled
		dc.l	ik_GeometricListDisable
		dc.l	GTLV_Selected
		dc.l	ik_CurrentGeometric
		dc.l	TAG_DONE

* ----------------------------- *
*	Liste "Cameras list"	*
* ----------------------------- *

CameraList_SE.text	STRING	"Cameras list"

CameraList_SE.tags
		dc.l	GA_Disabled,TRUE
		dc.l	GTLV_Labels,ik_EmptyList
		dc.l	GTLV_ReadOnly,FALSE
		dc.l	GTLV_ScrollWidth,16
		dc.l	GTLV_ShowSelected,0
		dc.l	GTLV_Selected,0
		dc.l	TAG_DONE

CameraList_SE.refreshTags
			dc.l	GA_Disabled
CameraList_SE.disable	dc.l	FALSE
			dc.l	GTLV_Top,0
			dc.l	GTLV_Selected,0
			dc.l	GTLV_Labels
CameraList_SE.list	dc.l	0
			dc.l	TAG_DONE

CameraList_SE.readTags
		dc.l	GA_Disabled
		dc.l	ik_CameraListDisable
		dc.l	GTLV_Selected
		dc.l	ik_CurrentCamera
		dc.l	TAG_DONE


* ----------------------------- *
*	Liste "Lights list"	*
* ----------------------------- *

LightList_SE.text	STRING	"Lights list"

LightList_SE.tags
		dc.l	GA_Disabled,TRUE
		dc.l	GTLV_Labels,ik_EmptyList
		dc.l	GTLV_ReadOnly,FALSE
		dc.l	GTLV_ScrollWidth,16
		dc.l	GTLV_ShowSelected,0
		dc.l	GTLV_Selected,0
		dc.l	TAG_DONE

LightList_SE.refreshTags
			dc.l	GA_Disabled
LightList_SE.disable	dc.l	FALSE
			dc.l	GTLV_Top,0
			dc.l	GTLV_Selected,0
			dc.l	GTLV_Labels
LightList_SE.list	dc.l	0
			dc.l	TAG_DONE

LightList_SE.readTags
		dc.l	GA_Disabled
		dc.l	ik_LightListDisable
		dc.l	GTLV_Selected
		dc.l	ik_CurrentLight
		dc.l	TAG_DONE

* ----------------------------- *
*	Liste "Motions list"	*
* ----------------------------- *

MotionList_SE.text	STRING	"Motions list"

MotionList_SE.tags
		dc.l	GA_Disabled,TRUE
		dc.l	GTLV_Labels,ik_EmptyList
		dc.l	GTLV_ReadOnly,FALSE
		dc.l	GTLV_ScrollWidth,16
		dc.l	GTLV_ShowSelected,0
		dc.l	GTLV_Selected,0
		dc.l	TAG_DONE

MotionList_SE.refreshTags
			dc.l	GA_Disabled
MotionList_SE.disable	dc.l	FALSE
			dc.l	GTLV_Top,0
			dc.l	GTLV_Selected,0
			dc.l	GTLV_Labels
MotionList_SE.list	dc.l	0
			dc.l	TAG_DONE

MotionList_SE.readTags
		dc.l	GA_Disabled
		dc.l	ik_MotionListDisable
		dc.l	GTLV_Selected
		dc.l	ik_CurrentMotion
		dc.l	TAG_DONE

* ------------------------------------- *
*	Cycle "Display Scene"		*
* ------------------------------------- *


DisplayScene.text		STRING	"Display scene:"

DisplayScene.refreshTags
		dc.l	GTCY_Active,DispMode_NoDisplay
		dc.l	TAG_DONE
DisplayScene.tags
		dc.l	GA_Disabled,FALSE
		dc.l	GTCY_Labels,DisplayScene.labels
		dc.l	GTCY_Active,DispMode_NoDisplay
		dc.l	TAG_DONE

DisplayScene.readTags
		dc.l	GTCY_Active,ik_DisplayScene
		dc.l	TAG_DONE

DisplayScene.labels
	dc.l	DisplayScene.noDisplay,DisplayScene.friendly,DisplayScene.internal,0

DisplayScene.noDisplay	STRING	"No display"
DisplayScene.friendly	STRING	"Friendly"
DisplayScene.internal	STRING	"Internal"

* ------------------------------------- *
*	Cycle "Render depth"		*
* ------------------------------------- *


RenderDepth.text		STRING	"Render depth:"

RenderDepth.refreshTags
		dc.l	GTCY_Active,UserRDepth_32bits
		dc.l	TAG_DONE
RenderDepth.tags
		dc.l	GA_Disabled,FALSE
		dc.l	GTCY_Labels,RenderDepth.labels
		dc.l	GTCY_Active,UserRDepth_32bits
		dc.l	TAG_DONE

RenderDepth.readTags
		dc.l	GTCY_Active,ik_RenderDepth
		dc.l	TAG_DONE

RenderDepth.labels
	dc.l	RenderDepth.8bits,RenderDepth.15bits,RenderDepth.16bits,RenderDepth.32bits,0

RenderDepth.8bits	STRING	"8 bits"
RenderDepth.15bits	STRING	"15 bits"
RenderDepth.16bits	STRING	"16 bits"
RenderDepth.32bits	STRING	"32 bits"


*************************** PANNEAU "GEOMETRIC EDITOR" ***********************************

* ----------------------------- *
*   Bouton "Change geometric"	*
* ----------------------------- *


ChangeGeo.text		STRING	"Change object"

ChangeGeo.tags
		dc.l	GA_Disabled,FALSE
		dc.l	GA_Immediate,FALSE
		dc.l	TAG_DONE

* ----------------------------- *
*   Bouton "Save geometric"	*
* ----------------------------- *


SaveGeo.text		STRING	"Save object"

SaveGeo.tags
		dc.l	GA_Disabled,FALSE
		dc.l	GA_Immediate,FALSE
		dc.l	TAG_DONE

* ----------------------------- *
*   Bouton "Remove surface"	*
* ----------------------------- *

RemoveSurface.text		STRING	"Remove surface"

RemoveSurface.tags
		dc.l	GA_Disabled,FALSE
		dc.l	GA_Immediate,FALSE
		dc.l	TAG_DONE

* ----------------------------- *
* 	Texte "Object name"	*
* ----------------------------- *


ObjectName.text		STRING	"Object name:"

ObjectName.tags
		dc.l	GTTX_Text,ik_GeometricName
		dc.l	GTTX_Border,TRUE
		dc.l	TAG_DONE
ObjectName.refreshTags
		dc.l	GTTX_Text,ik_GeometricName
		dc.l	TAG_DONE


* ----------------------------- *
* 	Numéro "Object Size"	*
* ----------------------------- *


ObjectSize.text		STRING	"Object size:"

ObjectSize.tags
		dc.l	GTNM_Number,0
		dc.l	GTNM_Border,TRUE
		dc.l	TAG_DONE
ObjectSize.refreshTags
			dc.l	GTNM_Number
ObjectSize.number	dc.l	0
			dc.l	TAG_DONE

* ----------------------------- *
* 	Numéro "Points"		*
* ----------------------------- *


NumPoints_GE.text		STRING	"Points"

NumPoints_GE.tags
		dc.l	GTNM_Number,0
		dc.l	GTNM_Border,TRUE
		dc.l	TAG_DONE

NumPoints_GE.refreshTags
			dc.l	GTNM_Number
NumPoints_GE.number	dc.l	0
			dc.l	TAG_DONE

* ----------------------------- *
* 	Numéro "Polygons"	*
* ----------------------------- *


NumPolygons_GE.text		STRING	"Polygons"

NumPolygons_GE.tags
		dc.l	GTNM_Number,0
		dc.l	GTNM_Border,TRUE
		dc.l	TAG_DONE

NumPolygons_GE.refreshTags
			dc.l	GTNM_Number
NumPolygons_GE.number	dc.l	0
			dc.l	TAG_DONE

* ----------------------------- *
* 	Numéro "Surfaces"	*
* ----------------------------- *


NumSurfaces_GE.text		STRING	"Surfaces"

NumSurfaces_GE.tags
		dc.l	GTNM_Number,0
		dc.l	GTNM_Border,TRUE
		dc.l	TAG_DONE
NumSurfaces_GE.refreshTags
			dc.l	GTNM_Number
NumSurfaces_GE.number	dc.l	0
			dc.l	TAG_DONE

* ----------------------------- *
* 	Numéro "Images:"	*
* ----------------------------- *


NumImages_GE.text		STRING	"Images"

NumImages_GE.tags
		dc.l	GTNM_Number,0
		dc.l	GTNM_Border,TRUE
		dc.l	TAG_DONE
NumImages_GE.refreshTags
			dc.l	GTNM_Number
NumImages_GE.number	dc.l	0
			dc.l	TAG_DONE


* ----------------------------- *
*    Liste "Geometrics list"	*
* ----------------------------- *


GeometricList_GE.text	STRING	"Geometrics list"

GeometricList_GE.tags
		dc.l	GA_Disabled,TRUE
		dc.l	GTLV_Labels,ik_EmptyList
		dc.l	GTLV_ReadOnly,FALSE
		dc.l	GTLV_ScrollWidth,16
		dc.l	GTLV_ShowSelected,0
		dc.l	GTLV_Selected,0
		dc.l	TAG_DONE

GeometricList_GE.refreshTags
				dc.l	GA_Disabled
GeometricList_GE.disable	dc.l	FALSE
				dc.l	GTLV_Top,0
				dc.l	GTLV_Selected,0
				dc.l	GTLV_Labels
GeometricList_GE.list		dc.l	0
				dc.l	TAG_DONE

GeometricList_GE.readTags
		dc.l	GA_Disabled
		dc.l	ik_GeometricListDisable
		dc.l	GTLV_Selected
		dc.l	ik_CurrentGeometric
		dc.l	TAG_DONE

* ----------------------------- *
* 	Liste "SurfaceList"	*
* ----------------------------- *


SurfaceList_GE.text	STRING	"Surfaces list"

SurfaceList_GE.tags
		dc.l	GA_Disabled,TRUE
		dc.l	GTLV_Labels,ik_EmptyList
		dc.l	GTLV_ReadOnly,FALSE
		dc.l	GTLV_ScrollWidth,16
		dc.l	GTLV_ShowSelected,0
		dc.l	GTLV_Selected,0
		dc.l	TAG_DONE

SurfaceList_GE.refreshTags
			dc.l	GA_Disabled
SurfaceList_GE.disable	dc.l	FALSE
			dc.l	GTLV_Top,0
			dc.l	GTLV_Selected,0
			dc.l	GTLV_Labels
SurfaceList_GE.list	dc.l	0
			dc.l	TAG_DONE

SurfaceList_GE.readTags
		dc.l	GA_Disabled
		dc.l	ik_SurfaceListDisable
		dc.l	GTLV_Selected
		dc.l	ik_GeoCurrentSurface
		dc.l	TAG_DONE

* ----------------------------- *
* 	Liste "Images list"	*
* ----------------------------- *


ImageList_GE.text	STRING	"Images list"

ImageList_GE.tags
		dc.l	GA_Disabled,TRUE
		dc.l	GTLV_Labels,ik_EmptyList
		dc.l	GTLV_ReadOnly,FALSE
		dc.l	GTLV_ScrollWidth,16
		dc.l	GTLV_ShowSelected,0
		dc.l	GTLV_Selected,0
		dc.l	TAG_DONE

ImageList_GE.refreshTags
			dc.l	GA_Disabled
ImageList_GE.disable	dc.l	FALSE
			dc.l	GTLV_Top,0
			dc.l	GTLV_Selected,0
			dc.l	GTLV_Labels
ImageList_GE.list	dc.l	0
			dc.l	TAG_DONE

ImageList_GE.readTags
		dc.l	GA_Disabled,ik_ImageListDisable
		dc.l	GTLV_Selected,ik_GeoCurrentImage
		dc.l	TAG_DONE

* ------------------------------------- *
*	Cycle "DisplayGeo mode"		*
* ------------------------------------- *

DisplayGeo.text		STRING	"Display mode:"

DisplayGeo.tags
		dc.l	GA_Disabled,FALSE
		dc.l	GTCY_Labels,DisplayGeo.labels
		dc.l	GTCY_Active,DispMode_NoDisplay
		dc.l	TAG_DONE

DisplayGeo.refreshTags
		dc.l	GTCY_Active,DispMode_NoDisplay
		dc.l	TAG_DONE

DisplayGeo.readTags
		dc.l	GTCY_Active,ik_DisplayGeo
		dc.l	TAG_DONE

DisplayGeo.labels
	dc.l	DisplayGeo.noDisplay,DisplayGeo.friendly,DisplayGeo.internal,0

DisplayGeo.noDisplay	STRING	"No display"
DisplayGeo.friendly	STRING	"Friendly"
DisplayGeo.internal	STRING	"Internal"



* ------------------------------------- *
*	Slider "AlphaX"			*
* ------------------------------------- *

AlphaX.text		STRING	"AlphaX:"

AlphaX.tags
		dc.l	GA_Disabled,TRUE
		dc.l	GA_Immediate,FALSE
		dc.l	GTSL_Min,0
		dc.l	GTSL_Max,360
		dc.l	GTSL_MaxLevelLen,2
		dc.l	GTSL_LevelPlace,PLACETEXT_RIGHT
		dc.l	PGA_Freedom,LORIENT_HORIZ
		dc.l	TAG_DONE

AlphaX.refreshTags
		dc.l	GA_Disabled
AlphaX.disable	dc.l	TRUE
		dc.l	TAG_DONE

AlphaX.readTags
		dc.l	GTSL_Level,ik_AlphaX
		dc.l	TAG_DONE

* ------------------------------------- *
*	Slider "AlphaY"			*
* ------------------------------------- *

AlphaY.text		STRING	"AlphaY:"

AlphaY.tags
		dc.l	GA_Disabled,TRUE
		dc.l	GA_Immediate,FALSE
		dc.l	GTSL_Min,0
		dc.l	GTSL_Max,360
		dc.l	GTSL_MaxLevelLen,2
		dc.l	GTSL_LevelPlace,PLACETEXT_RIGHT
		dc.l	PGA_Freedom,LORIENT_HORIZ
		dc.l	TAG_DONE
AlphaY.refreshTags
		dc.l	GA_Disabled
AlphaY.disable	dc.l	TRUE
		dc.l	TAG_DONE
AlphaY.readTags
		dc.l	GTSL_Level,ik_AlphaY
		dc.l	TAG_DONE

* ------------------------------------- *
*	Slider "AlphaZ"			*
* ------------------------------------- *

AlphaZ.text		STRING	"AlphaZ:"

AlphaZ.tags
		dc.l	GA_Disabled,TRUE
		dc.l	GA_Immediate,FALSE
		dc.l	GTSL_Min,0
		dc.l	GTSL_Max,360
		dc.l	GTSL_MaxLevelLen,2
		dc.l	GTSL_LevelPlace,PLACETEXT_RIGHT
		dc.l	PGA_Freedom,LORIENT_HORIZ
		dc.l	TAG_DONE

AlphaZ.refreshTags
		dc.l	GA_Disabled
AlphaZ.disable	dc.l	TRUE
		dc.l	TAG_DONE

AlphaZ.readTags
		dc.l	GTSL_Level,ik_AlphaZ
		dc.l	TAG_DONE

* ----------------------------- *
* 	CheckBox "AutoRotation"	*
* ----------------------------- *

AutoRotation.text	STRING	"Auto rotation"

AutoRotation.tags
		dc.l	GA_Disabled,FALSE
		dc.l	GTCB_Checked,FALSE
		dc.l	GTCB_Scaled,TRUE
		dc.l	TAG_DONE

AutoRotation.readTags
		dc.l	GTCB_Checked,ik_AutoRotation
		dc.l	TAG_DONE



********************************** PANNEAU "CAMERA EDITOR" *****************************

* ----------------------------- *
*   Bouton "Change camera"	*
* ----------------------------- *

ChangeCam.text		STRING	"Change object"

ChangeCam.tags
		dc.l	GA_Disabled,FALSE
		dc.l	GA_Immediate,FALSE
		dc.l	TAG_DONE

* ----------------------------- *
*   Bouton "Save camera"	*
* ----------------------------- *

SaveCam.text		STRING	"Save camera"

SaveCam.tags
		dc.l	GA_Disabled,FALSE
		dc.l	GA_Immediate,FALSE
		dc.l	TAG_DONE

* ------------------------------------- *
*	Slider "XRadius"		*
* ------------------------------------- *

XRadius.text		STRING	"XRadius:"

XRadius.tags
		dc.l	GA_Disabled,TRUE
		dc.l	GA_Immediate,FALSE
		dc.l	GTSL_Min,0
		dc.l	GTSL_Max,90
		dc.l	GTSL_MaxLevelLen,2
		dc.l	GTSL_LevelPlace,PLACETEXT_RIGHT
		dc.l	PGA_Freedom,LORIENT_HORIZ
		dc.l	TAG_DONE

XRadius.refreshTags
		dc.l	GA_Disabled
XRadius.disable	dc.l	TRUE
		dc.l	TAG_DONE

XRadius.readTags
		dc.l	GTSL_Level,ik_XRadius
		dc.l	TAG_DONE

* ------------------------------------- *
*	Slider "YRadius"		*
* ------------------------------------- *

YRadius.text		STRING	"YRadius:"

YRadius.tags
		dc.l	GA_Disabled,TRUE
		dc.l	GA_Immediate,FALSE
		dc.l	GTSL_Min,0
		dc.l	GTSL_Max,90
		dc.l	GTSL_MaxLevelLen,2
		dc.l	GTSL_LevelPlace,PLACETEXT_RIGHT
		dc.l	PGA_Freedom,LORIENT_HORIZ
		dc.l	TAG_DONE

YRadius.refreshTags
		dc.l	GA_Disabled
YRadius.disable	dc.l	TRUE
		dc.l	TAG_DONE

YRadius.readTags
		dc.l	GTSL_Level,ik_YRadius
		dc.l	TAG_DONE

* ----------------------------- *
* 	Texte "Camera name"	*
* ----------------------------- *

CameraName.text		STRING	"Camera name:"

CameraName.tags
		dc.l	GTTX_Text,ik_CameraName
		dc.l	GTTX_Border,TRUE
		dc.l	TAG_DONE

CameraName.refreshTags
		dc.l	GTTX_Text,ik_CameraName
		dc.l	TAG_DONE


* ----------------------------- *
* 	Liste "Camera list"	*
* ----------------------------- *

CameraList_CE.text	STRING	"Cameras list"

CameraList_CE.tags
		dc.l	GA_Disabled,TRUE
		dc.l	GTLV_Labels,ik_EmptyList
		dc.l	GTLV_ReadOnly,FALSE
		dc.l	GTLV_ScrollWidth,16
		dc.l	GTLV_ShowSelected,0
		dc.l	GTLV_Selected,0
		dc.l	TAG_DONE

CameraList_CE.refreshTags
			dc.l	GA_Disabled
CameraList_CE.disable	dc.l	FALSE
			dc.l	GTLV_Top,0
			dc.l	GTLV_Selected,0
			dc.l	GTLV_Labels
CameraList_CE.list	dc.l	0
			dc.l	TAG_DONE

CameraList_CE.readTags
		dc.l	GA_Disabled,ik_CameraListDisable
		dc.l	GTLV_Selected,ik_CurrentCamera
		dc.l	TAG_DONE

********************************** PANNEAU "LIGHT EDITOR" *****************************

* ----------------------------- *
*   Bouton "Change light"	*
* ----------------------------- *

ChangeLight.text		STRING	"Change light"

ChangeLight.tags
		dc.l	GA_Disabled,FALSE
		dc.l	GA_Immediate,FALSE
		dc.l	TAG_DONE

* ----------------------------- *
*   Bouton "Save light"	*
* ----------------------------- *

SaveLight.text		STRING	"Save light"

SaveLight.tags
		dc.l	GA_Disabled,FALSE
		dc.l	GA_Immediate,FALSE
		dc.l	TAG_DONE

* ------------------------------------- *
*	Slider "Radius"			*
* ------------------------------------- *

LightRadius.text		STRING	"Radius:"

LightRadius.tags
		dc.l	GA_Disabled,TRUE
		dc.l	GA_Immediate,FALSE
		dc.l	GTSL_Min,0
		dc.l	GTSL_Max,180
		dc.l	GTSL_MaxLevelLen,2
		dc.l	GTSL_LevelPlace,PLACETEXT_RIGHT
		dc.l	PGA_Freedom,LORIENT_HORIZ
		dc.l	TAG_DONE

LightRadius.refreshTags
			dc.l	GA_Disabled
LightRadius.disable	dc.l	TRUE
			dc.l	TAG_DONE

LightRadius.readTags
		dc.l	GTSL_Level,ik_LightRadius
		dc.l	TAG_DONE

* ----------------------------- *
* 	Texte "Color"		*
* ----------------------------- *

LightColor.text	STRING	"-Color-"

LightColor.tags
		dc.l	GTTX_Text,LightColor.text
		dc.l	GTTX_Border,TRUE
		dc.l	TAG_DONE

* ------------------------------------- *
*	Slider "R:"			*
* ------------------------------------- *

LightRed.text	STRING	"R:"

LightRed.tags
		dc.l	GA_Disabled,TRUE
		dc.l	GA_Immediate,FALSE
		dc.l	GTSL_Min,0
		dc.l	GTSL_Max,255
		dc.l	GTSL_MaxLevelLen,1
		dc.l	GTSL_LevelPlace,PLACETEXT_RIGHT
		dc.l	PGA_Freedom,LORIENT_HORIZ
		dc.l	TAG_DONE

LightRed.refreshTags
			dc.l	GA_Disabled
LightRed.disable	dc.l	TRUE
			dc.l	GTSL_Level
LightRed.level		dc.l	0
			dc.l	TAG_DONE

LightRed.readTags
		dc.l	GTSL_Level,ik_LightRed
		dc.l	TAG_DONE

* ------------------------------------- *
*	Slider "G:"			*
* ------------------------------------- *

LightGreen.text		STRING	"G:"

LightGreen.tags
		dc.l	GA_Disabled,TRUE
		dc.l	GA_Immediate,FALSE
		dc.l	GTSL_Min,0
		dc.l	GTSL_Max,255
		dc.l	GTSL_MaxLevelLen,1
		dc.l	GTSL_LevelPlace,PLACETEXT_RIGHT
		dc.l	PGA_Freedom,LORIENT_HORIZ
		dc.l	TAG_DONE

LightGreen.refreshTags
			dc.l	GA_Disabled
LightGreen.disable	dc.l	TRUE
			dc.l	GTSL_Level
LightGreen.level	dc.l	0
			dc.l	TAG_DONE

LightGreen.readTags
		dc.l	GTSL_Level,ik_LightGreen
		dc.l	TAG_DONE

* ------------------------------------- *
*	Slider "B:"			*
* ------------------------------------- *

LightBlue.text		STRING	"B:"

LightBlue.tags
		dc.l	GA_Disabled,TRUE
		dc.l	GA_Immediate,FALSE
		dc.l	GTSL_Min,0
		dc.l	GTSL_Max,255
		dc.l	GTSL_MaxLevelLen,1
		dc.l	GTSL_LevelPlace,PLACETEXT_RIGHT
		dc.l	PGA_Freedom,LORIENT_HORIZ
		dc.l	TAG_DONE

LightBlue.refreshTags
			dc.l	GA_Disabled
LightBlue.disable	dc.l	TRUE
			dc.l	GTSL_Level
LightBlue.level		dc.l	0
			dc.l	TAG_DONE

LightBlue.readTags
		dc.l	GTSL_Level,ik_LightBlue
		dc.l	TAG_DONE

* ------------------------------------- *
*	Slider "Intensity:"		*
* ------------------------------------- *

Intensity.text		STRING	"Intensity:"

Intensity.tags
		dc.l	GA_Disabled,TRUE
		dc.l	GA_Immediate,FALSE
		dc.l	GTSL_Min,0
		dc.l	GTSL_Max,100
		dc.l	GTSL_MaxLevelLen,1
		dc.l	GTSL_LevelPlace,PLACETEXT_RIGHT
		dc.l	PGA_Freedom,LORIENT_HORIZ
		dc.l	TAG_DONE

Intensity.refreshTags
			dc.l	GA_Disabled
Intensity.disable	dc.l	TRUE
			dc.l	GTSL_Level
Intensity.level		dc.l	0
			dc.l	TAG_DONE

Intensity.readTags
		dc.l	GTSL_Level,ik_LightIntensity
		dc.l	TAG_DONE

* ----------------------------- *
* 	Texte "Light name"	*
* ----------------------------- *

LightName.text		STRING	"Light name:"

LightName.tags
		dc.l	GTTX_Text,ik_LightName
		dc.l	GTTX_Border,TRUE
		dc.l	TAG_DONE

LightName.refreshTags
		dc.l	GTTX_Text,ik_LightName
		dc.l	TAG_DONE


* ----------------------------- *
* 	Liste "Light list"	*
* ----------------------------- *

LightList_LE.text	STRING	"Lights list"

LightList_LE.tags
		dc.l	GA_Disabled,TRUE
		dc.l	GTLV_Labels,ik_EmptyList
		dc.l	GTLV_ReadOnly,FALSE
		dc.l	GTLV_ScrollWidth,16
		dc.l	GTLV_ShowSelected,0
		dc.l	GTLV_Selected,0
		dc.l	TAG_DONE

LightList_LE.refreshTags
			dc.l	GA_Disabled
LightList_LE.disable	dc.l	FALSE
			dc.l	GTLV_Top,0
			dc.l	GTLV_Selected,0
			dc.l	GTLV_Labels
LightList_LE.list	dc.l	0
			dc.l	TAG_DONE

LightList_LE.readTags
		dc.l	GA_Disabled,ik_LightListDisable
		dc.l	GTLV_Selected,ik_CurrentLight
		dc.l	TAG_DONE

********************************** PANNEAU "MOTION EDITOR" *****************************

* ----------------------------- *
*   Bouton "Change motion"	*
* ----------------------------- *

ChangeMotion.text		STRING	"Change motion"

ChangeMotion.tags
		dc.l	GA_Disabled,FALSE
		dc.l	GA_Immediate,FALSE
		dc.l	TAG_DONE

* ----------------------------- *
*   Bouton "Save motion"	*
* ----------------------------- *

SaveMotion.text		STRING	"Save motion"

SaveMotion.tags
		dc.l	GA_Disabled,FALSE
		dc.l	GA_Immediate,FALSE
		dc.l	TAG_DONE

* ----------------------------- *
* 	Texte "Motion name"	*
* ----------------------------- *

MotionName.text		STRING	"Motion name:"

MotionName.tags
		dc.l	GTTX_Text,ik_MotionName
		dc.l	GTTX_Border,TRUE
		dc.l	TAG_DONE

MotionName.refreshTags
		dc.l	GTTX_Text,ik_MotionName
		dc.l	TAG_DONE

* ----------------------------- *
* 	Texte "Motion type"	*
* ----------------------------- *

MotionType.text		STRING	"Motion type:"

MotionType.tags
		dc.l	GTTX_Text,ik_MotionTypeName
		dc.l	GTTX_Border,TRUE
		dc.l	TAG_DONE

MotionType.refreshTags
		dc.l	GTTX_Text,ik_MotionTypeName
		dc.l	TAG_DONE

* ----------------------------- *
* 	Liste "Motion list"	*
* ----------------------------- *

MotionList_ME.text	STRING	"Motions list"

MotionList_ME.tags
		dc.l	GA_Disabled,TRUE
		dc.l	GTLV_Labels,ik_EmptyList
		dc.l	GTLV_ReadOnly,FALSE
		dc.l	GTLV_ScrollWidth,16
		dc.l	GTLV_ShowSelected,0
		dc.l	GTLV_Selected,0
		dc.l	TAG_DONE

MotionList_ME.refreshTags
			dc.l	GA_Disabled
MotionList_ME.disable	dc.l	FALSE
			dc.l	GTLV_Top,0
			dc.l	GTLV_Selected,0
			dc.l	GTLV_Labels
MotionList_ME.list	dc.l	0
			dc.l	TAG_DONE

MotionList_ME.readTags
		dc.l	GA_Disabled,ik_MotionListDisable
		dc.l	GTLV_Selected,ik_CurrentMotion
		dc.l	TAG_DONE

* ----------------------------- *
* 	Liste "MotionType list"	*
* ----------------------------- *

MotionTypeList.text	STRING	"Motion types list"

MotionTypeList.tags
		dc.l	GA_Disabled,TRUE
		dc.l	GTLV_Labels,ik_EmptyList
		dc.l	GTLV_ReadOnly,FALSE
		dc.l	GTLV_ScrollWidth,16
		dc.l	GTLV_ShowSelected,0
		dc.l	GTLV_Selected,0
		dc.l	TAG_DONE

MotionTypeList.refreshTags
			dc.l	GA_Disabled
MotionTypeList.disable	dc.l	FALSE
			dc.l	GTLV_Top,0
			dc.l	GTLV_Selected,0
			dc.l	GTLV_Labels
MotionTypeList.list	dc.l	0
			dc.l	TAG_DONE

MotionTypeList.readTags
		dc.l	GA_Disabled,ik_MotionTypeListDisable
		dc.l	GTLV_Selected,ik_CurrentMotionType
		dc.l	TAG_DONE

********************************** PANNEAU "SURFACE EDITOR" *****************************

* ----------------------------- *
* 	Texte "Surface name"	*
* ----------------------------- *


SurfName.text		STRING	"Surface name:"

SurfName.tags
		dc.l	GTTX_Text,ik_SurfaceName
		dc.l	GTTX_Border,TRUE
		dc.l	TAG_DONE

SurfName.refreshTags
		dc.l	GTTX_Text,ik_SurfaceName
		dc.l	TAG_DONE


* ----------------------------- *
* 	Numéro "Surface Size"	*
* ----------------------------- *


SurfSize.text		STRING	"Surface size:"

SurfSize.tags
		dc.l	GTNM_Number,0
		dc.l	GTNM_Border,TRUE
		dc.l	TAG_DONE

SurfSize.refreshTags
		dc.l	GTNM_Number
SurfSize.number	dc.l	0
		dc.l	TAG_DONE

* ----------------------------- *
*   Bouton "Change surface"	*
* ----------------------------- *

ChangeSurf.text		STRING	"Change surface"

ChangeSurf.tags
		dc.l	GA_Disabled,FALSE
		dc.l	GA_Immediate,FALSE
		dc.l	TAG_DONE

* ----------------------------- *
*   Bouton "Save surface"	*
* ----------------------------- *

SaveSurf.text		STRING	"Save surface"

SaveSurf.tags
		dc.l	GA_Disabled,FALSE
		dc.l	GA_Immediate,FALSE
		dc.l	TAG_DONE

* ----------------------------- *
* 	Texte "Surface color"	*
* ----------------------------- *

SurfColor.tags
		dc.l	GTTX_Text,SurfColor.text
		dc.l	GTTX_Border,TRUE
		dc.l	TAG_DONE
SurfColor.text
		STRING	"-Color-"


* ------------------------------------- *
*	Slider "R:"			*
* ------------------------------------- *

SurfRed.text		STRING	"R:"

SurfRed.tags
		dc.l	GA_Disabled,TRUE
		dc.l	GA_Immediate,FALSE
		dc.l	GTSL_Min,0
		dc.l	GTSL_Max,255
		dc.l	GTSL_MaxLevelLen,1
		dc.l	GTSL_LevelPlace,PLACETEXT_RIGHT
		dc.l	PGA_Freedom,LORIENT_HORIZ
		dc.l	TAG_DONE

SurfRed.refreshTags
		dc.l	GA_Disabled
SurfRed.disable	dc.l	TRUE
		dc.l	GTSL_Level
SurfRed.level	dc.l	0
		dc.l	TAG_DONE


SurfRed.readTags
		dc.l	GTSL_Level,ik_SurfaceRed
		dc.l	TAG_DONE

* ------------------------------------- *
*	Slider "G:"			*
* ------------------------------------- *

SurfGreen.text		STRING	"G:"

SurfGreen.tags
		dc.l	GA_Disabled,TRUE
		dc.l	GA_Immediate,FALSE
		dc.l	GTSL_Min,0
		dc.l	GTSL_Max,255
		dc.l	GTSL_MaxLevelLen,1
		dc.l	GTSL_LevelPlace,PLACETEXT_RIGHT
		dc.l	PGA_Freedom,LORIENT_HORIZ
		dc.l	TAG_DONE
SurfGreen.refreshTags
			dc.l	GA_Disabled
SurfGreen.disable	dc.l	TRUE
			dc.l	GTSL_Level
SurfGreen.level		dc.l	0
			dc.l	TAG_DONE


SurfGreen.readTags
		dc.l	GTSL_Level,ik_SurfaceGreen
		dc.l	TAG_DONE

* ------------------------------------- *
*	Slider "B:"			*
* ------------------------------------- *

SurfBlue.text		STRING	"B:"

SurfBlue.tags
		dc.l	GA_Disabled,TRUE
		dc.l	GA_Immediate,FALSE
		dc.l	GTSL_Min,0
		dc.l	GTSL_Max,255
		dc.l	GTSL_MaxLevelLen,1
		dc.l	GTSL_LevelPlace,PLACETEXT_RIGHT
		dc.l	PGA_Freedom,LORIENT_HORIZ
		dc.l	TAG_DONE

SurfBlue.refreshTags
			dc.l	GA_Disabled
SurfBlue.disable	dc.l	TRUE
			dc.l	GTSL_Level
SurfBlue.level		dc.l	0
			dc.l	TAG_DONE


SurfBlue.readTags
		dc.l	GTSL_Level,ik_SurfaceBlue
		dc.l	TAG_DONE

* ----------------------------- *
* 	CheckBox "Luminous"	*
* ----------------------------- *

Luminous.tags	dc.l	GA_Disabled,TRUE
		dc.l	GTCB_Checked,FALSE
		dc.l	GTCB_Scaled,FALSE
		dc.l	TAG_DONE

Luminous.refreshTags
			dc.l	GA_Disabled
Luminous.disabled	dc.l	FALSE
			dc.l	GTCB_Checked
Luminous.checked	dc.l	FALSE
			dc.l	TAG_DONE

Luminous.text	STRING	"Luminous"

* ----------------------------- *
* 	CheckBox "Outline"	*
* ----------------------------- *

Outline.tags	dc.l	GA_Disabled,TRUE
		dc.l	GTCB_Checked,FALSE
		dc.l	GTCB_Scaled,FALSE
		dc.l	TAG_DONE

Outline.refreshTags
			dc.l	GA_Disabled
Outline.disabled	dc.l	FALSE
			dc.l	GTCB_Checked
Outline.checked		dc.l	FALSE
			dc.l	TAG_DONE

Outline.text	STRING	"Outline"

* ----------------------------- *
* 	CheckBox "Smoothing"	*
* ----------------------------- *

Smoothing.tags	dc.l	GA_Disabled,TRUE
		dc.l	GTCB_Checked,FALSE
		dc.l	GTCB_Scaled,FALSE
		dc.l	TAG_DONE

Smoothing.refreshTags
			dc.l	GA_Disabled
Smoothing.disabled	dc.l	FALSE
			dc.l	GTCB_Checked
Smoothing.checked	dc.l	FALSE
			dc.l	TAG_DONE

Smoothing.text	STRING	"Smoothing"

* ----------------------------- *
* 	CheckBox "ColorHL"	*
* ----------------------------- *

ColorHL.tags	dc.l	GA_Disabled,TRUE
		dc.l	GTCB_Checked,FALSE
		dc.l	GTCB_Scaled,FALSE
		dc.l	TAG_DONE

ColorHL.refreshTags
			dc.l	GA_Disabled
ColorHL.disabled	dc.l	FALSE
			dc.l	GTCB_Checked
ColorHL.checked		dc.l	FALSE
			dc.l	TAG_DONE

ColorHL.text	STRING	"Color highlights"

* ----------------------------- *
* 	CheckBox "ColorFilter"	*
* ----------------------------- *

ColorFilter.tags
		dc.l	GA_Disabled,TRUE
		dc.l	GTCB_Checked,FALSE
		dc.l	GTCB_Scaled,FALSE
		dc.l	TAG_DONE

ColorFilter.refreshTags
			dc.l	GA_Disabled
ColorFilter.disabled	dc.l	FALSE
			dc.l	GTCB_Checked
ColorFilter.checked	dc.l	FALSE
			dc.l	TAG_DONE

ColorFilter.text	STRING	"Color filter"

* ----------------------------- *
* 	CheckBox "OpaqueEdge"	*
* ----------------------------- *

OpaqueEdge.tags	dc.l	GA_Disabled,TRUE
		dc.l	GTCB_Checked,FALSE
		dc.l	GTCB_Scaled,FALSE
		dc.l	TAG_DONE

OpaqueEdge.refreshTags
			dc.l	GA_Disabled
OpaqueEdge.disabled	dc.l	FALSE
			dc.l	GTCB_Checked
OpaqueEdge.checked	dc.l	FALSE
			dc.l	TAG_DONE

OpaqueEdge.text	STRING	"Opaque edge"

* ----------------------------- *
* 	CheckBox "TranspEdge"	*
* ----------------------------- *

TranspEdge.tags	dc.l	GA_Disabled,TRUE
		dc.l	GTCB_Checked,FALSE
		dc.l	GTCB_Scaled,FALSE
		dc.l	TAG_DONE

TranspEdge.refreshTags
			dc.l	GA_Disabled
TranspEdge.disabled	dc.l	FALSE
			dc.l	GTCB_Checked
TranspEdge.checked	dc.l	FALSE
			dc.l	TAG_DONE

TranspEdge.text	STRING	"Transparent edge"

* ----------------------------- *
* 	CheckBox "SharpTerm"	*
* ----------------------------- *

SharpTerm.tags	dc.l	GA_Disabled,TRUE
		dc.l	GTCB_Checked,FALSE
		dc.l	GTCB_Scaled,FALSE
		dc.l	TAG_DONE

SharpTerm.refreshTags	dc.l	GA_Disabled
SharpTerm.disabled	dc.l	FALSE
			dc.l	GTCB_Checked
SharpTerm.checked	dc.l	FALSE
			dc.l	TAG_DONE

SharpTerm.text	STRING	"SharpTerminator"

* ----------------------------- *
* 	CheckBox "DoubleSided"	*
* ----------------------------- *

DoubleSided.tags
		dc.l	GA_Disabled,TRUE
		dc.l	GTCB_Checked,FALSE
		dc.l	GTCB_Scaled,FALSE
		dc.l	TAG_DONE

DoubleSided.refreshTags	dc.l	GA_Disabled
DoubleSided.disabled	dc.l	FALSE
			dc.l	GTCB_Checked
DoubleSided.checked	dc.l	FALSE
			dc.l	TAG_DONE

DoubleSided.text	STRING	"Double sided"

* ----------------------------- *
* 	CheckBox "Additive"	*
* ----------------------------- *

Additive.tags	dc.l	GA_Disabled,TRUE
		dc.l	GTCB_Checked,FALSE
		dc.l	GTCB_Scaled,FALSE
		dc.l	TAG_DONE

Additive.refreshTags	dc.l	GA_Disabled
Additive.disabled	dc.l	FALSE
			dc.l	GTCB_Checked
Additive.checked	dc.l	FALSE
			dc.l	TAG_DONE

Additive.text	STRING	"Additive"

* ----------------------------- *
* 	Liste "SurfaceList"	*
* ----------------------------- *


SurfaceList_SU.text	STRING	"Surfaces list"

SurfaceList_SU.tags
		dc.l	GA_Disabled,TRUE
		dc.l	GTLV_Labels,ik_EmptyList
		dc.l	GTLV_ReadOnly,FALSE
		dc.l	GTLV_ScrollWidth,16
		dc.l	GTLV_ShowSelected,0
		dc.l	GTLV_Selected,0
		dc.l	TAG_DONE

SurfaceList_SU.refreshTags
			dc.l	GA_Disabled
SurfaceList_SU.disable	dc.l	FALSE
			dc.l	GTLV_Top,0
			dc.l	GTLV_Selected,0
			dc.l	GTLV_Labels
SurfaceList_SU.list	dc.l	0
			dc.l	TAG_DONE

SurfaceList_SU.readTags
		dc.l	GA_Disabled
		dc.l	ik_SurfaceListDisable
		dc.l	GTLV_Selected
		dc.l	ik_SceneCurrentSurface
		dc.l	TAG_DONE

********************************** PANNEAU "TEXTURE EDITOR" *****************************



********************************** PANNEAU "IMAGE EDITOR" *******************************


* ----------------------------- *
* 	Numéro "Image width"	*
* ----------------------------- *

ImageWidth.text		STRING	"Width:"

ImageWidth.tags
		dc.l	GTNM_Number,0
		dc.l	GTNM_Border,TRUE
		dc.l	TAG_DONE

ImageWidth.refreshTags
			dc.l	GTNM_Number
ImageWidth.number	dc.l	0
			dc.l	TAG_DONE

* ----------------------------- *
* 	Numéro "Image height"	*
* ----------------------------- *

ImageHeight.text		STRING	"Height:"

ImageHeight.tags
			dc.l	GTNM_Number,0
			dc.l	GTNM_Border,TRUE
			dc.l	TAG_DONE
ImageHeight.refreshTags
			dc.l	GTNM_Number
ImageHeight.number	dc.l	0
			dc.l	TAG_DONE

* ----------------------------- *
* 	Liste "Images list"	*
* ----------------------------- *

ImageList_IE.text	STRING	"Images list"

ImageList_IE.tags
		dc.l	GA_Disabled,TRUE
		dc.l	GTLV_Labels,ik_EmptyList
		dc.l	GTLV_ReadOnly,FALSE
		dc.l	GTLV_ScrollWidth,16
		dc.l	GTLV_ShowSelected,0
		dc.l	GTLV_Selected,0
		dc.l	TAG_DONE

ImageList_IE.refreshTags
			dc.l	GA_Disabled
ImageList_IE.disable	dc.l	FALSE
			dc.l	GTLV_Top,0
			dc.l	GTLV_Selected,0
			dc.l	GTLV_Labels
ImageList_IE.list	dc.l	0
			dc.l	TAG_DONE

ImageList_IE.readTags
		dc.l	GA_Disabled,ik_ImageListDisable
		dc.l	GTLV_Selected,ik_CurrentImage
		dc.l	TAG_DONE

*****************************************************************************************
*											*
*				DONNEES PAR DEFAUT					*
*											*
*****************************************************************************************


*****************************************************************************************
*											*
*				NOYAU DE L'INTERFACE					*
*											*
*****************************************************************************************



ik_PanelList		dc.l	PanelList.List	;Liste des panneaux
ik_PanelDisable		dc.l	FALSE	;Flag (TRUE=List désactivée)
ik_CurrentPanel		dc.l	0	;Identité du panneau actif
ik_Status		dc.l	0	;Pointeur sur dernier message de status (chaine ASCII)

;----Données concernant l'éditeur de scène:
;	Infos:
ik_SceneName		dcb.b	108,0	;Nom de la scene
ik_SceneSize		dc.l	0	;Place occupée par la scène en mémoire
ik_NumGeometrics	dc.l	0	;Nombre d'objets géométriques dans la scène
ik_NumCameras		dc.l	0	;Nombre de caméras dans la scène
ik_NumLights		dc.l	0	;Nombre de sources lumineuses dans la scène
ik_NumMotions		dc.l	0	;Nombre de mouvements dans la scène
ik_SceneNumPoints	dc.l	0	;Nombre total de points dans la scène
ik_SceneNumPolygons	dc.l	0	;Nombre total de polygones dans la scène
ik_SceneNumSurfaces	dc.l	0	;Nombre total de surfaces dans la scène
ik_SceneNumImages	dc.l	0	;Nombre total d'images dans la scène
;	Listes:
ik_GeometricList	dc.l	ik_EmptyList	;Liste des objets géométriques
ik_CameraList		dc.l	ik_EmptyList	;Liste des caméras
ik_LightList		dc.l	ik_EmptyList	;Liste des sources lumineuses
ik_MotionList		dc.l	ik_EmptyList	;Liste des mouvements
ik_SceneSurfaceList	dc.l	ik_EmptyList	;Liste des surfaces
;	Pointeurs de listes:
ik_CurrentGeometric	dc.l	0	;Numéro de l'objet géométrique sélectionné
ik_CurrentCamera	dc.l	0	;Numéro de la caméra sélectionné
ik_CurrentLight		dc.l	0	;Numéro de la source lumineuse sélectionnée
ik_CurrentMotion	dc.l	0	;Numéro du mouvement sélectionné
ik_SceneCurrentSurface	dc.l	0
;	Flags:
ik_GeometricListDisable	dc.l	TRUE	;TRUE=liste désactivée
ik_CameraListDisable	dc.l	TRUE
ik_LightListDisable	dc.l	TRUE
ik_MotionListDisable	dc.l	TRUE
;	Viewer de scene:
ik_DisplayScene		dc.l	DispMode_NoDisplay	;Mode de rendu de la scène (OFF,Friendly,Internal)
ik_RenderDepth		dc.l	UserRDepth_32bits	;Profondeur du rendu (Sert aussi pour le viewer
;					 d'objet individuel, dans l'éditeur d'objets Geo)

;----Données concerant l'éditeur d'objets Geo:
;	Infos:
ik_GeometricName	dcb.b	108,0	;Nom de l'objet
ik_GeometricSize	dc.l	0	;Place occupé en mémoire par l'objet
ik_GeoNumPoints		dc.l	0	;Nombre de points
ik_GeoNumPolygons	dc.l	0	;Nombre de polygones	
ik_GeoNumSurfaces	dc.l	0	;Nombre de surfaces
ik_GeoNumImages		dc.l	0	;Nombre d'images
;	Listes:
ik_GeoSurfaceList	dc.l	ik_EmptyList	;Liste des surfaces
ik_GeoImageList		dc.l	ik_EmptyList	;Liste des images
;	Pointeurs de listes:
ik_GeoCurrentImage		dc.l	0	;Numéro de l'image sélectionnée
ik_GeoCurrentSurface	dc.l	0	;Numéro de la surface sélectionnée
;	Flags:
ik_SurfaceListDisable	dc.l	TRUE	;TRUE=liste désactivée
ik_ImageListDisable	dc.l	TRUE
;	Viewer d'objet:
ik_DisplayGeo		dc.l	DispMode_NoDisplay	;Mode de rendu du viewer d'objet individuel
ik_AlphaX		dc.l	0	;Angles de rotation de l'objet
ik_AlphaY		dc.l	0
ik_AlphaZ		dc.l	0
ik_AutoRotation		dc.l	FALSE	;Flag (TRUE=Autorotation de l'objet)
;	Viewer d'image:
ik_DispImageGeo		dc.l	FALSE	;Flag (TRUE=Affichage de l'image sélectionnée)


;---- Données concernant l'éditeur de caméras:
;	Infos:
ik_CameraName		dcb.b	108,0	;Nom de l'objet
ik_CameraSize		dc.l	0	;Place occupée en mémoire par l'objet
ik_XRadius		dc.l	0	;Angle horizontal
ik_YRadius		dc.l	0	;Angle vertical

;---- Données concernant l'éditeur de source lumineuses:
;	Infos:
ik_LightName		dcb.b	108,0	;Nom de l'objet
ik_LightSize		dc.l	0	;Place occupée en mémoire par l'objet
ik_LightRadius		dc.l	0	;Angle du faisceau
ik_LightRed		dc.l	0	;Composante rouge
ik_LightGreen		dc.l	0	;Composante verte
ik_LightBlue		dc.l	0	;Composante bleue
ik_LightIntensity	dc.l	0	;Intensité lumineuse

;---- Données concernant l'éditeur de mouvements:
;	Infos:
ik_MotionName		dcb.b	108,0	;Nom du mouvement
ik_MotionSize		dc.l	0	;Place occupée en mémoire par le mouvement	
ik_MotionTypeName	dcb.b	108,0	;Nom du type du mouvement sélectionné
;	Liste:
ik_MotionTypeList	dc.l	ik_EmptyList	;Liste des types de mouvements
;	Pointeur de liste:
ik_CurrentMotionType	dc.l	0		;Type de mouvement sélectionné
;	Flags:
ik_MotionTypeListDisable dc.l	TRUE	;TRUE=liste désactivée

;---- Données concernant l'éditeur de surfaces:
;	Infos:
ik_SurfaceName		dcb.b	108,0	;Nom de la surface
ik_SurfaceSize		dc.l	0	;Taille de la surface
ik_SurfaceRed		dc.l	0	;Composante rouge
ik_SurfaceGreen		dc.l	0	;Composante verte
ik_SurfaceBlue		dc.l	0	;Composante bleue
;	Attributs de la surface (flags):
ik_SurfLuminous		dc.l	FALSE
ik_SurfOutLine		dc.l	FALSE
ik_SurfSmoothing	dc.l	FALSE
ik_SurfColorHL		dc.l	FALSE
ik_SurfColorFilter	dc.l	FALSE
ik_SurfOpaqueEdge	dc.l	FALSE
ik_SurfTranspEdge	dc.l	FALSE
ik_SurfSharpTerm	dc.l	FALSE
ik_SurfDoubleSided	dc.l	FALSE
ik_SurfAdditive		dc.l	FALSE

;---- Données concernant l'éditeur d'images:
ik_ImageList	dc.l	ik_EmptyList	;Liste des images
ik_CurrentImage	dc.l	0		;Numéro de l'image sélectionnée
ik_ImageWidth	dc.l	0		;Largeur de l'image sélectionnée
ik_ImageHeight	dc.l	0		;Hauteur de l'image délectionnée

;---- Liste vide pour les gadget "LISTVIEW_KIND":
ik_EmptyList
.header	dc.l	.node1
.tail	dc.l	0
	dc.l	.node1

.node1	dc.l	.tail
	dc.l	.header
	dc.b	0
	dc.b	0
	dc.l	.empty

.empty	STRING	"-- Empty --"
