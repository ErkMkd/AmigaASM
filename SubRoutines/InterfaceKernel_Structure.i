;APS0000126E0000126E0000126E0000126E0000126E0000126E0000126E0000126E0000126E0000126E
*****************************************************************************************
*											*
*			STRUCTURE DU NOYAU DE L'INTERFACE - 14/4/2001			*
*											*
*****************************************************************************************

	STRUCTURE	InterfaceKernel,0

******** Centralisation des données transitées par les gadgets ********

	APTR	ik_PanelList		;Liste des panneaux
	ULONG	ik_CurrentPanel		;Identité du panneau actif
	APTR	ik_Status		;Pointeur sur dernier message de status (chaine ASCII)

;	----Données concernant l'éditeur de scène:
;	Infos:
	APTR	ik_SceneName		;Nom de la scene
	ULONG	ik_SceneSize		;Place occupée par la scène en mémoire
	ULONG	ik_NumGeometrics	;Nombre d'objets géométriques dans la scène
	ULONG	ik_NumCameras		;Nombre de caméras dans la scène
	ULONG	ik_NumLights		;Nombre de sources lumineuses dans la scène
	ULONG	ik_NumMotions		;Nombre de mouvements dans la scène
	ULONG	ik_SceneNumPoints	;Nombre total de points dans la scène
	ULONG	ik_SceneNumPolygons	;Nombre total de polygones dans la scène
	ULONG	ik_SceneNumSurfaces	;Nombre total de surfaces dans la scène
	ULONG	ik_SceneNumImages	;Nombre total d'images dans la scène
;	Listes:
	APTR	ik_GeometricList	;Liste des objets géométriques
	APTR	ik_CameraList		;Liste des caméras
	APTR	ik_LightList		;Liste des sources lumineuses
	APTR	ik_MotionList		;Liste des mouvements
	APTR	ik_SceneSurfaceList	;Liste des surfaces
	APTR	ik_SceneImageList	;Liste des images
;	Pointeurs de listes:
	ULONG	ik_CurrentGeometric	;Numéro de l'objet géométrique sélectionné
	ULONG	ik_CurrentCamera	;Numéro de la caméra sélectionné
	ULONG	ik_CurrentLight		;Numéro de la source lumineuse sélectionnée
	ULONG	ik_CurrentMotion	;Numéro du mouvement sélectionné
	ULONG	ik_SceneCurrentImage	;Numéro de l'image sélectionnée
;	Viewer de scene:
	ULONG	ik_DisplayScene		;Mode de rendu de la scène (OFF,Friendly,Internal)
	ULONG	ik_RenderDepth		;Profondeur du rendu (Sert aussi pour le viewer
;					 d'objet individuel, dans l'éditeur d'objets Geo)
;	Viewer d'image:
	ULONG	ik_SceneDispImage	;Flag (TRUE=Affichage de l'image sélectionnée)
	ULONG	ik_SceneImageWidth	;Largeur de l'image sélectionnée
	ULONG	ik_SceneImageHeight	;Hauteur de l'image délectionnée

;	----Données concerant l'éditeur d'objets Geo:
;	Infos:
	APTR	ik_GeometricName	;Nom de l'objet
	ULONG	ik_GeometricSize	;Place occupé en mémoire par l'objet
	ULONG	ik_GeoNumPoints		;Nombre de points
	ULONG	ik_GeoNumPolygons	;Nombre de polygones	
	ULONG	ik_GeoNumSurfaces	;Nombre de surfaces
	ULONG	ik_GeoNumImages		;Nombre d'images
;	Listes:

	ULONG	ik_GeoSurfaceList	;Liste des surfaces
	ULONG	ik_ImageListGeo		;Liste des images
;	Pointeurs de listes:
	ULONG	ik_GeoCurrentImage	;Numéro de l'image sélectionnée
	ULONG	ik_GeoCurrentSurface	;Numéro de la surface sélectionnée
;	Viewer d'objet:
	ULONG	ik_DisplayGeo		;Mode de rendu du viewer d'objet individuel
	LONG	ik_AlphaX		;Angles de rotation de l'objet
	LONG	ik_AlphaY
	LONG	ik_AlphaZ
	ULONG	ik_AutoRotation		;Flag (TRUE=Autorotation de l'objet)
;	Viewer d'image:
	ULONG	ik_DispImageGeo		;Flag (TRUE=Affichage de l'image sélectionnée)
	ULONG	ik_GeoImageWidth	;Largeur de l'image sélectionnée
	ULONG	ik_GeoImageHeight	;Hauteur de l'image délectionnée

;	---- Données concernant l'éditeur de caméras:
;	Infos:
	APTR	ik_CameraName		;Nom de l'objet
	ULONG	ik_CameraSize		;Place occupée en mémoire par l'objet
	ULONG	ik_XRadius		;Angle horizontal
	ULONG	ik_YRadius		;Angle vertical

;	---- Données concernant l'éditeur de source lumineuses:
;	Infos:
	APTR	ik_LightName		;Nom de l'objet
	ULONG	ik_LightSize		;Place occupée en mémoire par l'objet
	ULONG	ik_LightRadius		;Angle du faisceau
	ULONG	ik_LightRed		;Composante rouge
	ULONG	ik_LightGreen		;Composante verte
	ULONG	ik_LightBlue		;Composante bleue
	ULONG	ik_LightIntensity	;Intensité lumineuse

;	---- Données concernant l'éditeur de mouvements:
;	Infos:
	APTR	ik_MotionName		;Nom du mouvement
	ULONG	ik_MotionSize		;Place occupée en mémoire par le mouvement	
;	Liste:
	APTR	ik_MotionTypeList	;Liste des types de mouvements
;	Pointeur de liste:
	ULONG	ik_CurrentMotionType	;Type de mouvement sélectionné

;	---- Données concernant l'éditeur de surfaces:
;	Infos:
	APTR	ik_SurfaceName		;Nom de la surface
	ULONG	ik_SurfaceSize		;Taille de la surface
	ULONG	ik_SurfaceRed		;Composante rouge
	ULONG	ik_SurfaceGreen		;Composante verte
	ULONG	ik_SurfaceBlue		;Composante bleue
;	Attributs de la surface (flags):
	ULONG	ik_SurfLuminous
	ULONG	ik_SurfOutLine
	ULONG	ik_SurfSmoothing
	ULONG	ik_SurfColorHL
	ULONG	ik_SurfColorFilter
	ULONG	ik_SurfOpaqueEdge
	ULONG	ik_SurfTranspEdge
	ULONG	ik_SurfSharpTerm
	ULONG	ik_SurfDoubleSided
	ULONG	ik_SurfAdditive

	LABEL	InterfaceKernel_SIZE
