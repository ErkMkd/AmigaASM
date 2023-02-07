;APS00012B780000D7280000D7280000D7280000D7280000D7280000D7280000D7280000D7280000D728
	*****************************************************************
*								*
*	Routines d'initialisation des objets LightWave		*
*	Revision:7/4/2001					*
*****************************************************************

*****************************************************************
*	Transforme les données d'un fichier LWOB de manière	*
*	plus lisible.						*
*IN:	a0=@Données au format LWOB				*
*OUT:	Initialisation des données ci-dessous.			*
*****************************************************************

;Notes: -Pour libérer la mémoire allouée par "InitLWOB", appeler
;	 "RemoveLWOB".

;	-Les "detail polygons" sont transformés en polygones normaux.

;	-Cette routine utilise la structure "Surface" pour stocker les
;	 données relatives aux surfaces. Cependant, les structures
;	 "ImageData" ne sont pas créées, et les champs des structures
;	 "Surface" qui pointent normalement sur les structures "ImageData"
;	 sont simplement initialisés avec les numeros des images.
;	 Ce numéro correspond à la position du pointeur sur le nom du fichier
;	 contenu dans la table des noms des images "LWOB_ImageNamesTable"
;	 (le premier pointeur porte le n°1).

;	-Les numéros des types de textures ("Planar Image Map",etc) dans les
;	 structures "Surface" ne sont pas initialisés.

;	-Les arrêtes courbes (curves) sont ignorées.

******** Données en sortie ********

LWOB			dc.l	0
LWOB_Size		dc.l	0
LWOB_NbrPoints		dc.l	0
LWOB_NbrSurfaces	dc.l	0
LWOB_NbrCurves		dc.l	0
LWOB_NbrPolygons	dc.l	0
LWOB_NbrImages		dc.l	0
; Adresses des chunks principaux:
LWOB_PNTS	dc.l	0
LWOB_SRFS	dc.l	0
LWOB_POLS	dc.l	0
LWOB_CRVS	dc.l	0

; Tables:
LWOB_PolygonsTable	dc.l	0
LWOB_SurfaceNamesTable	dc.l	0
LWOB_SurfacesTable	dc.l	0
LWOB_CurvesTable	dc.l	0
LWOB_ImageNamesTable	dc.l	0
; Buffers des chaines de caractères:
LWOB_SurfaceNamesBuffer	dc.l	0

************ Routine ***************

InitLWOB
	movem.l		d0-a6,-(sp)
	move.l		a0,LWOB
;	---- Init taille de l'objet:
	move.l		LWOB(pc),a0
	move.l		4(a0),LWOB_Size
	addq.l		#8,LWOB_Size
;	---- Init PNTS chunk:
	move.l		#"PNTS",d0
	bsr.w		.SearchChunk
	move.l		a0,LWOB_PNTS
;	---- Init SRFS chunk:
	move.l		#"SRFS",d0
	bsr.w		.SearchChunk
	move.l		a0,LWOB_SRFS
;	---- Init POLS chunk:
	move.l		#"POLS",d0
	bsr.w		.SearchChunk
	move.l		a0,LWOB_POLS
;	---- Init CRVS chunk:
	move.l		#"CRVS",d0
	bsr.w		.SearchChunk
	move.l		a0,LWOB_CRVS
;	---- Calcul le nombre de points:
	tst.l		LWOB_PNTS(pc)
	beq.w		.end
	move.l		LWOB_PNTS(pc),a0
	move.l		4(a0),d0
	divu.w		#12,d0
	move.l		d0,LWOB_NbrPoints

;	---- Calcul le nombre de polygones:
.initPolygons
	tst.l		LWOB_POLS(pc)
	beq.s		.initSurfaces
	move.l		LWOB_POLS(pc),a0
	move.l		4(a0),d0
	clr.l		d1		;d1=compteur de polygones
	addq.w		#8,a0
	lea		(a0,d0.l),a1	;a1=adresse de fin
.ploop1	clr.l	d0
	move.w	(a0)+,d0	;vertices
	addq.l	#1,d1
	lea	(a0,d0.w*2),a0
	move.w	(a0)+,d0	;surface
	bpl.s	.noDetail1
	addq.w	#2,a0		;Si #surface<0, c'est un "detail polygon"
.noDetail1
	cmp.l	a0,a1
	bhi.s	.ploop1
	move.l		d1,LWOB_NbrPolygons
;	---- Allocation de la tables des polygones:
	move.l		LWOB_NbrPolygons(pc),d0
	lsl.l		#2,d0
	moveq		#MEMF_FAST,d1
	CALLEXEC	AllocVec
	tst.l		d0
	beq.w		.e_Memory
	move.l		d0,LWOB_PolygonsTable
;	---- Init la table des polygones:
	move.l		LWOB_POLS(pc),a0
	move.l		LWOB_PolygonsTable(pc),a1
	move.l		LWOB_NbrPolygons(pc),d0
	addq.w		#8,a0
.ploop2	move.l	a0,(a1)+
	move.w	(a0)+,d1	;vertices
	lea	(a0,d1.w*2),a0
	move.w	(a0)+,d1	;d1=Surface
	bpl.s	.noDetail2
	neg.w	d1		;Si #Surface<0, c'est un "detail polygon"...
	move.w	d1,-2(a0)	;On inverse le signe du numéro de la surface,
	addq.w	#2,a0		;donc le "detail polygon" devient un polygone normal
.noDetail2
	subq.l	#1,d0
	bne.s	.ploop2

;	---- Copie les noms des surfaces:
.initSurfaces
	tst.l		LWOB_SRFS(pc)
	beq.w		.initCurves
	move.l		LWOB_SRFS(pc),a2
	move.l		4(a2),d0
	move.l		#MEMF_FAST,d1
	CALLEXEC	AllocVec
	tst.l		d0
	beq.w		.e_Memory
	move.l		d0,LWOB_SurfaceNamesBuffer
	move.l		d0,a0
	move.l		4(a2),d0
	addq.l		#8,a2
.copySN	move.b		(a2)+,(a0)+
	subq.l		#1,d0
	bne.s		.copySN
;	---- Calcul le nombre de surfaces:
	move.l		LWOB_SRFS(pc),a0
	move.l		4(a0),d0
	addq.l		#8,a0
	lea		(a0,d0.l),a1
	clr.l		d0	;d0=compteur de surfaces
.sloop1	tst.b	(a0)+
	bne.s	.sloop1
	addq.l	#1,d0
	tst.b	(a0)
	bne.s	.even
	addq.l	#1,a0
.even	cmp.l	a0,a1
	bhi.s	.sloop1
	move.l		d0,LWOB_NbrSurfaces
;	---- Allocation de la table des noms des surfaces:
;	La table des noms des surfaces sert surtout pour
;	initialiser les surfaces (opération suivante).
	move.l		LWOB_NbrSurfaces(pc),d0
	beq.w		.initCurves
	lsl.l		#2,d0
	moveq		#MEMF_FAST,d1
	CALLEXEC	AllocVec
	tst.l		d0
	beq.w		.e_Memory
	move.l		d0,LWOB_SurfaceNamesTable
;	---- Init de la table des noms des surfaces:
	move.l		LWOB_SurfaceNamesBuffer(pc),a0
	move.l		LWOB_SurfaceNamesTable(pc),a1
	move.l		LWOB_NbrSurfaces(pc),d0
.sloop2	move.l	a0,(a1)+
.nxt1	tst.b	(a0)+
	bne.s	.nxt1
	tst.b	(a0)
	bne.s	.nxt2
	addq.l	#1,a0
.nxt2	subq.l	#1,d0
	bne.s	.sloop2
;	---- Allocation de la table et des structures des surfaces:
	move.l		LWOB_NbrSurfaces(pc),d0
	move.l		d0,d1
	lsl.l		#2,d0
	mulu.l		#surf_SIZE,d1
	add.l		d1,d0
	move.l		#MEMF_FAST!MEMF_CLEAR,d1
	CALLEXEC	AllocVec
	tst.l		d0
	beq.w		.e_Memory
	move.l		d0,LWOB_SurfacesTable
;	---- Initialisation des surfaces:
;Note: Les champs réservés aux pointeurs sur les structures "ImageData" sont
;	ici initialisés avec un pointeur sur le nom du fichier utilisé pour l'image.
;	Ceci facilite la création de la table des noms des images.

	move.l		LWOB_SurfaceNamesTable(pc),a1
	move.l		LWOB_SurfacesTable(pc),a2
	move.l		LWOB_NbrSurfaces(pc),d1
	lea		(a2,d1.l*4),a3		;a3=Pointeur sur structure "Surface"
.surfLoop
	move.l	a3,(a2)+
	move.l	(a1),a0
	bsr.w	.SearchSurf
	cmp.l	#0,a0
	beq.w	.e_corrupted
	move.l	a0,a5
	move.l	(a1)+,surf_Name(a3)
;	Couleur:
.colr	move.l	a5,a0
	move.l	#"COLR",d0
	bsr.w	.SearchSURFSubChunk
	cmp.l	#0,a0
	beq.s	.flag
	move.l	6(a0),surf_Color(a3)
;	Flags:
.flag	move.l	a5,a0
	move.l	#"FLAG",d0
	bsr.w	.SearchSURFSubChunk
	cmp.l	#0,a0
	beq.s	.lumi
	move.w	6(a0),surf_Flags(a3)
;	Luminosity:
.lumi	move.l	a5,a0
	move.l	#"LUMI",d0
	bsr.w	.SearchSURFSubChunk
	cmp.l	#0,a0
	beq.s	.diff
	move.w	6(a0),surf_Lumi(a3)
;	Diffuse:
.diff	move.l	a5,a0
	move.l	#"DIFF",d0
	bsr.w	.SearchSURFSubChunk
	cmp.l	#0,a0
	beq.s	.spec
	move.w	6(a0),surf_Diff(a3)
;	Specular:
.spec	move.l	a5,a0
	move.l	#"SPEC",d0
	bsr.w	.SearchSURFSubChunk
	cmp.l	#0,a0
	beq.s	.refl
	move.w	6(a0),surf_Spec(a3)
;	Reflexion:
.refl	move.l	a5,a0
	move.l	#"REFL",d0
	bsr.w	.SearchSURFSubChunk
	cmp.l	#0,a0
	beq.s	.tran
	move.w	6(a0),surf_Refl(a3)
;	Transparency:
.tran	move.l	a5,a0
	move.l	#"TRAN",d0
	bsr.w	.SearchSURFSubChunk
	cmp.l	#0,a0
	beq.s	.glos
	move.w	6(a0),surf_Tran(a3)
;	Glossiness:
.glos	move.l	a5,a0
	move.l	#"GLOS",d0
	bsr.w	.SearchSURFSubChunk
	cmp.l	#0,a0
	beq.s	.rimg
	move.w	6(a0),surf_Glos(a3)
;	Reflexion map:
.rimg	move.l	a5,a0
	move.l	#"RIMG",d0
	bsr.w	.SearchSURFSubChunk
	cmp.l	#0,a0
	beq.s	.rsan
	move.l	a0,surf_Rimg(a3)
	addq.l	#6,surf_Rimg(a3)
;	Reflexion map seam angle:
.rsan	move.l	a5,a0
	move.l	#"RSAN",d0
	bsr.w	.SearchSURFSubChunk
	cmp.l	#0,a0
	beq.s	.rind
	move.l	6(a0),surf_Rsan(a3)
;	Refractive index:
.rind	move.l	a5,a0
	move.l	#"RIND",d0
	bsr.w	.SearchSURFSubChunk
	cmp.l	#0,a0
	beq.s	.edge
	move.l	6(a0),surf_Rind(a3)
;	Edge transparency:
.edge	move.l	a5,a0
	move.l	#"EDGE",d0
	bsr.w	.SearchSURFSubChunk
	cmp.l	#0,a0
	beq.s	.sman
	move.l	6(a0),surf_Edge(a3)
;	Smooth maximum angle:
.sman	move.l	a5,a0
	move.l	#"SMAN",d0
	bsr.w	.SearchSURFSubChunk
	cmp.l	#0,a0
	beq.s	.ctex
	move.l	6(a0),surf_Sman(a3)
;	Color texture:
.ctex	move.l	a5,a0
	move.l	#"CTEX",d0
	bsr.w	.SearchSURFSubChunk
	cmp.l	#0,a0
	beq.w	.dtex
	move.l	a0,a4
	addq.l	#6,a0
	move.l	a0,surf_Ctex(a3)
.ctex_timg
	move.l	#"TIMG",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.ctex_tflg
	addq.l	#6,a0
	move.l	a0,surf_CtexTimg(a3)
.ctex_tflg
	move.l	#"TFLG",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.ctex_tsiz
	move.w	6(a0),surf_CtexTflg(a3)
.ctex_tsiz
	move.l	#"TSIZ",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.ctex_tctr
	addq.l	#6,a0
	move.l	(a0)+,surf_CtexTsiz_X(a3)
	move.l	(a0)+,surf_CtexTsiz_Y(a3)
	move.l	(a0)+,surf_CtexTsiz_Z(a3)
.ctex_tctr
	move.l	#"TCTR",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.ctex_tfal
	addq.l	#6,a0
	move.l	(a0)+,surf_CtexTctr_X(a3)
	move.l	(a0)+,surf_CtexTctr_Y(a3)
	move.l	(a0)+,surf_CtexTctr_Z(a3)
.ctex_tfal
	move.l	#"TFAL",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.ctex_tvel
	addq.l	#6,a0
	move.l	(a0)+,surf_CtexTfal_X(a3)
	move.l	(a0)+,surf_CtexTfal_Y(a3)
	move.l	(a0)+,surf_CtexTfal_Z(a3)
.ctex_tvel
	move.l	#"TVEL",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.ctex_tclr
	addq.l	#6,a0
	move.l	(a0)+,surf_CtexTvel_X(a3)
	move.l	(a0)+,surf_CtexTvel_Y(a3)
	move.l	(a0)+,surf_CtexTvel_Z(a3)
.ctex_tclr
	move.l	#"TCLR",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.dtex
	move.l	6(a0),surf_CtexTclr(a3)
;	Diffuse texture:
.dtex	move.l	a5,a0
	move.l	#"DTEX",d0
	bsr.w	.SearchSURFSubChunk
	cmp.l	#0,a0
	beq.w	.stex
	move.l	a0,a4
	addq.l	#6,a0
	move.l	a0,surf_Dtex(a3)
.dtex_timg
	move.l	#"TIMG",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.dtex_tflg
	addq.l	#6,a0
	move.l	a0,surf_DtexTimg(a3)
.dtex_tflg
	move.l	#"TFLG",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.dtex_tsiz
	move.w	6(a0),surf_DtexTflg(a3)
.dtex_tsiz
	move.l	#"TSIZ",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.dtex_tctr
	addq.l	#6,a0
	move.l	(a0)+,surf_DtexTsiz_X(a3)
	move.l	(a0)+,surf_DtexTsiz_Y(a3)
	move.l	(a0)+,surf_DtexTsiz_Z(a3)
.dtex_tctr
	move.l	#"TCTR",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.dtex_tfal
	addq.l	#6,a0
	move.l	(a0)+,surf_DtexTctr_X(a3)
	move.l	(a0)+,surf_DtexTctr_Y(a3)
	move.l	(a0)+,surf_DtexTctr_Z(a3)
.dtex_tfal
	move.l	#"TFAL",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.dtex_tvel
	addq.l	#6,a0
	move.l	(a0)+,surf_DtexTfal_X(a3)
	move.l	(a0)+,surf_DtexTfal_Y(a3)
	move.l	(a0)+,surf_DtexTfal_Z(a3)
.dtex_tvel
	move.l	#"TVEL",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.dtex_tval
	addq.l	#6,a0
	move.l	(a0)+,surf_DtexTvel_X(a3)
	move.l	(a0)+,surf_DtexTvel_Y(a3)
	move.l	(a0)+,surf_DtexTvel_Z(a3)
.dtex_tval
	move.l	#"TVAL",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.stex
	move.w	6(a0),surf_DtexTval(a3)
;	Specular texture:
.stex	move.l	a5,a0
	move.l	#"STEX",d0
	bsr.w	.SearchSURFSubChunk
	cmp.l	#0,a0
	beq.w	.rtex
	move.l	a0,a4
	addq.l	#6,a0
	move.l	a0,surf_Stex(a3)
.stex_timg
	move.l	#"TIMG",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.stex_tflg
	addq.l	#6,a0
	move.l	a0,surf_StexTimg(a3)
.stex_tflg
	move.l	#"TFLG",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.stex_tsiz
	move.w	6(a0),surf_StexTflg(a3)
.stex_tsiz
	move.l	#"TSIZ",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.stex_tctr
	addq.l	#6,a0
	move.l	(a0)+,surf_StexTsiz_X(a3)
	move.l	(a0)+,surf_StexTsiz_Y(a3)
	move.l	(a0)+,surf_StexTsiz_Z(a3)
.stex_tctr
	move.l	#"TCTR",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.stex_tfal
	addq.l	#6,a0
	move.l	(a0)+,surf_StexTctr_X(a3)
	move.l	(a0)+,surf_StexTctr_Y(a3)
	move.l	(a0)+,surf_StexTctr_Z(a3)
.stex_tfal
	move.l	#"TFAL",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.stex_tvel
	addq.l	#6,a0
	move.l	(a0)+,surf_StexTfal_X(a3)
	move.l	(a0)+,surf_StexTfal_Y(a3)
	move.l	(a0)+,surf_StexTfal_Z(a3)
.stex_tvel
	move.l	#"TVEL",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.stex_tval
	addq.l	#6,a0
	move.l	(a0)+,surf_StexTvel_X(a3)
	move.l	(a0)+,surf_StexTvel_Y(a3)
	move.l	(a0)+,surf_StexTvel_Z(a3)
.stex_tval
	move.l	#"TVAL",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.rtex
	move.w	6(a0),surf_StexTval(a3)
;	Reflection texture:
.rtex	move.l	a5,a0
	move.l	#"RTEX",d0
	bsr.w	.SearchSURFSubChunk
	cmp.l	#0,a0
	beq.w	.ttex
	move.l	a0,a4
	addq.l	#6,a0
	move.l	a0,surf_Rtex(a3)
.rtex_timg
	move.l	#"TIMG",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.rtex_tflg
	addq.l	#6,a0
	move.l	a0,surf_RtexTimg(a3)
.rtex_tflg
	move.l	#"TFLG",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.rtex_tsiz
	move.w	6(a0),surf_RtexTflg(a3)
.rtex_tsiz
	move.l	#"TSIZ",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.rtex_tctr
	addq.l	#6,a0
	move.l	(a0)+,surf_RtexTsiz_X(a3)
	move.l	(a0)+,surf_RtexTsiz_Y(a3)
	move.l	(a0)+,surf_RtexTsiz_Z(a3)
.rtex_tctr
	move.l	#"TCTR",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.rtex_tfal
	addq.l	#6,a0
	move.l	(a0)+,surf_RtexTctr_X(a3)
	move.l	(a0)+,surf_RtexTctr_Y(a3)
	move.l	(a0)+,surf_RtexTctr_Z(a3)
.rtex_tfal
	move.l	#"TFAL",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.rtex_tvel
	addq.l	#6,a0
	move.l	(a0)+,surf_RtexTfal_X(a3)
	move.l	(a0)+,surf_RtexTfal_Y(a3)
	move.l	(a0)+,surf_RtexTfal_Z(a3)
.rtex_tvel
	move.l	#"TVEL",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.rtex_tval
	addq.l	#6,a0
	move.l	(a0)+,surf_RtexTvel_X(a3)
	move.l	(a0)+,surf_RtexTvel_Y(a3)
	move.l	(a0)+,surf_RtexTvel_Z(a3)
.rtex_tval
	move.l	#"TVAL",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.ttex
	move.w	6(a0),surf_RtexTval(a3)
;	Transparency texture:
.ttex	move.l	a5,a0
	move.l	#"TTEX",d0
	bsr.w	.SearchSURFSubChunk
	cmp.l	#0,a0
	beq.w	.btex
	move.l	a0,a4
	addq.l	#6,a0
	move.l	a0,surf_Ttex(a3)
.ttex_timg
	move.l	#"TIMG",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.ttex_tflg
	addq.l	#6,a0
	move.l	a0,surf_TtexTimg(a3)
.ttex_tflg
	move.l	#"TFLG",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.ttex_tsiz
	move.w	6(a0),surf_TtexTflg(a3)
.ttex_tsiz
	move.l	#"TSIZ",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.ttex_tctr
	addq.l	#6,a0
	move.l	(a0)+,surf_TtexTsiz_X(a3)
	move.l	(a0)+,surf_TtexTsiz_Y(a3)
	move.l	(a0)+,surf_TtexTsiz_Z(a3)
.ttex_tctr
	move.l	#"TCTR",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.ttex_tfal
	addq.l	#6,a0
	move.l	(a0)+,surf_TtexTctr_X(a3)
	move.l	(a0)+,surf_TtexTctr_Y(a3)
	move.l	(a0)+,surf_TtexTctr_Z(a3)
.ttex_tfal
	move.l	#"TFAL",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.ttex_tvel
	addq.l	#6,a0
	move.l	(a0)+,surf_TtexTfal_X(a3)
	move.l	(a0)+,surf_TtexTfal_Y(a3)
	move.l	(a0)+,surf_TtexTfal_Z(a3)
.ttex_tvel
	move.l	#"TVEL",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.ttex_tval
	addq.l	#6,a0
	move.l	(a0)+,surf_TtexTvel_X(a3)
	move.l	(a0)+,surf_TtexTvel_Y(a3)
	move.l	(a0)+,surf_TtexTvel_Z(a3)
.ttex_tval
	move.l	#"TVAL",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.btex
	move.w	6(a0),surf_TtexTval(a3)
;	Bump texture:
.btex	move.l	a5,a0
	move.l	#"BTEX",d0
	bsr.w	.SearchSURFSubChunk
	cmp.l	#0,a0
	beq.w	.nextSurface
	move.l	a0,a4
	addq.l	#6,a0
	move.l	a0,surf_Btex(a3)
.btex_timg
	move.l	#"TIMG",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.btex_tflg
	addq.l	#6,a0
	move.l	a0,surf_BtexTimg(a3)
.btex_tflg
	move.l	#"TFLG",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.btex_tsiz
	move.w	6(a0),surf_BtexTflg(a3)
.btex_tsiz
	move.l	#"TSIZ",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.btex_tctr
	addq.l	#6,a0
	move.l	(a0)+,surf_BtexTsiz_X(a3)
	move.l	(a0)+,surf_BtexTsiz_Y(a3)
	move.l	(a0)+,surf_BtexTsiz_Z(a3)
.btex_tctr
	move.l	#"TCTR",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.btex_tfal
	addq.l	#6,a0
	move.l	(a0)+,surf_BtexTctr_X(a3)
	move.l	(a0)+,surf_BtexTctr_Y(a3)
	move.l	(a0)+,surf_BtexTctr_Z(a3)
.btex_tfal
	move.l	#"TFAL",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.btex_tvel
	addq.l	#6,a0
	move.l	(a0)+,surf_BtexTfal_X(a3)
	move.l	(a0)+,surf_BtexTfal_Y(a3)
	move.l	(a0)+,surf_BtexTfal_Z(a3)
.btex_tvel
	move.l	#"TVEL",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.btex_tamp
	addq.l	#6,a0
	move.l	(a0)+,surf_BtexTvel_X(a3)
	move.l	(a0)+,surf_BtexTvel_Y(a3)
	move.l	(a0)+,surf_BtexTvel_Z(a3)
.btex_tamp
	move.l	#"TAMP",d0
	move.l	a4,a0
	bsr.w	.SearchTEXSubChunk
	cmp.l	#0,a0
	beq.s	.nextSurface
	move.l	6(a0),surf_BtexTamp(a3)
;	Surface suivante:
.nextSurface
	lea	surf_SIZE(a3),a3
	subq.l	#1,d1
	bne.w	.surfLoop

;	---- Création de la table des noms des images:
;Notes:	-On compte d'abord le nombre de noms d'images contenus dans
;	 les données LWOB, puis on les place dans une table provisoire.
;	-Ensuite, on supprime dans cette table les noms identiques
;	 (mêmes images utilisées plusieurs fois) pour ne garder
;	 qu'un seul exemplaire de chaque nom.
;	-Puis on compte le nombre de noms restants, pour créer
;	 et initialiser la table finale des noms des images.
;	-Enfin, on initialise les champs "surf_.texTimg" avec les numéros
;	 des positions des noms des images dans la table finale (ces numéros
;	 commencent à 1).

.CreateImageNamesTable
;	Premier comptage:
	move.l	LWOB_NbrSurfaces(pc),d0
	move.l	LWOB_SurfacesTable(pc),a0
	clr.l	d2	;d2=compteur de nombre de noms d'images
.c1	move.l	(a0)+,a1
.Rimg	tst.l	surf_Rimg(a1)
	beq.s	.cimg
	addq.l	#1,d2
.cimg	tst.l	surf_CtexTimg(a1)
	beq.s	.dimg
	addq.l	#1,d2
.dimg	tst.l	surf_DtexTimg(a1)
	beq.s	.simg
	addq.l	#1,d2
.simg	tst.l	surf_StexTimg(a1)
	beq.w	.rImg
	addq.l	#1,d2
.rImg	tst.l	surf_RtexTimg(a1)
	beq.s	.timg
	addq.l	#1,d2
.timg	tst.l	surf_TtexTimg(a1)
	beq.s	.bimg
	addq.l	#1,d2
.bimg	tst.l	surf_BtexTimg(a1)
	beq.s	.next
	addq.l	#1,d2
.next	subq.l	#1,d0
	bne.s	.c1
;	Allocation table provisoire:
	tst.l		d2
	beq.w		.initCurves
	move.l		d2,.imagesCptr
	move.l		d2,d0
	lsl.l		#2,d0
	move.l		#MEMF_FAST,d1
	CALLEXEC	AllocVec
	tst.l		d0
	beq.w		.e_Memory
	move.l		d0,.imagesTable
;	Stockage des pointeurs provisoires:
	move.l	.imagesTable(pc),a2
	move.l	LWOB_NbrSurfaces(pc),d0
	move.l	LWOB_SurfacesTable(pc),a0
.stock	move.l	(a0)+,a1
.Rimg0	move.l	surf_Rimg(a1),d1
	beq.s	.cimg0
	move.l	d1,(a2)+
.cimg0	move.l	surf_CtexTimg(a1),d1
	beq.s	.dimg0
	move.l	d1,(a2)+
.dimg0	move.l	surf_DtexTimg(a1),d1
	beq.s	.simg0
	move.l	d1,(a2)+
.simg0	move.l	surf_StexTimg(a1),d1
	beq.s	.rimg0
	move.l	d1,(a2)+
.rimg0	move.l	surf_RtexTimg(a1),d1
	beq.s	.timg0
	move.l	d1,(a2)+
.timg0	move.l	surf_TtexTimg(a1),d1
	beq.s	.bimg0
	move.l	d1,(a2)+
.bimg0	move.l	surf_BtexTimg(a1),d1
	beq.s	.next0
	move.l	d1,(a2)+
.next0	subq.l	#1,d0
	bne.s	.stock
;	Supprime les noms identiques,et compte les noms différents:
	move.l	.imagesTable(pc),a2
	move.l	.imagesCptr(pc),d0
	move.l	d0,d2	;d2=compteur des noms différents
.suppr	move.l	(a2)+,d1
	beq.s	.nstr1
	move.l	d1,a0
	move.l	a2,a3
	move.l	d0,d1
	subq.l	#1,d1
	beq.s	.finSup
.tststr	move.l	(a3)+,a1
	bsr.w	CmpStrings
	bcs.s	.nstr2
	clr.l	-4(a3)	;Suppression (pointeur à 0)
	subq.l	#1,d2
.nstr2	subq.l	#1,d1
	bne.s	.tststr
.nstr1	subq.l	#1,d0
	bne.s	.suppr
.finSup	move.l	d2,LWOB_NbrImages
;	Allocation de la table finale:
	move.l		LWOB_NbrImages(pc),d0
	lsl.l		#2,d0
	move.l		#MEMF_FAST,d1
	CALLEXEC	AllocVec
	tst.l		d0
	beq.w		.e_imagesTable
	move.l		d0,LWOB_ImageNamesTable
;	Allocation/Copiage des noms des images:
	move.l	.imagesTable(pc),a2
	move.l	LWOB_ImageNamesTable(pc),a3
	move.l	.imagesCptr(pc),d2
.cstr	move.l		(a2)+,d0
	beq.s		.nstr
	move.l		d0,a0
	move.l		d0,a4
	bsr.w		.StringLenght
	move.w		d0,d3
	move.l		#MEMF_FAST!MEMF_CLEAR,d1
	CALLEXEC	AllocVec
	tst.l		d0
	beq.w		.e_imagesTable
	move.l		d0,(a3)+
	move.l		d0,a5
	subq.w		#1,d3
.copy	move.b		(a4)+,(a5)+
	dbra		d3,.copy
.nstr	subq.l		#1,d2
	bne.s		.cstr
;	Suppression de la table provisoire:
	move.l		.imagesTable(pc),a1
	CALLEXEC	FreeVec
;	Initialisation des numéros des images dans les structures "Surface":
	move.l	LWOB_SurfacesTable(pc),a1
	move.l	LWOB_NbrSurfaces(pc),d1
.reint	move.l	(a1)+,a2
.Rimg1	move.l	surf_Rimg(a2),d0
	beq.s	.cimg1
	move.l	d0,a0
	bsr.w	.GetImageNumber
	move.l	d0,surf_Rimg(a2)
.cimg1	move.l	surf_CtexTimg(a2),d0
	beq.s	.dimg1
	move.l	d0,a0
	bsr.w	.GetImageNumber
	move.l	d0,surf_CtexTimg(a2)
.dimg1	move.l	surf_DtexTimg(a2),d0
	beq.s	.simg1
	move.l	d0,a0
	bsr.w	.GetImageNumber
	move.l	d0,surf_DtexTimg(a2)
.simg1	move.l	surf_StexTimg(a2),d0
	beq.s	.rimg1
	move.l	d0,a0
	bsr.w	.GetImageNumber
	move.l	d0,surf_StexTimg(a2)
.rimg1	move.l	surf_RtexTimg(a2),d0
	beq.s	.timg1
	move.l	d0,a0
	bsr.w	.GetImageNumber
	move.l	d0,surf_RtexTimg(a2)
.timg1	move.l	surf_TtexTimg(a2),d0
	beq.s	.bimg1
	move.l	d0,a0
	bsr.w	.GetImageNumber
	move.l	d0,surf_TtexTimg(a2)
.bimg1	move.l	surf_BtexTimg(a2),d0
	beq.s	.next1
	move.l	d0,a0
	bsr.w	.GetImageNumber
	move.l	d0,surf_BtexTimg(a2)
.next1	subq.l	#1,d1
	bne.s	.reint


;	---- Calcul le nombre de polygones courbes:
;Note:	Ce sera pas inclus avant un petit moment.
.initCurves


;	---- Zee End:
.end	movem.l	(sp)+,d0-a6
	clc
	rts

;******** Recherche un chunk ********
;IN:	d0=Chunk name
;OUT:	a0=@Chunk (0=Chunk inexistant)
.SearchChunk
	move.l	d1,-(sp)
	move.l	LWOB(pc),a0
	move.l	LWOB_Size(pc),d1
	lsr.l	d1
.loop	cmp.l	(a0),d0
	beq.s	.found
	addq.l	#2,a0
	subq.l	#1,d1
	bgt.s	.loop
	sub.l	a0,a0
.found	move.l	(sp)+,d1
	rts

;******** Recherche d'un sub-chunk d'une surface ********
;IN:	a0=@SURF chunk
;	d0=Chunk name
;OUT:	a0=@Sub-chunk (0=Chunk inexistant)
.SearchSURFSubChunk
	move.l	d1,-(sp)
	move.l	4(a0),d1
	lsr.l	d1
	bra.s	.loop

;******** Recherche d'un sub-chunk d'une texture ********
;IN:	a0=@Texture chunk
;	d0=Chunk name (0=Chunk inexistant)
.SearchTEXSubChunk
	movem.l	d1/a1,-(sp)
	move.l	LWOB(pc),a1
	add.l	LWOB_Size(pc),a1
.lpTEX	addq.l	#2,a0
	move.l	(a0),d1
	cmp.l	d1,d0
	beq.s	.fndTEX
	and.l	#$00FFFFFF,d1
	cmp.l	#"TEX",d1
	beq.s	.notFnd
	cmp.l	a0,a1
	bgt.s	.lpTEX
.notFnd	sub.l	a0,a0
.fndTEX	movem.l	(sp)+,d1/a1
	rts


;******** Recherche d'une surface ********
;IN:	a0=@Surface name
;OUT:	a0=@SURF chunk (0=erreur)
.SearchSurf
	movem.l	d0/a1-a3,-(sp)
	move.l	LWOB(pc),a1
	move.l	LWOB_Size(pc),d0
	lsr.l	d0
.loop0	cmp.l	#"SURF",(a1)
	beq.s	.tstName
	addq.l	#2,a1
	subq.l	#1,d0
	bgt.s	.loop0
.error	sub.l	a0,a0
	bra.s	.end0
.tstName
	addq.l	#8,a1
	subq.l	#4,d0
	ble.s	.error
	move.l	a0,a2
	move.l	a1,a3
.loop1	cmpm.b	(a2)+,(a3)+
	bne.s	.loop0
	tst.b	-1(a2)
	bne.s	.loop1
	move.l	a1,a0
	subq.l	#8,a0
.end0	movem.l	(sp)+,d0/a1-a3
	rts

;******** Calcul la taille d'une chaine ascii ********
;Note: Le 0 final compte pour un caractère
;IN:	a0=@String
;OUT:	d0=lenght
.StringLenght
	move.l	a0,-(sp)
	moveq	#1,d0
.loop2	tst.b	(a0)+
	beq.s	.ok
	addq.w	#1,d0
	bra.s	.loop2
.ok	move.l	(sp)+,a0
	rts

;******** Cherche le numéro d'une image dans la table des images ********
;IN:	a0=@String (nom de l'image)
;OUT:	d0=Numéro de l'image (Flag C=TRUE si le numéro n'a pas été trouvé)
;	(La première image est la n°1, et pas la n°0)
.GetImageNumber
	movem.l	a1/a2,-(sp)
	move.l	LWOB_ImageNamesTable(pc),a2
	move.l	LWOB_NbrImages(pc),d0
	lea	(a2,d0.l*4),a2
.INLoop	move.l	-(a2),a1
	bsr.w	CmpStrings
	bcc.s	.INFnd
	subq.l	#1,d0
	bne.s	.INLoop
	movem.l	(sp)+,a1/a2
	stc
	rts
.INFnd	movem.l	(sp)+,a1/a2
	clc
	rts

;******** Erreurs ********
.e_Memory
	bsr.w		RemoveLWOB
	movem.l		(sp)+,d0-a6
	moveq		#Not_enough_memory,d0
	stc
	rts

.e_corrupted
	bsr.w		RemoveLWOB
	movem.l		(sp)+,d0-a6
	moveq		#File_corrupted,d0
	stc
	rts

.e_imagesTable
	move.l		.imagesTable(pc),a1
	CALLEXEC	FreeVec
	bsr.w		RemoveLWOB
	movem.l		(sp)+,d0-a6
	moveq		#Not_enough_memory,d0
	stc
	rts

;******** Données ********

.imagesTable		dc.l	0
.imagesCptr		dc.l	0


*********************************************************
*	Compare deux chaines ascii			*
*IN:	a0=@String1, a1=@String2 (Terminées par un 0)	*
*OUT:	Flag C=TRUE si les chaines sont différentes	*
*********************************************************

CmpStrings
	movem.l	a0/a1,-(sp)
.loop3	cmpm.b	(a0)+,(a1)+
	bne.s	.CTrue
	tst.b	-1(a0)
	bne.s	.loop3
	movem.l	(sp)+,a0/a1
	clc
	rts
.CTrue	movem.l	(sp)+,a0/a1
	stc
	rts

*************************************************
*	Destruction d'un objet LWOB		*
*************************************************
RemoveLWOB
	movem.l		d0-d2/a0-a2/a6,-(sp)
;	Destruction pointeurs et tables:
.pols	clr.l		LWOB_NbrPolygons
	move.l		LWOB_PolygonsTable(pc),d0
	beq.s		.crvs
	move.l		d0,a1
	CALLEXEC	FreeVec
.crvs	clr.l		LWOB_NbrCurves
	move.l		LWOB_CurvesTable(pc),d0
	beq.s		.snames
	move.l		d0,a1
	CALLEXEC	FreeVec
.snames	clr.l		LWOB_NbrSurfaces
	move.l		LWOB_SurfaceNamesBuffer(pc),d0
	beq.s		.sntab
	move.l		d0,a1
	CALLEXEC	FreeVec
.sntab	move.l		LWOB_SurfaceNamesTable(pc),d0
	beq.s		.surf
	move.l		d0,a1
	CALLEXEC	FreeVec
.surf	move.l		LWOB_SurfacesTable(pc),d0
	beq.s		.inames
	move.l		d0,a1
	CALLEXEC	FreeVec
.inames	move.l		LWOB_NbrImages(pc),d2
	beq.s		.kill
	clr.l		LWOB_NbrImages
	move.l		LWOB_ImageNamesTable(pc),d0
	beq.s		.kill
	move.l		d0,a2
.l0	move.l		(a2)+,d0
	beq.s		.next
	move.l		d0,a1
	CALLEXEC	FreeVec
.next	subq.l		#1,d2
	bne.s		.l0
.intab	move.l		LWOB_ImageNamesTable(pc),d0
	beq.s		.kill
	move.l		d0,a1
	CALLEXEC	FreeVec
.kill	clr.l		LWOB_PNTS
	clr.l		LWOB_POLS
	clr.l		LWOB_SRFS
	clr.l		LWOB_CRVS
	clr.l		LWOB_NbrPoints
	clr.l		LWOB_Size
;	---- Zee End:
	movem.l		(sp)+,d0-d2/a0-a2/a6
	clc
	rts
*************************************************
*	Création d'un objet géometrique		*
*IN:	a0=@Données au format LWOB		*
*OUT:	a0=@ObjectHeader			*
*************************************************
;Notes:
; La table des mouvements subit par l'objet n'est pas initialisée par
; cette routine.

; Les structures "ImageData" sont créées mais les images ne sont pas chargées.
; (Le champ "id_Buffer" est mis à 0).
; C'est la routine "InitScene" qui se charge de charger et convertir les images
; au format approprié.

; L'initialisation se passe en deux phases:
;	1/ Premier passage des données au format LWOB par la routine "InitLWOB".
;	    De cette manière les données sont plus faciles à utiliser pour créer
;	    la structure "Geometric", même si ça alourdi la programmation.
;	2/ Création proprement dite de la structure "Geometric".

CreateGeometric
	movem.l	d0-a6,-(sp)
;	---- On dégrossi un peu les données:
	bsr.w	InitLWOB
	bcs	.e_error
;	---- Structure "Geometric":
	moveq		#Geometric_SIZE,d0
	move.l		#MEMF_FAST!MEMF_CLEAR,d1
	CALLEXEC	AllocVec
	tst.l		d0
	beq		.e_Geometric
	move.l		d0,.geometric
	move.l		d0,a2
;	---- Init. des structures "ObjectHeader" et "SpaceReference":
	move.w	#ObjID_Geometric,obj_ObjectID(a2)
	lea	obj_sr(a2),a0

	bsr.w	TestFPU
	bcc.s	.FPU

.noFPU	move.l	#$00010000,sr_XAxisXInit(a0)
	clr.l	sr_XAxisYPos(a0)
	clr.l	sr_XAxisZPos(a0)
	clr.l	sr_YAxisXPos(a0)
	move.l	#$00010000,sr_YAxisYInit(a0)
	clr.l	sr_YAxisZPos(a0)
	clr.l	sr_ZAxisXPos(a0)
	clr.l	sr_ZAxisYPos(a0)
	move.l	#$00010000,sr_ZAxisZInit(a0)
	bra.s	.points

.FPU	fmove.s	#0,fp0
	fmove.s	#1,fp1
	fmove.s	fp1,sr_XAxisXInit(a0)
	fmove.s	fp0,sr_XAxisYInit(a0)
	fmove.s	fp0,sr_XAxisZInit(a0)
	fmove.s	fp0,sr_YAxisXInit(a0)
	fmove.s	fp1,sr_YAxisYInit(a0)
	fmove.s	fp0,sr_YAxisZInit(a0)
	fmove.s	fp0,sr_ZAxisXInit(a0)
	fmove.s	fp0,sr_ZAxisYInit(a0)
	fmove.s	fp1,sr_ZAxisZInit(a0)

;	---- Table des points:
;	Alloue la table, puis copie les coordonnées
;	provenant des données au format LWOB.
.points	move.l		LWOB_NbrPoints(pc),d0
	beq.w		.end
	mulu.l		#12,d0
	move.l		#MEMF_FAST!MEMF_CLEAR,d1
	CALLEXEC	AllocVec
	tst.l		d0
	beq		.e_Points
	move.l		LWOB_NbrPoints(pc),Geo_NbrPoints(a2)
	move.l		d0,Geo_Points(a2)
;	Copiage des coordonnées:
	move.l	LWOB_PNTS(pc),a0
	addq.w	#8,a0
	move.l	Geo_Points(a2),a1
	move.l	Geo_NbrPoints(a2),d0
.copyP	rept	3
	move.l	(a0)+,(a1)+
	endr
	subq.l	#1,d0
	bne.s	.copyP

;	---- Table polygones:
;	Crée la table des pointeurs des structures "polygon"
.polygonsTable
	move.l		LWOB_NbrPolygons(pc),d0
	beq.w		.SurfacesTable
	lsl.l		#2,d0
	move.l		#MEMF_FAST!MEMF_CLEAR,d1
	CALLEXEC	AllocVec
	tst.l		d0
	beq		.e_PolygonsTable
	move.l		LWOB_NbrPolygons(pc),Geo_NbrPolygons(a2)
	move.l		d0,Geo_Polygons(a2)


;	---- Structures polygon:
;	Alloue les structures "polygon" puis les initialise
.polygons

;	Comptage des vertices:
	move.l		Geo_NbrPolygons(a2),d2
	move.l		LWOB_PolygonsTable(pc),a3
	clr.l	d0
	clr.l	d1		;d1=Compteur vertices
.vertices
	move.l		(a3)+,a5
	move.w		(a5),d0
	add.l		d0,d1
	subq.l		#1,d2
	bne.s		.vertices

;	Allocation des structures:
	lsl.l	#2,d1
	move.l	Geo_NbrPolygons(a2),d0
	mulu.l	#polygon_SIZE,d0
	add.l	d1,d0
	move.l	#MEMF_FAST!MEMF_CLEAR,d1
	CALLEXEC	AllocVec
	tst.l	d0
	beq	.e_polygon
	move.l	d0,a0

;	boucle d'initialisation des structures polygon:
	move.l	Geo_NbrPolygons(a2),d2
	move.l	LWOB_PolygonsTable(pc),a3
	move.l	Geo_Polygons(a2),a4
.initPoly
	move.l		a0,(a4)+
	move.l		(a3)+,a5	;a5=@polygone au format LWOB
	move.w		(a5)+,d0	;d0=nombre de vertices
	move.w		d0,poly_NbrVertices(a0)
	subq.w		#1,d0
	move.l		a0,a1
	lea		poly_Vertices(a0),a0
	move.l		LWOB_SurfacesTable(pc),a6
.copyV	move.w		(a5)+,d4
	mulu.w		#12,d4		;***> EN FONCTION DE LA TAILLE DU TYPE DES DONNEES
	move.l		d4,(a0)+
	dbra		d0,.copyV
	move.w		(a5)+,d4
	move.l		(a6,d4.w*4),poly_Surface(a1)
;	polygone suivant:
	subq.l		#1,d2
	bne.s		.initPoly



;	---- Table des surfaces:
;	Reprend la table des structures "surface"
;	créée par "InitLWOB".
.SurfacesTable
	tst.w	LWOB_NbrSurfaces+2(pc)
	beq.w	.end
	move.w	LWOB_NbrSurfaces+2(pc),Geo_NbrSurfaces(a2)
	move.l	LWOB_SurfacesTable(pc),Geo_Surfaces(a2)
	clr.l	LWOB_NbrSurfaces	;Pour pas que "RemoveLWOB" efface les tables.
	clr.l	LWOB_SurfacesTable	;(Elle seront effacées par 
	clr.l	LWOB_SurfaceNamesBuffer	;"RemoveGeometric")

;	---- Création de la table des images:
.ImagesTable
	move.l		LWOB_NbrImages(pc),d0
	beq.w		.end
	lsl.l		#2,d0
	move.l		#MEMF_FAST!MEMF_CLEAR,d1
	CALLEXEC	AllocVec
	tst.l		d0
	beq.w		.e_imagesTable
	move.l		d0,Geo_Images(a2)
	move.w		LWOB_NbrImages+2(pc),Geo_NbrImages(a2)
;	---- Création des structures "ImageData":
	move.w		Geo_NbrImages(a2),d0
	mulu.w		#ImageData_SIZE,d0
	move.l		#MEMF_FAST!MEMF_CLEAR,d1
	CALLEXEC	AllocVec
	tst.l		d0
	beq.w		.e_ImageData
;	---- Init. de la table des images et des structures ImageData:
;Note:	-Initialise les pointeurs sur les structures "ImageData" dans la
;	 table des images.
;	-Initialise les pointeurs sur les noms des fichier et les noms
;	 des images dans les structures "ImageData".
	move.l	d0,a0
	move.w	Geo_NbrImages(a2),d0
	subq.w	#1,d0
	move.l	LWOB_ImageNamesTable(pc),a1
	move.l	Geo_Images(a2),a3

.loop	move.l		a0,(a3)+
	move.l		(a1),a4		;a4=@Nom du fichier de l'image
	clr.l		(a1)+	;On efface pour pas que "RemoveLWOB" efface les données.
	move.l		a4,id_Path(a0)
	move.l		a4,a5		;a5=@Fin de la chaine ascii du nom du fichier
.eStr	tst.b		(a5)+
	bne.s		.eStr
.iName	cmp.b		#"/",-(a5)
	beq.s		.fndN
	cmp.l		a4,a5
	bgt.s		.iName
	bra.s		.initN
.fndN	addq.l		#1,a5
.initN	move.l		a5,id_Name(a0)
	lea		ImageData_SIZE(a0),a0
	dbra		d0,.loop
;	---- Init. des pointeurs sur les structures "ImageData" dans les structures "Surface":
	move.w	Geo_NbrSurfaces(a2),d0
	subq.w	#1,d0
	move.l	Geo_Surfaces(a2),a0
	move.l	Geo_Images(a2),a1
.loop0	move.l		(a0)+,a3
.Rimg	move.l		surf_Rimg(a3),d1
	beq.s		.cimg
	move.l		-4(a1,d1.l*4),surf_Rimg(a3)
.cimg	move.l		surf_CtexTimg(a3),d1
	beq.s		.dimg
	move.l		-4(a1,d1.l*4),surf_CtexTimg(a3)
.dimg	move.l		surf_DtexTimg(a3),d1
	beq.s		.simg
	move.l		-4(a1,d1.l*4),surf_DtexTimg(a3)
.simg	move.l		surf_StexTimg(a3),d1
	beq.s		.rimg
	move.l		-4(a1,d1.l*4),surf_StexTimg(a3)
.rimg	move.l		surf_RtexTimg(a3),d1
	beq.s		.timg
	move.l		-4(a1,d1.l*4),surf_RtexTimg(a3)
.timg	move.l		surf_TtexTimg(a3),d1
	beq.s		.bimg
	move.l		-4(a1,d1.l*4),surf_TtexTimg(a3)
.bimg	move.l		surf_BtexTimg(a3),d1
	beq.s		.next
	move.l		-4(a1,d1.l*4),surf_BtexTimg(a3)
.next	dbra		d0,.loop0
;	---- Initialise les identificateurs de type de texture:
;Note:	Initialise les numéros de types, ainsi que les
;	pointeurs sur les identificateurs ascii.
	move.w	Geo_NbrSurfaces(a2),d1
	subq.w	#1,d1
	move.l	Geo_Surfaces(a2),a1
.texId	move.l		(a1)+,a3
.ctex	move.l		surf_Ctex(a3),d0
	beq.s		.dtex
	move.l		d0,a0
	bsr.w		.GetTexType
	move.l		a0,surf_Ctex(a3)
	move.w		d0,surf_CtexType(a3)
.dtex	move.l		surf_Dtex(a3),d0
	beq.s		.stex
	move.l		d0,a0
	bsr.w		.GetTexType
	move.l		a0,surf_Dtex(a3)
	move.w		d0,surf_DtexType(a3)
.stex	move.l		surf_Stex(a3),d0
	beq.s		.rtex
	move.l		d0,a0
	bsr.w		.GetTexType
	move.l		a0,surf_Stex(a3)
	move.w		d0,surf_StexType(a3)
.rtex	move.l		surf_Rtex(a3),d0
	beq.s		.ttex
	move.l		d0,a0
	bsr.w		.GetTexType
	move.l		a0,surf_Rtex(a3)
	move.w		d0,surf_RtexType(a3)
.ttex	move.l		surf_Ttex(a3),d0
	beq.s		.btex
	move.l		d0,a0
	bsr.w		.GetTexType
	move.l		a0,surf_Ttex(a3)
	move.w		d0,surf_TtexType(a3)
.btex	move.l		surf_Btex(a3),d0
	beq.s		.nextT
	move.l		d0,a0
	bsr.w		.GetTexType
	move.l		a0,surf_Btex(a3)
	move.w		d0,surf_BtexType(a3)
.nextT	dbra		d1,.texId

;	---- Zee End:
.end	bsr.w	RemoveLWOB	;On efface les éventuelles données de construction.
	movem.l	(sp)+,d0-a6
	move.l	.geometric(pc),a0
	clc
	rts

******** Recherche le numéro d'un type de texture ********
;IN:  a0=@Nom du type
;OUT: a0=@Nom du type dans la table interne, d0=Texture type
.GetTexType
	movem.l	a1/a2,-(sp)
	lea	.TextureTypes(pc),a2
.search	move.l		(a2),a1
	cmp.l		#0,a1
	beq.s		.unknwn
	bsr.w		CmpStrings
	bcc.s		.found
	addq.w		#8,a2
	bra.s		.search
.found	move.l	(a2)+,a0
	move.l	(a2),d0
	movem.l	(sp)+,a1/a2
	clc
	rts
.unknwn	lea	.Unknown(pc),a0
	moveq	#TexType_Unknown,d0
	movem.l	(sp)+,a1/a2
	stc
	rts


******** Données ********
.geometric	dc.l	0

.TextureTypes
	dc.l	.PlanarIM,		TexType_PlanarIM
	dc.l	.CylindricalIM,		TexType_CylindricalIM
	dc.l	.SphericalIM,		TexType_SphericalIM
	dc.l	.CubicIM,		TexType_CubicIM
	dc.l	.FrontProjectionIM,	TexType_FrontProjectionIM
	dc.l	.Checkerboard,		TexType_Checkerboard
	dc.l	.Grid,			TexType_Grid
	dc.l	.Dots,			TexType_Dots
	dc.l	.Marble,		TexType_Marble
	dc.l	.Wood,			TexType_Wood
	dc.l	.Underwater,		TexType_Underwater
	dc.l	.FractalNoise,		TexType_FractalNoise
	dc.l	.BumpArray,		TexType_BumpArray
	dc.l	.Crust,			TexType_Crust
	dc.l	.Veins,			TexType_Veins
	dc.l	0

.Unknown		STRING	"Unknown"
.PlanarIM		STRING	"Planar Image Map"
.CylindricalIM		STRING	"Cylindrical Image Map"
.SphericalIM		STRING	"Spherical Image Map"
.CubicIM		STRING	"Cubic Image Map"
.FrontProjectionIM	STRING	"Front Projection Image Map"
.Checkerboard		STRING	"Checkerboard"
.Grid			STRING	"Grid"
.Dots			STRING	"Dots"
.Marble			STRING	"Marble"
.Wood			STRING	"Wood"
.Underwater		STRING	"Underwater"
.FractalNoise		STRING	"Fractal Noise"
.BumpArray		STRING	"Bump Array"
.Crust			STRING	"Crust"
.Veins			STRING	"Veins"


******** Erreurs ********

.e_Geometric
	bsr.w	RemoveLWOB
	movem.l	(sp)+,d0-a6
	moveq	#Not_enough_memory,d0
	stc
	rts

.e_PolygonsTable
.e_Points
.e_polygon
.e_surfaces
.e_imagesTable
.e_ImageData
	bsr.w	RemoveLWOB
	move.l	.geometric(pc),a0
	bsr.w	RemoveGeometric
	movem.l	(sp)+,d0-a6
	moveq	#Not_enough_memory,d0
	stc
	rts


.e_error
	move.l	d0,(sp)
	movem.l	(sp)+,d0-a6
	stc
	rts


*************************************************
*	Destruction d'un objet géométrique	*
*IN:	a0=@Geometric				*
*************************************************
RemoveGeometric
	movem.l	d0-a6,-(sp)
	move.l	a0,a2
;	---- Destruction des structures "polygon":
.polygons
	move.l	Geo_NbrPolygons(a2),d0
	beq.s	.surfaceNames
	move.l	Geo_Polygons(a2),d1
	beq.s	.surfaceNames
	move.l	d1,a3
	move.l	(a3),d1
	beq.s	.polygonsTable
	move.l	d1,a1
	CALLEXEC	FreeVec

;	---- Destruction de la table des polygones:
.polygonsTable
	move.l	a3,a1
	CALLEXEC	FreeVec

;	---- Destruction du buffer des noms des surfaces:
;Note:	L'adresse du buffer est celle de la chaine ascii du
;	nom de la première surface.
.surfaceNames
	tst.w		Geo_NbrSurfaces(a2)
	beq.s		.images
	move.l		Geo_Surfaces(a2),d0
	beq.s		.images
	move.l		d0,a1
	move.l		(a1),d0
	beq.s		.images
	move.l		d0,a1
	move.l		surf_Name(a1),d0
	beq.s		.images
	move.l		d0,a1
	CALLEXEC	FreeVec
;	---- Destruction des surfaces (structures et table):
.surfaces
	move.l		Geo_Surfaces(a2),d0
	beq.s		.images
	move.l		d0,a1
	CALLEXEC	FreeVec

;	---- Destruction des images:
.images
	move.w	Geo_NbrImages(a2),d2
	beq.s	.points
;	Suppression des noms des fichiers:
	subq.w	#1,d2
	move.l	Geo_Images(a2),d0
	beq.s	.points
	move.l	d0,a3
	move.l	a3,a5
.ILoop	move.l		(a3)+,a4
	cmp.l		#0,a4
	beq.s		.id
	move.l		id_Path(a4),a1
	cmp.l		#0,a1
	beq.s		.id
	CALLEXEC	FreeVec
	dbra		d2,.ILoop
;	Suppression des structures ImageData:
.id	move.l		(a5),d0
	beq.s		.points
	move.l		d0,a1
	CALLEXEC	FreeVec
;	Suppression de la table des images:
	move.l		a5,a1
	CALLEXEC	FreeVec

;	---- Destruction de la table des points:
.points
	move.l		Geo_Points(a2),d0
	beq.s		.end
	move.l		d0,a1
	CALLEXEC	FreeVec
;	---- Destruction de la structure "Geometric":
.geometric
	move.l		a2,a1
	CALLEXEC	FreeVec

;	---- Zee End:
.end	movem.l	(sp)+,d0-a6
	clc
	rts


*********************************************************
*	Initialisation de la structure Scene		*
*IN:	a0=@Scene					*
*********************************************************

;La table des objets géométriques doit être déjà initialisée.

;Les champs suivants sont initialisés par cette routine:
;	scn_NbrPoints
;	scn_Coords
;	scn_NbrPolygons
;	scn_Polygons
;	scn_NbrSurfaces
;	scn_Surfaces
;	scn_NbrImages
;	scn_Images

InitScene
	movem.l	d0-a6,-(sp)
	move.l	a0,a2
	move.w	scn_NbrGeometrics(a2),d0
	beq.w	is.end
	move.l	scn_Geometrics(a2),a1

;	---- Comptage des points, polygones, surfaces et images:
	subq.w	#1,d0
	move.w	d0,d4
	clr.l	d2	;d2=compteur points
	clr.l	d3	;d3=compteur polygones
	clr.l	d4	;d4=compteur surfaces
	clr.l	d6	;d6=compteur images
.Coords
	move.l	(a1)+,d7
	beq.s	.nxtGeo
	move.l	d7,a3
	add.l	Geo_NbrPoints(a3),d2
	add.l	Geo_NbrPolygons(a3),d3
	clr.l	d7
	move.w	Geo_NbrSurfaces(a3),d7
	add.l	d7,d4
	move.w	Geo_NbrImages(a3),d7
	add.l	d7,d6
.nxtGeo	dbra	d0,.Coords

	move.l	d2,scn_NbrPoints(a2)
	move.l	d3,scn_NbrPolygons(a2)
	move.l	d4,scn_NbrSurfaces(a2)
	move.l	d6,scn_NbrImages(a2)

;	---- Allocation des tables:
	mulu.l	#12,d2
	lsl.l	#2,d3
	lsl.l	#2,d4
	lsl.l	#2,d6
	move.l	d2,d0
	add.l	d3,d0
	add.l	d4,d0
	add.l	d6,d0

	move.l		#MEMF_FAST!MEMF_CLEAR,d1
	CALLEXEC	AllocVec
	tst.l		d0
	beq.w		is.e_Memory

;	---- Initialisation des pointeurs:
	move.l	d0,scn_Coords(a2)

	move.l	scn_NbrPoints(a2),d1
	mulu.l	#12,d1
	add.l	d1,d0
	move.l	d0,scn_Polygons(a2)

	move.l	scn_NbrPolygons(a2),d1
	lsl.l	#2,d1
	add.l	d1,d0
	move.l	d0,scn_Surfaces(a2)

	move.l	scn_NbrSurfaces(a2),d1
	lsl.l	#2,d1
	add.l	d1,d0
	move.l	d0,scn_Images(a2)

;	---- Comptage du nombre total de vertices:
	clr.l	d3	;d3=compteur de vertices
	clr.l	d4
	move.l	scn_Geometrics(a2),a0
	move.w	scn_NbrGeometrics(a2),d0
	subq.w	#1,d0
.geo		move.l	(a0)+,d1
		move.l	d1,a1
		move.l	Geo_NbrPolygons(a1),d1
		beq.s	.nextGeo
		move.l	Geo_Polygons(a1),a3
.pol			move.l	(a3)+,a4
			move.w	poly_NbrVertices(a4),d4
			add.l	d4,d3
.nxtPol			subq.l	#1,d1
			bne.s	.pol
.nextGeo	dbra	d0,.geo

;	---- Allocation des structures des polygones:
;	La totalité des polygones des objets géométriques sont référencés
;	au sein de la scène. Leurs structures sont dupliquées pour permettre
;	un réajustement des vertices, qui ne désignent plus les numéros des
;	points dans les tables respectives des objets géométriques, mais dans
;	la table "scn_coords" qui regroupe la totalité des points des objets
;	géométriques de la scène.

	move.l		scn_NbrPolygons(a2),d0
	beq.s		is.surfaces
	mulu.l		#polygon_SIZE,d0
	lsl.l		#2,d3
	add.l		d3,d0
	move.l		#MEMF_FAST!MEMF_CLEAR,d1
	CALLEXEC	AllocVec
	tst.l		d0
	beq.w		is.e_Memory

is.stop

;	---- Initialisation des structures polygons:
	move.l	d0,a0
	move.l	scn_Geometrics(a2),a1
	move.l	scn_Polygons(a2),a3
	clr.l	d0	;d0=Compteur-offset de points
	move.w	scn_NbrGeometrics(a2),d1
	subq.w	#1,d1

.geo0		move.l	(a1)+,a4
		move.l	Geo_NbrPolygons(a4),d2
		beq.s	.nextGeo0
		move.l	Geo_Polygons(a4),a5
.pol0			move.l	(a5)+,a6
			move.w	poly_NbrVertices(a6),d3
			move.w	d3,poly_NbrVertices(a0)
			move.l	poly_Surface(a6),poly_Surface(a0)
			subq.w	#1,d3
			move.l	a0,(a3)+
			lea	poly_Vertices(a6),a6
			lea	poly_Vertices(a0),a0
.vertice			move.l	(a6)+,d4
				add.l	d0,d4
				move.l	d4,(a0)+
				dbra	d3,.vertice
.nextpol0		subq.l	#1,d2
			bne.s	.pol0
.nextGeo0	move.l	Geo_NbrPoints(a4),d2
		mulu.l	#12,d2		;***> EN FONCTION DE LA TAILLE DU TYPE DES DONNEES
		add.l	d2,d0
		dbra	d1,.geo0

;	---- Initialisation de la table des surfaces:
is.surfaces
	tst.l	scn_NbrSurfaces(a2)
	beq.s	.images
	move.w	scn_NbrGeometrics(a2),d1
	move.l	scn_Geometrics(a2),a0
	move.l	scn_Surfaces(a2),a1
	subq.w	#1,d1
.geo1		move.l	(a0)+,a3
		move.w	Geo_NbrSurfaces(a3),d2
		beq.s	.nextGeo1
		move.l	Geo_Surfaces(a3),a4
		subq.w	#1,d2
.surf			move.l	(a4)+,(a1)+
			dbra	d2,.surf
.nextGeo1	dbra	d1,.geo1


;	---- Initialisation de la table des images:
.images
	tst.l	scn_NbrImages(a2)
	beq.s	is.end
	move.w	scn_NbrGeometrics(a2),d1
	move.l	scn_Geometrics(a2),a0
	move.l	scn_Images(a2),a1
	subq.w	#1,d1
.geo2		move.l	(a0)+,a3
		move.w	Geo_NbrImages(a3),d2
		beq.s	.nextGeo2
		move.l	Geo_Images(a3),a4
		subq.w	#1,d2
.image			move.l	(a4)+,(a1)+
			dbra	d2,.image
.nextGeo2	dbra	d1,.geo2


;	Chargement des images:
.LoadImages
	move.l	a2,a0
	bsr.w	LoadImages
	bcs.s	is.e_LoadImages

;	---- Zee End:
is.end	movem.l	(sp)+,d0-a6
	clc
	rts

is.e_Memory
	movem.l	(sp)+,d0-a6
	moveq	#Not_enough_memory,d0
	stc
	rts

is.e_LoadImages
	move.l	d0,(sp)
	movem.l	(sp)+,d0-a6
	stc
	rts

*****************************************************************
*	Destruction des tables allouées par InitScene		*
*IN:	a0=@Scene						*
*****************************************************************
;Note: La mémoire utilisée par les structures "ImageData" est
;      libérée par la routine "RemoveGeometric".
RemoveScene
	movem.l	d0-d2/a0-a4/a6,-(sp)
	move.l	a0,a2
;	---- Destruction des bitmaps des images (initialisations de "LoadImages()"):
	move.l		scn_NbrImages(a2),d2
	beq.s		.poly
	clr.l		scn_NbrImages(a2)
	move.l		scn_Images(a2),a3
.image	move.l		(a3)+,a4
	tst.l		id_Buffer(a4)
	beq.s		.pal
	move.l		id_Buffer(a4),a1
	clr.l		id_Buffer(a4)
	CALLEXEC	FreeVec
.pal	tst.l		id_Palette(a4)
	beq.s		.nextImage
	move.l		id_Palette(a4),a1
	clr.l		id_Palette(a4)
	CALLEXEC	FreeVec
.nextImage
	subq.l		#1,d2
	bne.s		.image
;	---- Destruction des structures polygons:
.poly	tst.l		scn_NbrPolygons(a2)
	beq.s		.tables
	move.l		scn_Polygons(a2),a1
	move.l		(a1),a1
	clr.l		scn_NbrPolygons(a2)
	clr.l		scn_Polygons(a2)
	CALLEXEC	FreeVec
;	---- Destruction des tables:
;	(Toutes les tables font partie du même bloc mémoire,dont l'adresse
;	 de base est située au champ scn_Coords)
.tables	move.l		scn_Coords(a2),d0
	beq.s		.end
	move.l		d0,a1
	clr.l		scn_NbrPoints(a2)
	clr.l		scn_Coords(a2)
	CALLEXEC	FreeVec
;	---- Zee End:
.end	movem.l	(sp)+,d0-d2/a0-a4/a6
	clc
	rts

*************************************************
*	Chargement des images d'une scène	*
*IN:	a0=@Scene				*
*************************************************
;La table des images doit être initialisée.

LoadImages
	movem.l	d0-a6,-(sp)

	move.l	a0,i.scene
	move.l	scn_NbrImages(a0),d7
	beq.s	i.end
	move.l	scn_Images(a0),a3
	move.b	scn_Depth(a0),d1

;	---- Mode 8 bits:
i.8bits
	cmp.b	#RenderDepth_8bits,d1
	bne.s	i.15bits
	bsr.w	i.Mode_8bits
	bcs.s	i.e_error
	bra.s	i.end

;	---- Mode 15 bits:
i.15bits
	cmp.b	#RenderDepth_15bits,d1
	bne.s	i.16bits
	bsr.w	i.Mode_15bits
	bcs.s	i.e_error
	bra.s	i.end

;	---- Mode 16 bits:
i.16bits
	cmp.b	#RenderDepth_16bits,d1
	bne.s	i.32bits
	bsr.w	i.Mode_16bits
	bcs.s	i.e_error
	bra.s	i.end

;	---- Mode 32 bits:
i.32bits
	cmp.b	#RenderDepth_32bits,d1
	bne.s	i.e_RenderDepth
	bsr.s	i.Mode_32bits
	bcs.s	i.e_error

;	---- Zee End:
i.end	movem.l	(sp)+,d0-a6
	clc
	rts


;	******** ERREURS ********
i.e_RenderDepth
	movem.l	(sp)+,d0-a6
	move.l	#Invalid_render_depth,d0
	stc
	rts

i.e_error
	bsr.w	i.dispose
	move.l	d0,(sp)
	movem.l	(sp)+,d0-a6
	stc
	rts

;	******** SOUS-ROUTINES ********

;------------------------------------------
;	Convertion image 8bits => 32bits
;IN: a3=@Table des structure ImageData
;    d7=Nombre d'images
;------------------------------------------
;Format d'un pixel:
;	%00000000 rrrrrrrr gggggggg bbbbbbbb 	8bits par composantes

i.Mode_32bits
;	---- Boucle
	move.l	(a3)+,a4	;a4=@ImageData
	bsr.w	i.initDT
	bcs.w	i.e_32bitsError
;	---- Allocation id_Buffer:
	moveq	#2,d0
	bsr.w	i.AllocIdBuffer
	bcs.w	i.e_32bitsMemory
;	---- Convertion palette:
	move.l	i.colors(pc),a0
	lea	i.palette(pc),a1
	move.l	i.numColors(pc),d0
	subq.l	#1,d0
.pal	move.l	(a0)+,d1
	and.l	#$ff0000,d1	;**** VOIR LE FORMAT DU MODE 32BITS DU PLAYFIELD ****
	move.l	(a0)+,d2
	move.w	d2,d1
	move.l	(a0)+,d3
	move.b	d3,d1
	move.l	d1,(a1)+
	dbra	d0,.pal
;	---- Convertion 32 bits:
	bsr.w	i.InitConvertion
;	---- Boucle:
.loop	move.w	i.Num8bitsOrg(pc),d4
.row	bsr.w	i.p2c
	lea	i.bplDatas(pc),a0
	lea	i.palette(pc),a1
	moveq	#7,d1
	clr.w	d2
.bloc	move.b	(a0)+,d2
	move.l	(a1,d2.w*4),(a6)+
	dbra	d1,.bloc
	addq.l	#1,d0
	dbra	d4,.row
;	Dernier bloc (inférieur à 8 pixels):
	move.w	i.ModuloOrg(pc),d4
	beq.s	.modBpl
	bsr.w	i.p2c
	lea	i.bplDatas(pc),a0
	lea	i.palette(pc),a1
	subq.w	#1,d4
	clr.w	d2
.bloc0	move.b	(a0)+,d2
	move.l	(a1,d2.w*4),(a6)+
	dbra	d4,.bloc0
.modBpl	add.l	i.ModuloBpl(pc),d0
	dbra	d5,.loop
;	---- Image suivante:
	bsr.w	i.dispose
	subq.l	#1,d7
	bne.w	i.Mode_32bits
;	---- Ok:
	clc
	rts

;	---- Erreurs
i.e_32bitsMemory
	moveq	#Not_enough_memory,d0
	stc
	rts

i.e_32bitsError
	stc
	rts

;------------------------------------------
;	Convertion image 8bits => 15bits
;IN: a3=@Table des structure ImageData
;    d7=Nombre d'images
;------------------------------------------
;Format d'un pixel:
;	%0 rrrrr gg ggg bbbbb	5bits par composantes
i.Mode_15bits
;	---- Boucle
	move.l	(a3)+,a4	;a4=@ImageData
	bsr.w	i.initDT
	bcs.w	i.e_16bitsError
;	---- Allocation id_Buffer:
	moveq	#1,d0
	bsr.w	i.AllocIdBuffer
	bcs.w	i.e_15bitsMemory
;	---- Convertion palette:
	move.l	i.colors(pc),a0
	lea	i.palette(pc),a1
	move.l	i.numColors(pc),d0
	subq.l	#1,d0
.pal	move.l	(a0)+,d1
	lsr.w	d1
	and.w	#%0111110000000000,d1
	move.l	(a0)+,d2
	lsl.w	#2,d2
	and.w	#%0000001111100000,d2
	or.w	d2,d1
	move.l	(a0)+,d2
	lsr.b	#3,d2
	or.b	d2,d1
	move.w	d1,(a1)+
	dbra	d0,.pal
;	---- Convertion 15 bits:
	bsr.w	i.InitConvertion
;	---- Boucle:
.loop	move.w	i.Num8bitsOrg(pc),d4
.row	bsr.w	i.p2c
	lea	i.bplDatas(pc),a0
	lea	i.palette(pc),a1
	moveq	#7,d1
	clr.w	d2
.bloc	move.b	(a0)+,d2
	move.w	(a1,d2.w*2),(a6)+
	dbra	d1,.bloc
	addq.l	#1,d0
	dbra	d4,.row
;	Dernier bloc (inférieur à 8 pixels):
	move.w	i.ModuloOrg(pc),d4
	beq.s	.modBpl
	bsr.w	i.p2c
	lea	i.bplDatas(pc),a0
	lea	i.palette(pc),a1
	subq.w	#1,d4
	clr.w	d2
.bloc0	move.b	(a0)+,d2
	move.w	(a1,d2.w*2),(a6)+
	dbra	d4,.bloc0
.modBpl	add.l	i.ModuloBpl(pc),d0
	dbra	d5,.loop
;	---- Image suivante:
	bsr.w	i.dispose
	subq.l	#1,d7
	bne.w	i.Mode_15bits
;	---- Ok:
	clc
	rts

;	---- Erreurs
i.e_15bitsMemory
	moveq	#Not_enough_memory,d0
	stc
	rts

i.e_15bitsError
	stc
	rts

;------------------------------------------
;	Convertion image 8bits => 16bits
;IN: a3=@Table des structure ImageData
;    d7=Nombre d'images
;------------------------------------------
;Format d'un pixel:
;	%rrrrr gggggg bbbbb - 5bits rouge, 6bits verts, 5bits bleu
i.Mode_16bits
;	---- Boucle
	move.l	(a3)+,a4	;a4=@ImageData
	bsr.w	i.initDT
	bcs.w	i.e_16bitsError
;	---- Allocation id_Buffer:
	moveq	#1,d0
	bsr.w	i.AllocIdBuffer
	bcs.w	i.e_16bitsMemory
;	---- Convertion palette:
	move.l	i.colors(pc),a0
	lea	i.palette(pc),a1
	move.l	i.numColors(pc),d0
	subq.l	#1,d0
.pal	move.l	(a0)+,d1
	and.w	#%1111100000000000,d1
	move.l	(a0)+,d2
	lsr.w	#5,d2
	and.w	#%0000011111100000,d2
	or.w	d2,d1
	move.l	(a0)+,d2
	lsr.b	#3,d2
	or.b	d2,d1
	move.w	d1,(a1)+
	dbra	d0,.pal
;	---- Convertion 16 bits:
	bsr.w	i.InitConvertion
;	---- Boucle:
.loop	move.w	i.Num8bitsOrg(pc),d4
.row	bsr.w	i.p2c
	lea	i.bplDatas(pc),a0
	lea	i.palette(pc),a1
	moveq	#7,d1
	clr.w	d2
.bloc	move.b	(a0)+,d2
	move.w	(a1,d2.w*2),(a6)+
	dbra	d1,.bloc
	addq.l	#1,d0
	dbra	d4,.row
;	Dernier bloc (inférieur à 8 pixels):
	move.w	i.ModuloOrg(pc),d4
	beq.s	.modBpl
	bsr.w	i.p2c
	lea	i.bplDatas(pc),a0
	lea	i.palette(pc),a1
	subq.w	#1,d4
	clr.w	d2
.bloc0	move.b	(a0)+,d2
	move.w	(a1,d2.w*2),(a6)+
	dbra	d4,.bloc0
.modBpl	add.l	i.ModuloBpl(pc),d0
	dbra	d5,.loop
;	---- Image suivante:
	bsr.w	i.dispose
	subq.l	#1,d7
	bne.w	i.Mode_16bits
;	---- Ok:
	clc
	rts

;	---- Erreurs
i.e_16bitsMemory
	moveq	#Not_enough_memory,d0
	stc
	rts

i.e_16bitsError
	stc
	rts

;----------------------------------------------
;	Convertion image 8bits bpl => 8bits cnk
;IN: a3=@Table des structure ImageData
;    d7=Nombre d'images
;----------------------------------------------
;Format d'un pixel:
;	%cccccccc - Numéro de la couleur.
i.Mode_8bits
;	---- Boucle
	move.l	(a3)+,a4	;a4=@ImageData
	bsr.w	i.initDT
	bcs.w	i.e_8bitsError
;	---- Allocation id_Buffer:
	moveq	#1,d0
	bsr.w	i.AllocIdBuffer
	bcs.w	i.e_8bitsMemory
;	---- Création palette:
	move.l	#256*4,d0
	move.l	#MEMF_FAST!MEMF_CLEAR,d1
	CALLEXEC	AllocVec
	tst.l	d0
	beq.s	i.e_palette
	move.l	d0,id_Palette(a4)
	move.l	d0,a1
	move.l	i.colors(pc),a0
	move.l	i.numColors(pc),d0
	subq.l	#1,d0
.pal	move.l	(a0)+,d1
	and.l	#$ff0000,d1	;**** VOIR LE FORMAT DU MODE 32BITS DU PLAYFIELD ****
	move.l	(a0)+,d2
	move.w	d2,d1
	move.l	(a0)+,d3
	move.b	d3,d1
	move.l	d1,(a1)+
	dbra	d0,.pal
;	---- Convertion 16 bits:
	bsr.w	i.InitConvertion
;	---- Boucle:
.loop	move.w	i.Num8bitsOrg(pc),d4
.row	bsr.w	i.p2c
	lea	i.bplDatas(pc),a0
	lea	i.palette(pc),a1
	moveq	#7,d1
	clr.w	d2
.bloc	move.b	(a0)+,(a6)+
	dbra	d1,.bloc
	addq.l	#1,d0
	dbra	d4,.row
;	Dernier bloc (inférieur à 8 pixels):
	move.w	i.ModuloOrg(pc),d4
	beq.s	.modBpl
	bsr.w	i.p2c
	lea	i.bplDatas(pc),a0
	lea	i.palette(pc),a1
	subq.w	#1,d4
	clr.w	d2
.bloc0	move.b	(a0)+,(a6)+
	dbra	d4,.bloc0
.modBpl	add.l	i.ModuloBpl(pc),d0
	dbra	d5,.loop
;	---- Image suivante:
	bsr.s	i.dispose
	subq.l	#1,d7
	bne.w	i.Mode_8bits
;	---- Ok:
	clc
	rts

;	---- Erreurs
i.e_palette
	move.l	#Cant_create_image_palette,d0
	stc
	rts

i.e_8bitsMemory
	moveq	#Not_enough_memory,d0
	stc
	rts

i.e_8bitsError
	stc
	rts

;-----------------------------------
;	Création du datatype
;IN:a4=@ImageData
;CRASH: d0,d1 - a0,a1,a2,a6
;-----------------------------------
i.initDT
;	---- Création datatype:
	move.l	id_Path(a4),d0
	sub.l	a0,a0
	bsr.w	DataCache_Off
	CALLDT	NewDTObjectA
	bsr.w	DataCache_On
	tst.l	d0
	beq.s	i.e_Image
	move.l	d0,i.object
;	---- Saisie paramètres image:
	move.l	i.object(pc),a0
	lea	i.getAttrs(pc),a2
	CALLDT	GetDTAttrsA
;	---- Init Taille:
	move.l	i.bmh(pc),a0
	move.w	bmh_Width(a0),id_XSize(a4)
	move.w	bmh_Height(a0),id_YSize(a4)
;	---- Ok:
	clc
	rts

;	---- Erreur:
i.e_Image
	move.l	#Cant_load_image,d0
	stc
	rts

;-----------------------------------
;	Destruction du datatype
;-----------------------------------
i.dispose
	movem.l	d0/d1/a0/a1/a6,-(sp)
	move.l	i.object(pc),d0
	beq.s	i.nDisp
	clr.l	i.object
	move.l	d0,a0
	CALLDT	DisposeDTObject
i.nDisp	movem.l	(sp)+,d0/d1/a0/a1/a6
	rts

;-------------------------------------------------------
;	Allocation id_Buffer
;IN:	a4=@ImageData
;	d0=Coefficient multiplicateur (en fonction du format)
;OUT:	"id_Buffer" initialisé
;CRASH: d1 - a0,a1,a6
;-------------------------------------------------------
i.AllocIdBuffer
	move.w	id_XSize(a4),d1
	mulu.w	id_YSize(a4),d1
	lsl.l	d0,d1
	move.l	d1,d0
	move.l	#MEMF_FAST!MEMF_CLEAR,d1
	CALLEXEC	AllocVec
	tst.l	d0
	beq.w	.e_memory
	move.l	d0,id_Buffer(a4)
	clc
	rts
.e_memory
	stc
	rts

;----------------------------------------------------
;	Initialisation de la boucle de convertion
;IN: a4=@ImageData
;OUT:	i.Num8bitsOrg
;	i.ModuloOrg
;	i.ModuloBpl
;	d5=YSize-1 (compteur boucle)
;	d6=$00ff00ff
;	a6=@id_Buffer
;CRASH: d4 - a0
;----------------------------------------------------
i.InitConvertion
	clr.l	d4
	clr.l	d6
	move.w	id_XSize(a4),d4
	move.w	d4,d5
	lsr.w	#3,d4	;d4=Nombre de blocs 8 bits entiers par ligne dans l'image originale
	and.w	#$7,d5	;d5=Nombre de pixels en fin de ligne (inférieur à 8)
	move.l	i.bitmap(pc),a0
	move.w	bm_BytesPerRow(a0),d6
	sub.l	d4,d6	;d6=Nombre d'octets en plus dans l'image au format bitplan (Modulo)
	subq.w	#1,d4
	move.w	d4,i.Num8bitsOrg
	move.w	d5,i.ModuloOrg
	move.l	d6,i.ModuloBpl
	move.w	id_YSize(a4),d5
	move.l	id_Buffer(a4),a6
	clr.l	d0
	subq.w	#1,d5
	move.l	#$00ff00ff,d6	;Masque pour planar-to-chunky (optim)
	rts

;----------------------------------------------------------
;	Routine de planar to chunky
;IN: d0=Offset dans l'image (Numéro du bloc de 8 pixels)
;    d6=$00ff00ff
;OUT:Table "bplData" initialisée avec les 8 pixels au
;    format chunky 8bits.
;CRASH:  d1,d2,d3 - a0,a1,a2,a4,a5
;----------------------------------------------------------
i.p2c
	move.l	i.bitmap(pc),a0

;	---- Effacement de la table BplDatas:
	lea	i.bplDatas(pc),a1
	clr.l	(a1)
	clr.l	4(a1)

;	---- Initialisation de BplDatas avec les données au format bitPlans:
	clr.w	d1
	move.b	bm_Depth(a0),d1
	subq.b	#1,d1
	lea	bm_Planes(a0),a2
	lea	8(a1),a5
.initBplDatas
	move.l	(a2)+,a4
	move.b	(a4,d0.l),-(a5)
	dbra	d1,.initBplDatas
;	---- Convertion Planar=>Chunky:
	move.l	4(a1),d1
;	Pass1:
	move.l	d1,d2
	lsr.l	#4,d2
	move.l	(a1),d3
	eor.l	d3,d2
	and.l	#$0f0f0f0f,d2
	eor.l	d2,d3
	lsl.l	#4,d2
	eor.l	d2,d1
;	Pass2:
	move.w	d3,d2
	swap	d1
	move.w	d1,d3
	move.w	d2,d1
	swap	d1
;	Pass3:
	move.l	d1,d2
	lsr.l	#2,d2
	eor.l	d3,d2
	and.l	#$33333333,d2
	eor.l	d2,d3
	lsl.l	#2,d2
	eor.l	d2,d1
;	Pass4:
	move.l	d1,d2
	lsr.l	#8,d2
	eor.l	d3,d2
	and.l	d6,d2
	eor.l	d2,d3
	lsl.l	#8,d2
	eor.l	d2,d1
;	Pass5:
	move.l	d1,d2
	lsr.l	d2
	eor.l	d3,d2
	and.l	#$55555555,d2
	eor.l	d2,d3
	lsl.l	d2
	eor.l	d2,d1
;	Les deux passes suivantes servent juste à remettre les
;	pixels chunky dans le bon ordre:
;	Pass6:
	move.l	d1,d2
	lsr.l	#8,d2
	eor.l	d3,d2
	and.l	d6,d2
	eor.l	d2,d3
	lsl.l	#8,d2
	eor.l	d2,d1
;	Pass7:
	move.w	d3,d2
	swap	d1
	move.w	d1,d3
	move.l	d3,(a1)+
	move.w	d2,d1
	swap	d1
;	Fin:
	move.l	d1,(a1)
	rts

;	******** DONNEES ********

i.scene		dc.l	0	;Sauvegarde su paramètre d'entrée
i.object	dc.l	0	;Objet créé par NewDTObject
i.bitmap	dc.l	0	;Structure BitMap de l'image (bitmap AGA, 256 couleurs max)
i.bmh		dc.l	0	;Structure BitMapHeader du datatype
i.numColors	dc.l	0	;Nombre de couleurs
i.colors	dc.l	0	;Palette de l'image

;Variables servants à la suppression de la marge ajoutée
;à la fin de chaque ligne dans l'image au format bpl
;(a cause des alignements requis par l'aga):
i.Num8bitsOrg	dc.w	0 ;Nombre de bloc d 8 pixels entiers par ligne dans l'image originale
i.ModuloOrg	dc.w	0 ;Nombre de pixels dans le dernier bloc d'une ligne,inférieur à 8 pixels
i.ModuloBpl	dc.l	0 ;Nombre d'octets en plus par ligne dans l'image au format bitplan

;Tables:
i.bplDatas	dcb.b	8,0	;Table utilisée pour la convertion planar=>Chunky.
i.palette	dcb.l	256,0	;Palette convertie en 8bits par composante

;Listes de tags:

i.getAttrs	dc.l	PDTA_BitMap,i.bitmap
		dc.l	PDTA_BitMapHeader,i.bmh
		dc.l	PDTA_NumColors,i.numColors
		dc.l	PDTA_CRegs,i.colors

		dc.l	TAG_DONE

