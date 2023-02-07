;APS00000000000000000000000000000000000000000000000000000000000000000000000000000000
*****************************************
*					*
*	Revision:	30/4/2001	*
*					*
*****************************************

*************************************************
*		Structure Scene			*
*************************************************

;Note: Les donn�es de rendu sont provisoirement incluent dans
;	la structure "Scene", pour simplifier les choses.
;	Il sera sans doute n�cessaire de reviser �a lors du
;	d�veloppement de tout ce qui concerne l'animation.

	STRUCTURE	Scene,0
	UWORD		scn_NbrGeometrics	;Nombre d'objets g�ometriques dans la sc�ne
	UWORD		scn_NbrCameras		;Nombre de cameras
	UWORD		scn_NbrLights		;Nombre de sources lumineuses
	UWORD		scn_NbrMotions		;Nombre de structures de mouvement

	ULONG		scn_NbrPolygons		;Nombre total de polygones dans la sc�ne
	ULONG		scn_NbrSurfaces		;Nombre de surfaces
	ULONG		scn_NbrImages		;Nombre total d'images
	ULONG		scn_NbrPoints		;Nombre total de points dans la sc�ne

	APTR		scn_Geometrics		;Table des objets g�ometriques
	APTR		scn_Cameras		;Table des cam�ras
	APTR		scn_Lights		;Table des sources lumineuses
	APTR		scn_Images		;Table des images
	APTR		scn_Motions		;Table des mouvements
	APTR		scn_Polygons		;Table des polygones
	APTR		scn_Surfaces		;Table des surfaces
	APTR		scn_Coords		;Table des points
	APTR		scn_FirstPolygon	;Pointeur pour le tri

	APTR		scn_Colors		;Palette (Uniquement utilis� par le mode 8bits)
;Donn�es provisoires de rendu:
	UBYTE		scn_Depth		;Profondeur d'�cran (cf. ci-apr�s)
	UBYTE		scn_MathsMode		;M�thode de calculs (virgule flottante ou fixe)
	LABEL		Scene_SIZE

; Profondeur d'�cran, sp�cifi� par le champ "scn_Depth":

RenderDepth_8bits	equ	1
RenderDepth_15bits	equ	2
RenderDepth_16bits	equ	3
RenderDepth_32bits	equ	4

; Mode de calculs (champ "scn_MathsMode"):
RenderMaths_FPU	equ	$01	;Virgule flottante
RenderMaths_ALU	equ	$02	;Virgule fixe

*********************************************************
*		Structure SpaceReference		*
*********************************************************

;Note: Un rep�re spacial ("SpaceReference") est d�fini par un point
;	origine, et trois vecteurs spaciaux orthonormaux.

	STRUCTURE	SpaceReference,0
; Point origine du rep�re:
	FLOAT	sr_XPos
	FLOAT	sr_YPos
	FLOAT	sr_ZPos
; Orientation d'origine des axes du rep�re:
	LABEL	sr_InitialVector
	FLOAT	sr_XAxisXInit
	FLOAT	sr_XAxisYInit
	FLOAT	sr_XAxisZInit
	FLOAT	sr_YAxisXInit
	FLOAT	sr_YAxisYInit
	FLOAT	sr_YAxisZInit
	FLOAT	sr_ZAxisXInit
	FLOAT	sr_ZAxisYInit
	FLOAT	sr_ZAxisZInit
; Orientation instantan�e des axes du rep�re:
	LABEL	sr_CurrentVector
	FLOAT	sr_XAxisXPos
	FLOAT	sr_XAxisYPos
	FLOAT	sr_XAxisZPos
	FLOAT	sr_YAxisXPos
	FLOAT	sr_YAxisYPos
	FLOAT	sr_YAxisZPos
	FLOAT	sr_ZAxisXPos
	FLOAT	sr_ZAxisYPos
	FLOAT	sr_ZAxisZPos
	LABEL		SpaceReference_SIZE

*********************************************************
*	Structure de d�finition spaciale des objets	*
*********************************************************

	STRUCTURE	ObjectHeader,0
	UWORD		obj_ObjectID				;Voir d�finition ci-apr�s
	STRUCT		obj_sr,SpaceReference_SIZE	;Voir structure ci-avant
; La structure relative � la nature de l'objet (Camera,LightSource
; ou Geometric, d�finie par le champ "ObjectID") commence au champ
; "obj_Datas":

	LABEL		obj_Datas
	LABEL		ObjectHeader_SIZE

;-------- D�finitions du champ "obj_ObjectID":

ObjID_Light	equ	1
ObjID_Geometric	equ	2
ObjID_Camera	equ	3


*********************************************************
*	Structure des sources lumineuses		*
*********************************************************

	STRUCTURE	LightSource,ObjectHeader_SIZE
	LONG		ls_Color	;Couleur de la lumi�re (format ARGB)
	FLOAT		ls_Intensity
	FLOAT		ls_Radius	;Angle du faisceau (0=emission dans toutes les 
;					;directions)
	LABEL		LightSource_SIZE

*********************************************************
*		Structure des cam�ras			*
*********************************************************

	STRUCTURE	Camera,ObjectHeader_SIZE
	FLOAT		cam_XRadius	;Angle horizontal
	FLOAT		cam_YRadius	;Angle vertical
	LABEL		Camera_SIZE

*********************************************************
*		Structure des objets g�ometriques	*
*********************************************************

	STRUCTURE	Geometric,ObjectHeader_SIZE
	ULONG		Geo_NbrPoints	;Nombre de points
	ULONG		Geo_NbrPolygons	;Nombre de polygones
	UWORD		Geo_NbrSurfaces	;Nombre de surfaces
	UWORD		Geo_NbrImages	;Nombre d'images
	FLOAT		Geo_Scale	;Echelle de l'objet
	APTR		Geo_Points		;Table des points
	APTR		Geo_Polygons		;Table des polygones
	APTR		Geo_Surfaces		;Table des surfaces
	APTR		Geo_Images		;Table des images
	LABEL		Geometric_SIZE

;Notes:	-La table des points renferme les points qui d�finissent la forme
;	 de l'objet. Ils ne changent donc pas au cours des calculs.
;	 Les points une fois calcul�s au sein de la sc�ne sont stock�s
;	 au fur et � mesure dans la table "scn_Coords".
;	-La table des images renferme les pointeurs sur les structures "ImageData"
;	 utilis�es par les surfaces de l'objet.

*************************************************
*		Structure Polygone		*
*************************************************

	STRUCTURE	polygon,0
	APTR		poly_Next		;Pointeur pour le tri
	FLOAT		poly_Weight		;Poid pour le tri
	UWORD		poly_NbrVertices	;Nombre de vertices
	APTR		poly_Surface		;Adresse de la surface � laquelle
;						; est rattach� le polygone
	LABEL		poly_Vertices		;D�but de la table des vertices.
	LABEL		polygon_SIZE

;Note: Les vertices sont les offsets des points, et pas directement leurs num�ros (type ULONG).

*************************************************
*		Structure "ImageData"		*
*************************************************

;Notes: -Les images doivent �tre converties au format
;	 sp�cifi� par "scn_Depth".

;	-Si le mode de rendu change, il suffit de recharger l'image
;	 grace aux donn�es "id_Path" et "id_Name" et de la reconvertir.
;	 (Ca �vite d'avoir � utiliser de la m�moire pour garder les
;	 donn�es bruts provenant du fichier)


	STRUCTURE	ImageData,0
	APTR	id_Path		;Chemin du fichier (Suivi du nom du fichier)
	APTR	id_Name		;Nom de l'image (donc du fichier)
	UWORD	id_XSize
	UWORD	id_YSize
	APTR	id_Buffer
	APTR	id_Palette	;Ne sert qu'en mode 8bits (RenderDepth_8bits)
	LABEL	ImageData_SIZE

*************************************************
*		Structure Surface		*
*************************************************

;Note:	Cette structure est provisoire. La mani�re de stocker les donn�es
;	relatives aux textures sera surement � revoir, de mani�re � ce
;	qu'il soit possible d'ajouter ou de supprimer � volont� diff�rents
;	type de textures.

	STRUCTURE	surface,0
	APTR	surf_Name
	LONG	surf_Color
	WORD	surf_Flags	;Voir definition ci-apr�s.
;Param�tres g�n�raux (lumiosit�, transparence, reflexion, etc...)
	UWORD	surf_Lumi
	UWORD	surf_Diff
	UWORD	surf_Spec
	UWORD	surf_Refl
	UWORD	surf_Tran
	UWORD	surf_Glos	;Utilis� avec le parametre "specular" <> 0
	APTR	surf_Rimg	;Pointeur sur une structure "ImageData"
	FLOAT	surf_Rsan
	FLOAT	surf_Rind
	FLOAT	surf_Edge
	FLOAT	surf_Sman
; Texture de coloration:
	APTR	surf_Ctex	;Nom du type
	WORD	surf_CtexType	;Code du type
	APTR	surf_CtexTimg	;Pointeur sur la structure "ImageData"
	WORD	surf_CtexTflg
	LABEL	surf_CtexTsiz
	FLOAT	surf_CtexTsiz_X
	FLOAT	surf_CtexTsiz_Y
	FLOAT	surf_CtexTsiz_Z
	LABEL	surf_CtexTctr
	FLOAT	surf_CtexTctr_X
	FLOAT	surf_CtexTctr_Y
	FLOAT	surf_CtexTctr_Z
	LABEL	surf_CtexTfal
	FLOAT	surf_CtexTfal_X
	FLOAT	surf_CtexTfal_Y
	FLOAT	surf_CtexTfal_Z
	LABEL	surf_CtexTvel
	FLOAT	surf_CtexTvel_X
	FLOAT	surf_CtexTvel_Y
	FLOAT	surf_CtexTvel_Z
	LONG	surf_CtexTclr
; Texture de diffusion:
	APTR	surf_Dtex
	WORD	surf_DtexType
	APTR	surf_DtexTimg
	WORD	surf_DtexTflg
	LABEL	surf_DtexTsiz
	FLOAT	surf_DtexTsiz_X
	FLOAT	surf_DtexTsiz_Y
	FLOAT	surf_DtexTsiz_Z
	LABEL	surf_DtexTctr
	FLOAT	surf_DtexTctr_X
	FLOAT	surf_DtexTctr_Y
	FLOAT	surf_DtexTctr_Z
	LABEL	surf_DtexTfal
	FLOAT	surf_DtexTfal_X
	FLOAT	surf_DtexTfal_Y
	FLOAT	surf_DtexTfal_Z
	LABEL	surf_DtexTvel
	FLOAT	surf_DtexTvel_X
	FLOAT	surf_DtexTvel_Y
	FLOAT	surf_DtexTvel_Z
	UWORD	surf_DtexTval
; Texture "specular" :
	APTR	surf_Stex
	WORD	surf_StexType
	APTR	surf_StexTimg
	WORD	surf_StexTflg
	LABEL	surf_StexTsiz
	FLOAT	surf_StexTsiz_X
	FLOAT	surf_StexTsiz_Y
	FLOAT	surf_StexTsiz_Z
	LABEL	surf_StexTctr
	FLOAT	surf_StexTctr_X
	FLOAT	surf_StexTctr_Y
	FLOAT	surf_StexTctr_Z
	LABEL	surf_StexTfal
	FLOAT	surf_StexTfal_X
	FLOAT	surf_StexTfal_Y
	FLOAT	surf_StexTfal_Z
	LABEL	surf_StexTvel
	FLOAT	surf_StexTvel_X
	FLOAT	surf_StexTvel_Y
	FLOAT	surf_StexTvel_Z
	UWORD	surf_StexTval
; Texture de r�flexion :
	APTR	surf_Rtex
	WORD	surf_RtexType
	APTR	surf_RtexTimg
	WORD	surf_RtexTflg
	LABEL	surf_RtexTsiz
	FLOAT	surf_RtexTsiz_X
	FLOAT	surf_RtexTsiz_Y
	FLOAT	surf_RtexTsiz_Z
	LABEL	surf_RtexTctr
	FLOAT	surf_RtexTctr_X
	FLOAT	surf_RtexTctr_Y
	FLOAT	surf_RtexTctr_Z
	LABEL	surf_RtexTfal
	FLOAT	surf_RtexTfal_X
	FLOAT	surf_RtexTfal_Y
	FLOAT	surf_RtexTfal_Z
	LABEL	surf_RtexTvel
	FLOAT	surf_RtexTvel_X
	FLOAT	surf_RtexTvel_Y
	FLOAT	surf_RtexTvel_Z
	UWORD	surf_RtexTval
; Texture de transparence:
	APTR	surf_Ttex
	WORD	surf_TtexType
	APTR	surf_TtexTimg
	WORD	surf_TtexTflg
	LABEL	surf_TtexTsiz
	FLOAT	surf_TtexTsiz_X
	FLOAT	surf_TtexTsiz_Y
	FLOAT	surf_TtexTsiz_Z
	LABEL	surf_TtexTctr
	FLOAT	surf_TtexTctr_X
	FLOAT	surf_TtexTctr_Y
	FLOAT	surf_TtexTctr_Z
	LABEL	surf_TtexTfal
	FLOAT	surf_TtexTfal_X
	FLOAT	surf_TtexTfal_Y
	FLOAT	surf_TtexTfal_Z
	LABEL	surf_TtexTvel
	FLOAT	surf_TtexTvel_X
	FLOAT	surf_TtexTvel_Y
	FLOAT	surf_TtexTvel_Z
	UWORD	surf_TtexTval
; Texture bump:
	APTR	surf_Btex
	WORD	surf_BtexType
	APTR	surf_BtexTimg
	WORD	surf_BtexTflg
	LABEL	surf_BtexTsiz
	FLOAT	surf_BtexTsiz_X
	FLOAT	surf_BtexTsiz_Y
	FLOAT	surf_BtexTsiz_Z
	LABEL	surf_BtexTctr
	FLOAT	surf_BtexTctr_X
	FLOAT	surf_BtexTctr_Y
	FLOAT	surf_BtexTctr_Z
	LABEL	surf_BtexTfal
	FLOAT	surf_BtexTfal_X
	FLOAT	surf_BtexTfal_Y
	FLOAT	surf_BtexTfal_Z
	LABEL	surf_BtexTvel
	FLOAT	surf_BtexTvel_X
	FLOAT	surf_BtexTvel_Y
	FLOAT	surf_BtexTvel_Z
	FLOAT	surf_BtexTamp
	LABEL	surf_SIZE

; D�finition des flags du champ "surf_Flags":
; Si le bit est � 1: Le param�tre correspondant est actif.
; Si le bit est � 0: Le param�tre est inactif.
	BITDEF	srFlag,Luminous,0
	BITDEF	srFlag,Outline,1
	BITDEF	srFlag,Smoothing,2
	BITDEF	srFlag,ColorHL,3
	BITDEF	srFlag,ColorFilter,4
	BITDEF	srFlag,OpaqueEdge,5
	BITDEF	srFlag,TranspEdge,6
	BITDEF	srFlag,SharpTerm,7
	BITDEF	srFlag,DoubleSided,8
	BITDEF	srFlag,Additive,9

; Types de textures:

TexType_Unknown			equ	0
TexType_PlanarIM		equ	1
TexType_CylindricalIM		equ	2
TexType_SphericalIM		equ	3
TexType_CubicIM			equ	4
TexType_FrontProjectionIM	equ	5
TexType_Checkerboard		equ	6
TexType_Grid			equ	7
TexType_Dots			equ	8
TexType_Marble			equ	9
TexType_Wood			equ	10
TexType_Underwater		equ	11
TexType_FractalNoise		equ	12
TexType_BumpArray		equ	13
TexType_Crust			equ	14
TexType_Veins			equ	15


**************************************************************************
**************************************************************************
**									**
**			STRUCTURES DE MOUVEMENT				**
**									**
**************************************************************************
**************************************************************************


	STRUCTURE	MotionHeader,0
	UWORD	mh_MotionID		;Identificateur du type de mouvement (cf. ci-apr�s)
	UWORD	mh_NbrObjects		;Nombre d'objets influenc�s par le mouvement
	APTR	mh_Objects		;Table des objets
	LABEL	mh_motion		;Donn�es
	LABEL	mh_SIZE


;Types de mouvements:

MotionID_Unknown		equ	0
MotionID_absoluteRotation	equ	1

*************************************************
*	Rotation � 3 angles absolus		*
*************************************************

; Mesures des angles en RADIANS

	STRUCTURE	absoluteRotation,mh_SIZE
	FLOAT		ar_DeltaX	;Angle sur l'axe des x
	FLOAT		ar_DeltaY	;Angle sur l'axe des y
	FLOAT		ar_DeltaZ	;Angle sur l'axe des z
	LABEL		ar_SIZE

**************************************************************************
**************************************************************************
**									**
**		STRUCTURES DE DEFINITION PHYSICO-CHIMIQUE		**
**									**
**************************************************************************
**************************************************************************

;Note: Les mouvements dus � la force de gravit� seront calcul�s � partir
;	des donn�es physiques et chimiques.

*************************************************
*	Propri�t�s physique d'un atome		*
*************************************************

	STRUCTURE	AtomicProperties,0
	UWORD	Ap_Neutrons	;Nombre de neutrons
	UWORD	Ap_Charges	;Nombre de charges (Protons et �lectrons)
	FLOAT	Ap_Mass		;Masse atomique molaire en g/mol
	LABEL	AtomicProperties_SIZE

*************************************************
*	Constitution atomique d'un objet	*
*************************************************

;Tableau regroupant les quantit� d'atomes en pourcentage de chaque �l�ment
;constituant un objet.

	STRUCTURE	AtomicConstitution,0
	FLOAT	ac_H	;Hydrog�ne
	FLOAT	ac_He	;H�lium
	FLOAT	ac_Li	;Lithium
	FLOAT	ac_Be	;B�rylium
	FLOAT	ac_B	;Bore
	FLOAT	ac_C	;Carbone
	FLOAT	ac_N	;Azote
	FLOAT	ac_O	;Oxyg�ne
	FLOAT	ac_F	;Fluor
	FLOAT	ac_Ne	;N�on
	FLOAT	ac_Na	;Sodium
	FLOAT	ac_Mg	;Magn�sium
	FLOAT	ac_Al	;Aluminium
	FLOAT	ac_Si	;Silicium
	FLOAT	ac_P	;Phosphore
	FLOAT	ac_S	;Soufre
	FLOAT	ac_Cl	;Chlore
	FLOAT	ac_Ar	;Argon
	FLOAT	ac_K	;Potassium
	FLOAT	ac_Ca	;Calcium
	FLOAT	ac_Sc	;Scandium
	FLOAT	ac_Ti	;Titane
	FLOAT	ac_V	;Vanadium
	FLOAT	ac_Cr	;Chrome
	FLOAT	ac_Mn	;Mangan�se
	FLOAT	ac_Fe	;Fer
	FLOAT	ac_Co	;Cobalt
	FLOAT	ac_Ni	;Nickel
	FLOAT	ac_Cu	;Cuivre
	FLOAT	ac_Zn	;Zinc
	FLOAT	ac_Ga	;Gallium
	FLOAT	ac_Ge	;Germanium
	FLOAT	ac_As	;Arsenic
	FLOAT	ac_Se	;S�l�nium
	FLOAT	ac_Br	;Brome
	FLOAT	ac_Kr	;Krypton
	FLOAT	ac_Rb	;Rubinium
	FLOAT	ac_Sr	;Strontium
	FLOAT	ac_Y	;Yttrium
	FLOAT	ac_Zr	;Zirconium
	FLOAT	ac_Nb	;Niobium
	FLOAT	ac_Mo	;Molybd�ne
	FLOAT	ac_Tc	;Techn�tium
	FLOAT	ac_Ru	;Ruth�nium
	FLOAT	ac_Rh	;Rhodium
	FLOAT	ac_Pd	;Palladium
	FLOAT	ac_Ag	;Argent
	FLOAT	ac_Cd	;Cadmium
	FLOAT	ac_In	;Indium
	FLOAT	ac_Sn	;Etain
	FLOAT	ac_Sb	;Antimoine
	FLOAT	ac_Te	;Tellure
	FLOAT	ac_I	;Iode
	FLOAT	ac_Xe	;X�non
	FLOAT	ac_Cs	;C�sium
	FLOAT	ac_Ba	;Baryum
	FLOAT	ac_Hf	;Hafnium
	FLOAT	ac_Ta	;Tantale
	FLOAT	ac_W	;Tungst�ne
	FLOAT	ac_Re	;Rh�nium
	FLOAT	ac_Os	;Osmium
	FLOAT	ac_Ir	;Iridium
	FLOAT	ac_Pt	;Platine
	FLOAT	ac_Au	;Or
	FLOAT	ac_Hg	;Mercure
	FLOAT	ac_Tl	;Thallium
	FLOAT	ac_Pb	;Plomb
	FLOAT	ac_Bi	;Bismuth
	FLOAT	ac_Po	;Polonium
	FLOAT	ac_At	;Astate
	FLOAT	ac_Rn	;Radon
	FLOAT	ac_Fr	;Francium
	FLOAT	ac_Ra	;Radium
	FLOAT	ac_Ku	;Kurtchatovium
	FLOAT	ac_Ha	;Hahnium

	LABEL	ac_L	;Lanthanides (57 � 71 charges)
	FLOAT	ac_La	;Lanthane
	FLOAT	ac_Ce	;C�rium
	FLOAT	ac_Pr	;Pras�odyme
	FLOAT	ac_Nd	;N�odyme
	FLOAT	ac_Pm	;Prom�th�um
	FLOAT	ac_Sm	;Samarium
	FLOAT	ac_Eu	;Europium
	FLOAT	ac_Gd	;Gadolinium
	FLOAT	ac_Tb	;Terbium
	FLOAT	ac_Dy	;Dysprosium
	FLOAT	ac_Ho	;Holmium
	FLOAT	ac_Er	;Erbium
	FLOAT	ac_Tm	;Thulium
	FLOAT	ac_Yb	;Ytterbium
	FLOAT	ac_Lu	;Lut�nium

	LABEL	ac_A	;Actinides (89 � 103 charges)
	FLOAT	ac_Ac	;Actinium
	FLOAT	ac_Th	;Thorium
	FLOAT	ac_Pa	;Protactinium
	FLOAT	ac_U	;Uranium
	FLOAT	ac_Np	;Neptunium
	FLOAT	ac_Pu	;Plutonium
	FLOAT	ac_Am	;Am�ricium
	FLOAT	ac_Cm	;Curium
	FLOAT	ac_Bk	;Berk�lium
	FLOAT	ac_Cf	;Californium
	FLOAT	ac_Es	;Einsteinium
	FLOAT	ac_Fm	;Fermium
	FLOAT	ac_Md	;Mend�l�vium
	FLOAT	ac_No	;Nob�lium
	FLOAT	ac_Lw	;Lawrencium

	LABEL	AtomicConstitution_SIZE
	

*************************************************
*		Objet physique			*
*************************************************

	STRUCTURE	Physical,Geometric_SIZE
	STRUCT	phy_Ac,AtomicConstitution_SIZE
	FLOAT	phy_Density	;Densit� moyenne de l'objet
	FLOAT	phy_Volume	;Volume de l'objet en m�tre-cube
	FLOAT	phy_Mass	;Masse en Newton
	LABEL	Physical_SIZE
