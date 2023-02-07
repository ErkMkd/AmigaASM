;APS0000126E0000126E0000126E0000126E0000126E0000126E0000126E0000126E0000126E0000126E
*****************************************************************************************
*											*
*			STRUCTURE DU NOYAU DE L'INTERFACE - 14/4/2001			*
*											*
*****************************************************************************************

	STRUCTURE	InterfaceKernel,0

******** Centralisation des donn�es transit�es par les gadgets ********

	APTR	ik_PanelList		;Liste des panneaux
	ULONG	ik_CurrentPanel		;Identit� du panneau actif
	APTR	ik_Status		;Pointeur sur dernier message de status (chaine ASCII)

;	----Donn�es concernant l'�diteur de sc�ne:
;	Infos:
	APTR	ik_SceneName		;Nom de la scene
	ULONG	ik_SceneSize		;Place occup�e par la sc�ne en m�moire
	ULONG	ik_NumGeometrics	;Nombre d'objets g�om�triques dans la sc�ne
	ULONG	ik_NumCameras		;Nombre de cam�ras dans la sc�ne
	ULONG	ik_NumLights		;Nombre de sources lumineuses dans la sc�ne
	ULONG	ik_NumMotions		;Nombre de mouvements dans la sc�ne
	ULONG	ik_SceneNumPoints	;Nombre total de points dans la sc�ne
	ULONG	ik_SceneNumPolygons	;Nombre total de polygones dans la sc�ne
	ULONG	ik_SceneNumSurfaces	;Nombre total de surfaces dans la sc�ne
	ULONG	ik_SceneNumImages	;Nombre total d'images dans la sc�ne
;	Listes:
	APTR	ik_GeometricList	;Liste des objets g�om�triques
	APTR	ik_CameraList		;Liste des cam�ras
	APTR	ik_LightList		;Liste des sources lumineuses
	APTR	ik_MotionList		;Liste des mouvements
	APTR	ik_SceneSurfaceList	;Liste des surfaces
	APTR	ik_SceneImageList	;Liste des images
;	Pointeurs de listes:
	ULONG	ik_CurrentGeometric	;Num�ro de l'objet g�om�trique s�lectionn�
	ULONG	ik_CurrentCamera	;Num�ro de la cam�ra s�lectionn�
	ULONG	ik_CurrentLight		;Num�ro de la source lumineuse s�lectionn�e
	ULONG	ik_CurrentMotion	;Num�ro du mouvement s�lectionn�
	ULONG	ik_SceneCurrentImage	;Num�ro de l'image s�lectionn�e
;	Viewer de scene:
	ULONG	ik_DisplayScene		;Mode de rendu de la sc�ne (OFF,Friendly,Internal)
	ULONG	ik_RenderDepth		;Profondeur du rendu (Sert aussi pour le viewer
;					 d'objet individuel, dans l'�diteur d'objets Geo)
;	Viewer d'image:
	ULONG	ik_SceneDispImage	;Flag (TRUE=Affichage de l'image s�lectionn�e)
	ULONG	ik_SceneImageWidth	;Largeur de l'image s�lectionn�e
	ULONG	ik_SceneImageHeight	;Hauteur de l'image d�lectionn�e

;	----Donn�es concerant l'�diteur d'objets Geo:
;	Infos:
	APTR	ik_GeometricName	;Nom de l'objet
	ULONG	ik_GeometricSize	;Place occup� en m�moire par l'objet
	ULONG	ik_GeoNumPoints		;Nombre de points
	ULONG	ik_GeoNumPolygons	;Nombre de polygones	
	ULONG	ik_GeoNumSurfaces	;Nombre de surfaces
	ULONG	ik_GeoNumImages		;Nombre d'images
;	Listes:

	ULONG	ik_GeoSurfaceList	;Liste des surfaces
	ULONG	ik_ImageListGeo		;Liste des images
;	Pointeurs de listes:
	ULONG	ik_GeoCurrentImage	;Num�ro de l'image s�lectionn�e
	ULONG	ik_GeoCurrentSurface	;Num�ro de la surface s�lectionn�e
;	Viewer d'objet:
	ULONG	ik_DisplayGeo		;Mode de rendu du viewer d'objet individuel
	LONG	ik_AlphaX		;Angles de rotation de l'objet
	LONG	ik_AlphaY
	LONG	ik_AlphaZ
	ULONG	ik_AutoRotation		;Flag (TRUE=Autorotation de l'objet)
;	Viewer d'image:
	ULONG	ik_DispImageGeo		;Flag (TRUE=Affichage de l'image s�lectionn�e)
	ULONG	ik_GeoImageWidth	;Largeur de l'image s�lectionn�e
	ULONG	ik_GeoImageHeight	;Hauteur de l'image d�lectionn�e

;	---- Donn�es concernant l'�diteur de cam�ras:
;	Infos:
	APTR	ik_CameraName		;Nom de l'objet
	ULONG	ik_CameraSize		;Place occup�e en m�moire par l'objet
	ULONG	ik_XRadius		;Angle horizontal
	ULONG	ik_YRadius		;Angle vertical

;	---- Donn�es concernant l'�diteur de source lumineuses:
;	Infos:
	APTR	ik_LightName		;Nom de l'objet
	ULONG	ik_LightSize		;Place occup�e en m�moire par l'objet
	ULONG	ik_LightRadius		;Angle du faisceau
	ULONG	ik_LightRed		;Composante rouge
	ULONG	ik_LightGreen		;Composante verte
	ULONG	ik_LightBlue		;Composante bleue
	ULONG	ik_LightIntensity	;Intensit� lumineuse

;	---- Donn�es concernant l'�diteur de mouvements:
;	Infos:
	APTR	ik_MotionName		;Nom du mouvement
	ULONG	ik_MotionSize		;Place occup�e en m�moire par le mouvement	
;	Liste:
	APTR	ik_MotionTypeList	;Liste des types de mouvements
;	Pointeur de liste:
	ULONG	ik_CurrentMotionType	;Type de mouvement s�lectionn�

;	---- Donn�es concernant l'�diteur de surfaces:
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
