;APS00000000000000000000000000000000000000000000000000000000000000000000000000000000
**************************************************************
**************************************************************
*****************************************************************
*								*
*	-Moteur 3d à E®kinou/¡¶ðe¶$Ë-1997 (Vélo Version)-	*
*	(Thanks to S!lver pour son idée de mettre autre	chose	*
*	 qu'un froid numéro à la version... ¦)  )		*
* Trashing-off:							*
*samedi	24/5/1997:Débutation (Enfin après de longues heures	*
*		  de reflexions...¡¶ðe¶$Ës)			*
*diman	25/5/1997:Rotatouilles,calculs relatifs=>absolus (Dots)	*
*mardi	27/5/1997:Débutation du clipping			*
*mercr	28/5/1997:Debuggation et finitions des calculs 3d	*
*		  (double Matrice...)				*
*jeudi	29/5/1997:Re-Debuggation des calculs 3d			*
*lundi	2/6/1997:Première version du clipping sur Z(Gros boulot)*
*lundi	2/6/1997:-(Nuit suivante,avant minuit(23h44)) Deuxième	*
*		 version du clipping sur Z:Clipping sur Zmin ET	*
*		 Zmax,sans bugg,sinon que si l'objet dépasse sur*
*		 Zmin ET Zmax,ben y'a plantage...Alors attention*
*		 -J'ai également ajouter le contrôl de la rota-	*
*		  tion de la caméra au joypad.			*
*Mardi	4/6/1997:Prmières structures de mouvements:vecteur+Rota	*
*		Amélioration du control Joystick;on peut à	*
*		Présent se déplacer dans l'environnement.	*
*Mercr 4/6/1997 :Je m'aperçois que les mouvements sont pas sans	*
*		"buggs"...J'aurais un gros travail à ce niveau. *
*Diman 5/9/1997 :Troisième version du clipping sur Z.Cette	*
*		 version est le fruit d'une longue reflexion	*
*		 et va me permettre d'aboutir facilement aux	*
*		 autres clippings (X et Y)			*
*		 Le petit problème de la version 2 est niqué.	*
*Lundi 9/6/1997 :Et voilà,clipping X et Y terminés.Y'aura tout	*
*		 de même des petites choses à optimiser.	*
*Mardi 10/6/1997:Stockage des faces clippées/DeuxDéfiées sous	*
*		 forme d'une liste séquencielle.Je vais donc	*
*		 pouvoir maintenant m'attaquer au tri rapide.	*
*		 Mes première tentatives sont peu fructueuses...*
*Mercr 11/6/1997:TRI REUSSI.Le quicksort marche impec.Youpi.	*
*		 J'ai eut du mal et frôlé la folie récursive.	*
*		 And now...NOW,THE AFFICHAGE of polygones..Yeah!*
*Jeudi 12/6/1997:(Il est 3h50 du mat'...) J'ai inclus une de	*
*		 mes routines de polygones.			*
*		 Débugg du clipping (lisait trop de Points...). *
*		 Routine de Code G pour l'affichage des lignes	*
*		 lors du remplissage des polygones (3 bitplans)	*
*		 Prochain objectif:Optimiser le clipping.	*
*lundi 16/6/1997:Après plusieurs jours de tests...et de jeu sur *
*		 le moteur,de trifouillages de mouvements et	*
*		 d'objets,je me penche un peu sur les mouvements*
*		 J'ai donc niqué le déplacement de la caméra,qui*
*		 n'était là que pour tester les calculs 3d.	*
*		-J'ai amélioré le code G de l'affichage,je passe*
*		 ainsi en 4 bitplans(16 couleurs)		*
*Diman 22/6/1997 Première version d'objet type4:Trajectoire par	*
*		 étapes...C'est plus dur à faire qu'il n'y	*
*		 parait...					*
*Lundi 23/6/1997 La trajectoire par étapes marche NICKEL!	*
*		 Options: boucle ON/OFF,Backward,		*
*			  Reinit Startpos ON/OFF		*
*		 Ca a pas marché du tout premier coup,mais y'	*
*		 avait 3 fois rien à modifier...		*
*Mardi 24/6/1997 -Mouvement à la souris amelioré.Maitenant,je	*
*		 tiens compte du nombre de Vbls écoulées entre	*
*		 deux appels à la souris.			*
*		 -Effacement écran au Blitter.Interchangabilité	*
*		  avec l'effacement au processeur.		*
*		 l'avantage de l'effacement au blitter,c'est que*
*		 on perd autant de temps que l'effacement au	*
*		 processeur(68020 à 14Mhz...),mais en plus,on	*
*		 peut afficher un Background.Ce que j'ai fais	*
*		 avec un fond d'étoiles...Youpi!Ca ajoute un peu*
*		 de "dézigne".					*
*		-Il y a un bugg dans l'effacement au blitter.	*
*Mercr 25/6/1997 -Debuggage du blittclearing,mais seulement	*
*		 grâce à une bidouille:un écran de plus dans	*
*		 le buffer rotatif(donc 5 ecrans..aieaieaie...)	*
*Jeudi 26/6/1997 Un petit coup de folie m'a pris,et je me suis	*
*		 tapé un mode 256 couleurs avec background.	*
*Vendr 27/6/1997 -Un gros travail sur les matrices:		*
*		  correction sur X,et matrice caméra,qui traite	*
*		  les coords dans le sens inverse.		*
*		  Un bon point:Je sais maintenant "facilement"	*
*		  trouver une matrice à partir des formules de	*
*		  base......pfffouuu!!!				*
*		 -Allocation d'une pile personnelle.		*
*Diman 29/6/1997 -Débuggation de l'affichage des polygones.	*
*		 -calcul de l'orientation des popols.		*
*Mardi 1/7/1997 -Choix de nombre de bitplans(3-8)		*
*Mercr 2/7/1997 -Version Cinéma(16/9) Lores 352*200*6 		*
*		-Il reste des buggs...Mais je les supprimerais	*
*		 dans un prochain moteur, entierement recodé...	*
*		 	See you in another Time!		*
*								*
*				-End of 3dMotorV1.0 Making of-	*
*****************************************************************


*************************************************************************

*---- données générales de mes environnements----*
	OPL=44
	OPL1=44
	depth=6
	size=8800

*-------- Customs ----------------------------*
	Oui=1
	Nein=0

 	Test=Nein
 	BlitClear=Oui
	StackSize=20000
*---- Données pour les tests temps machine ---*

;Code des couleurs:
;	Bleu clair($88F):Calul matrice caméra

;	Rouge($F00)	:Calcul position objet
;	Blanc($FFF)	:Calcul matrice Objet+Camera
;	Bleu($F)	:Calcul points objet

;	Vert($F0)	:Calul Zclipping+Convertion 3d=>2d
;	Jaune($FF0)	:Xclipping
;	Bleu ciel($FF)	:Yclipping

;	Gris Foncé($666):Tri
;	Rose($FA8)	:Remplissage polygones
;	Violet($F0F)	:Affichage dots
;	gris($AAA)	:attente blitter
*----- Données Champ de vision ------*
	Perspective=8
	Xscrmin=0
	Xscrmax=351
	Yscrmin=0
	Yscrmax=199
	Zscrmin=10
	ZscrMax=10000000
	centerX=176
	centerY=100

*---- Données objets ----------------*
;	Types:	0=Caméra
;		1=Objet
;		2=Simple vecteur vitesse (vitesse sur 16 bits X,Y,Z)
;		3=Mouvement rotatif simple;vitesses angulaires de l'objet
;		4=Trajectoires rectilignes;calul trajectoire entre des étapes.
;		5=Vecteur Moteur;En fonction de l'orientation de l'objet
;		6=Point de force (attraction ou répulsion)
;		7=Trajectoire précalculée;liste des coords.
;		8=JoyVector ;vecteur moteur manuel,contôl au joypad.

	FacesMax=2000
	SommetsMax=20
	PointsMax=5460

	*---- Données générales ------------*
	Struct_type=0
	Struct_data=1
	*---- Données Polygone -------------*
	PolCouleur=2
	PolNbrPts=4
	PolStartList=6
	*---- Données Objet Type 0  ---------------*
	CamXpos=2
	CamYpos=6
	CamZpos=10
	CamAx=14
	CamAy=18
	CamAz=22
	CamMoveTable=26
	*--- Données objet type 1 ----------------*
	ObjXpos=CamXpos
	ObjYpos=CamYpos
	ObjZpos=CamZpos
	ObjAx=CamAx
	ObjAy=CamAy
	ObjAz=CamAz
	ObjMoveTable=CamMoveTable
	ObjMasse=30
	ObjNbrFrames=34
	ObjFramePtr=36
	ObjNbrPoints=38
	ObjPointsTable=40
	ObjBobsLDTable=44

	*--- Données Objet type 2 16bit ---------------*
	VectorDep2VX=2
	VectorDep2VY=4
	VectorDep2VZ=6

	*--- Données Objet type 3 16bits---------------*
	RotaVect3Vax=2
	RotaVect3Vay=6
	RotaVect3Vaz=10

	*--- Données Objet type 4 ---------------------*

	;flags:	bit0:Bouclage ON(1)/OFF(0)
	;	bit1:1=Mode Ping-pong
	;	bit2:1=Pas de retour à la position de départ

	;	bit4:1=Mouvement en cours
	;	bit5:1=Mouvement désactivé
	;	bit6:1=Mouvement en phase BackWard (pour ping-ping)

	Traject4EtapesPtr=2	;Pointeur étapes
	Traject4NbrEtapes=4	;Nombre total d'étapes
	Traject4StartXpos=6
	Traject4StartYpos=10
	Traject4StartZpos=14
	Traject4EtapeXadd=18	;Vitesse actuelle sur	X
	Traject4EtapeYadd=22	;	"	"	Y
	Traject4EtapeZadd=26	;	"	"	Z

	Etape4StartXpos=30	;Coord X de départ de l'étape
	Etape4StartYpos=34	;Coord Y " "
	Etape4StartZpos=38	;Coord Z " "
	Etape4NbrFrames=42	;Nombre de frames dans l'étape
	Etape4FramesPtr=44	;Pointeur frames
	Etape4EndXpos=46	;Coord X de fin de l'étape
	Etape4EndYpos=50	;Coord Y " "
	Etape4EndZpos=54	;Coord Z " "

	*--- Données Objet type 5 ---------------------*

	Vector5Speed=2
	Vector5Xdir=4
	Vector5Ydir=6
	Vector5Zdir=8

*------- Données diverses ------*

	Xpos=0
	Ypos=4
	Zpos=8

	Mlt=12

	O1=0
	O2=2
	O3=4
	O4=6
	O5=8
	O6=10
	O7=12
	O8=14
	O9=16

	PolyOffset=0
	PolyZmoy=2
	PolyAdd=6

************* CONDITIONS D'ASSEMBLAGE *******************
	iflt	Zscrmin
	end
	endif
	if	Xscrmax<=Xscrmin
	end
	endif
	if	Yscrmax<=Yscrmin
	end
	endif
	if	Zscrmax<=Zscrmin
	end
	endif
**************** Macros vin blanc. Putain,tordant le truc. **********

forbid		MACRO
		Move.l	4,a6
		Jsr	-132(a6)
		ENDM
Permit		MACRO
	Move.l	4,a6
	Jsr	-138(a6)
		ENDM
Openlib		MACRO		**> 1\=libname , 2\=version , 3\=base.
	Move.l	4,a6
	Move.l	#\1,a1
	moveq	#\2,d0
	Jsr	-552(a6)
	Move.l	d0,\3
		ENDM

CloseLib	MACRO		**> 1\=adresse de base de la library.
	Move.l	4,a6
	Move.l	\1,a1
	Jsr	-414(a6)
		ENDM

******************************************************************************
* C'est l'histoire de PAF le chien.Y'a une voiture,et PAF le chien!  subtil. *
*Y'a aussi l'histoire de boom l'éléphant:C'est un éléphant qui s'appelle BOOM*
*...y'a une Twingo qu'arrive,et BOOM la Twingo. (Cohe/Skyrock funnies! ¦) )  *
******************************************************************************
			section	programe,code_f
			incdir	cd0:code/routines/asm/TeufTeuf3d/
Zygo	forbid

*********************************************************
*ENVIRONNEMENT		Système à la con.		*
*********************************************************

BARRE_TOI
	lea		$dff000,a5
	Move.l		$6C.w,Vbl_save
	move.l		$80.w,int_save
	Move.w		INTENAR(a5),Intena_save
	Move.w		INTREQR(a5),Intreq_save
	Move.w		DMACONR(a5),DMA_save
	Move.w		#$7FFf,INTENA(a5)	;coupe pas le cia
	Move.w		#$7FFf,INTREQ(a5)
	Move.w		#$0dFF,DMACON(a5)

	clr.w		$dff180

	bsr.w	inits_1


REVIENS_LEON
	lea		$dff000,a5
	move.w		#32,$1dc(a5)
	Move.w		#$7fff,$dff09a
	Move.l		Vbl_save(pc),$6C.w
	move.l		int_save(pc),$80.w
	openlib		gfxname,39,gfxbase
	Move.l		GFXbase(pc),a4
	Move.l		38(a4),COP1LC(a5)
	CloseLib	GFXbase
	Clr.w		COPJMP1(a5)
	Move.w		Intena_save(pc),d0
	Or.w		#$8000,d0
	Move.w		d0,INTENA(a5)
	Move.w		Intreq_save(pc),d0
	Or.w		#$8000,d0
	Move.w		d0,INTREQ(a5)
	Move.w		DMA_save(pc),d0
	Or.w		#$8000,d0
	Move.w		d0,DMACON(a5)
	Permit
	moveq		#0,d0
	RTS

;****** VARS sys ******
Save_pile		dc.l	0
SAVE_Registres		Dcb.l	15
Vbl_save		Dc.l	0
int_save		dc.l	0
Intena_save		Dc.w	0
Intreq_save		Dc.w	0
DMA_save		Dc.w	0
;----------------------------
GFXname		Dc.b	'graphics.library',0
Dosname		Dc.b	'dos.library',0
ecs_aga		dc.b	0
GFXbase		dc.l	0
Dosbase		dc.l	0
sadds		dc.l	sprite0,sprite1,sprite2,sprite3,sprite4
		dc.l	sprite5,sprite6,sprite7
plan1		dc.l	0
plan2		dc.l	0
plan3		dc.l	0
plan4		dc.l	0
plan5		dc.l	0
*****************************************************************
*			INITS					*
*****************************************************************
inits_1
	;move.w	#%1001,d0	;cache start
	;movec	d0,cacr

	lea	Ecran3d,a0
	lea	Coppain,a1
	bsr.w	Calc_PlaneSize

	move.l	4.w,a6				;alloue la mémoire
	move.l	Ecran3d+Ecran_PlaneSize,d7
	clr.w	d0
	move.b	Ecran3d+Ecran_Depth,d0
	mulu.w	d0,d7
	move.l	d7,d0
	move.l	#$10002,d1
	jsr	-198(a6)
	tst.l	d0
	beq.w	Fin_programme0
	move.l	d0,Plan1
	move.l	d7,d0
	move.l	#$10002,d1
	jsr	-198(a6)
	tst.l	d0
	beq.w	Fin_programme1
	move.l	d0,Plan2
	move.l	d7,d0
	move.l	#$10002,d1
	jsr	-198(a6)
	tst.l	d0
	beq.w	Fin_programme2
	move.l	d0,Plan3
	move.l	d7,d0
	move.l	#$10002,d1
	jsr	-198(a6)
	tst.l	d0
	beq.w	Fin_programme3
	move.l	d0,Plan4
	move.l	d7,d0
	move.l	#$10002,d1
	jsr	-198(a6)
	tst.l	d0
	beq.w	Fin_programme4
	move.l	d0,Plan5

	lea	back,a0		;installe le background
	move.l	plan5(pc),a1
	move.l	#63,d0
	bset	#17,d0
	bset	#18,d0
	moveq	#5,d1
	move.w	#199,d2
	move.l	Ecran3d+Ecran_PlaneSize,d3
	move.l	d3,a5
	sub.l	#OPL1,a5
	clr.w	d4
	move.b	Ecran3d+Ecran_Depth,d4
	mulu.w	d4,d3
	sub.l	#OPL1,d3
	move.l	d3,a4
	move.l	#OPL1-1,a6
	bsr.w	Meuh

	lea	pal,a0		;installe la palette
	moveq	#63,d0
	bset	#16,d0
	bset	#18,d0
	bset	#19,d0
	bsr.w	Meuh
	moveq	#63,d0
	bsr.w	put_palette_on_clist

	lea	Ecran3d,a0
	lea	Coppain,a1
	bsr.w	Open_Ecran

	move.l	plan1(pc),d0
	move.l	Ecran3d+Ecran_PlaneSize,d2
	bsr.w	bijoul_coppain
	bsr.w	hello_spraitz
	lea	$dff000,a5
	move.l	#coppain,COP1LC(a5)
	move.l	#coppain2,COP2LC(a5)
	clr.w	COPJMP1(a5)

*************************************************************************
*			Début programme					*
*************************************************************************
Init3d
	move.l	4.w,a6				;Alloue Tables Masks
	clr.l	d0
	move.w	Ecran3d+Ecran_WinXsize,d0
	lsl.l	#3,d0
	move.l	d0,d7
	move.l	#$10004,d1
	jsr	-198(a6)
	tst.l	d0
	bne.s	.SkmDal
	move.l	d7,d0
	move.l	#$10002,d1
	jsr	-198(a6)
	tst.l	d0
	beq.w	Er_SkemaD
.SkmDal	move.l	d0,SkemaD
	clr.l	d0
	move.w	Ecran3d+Ecran_WinXsize,d0
	lsl.l	#2,d0
	addq.l	#1,d0
	move.l	d0,d7
	move.l	#$10004,d1
	jsr	-198(a6)
	tst.l	d0
	bne.s	.SkmFal
	move.l	d7,d0
	move.l	#$10002,d1
	jsr	-198(a6)
	tst.l	d0
	beq.w	Er_SkemaF
.SkmFal	move.l	d0,SkemaF
	clr.l	d0

	move.w	Ecran3d+Ecran_WinYsize,d0	;Alloue Tables Xmin/Xmax
	lsl.l	d0
	move.l	d0,d7
	move.l	#$10004,d1
	jsr	-198(a6)
	tst.l	d0
	bne.s	.xminal
	move.l	d7,d0
	move.l	#$10002,d1
	jsr	-198(a6)
	tst.l	d0
	beq.w	Er_XminTab
.xminal	move.l	d0,Xmin
	clr.l	d0
	move.w	Ecran3d+Ecran_WinYsize,d0
	lsl.l	d0
	addq.l	#1,d0
	move.l	d0,d7
	move.l	#$10004,d1
	jsr	-198(a6)
	tst.l	d0
	bne.s	.xmaxal
	move.l	d7,d0
	move.l	#$10002,d1
	jsr	-198(a6)
	tst.l	d0
	beq.w	Er_XmaxTab
.xmaxal	move.l	d0,Xmax

	bsr.w	Gogo_GadgetoCodeG		;Génère les roots de remp.
	bsr.w	Coucou_les_mamasks		;Génère les masks
	ifne	BlitClear			;attente blitter
	btst	#6,$dff002
	bne.s	*-8
	endif
	lea	$dff000,a5
	clr.w	JOYTEST(a5)
	move.l	#vbl,$6c.w
	move.w	#$c010,$dff09a
	move.w	#$83e0,DMACON(a5)
	bsr.w	Velo
	move.w	#$10,$dff09a

*********************************************************
*			Phases Finales			*
*********************************************************
Fin_programme
	move.l	4.w,a6
	clr.l	d0
	move.w	Ecran3d+Ecran_WinYsize,d0
	lsl.l	d0
	move.l	Xmax(pc),a1
	jsr	-210(a6)
Er_XmaxTab
	clr.l	d0
	move.w	Ecran3d+Ecran_WinYsize,d0
	lsl.l	d0
	move.l	Xmin(pc),a1
	jsr	-210(a6)
Er_XminTab
	clr.l	d0
	move.w	Ecran3d+Ecran_WinXsize,d0
	lsl.l	#2,d0
	move.l	SkemaF(pc),a1
	jsr	-210(a6)
Er_SkemaF
	clr.l	d0
	move.w	Ecran3d+Ecran_WinXsize,d0
	lsl.l	#3,d0
	move.l	SkemaD(pc),a1
	jsr	-210(a6)
Er_SkemaD
	move.l	Ecran3d+Ecran_PlaneSize,d7
	clr.w	d0
	move.b	Ecran3d+Ecran_Depth,d0
	mulu.w	d0,d7
	move.l	plan5(pc),a1
	move.l	d7,d0
	jsr	-210(a6)
Fin_Programme4
	move.l	plan4(pc),a1
	move.l	d7,d0
	jsr	-210(a6)
Fin_Programme3
	move.l	plan3(pc),a1
	move.l	d7,d0
	jsr	-210(a6)
Fin_Programme2
	move.l	plan2(pc),a1
	move.l	d7,d0
	jsr	-210(a6)
Fin_Programme1
	move.l	plan1(pc),a1
	move.l	d7,d0
	jsr	-210(a6)
Fin_Programme0
	rts	;rte
**************************************************************************
*	Programmes synchro avec la vblablablatralala.
**************************************************************************
Vbl
	movem.l	d0-a6,-(sp)
	bsr.w	Moumouse
	addq.w	#1,Vbl_compteur
	movem.l	(sp)+,d0-a6
	move.b	#1,vbl_ind
	;move.w	#$10,$dff09c
	rts
*************************************************************************
*			ROUTINES PRINCIPALES				*
*************************************************************************
*************************************************************************
*MOTEUR 3d	Erk/INTENSE 24/5/1997					*
*************************************************************************
Velo
*------------ synchronisation --------*
	move.l	Frame_delay(pc),d0
.sync	bsr.w	Vbl
	btst	#6,$bfe001
	bne.s	.0
	rts
.0	cmp.w	vbl_compteur(pc),d0
	bgt.s	.sync
.wtvbl	tst.b	vbl_ind
	beq.s	.wtvbl
.s	move.w	vbl_compteur(pc),vbl_compteur_a
	clr.w	vbl_compteur
		ifne	Test
		CLR.W	$DFF106
		MOVE.W	#$88F,$DFF180
		endif

*---------- Swap buffers ------------*
	move.l	plan4(pc),d0
	move.l	plan3(pc),plan4
	move.l	plan2(pc),plan3
	move.l	plan1(pc),plan2
	move.l	d0,plan1

*----------- Effacement écran -------*
	*--- effacement au processeur ------*
	ifeq	BlitClear	
	move.l	plan4(pc),a0
	move.w	Ecran3d+Ecran_Ysize,d0
	clr.w	d1
	move.b	Ecran3d+Ecran_Depth,d1
	mulu.w	d1,d0
	subq.w	#1,d0
	bsr.w	Zouh
	endif

	*----- effacement au blitter -------*
	ifne	BlitClear
	lea	$dff000,a5
	move.l	#-1,BLTAFWM(a5)
	clr.w	BLTAMOD(a5)
	clr.w	BLTDMOD(a5)
	move.l	#$09f00000,BLTCON0(a5)
	move.l	plan4(pc),BLTDPTH(a5)
	move.l	plan5(pc),BLTAPTH(a5)
	move.w	#1200,BLTSIZV(a5)
	move.w	#OPL1/2,BLTSIZH(a5)
	endif

*----------- CINEMATIQUE --------*
	*------- On calcul d'abord la matrice de la caméra ----*
	move.l	Camera,a0
	lea	mama_camera(pc),a5
	move.w	CamAz(a0),d5
	move.w	CamAy(a0),d6
	move.w	CamAx(a0),d7
	neg.w	d5
	neg.w	d6
	neg.w	d7
	bsr.w	caca_mama

	*------ Ensuite,on calcul les coordonnées des points de la scène ---*
	move.l	#Table_absolue,Scene_3dAbsolue
	lea	Scene_Objets,a0	;a0=Table des objets
	clr.w	nbrdots
.Coordonnees_3d
	tst.l	(a0)
	beq.s	Papy_a_la_mer
	move.l	(a0)+,a1	;a1=@objet
	move.l	a0,-(sp)
	move.b	Struct_type(a1),d0
.camt	cmp.b	#0,d0
	bne.s	.objt
	bsr.w	Cam_Cacalcucul
	bra.s	.suiv
.objt	cmp.b	#1,d0
	bne.s	.Traj4
	move.l	Camera,a0	;a0=@Caméra
	bsr.w	Obj_CacalCucul
	bra.s	.suiv
.traj4	cmp.b	#4,d0
	bne.s	.suiv
	bsr.w	Trajectoire_par_etapes
.suiv	move.l	(sp)+,a0
	bra.s	.Coordonnees_3d

*--------- CONVERTION 3d=>2d -------------*

Papy_a_la_mer
	move.l	#Scene2d,Scene_2d
	clr.w	nbrfaces
	clr.w	Poly_offset
	Lea	Scene_faces,a0	;a0=Table des faces de la scène
.concon
	tst.l	(a0)
	beq.s	Trilititi
	move.l	(a0)+,a1		;a1=@Face
	move.l	a0,-(sp)
	lea	Table_absolue,a0	;a0=@Table des points de la scène
	bsr.w	Cacaconcon
	move.l	(sp)+,a0
	bra.s	.concon

*----------------------- TRI --------------------------*
Trilititi
	ifne	Test
	MOVE.W	#$666,$DFF180
	endif
	move.l	a7,Save_pile
	lea	Stack,a7
	bsr.w	tri_zomik
	move.l	save_pile(pc),a7
	move.w	d1,Liste_Header

*------------------ AFFICHAGE -------------------------*
fifi	;bra.s	Fin_of_frame
	ifne	Test
	MOVE.W	#$FA8,$DFF180
	endif
	move.w	Nbrfaces(pc),d0
	subq.w	#1,d0
	bmi.s	Fin_of_frame
	lea	PolyAdds,a1
	move.w	Liste_Header(pc),d1
.aff	move.l	PolyAdd(a1,d1.w),a0	;a0=@ struct_polygone
	movem.l	d0/d1/a1,-(sp)
	bsr.w	Splashouille
	movem.l	(sp)+,d0/d1/a1
	move.w	PolyOffset(a1,d1.w),d1	;Offset struct_polygone suivant
	dbra	d0,.aff


Fin_of_frame
*------------ affichage des dots --------------*
		ifne	Test
		MOVE.W	#$F0F,$DFF180
		endif
	;bsr.w	Dodots_Clipped_Sorted
		ifne	test
		move.W	#$aaa,$DFF180
		endif

*------------ Init copper ----------------------*
	btst	#6,$dff002
	bne.s	*-8

	move.l	plan1(pc),d0
	move.l	Ecran3d+Ecran_PlaneSize,d2
	bsr.w	bijoul_coppain

*------------ divers inits ---------------------*
	move.l	Ax_Dep(pc),Ax_Dep2
	clr.l	Ax_Dep
	ifne	BlitClear
	endif
	clr.b	vbl_ind
		ifne	test
		CLR.W	$DFF180
		endif
	bra.w	Velo

*****************************************************************
*			SOUS-ROUTINES				*
*****************************************************************

*********************************************************
*OBJETs TYPE 0		CAMERAs				*
*********************************************************
Cam_Cacalcucul	;a1=@ structure Caméra
	move.w	CamAz(a1),d5
	move.w	CamAy(a1),d6
	move.w	CamAx(a1),d7
	;neg.w	d5
	;neg.w	d6
	;neg.w	d7
	lea	la_mama(pc),a5
	bsr.w	da_mama

	tst.l	CamMoveTable(a1)
	beq.w	.nono
	move.l	CamMoveTable(a1),a2
	bsr.w	Fripounette

.nono	rts
*********************************************************
*OBJETs TYPE 1		OBJETs				*
*********************************************************
Obj_Cacalcucul	;a1=@ Struct_Objet
	ifne	Test
	MOVE.W	#$F00,$DFF180
	endif

*- - - - Rotation de la position de l'objet (données en 32 bits)- -*
	move.l	camera,a0
	lea	gertrude(pc),a2		;Stockage position absolue de l'objet

	move.l	ObjXpos(a1),d0
	sub.l	CamXpos(a0),d0
	move.l	d0,Xpos(a2)

	move.l	ObjYpos(a1),d0
	sub.l	CamYpos(a0),d0
	move.l	d0,Ypos(a2)

	move.l	ObjZpos(a1),d0
	sub.l	CamZpos(a0),d0
	move.l	d0,Zpos(a2)	

	lea	mama_camera(pc),a5
	move.l	Xpos(a2),a0
	move.l	Ypos(a2),a4
	move.l	Zpos(a2),a6
	move.l	a2,a3
	move.l	#256,d4

	Rept	3
	move.l	a0,d0
	move.l	a4,d1
	move.l	a6,d2
	move.w	(a5)+,d3
	ext.l	d3
	muls.l	d3,d7:d0
	divs.l	d4,d7:d0
	move.w	(a5)+,d3
	ext.l	d3
	muls.l	d3,d7:d1
	divs.l	d4,d7:d1
	move.w	(a5)+,d3
	ext.l	d3
	muls.l	d3,d7:d2
	divs.l	d4,d7:d2
	add.l	d2,d1
	add.l	d1,d0
	move.l	d0,(a3)+
	endr

*- - - -  angles rotation camera+objet - - - - *
ess1	move.w	ObjAz(a1),d5
	move.w	ObjAy(a1),d6
	move.w	ObjAx(a1),d7
	lea	la_mama(pc),a5
	ifne	Test
	MOVE.W	#$FFF,$DFF180
	endif
	bsr.w	da_mama
	lea	les_mamelles(pc),a3
	lea	mama_camera(pc),a4
	rept	3
	movem.w	(a4),d0-d2
	muls.w	O1(a5),d0
	muls.w	O4(a5),d1
	muls.w	O7(a5),d2
	add.l	d2,d1
	add.l	d1,d0
	asr.l	#8,d0
	move.w	d0,(a3)+
	movem.w	(a4),d0-d2
	muls.w	O2(a5),d0
	muls.w	O5(a5),d1
	muls.w	O8(a5),d2
	add.l	d2,d1
	add.l	d1,d0
	asr.l	#8,d0
	move.w	d0,(a3)+
	movem.w	(a4)+,d0-d2
	muls.w	O3(a5),d0
	muls.w	O6(a5),d1
	muls.w	O9(a5),d2
	add.l	d2,d1
	add.l	d1,d0
	asr.l	#8,d0
	move.w	d0,(a3)+
	endr
	ifne	Test
	MOVE.W #$F,$dff180
	endif

*- - - - Badaboom,on calcul les pouaints - - - - -*
	move.w	ObjNbrPoints(a1),d5	;d5=nbr de points
	subq.w	#1,d5
	lea	nbrdots(pc),a6
	move.l	ObjPointsTable(a1),a0	;a0=Table des points relatifs
	lea	scene_3dAbsolue(pc),a4
	move.l	(a4),a3			;a3=Table des points absolus
	lea	les_mamelles(pc),a5	;a5=@matrice.
.points	movem.w	(a0),d0-d2		;Chargement des coordonnées
	muls	O1(a5),d0		;d0=X*O1
	muls	O2(a5),d1		;d1=Y*O2
	muls	O3(a5),d2		;d2=Z*O3
	add.l	d2,d1			;d1=Z*O3+Y*O2
	add.l	d1,d0			;d0=Z*O3+Y*O2+X*O1
	asr.l	#8,d0		;d0=X" relatif
	movem.w	(a0),d1-d3		;Chargement des coords
	muls	O4(a5),d1		;d1=X*O4
	muls	O5(a5),d2		;d2=Y*O5
	muls	O6(a5),d3		;d3=Z*O6
	add.l	d3,d2			;d2=Z*O6+Y*O5
	add.l	d2,d1			;d1=Z*O6+Y*O5+X*O4
	asr.l	#8,d1		;d1=Y" relatif
	movem.w	(a0)+,d2-d4		;Chargement des coords + incrémentation
	muls	O7(a5),d2		;d2=X*O7
	muls	O8(a5),d3		;d3=Y*O8
	muls	O9(a5),d4		;d4=Z*O9
	add.l	d4,d3			;d3=Z*O9+Y*O8
	add.l	d3,d2			;d2=Z*O9+Y*O8+X*O7
	asr.l	#8,d2		;d2=Z" relatif
	add.l	Xpos(a2),d0		;d0=X"absolu
	add.l	Ypos(a2),d1		;d1=Y"absolu
	add.l	Zpos(a2),d2		;d2=Z"absolu
	move.l	d0,(a3)+
	move.l	d1,(a3)+		;Stockage des coords 3d dans la table
	move.l	d2,(a3)+
	addq.w	#1,(a6)		;NE SERT QUE POUR AFFICHAGE DOTS...
	dbra	d5,.points		;Point suivant
	move.l	a3,(a4)		;Sauvegarde de la position actuelle du pointeur

*- - - - Mouvement objet - - - - - - *
	tst.l	ObjMoveTable(a1)
	beq.w	.fin
	move.l	ObjMoveTable(a1),a2
	bsr.w	Fripounette

.fin	rts			; sur la table des coordonnées absolues.

*****************************************************************
*OBJETs TYPE 4		TRAJECTOIREs PAR ETAPEs			*
*****************************************************************
Trajectoire_par_etapes	;a1=@Struct_Mouvement
	btst	#5,Struct_data(a1)	;test si mouvement terminé
	bne.w	Type4_Fin
	clr.l	d0
	move.w	Traject4EtapesPtr(a1),d0
	lsl.l	#4,d0
	lea	(a1,d0.l),a2
	btst	#4,Struct_data(a1)	;test si mouvement déjà entamé.
	bne.s	.Encours
	bset	#4,Struct_data(a1)
	bra.w	.initEtape
.Encours
	move.w	Etape4FramesPtr(a2),d0
	cmp.w	Etape4Nbrframes(a2),d0
	blt.w	.Fsuiv
	clr.w	Etape4FramesPtr(a2)
	btst	#6,struct_data(a1)
	bne.s	.backw
.forew	move.w	Traject4EtapesPtr(a1),d0
	addq.w	#1,d0
	cmp.w	Traject4NbrEtapes(a1),d0
	blt.s	.Esuiv
	btst	#1,Struct_data(a1)
	beq.s	.nopgpg
	bset	#6,Struct_data(a1)	;passage en mode ping pong
	bra.w	.initEtape
.nopgpg	btst	#0,Struct_data(a1)
	beq.s	.term
	clr.w	Traject4EtapesPtr(a1)
	btst	#2,Struct_data(a1)
	beq.s	.restrt
	move.l	a1,a2
	bra.s	.initEtape
.restrt	bclr	#4,Struct_data(a1)
	move.l	Traject4StartXpos(a1),Traject4EtapeXadd(a1)
	move.l	Traject4StartYpos(a1),Traject4EtapeYadd(a1)
	move.l	Traject4StartZpos(a1),Traject4EtapeZadd(a1)
	clr.l	Traject4StartXpos(a1)
	clr.l	Traject4StartYpos(a1)
	clr.l	Traject4StartZpos(a1)
	rts
.Esuiv	lea	16(a2),a2
	addq.w	#1,Traject4EtapesPtr(a1)
	bra.s	.initEtape
.backw	tst.w	Traject4EtapesPtr(a1)
	bgt.s	.Eprec
	btst	#0,Struct_data(a1)
	beq.s	.term
	bclr	#6,Struct_data(a1)
	bra.s	.initEtape
.Eprec	lea	-16(a2),a2
	subq.w	#1,Traject4EtapesPtr(a1)
	bra.s	.initEtape

.term	bset	#5,Struct_data(a1)
	rts

.Fsuiv	move.l	Traject4EtapeXadd(a1),d0
	sub.l	d0,Traject4StartXpos(a1)
	move.l	Traject4EtapeYadd(a1),d0
	sub.l	d0,Traject4StartYpos(a1)
	move.l	Traject4EtapeZadd(a1),d0
	sub.l	d0,traject4StartZpos(a1)
	addq.w	#1,Etape4FramesPtr(a2)
	rts
.initEtape
	move.w	Etape4NbrFrames(a2),d1
	ext.l	d1
	move.l	Etape4EndXpos(a2),d2
	sub.l	Etape4StartXpos(a2),d2
	divs.l	d1,d2
	move.l	Etape4EndYpos(a2),d3
	sub.l	Etape4StartYpos(a2),d3
	divs.l	d1,d3
	move.l	Etape4EndZpos(a2),d4
	sub.l	Etape4StartZpos(a2),d4
	divs.l	d1,d4
	btst	#6,Struct_data(a1)	;test si on est en
	beq.s	.Stock			; mode BackWard
	btst	#2,Struct_data(a1)
	bne.s	.Stock
	neg.l	d2
	neg.l	d3
	neg.l	d4
.Stock	move.l	d2,Traject4EtapeXAdd(a1)
	move.l	d3,Traject4EtapeYAdd(a1)
	move.l	d4,Traject4EtapeZAdd(a1)
	sub.l	d2,Traject4StartXpos(a1)
	sub.l	d3,Traject4StartYpos(a1)
	sub.l	d4,Traject4StartZpos(a1)
	addq.w	#1,Etape4FramesPtr(a2)
Type4_Fin
	rts
*****************************************************************
*		Matrice OBJETS corrigée.Erk/INTENSE 27/6/1997	*
*****************************************************************
*La présente matrice calcul les rotations en tenant compte de
*l'inversion sur X de l'écran...
*
*				Recherche:
*				----------
*-1°:
*----
*	X'=x*cos(az)-y*sin(az)
*	Y'=x*sin(az)+y*cos(az)
*
*	X"=X'*cos(ay)-z*sin(ay)
*	Z'=X'*sin(ay)+z*cos(ay)
*
*	Z"=Z'*cos(ax)-Y'*sin(ax)
*	Y"=Z'*sin(ax)+Y'*cos(ax)
*
*-2°:
*----
*	X"=[x*cos(az)-y*sin(az)]*cos(ay)-z*sin(ay)
*	Y"=[{x*cos(az)-y*sin(az)}*sin(ay)+z*cos(ay)]*sin(ax)
*	+[x*sin(az)+y*cos(az)]*cos(ax)
*	Z"=[{x*cos(az)-y*sin(az)}*sin(ay)+z*cos(ay)]*cos(ax)
*	-[x*sin(az)+y*cos(az)]*sin(ax)
*-3°:
*----
*	X"=
*	x*cos(az)*cos(ay)-y*sin(az)*cos(ay)-z*sin(ay)
*	Y"=
*	x*cos(az)*sin(ay)*sin(ax)-y*sin(az)*sin(ay)*sin(ax)+z*cos(ay)*sin(ax)
*	+x*sin(az)*cos(ax)+y*cos(az)*cos(ax)
*	Z"
*	=x*cos(az)*sin(ay)*cos(ax)-y*sin(az)*sin(ay)*cos(ax)+z*cos(ay)*cos(ax)
*	-x*sin(az)*sin(ax)-y*cos(az)*sin(ax)
*-4°:
*----
*	X"=
*	 x* [cos(az)*cos(ay)]
*	+y* [-sin(az)*cos(ay)]
*	+z* [-sin(ay)]
*	Y"=
*	x*[cos(az)*sin(ay)*sin(ax)+sin(az)*cos(ax)]
*	+y*[cos(az)*cos(ax)-sin(az)*sin(ay)*sin(ax)]
*	+z*[cos(ay)*sin(ax)]
*	Z"=
*	x*[cos(az)*sin(ay)*cos(ax)-sin(az)*sin(ax)]
*	+y*[-sin(az)*sin(ay)*cos(ax)-cos(az)*sin(ax)]
*	+z*[cos(ay)*cos(ax)]

*-5°:			Programme:
*----			----------

da_mama	;d5=Az  d6=Ay  d7=Ax	;a5=@Stockage Matrice
	lea	sin,a3
	lea	cos,a4
	and.w	#$ffe,d5
	and.w	#$ffe,d6
	and.w	#$ffe,d7
	move.w	(a3,d5.w),d2	;d2=Sin(Az)
	move.w	(a3,d6.w),d3	;d3=Sin(Ay)
	move.w	(a3,d7.w),d4	;d4=Sin(Ax)
	move.w	(a4,d5.w),d5	;d5=Cos(Az)
	move.w	(a4,d6.w),d6	;d6=Cos(Ay)
	move.w	(a4,d7.w),d7	;d7=Cos(Ax)

;O1=[cos(az)*cos(ay)] 
	move.w	d5,d0
	muls.w	d6,d0
	asr.l	#8,d0
	move.w	d0,O1(a5)
;O2=[-sin(az)*cos(ay)]
	move.w	d2,d0
	muls.w	d6,d0
	asr.l	#8,d0
	neg.w	d0
	move.w	d0,O2(a5)
;O3=[-sin(ay)]
	move.w	d3,d0
	neg.w	d0
	move.w	d0,O3(a5)
;O4=[cos(az)*sin(ay)*sin(ax)+sin(az)*cos(ax)]
	move.w	d5,d0
	muls.w	d3,d0
	asr.l	#8,d0
	muls.w	d4,d0
	move.w	d2,d1
	muls.w	d7,d1
	add.l	d1,d0
	asr.l	#8,d0
	move.w	d0,O4(a5)
;O5=[cos(az)*cos(ax)-sin(az)*sin(ay)*sin(ax)]
	move.w	d5,d0
	muls.w	d7,d0
	move.w	d2,d1
	muls.w	d3,d1
	asr.l	#8,d1
	muls.w	d4,d1
	sub.l	d1,d0
	asr.l	#8,d0
	move.w	d0,O5(a5)
;O6=[cos(ay)*sin(ax)]
	move.w	d6,d0
	muls.w	d4,d0
	asr.l	#8,d0
	move.w	d0,O6(a5)
;O7=[cos(az)*sin(ay)*cos(ax)-sin(az)*sin(ax)]
	move.w	d5,d0
	muls.w	d3,d0
	asr.l	#8,d0
	muls.w	d7,d0
	move.w	d2,d1
	muls.w	d4,d1
	sub.l	d1,d0
	asr.l	#8,d0
	move.w	d0,O7(a5)
;O8=[-sin(az)*sin(ay)*cos(ax)-cos(az)*sin(ax)]
	move.w	d2,d0
	muls.w	d3,d0
	asr.l	#8,d0
	muls.w	d7,d0
	move.w	d5,d1
	muls.w	d4,d1
	add.l	d1,d0
	asr.l	#8,d0
	neg.w	d0
	move.w	d0,O8(a5)
;O9=[cos(ay)*cos(ax)]
	move.w	d6,d0
	muls.w	d7,d0
	asr.l	#8,d0
	move.w	d0,O9(a5)
	rts


*****************************************************************
*	Matrice CAMERA corrigée.Erk/INTENSE 27/6/1997		*
*****************************************************************
*La présente matrice calcul les rotations en tenant compte de
*l'inversion sur X de l'écran...
*
*				Recherche:
*				----------
*-1°:
*----
*	Z'=Z*cos(ax)-Y*sin(ax)
*	Y'=Z*sin(ax)+Y*cos(ax)
*	X'=X*cos(ay)-Z'*sin(ay)
*	Z"=X*sin(ay)+Z'*cos(ay)
*	X"=X'*cos(az)-Y'*sin(az)
*	Y"=X'*sin(az)+Y'*cos(az)
*
*-2°:
*----
*	X"=
*	{X*cos(ay)-[Z*cos(ax)-Y*sin(ax)]*sin(ay)}*cos(az)
*	-[Z*sin(ax)+Y*cos(ax)]*sin(az)
*	Y"=
*	{X*cos(ay)-[Z*cos(ax)-Y*sin(ax)]*sin(ay)}*sin(az)
*	+[Z*sin(ax)+Y*cos(ax)]*cos(az)
*	Z"=
*	X*sin(ay)+[Z*cos(ax)-Y*sin(ax)]*cos(ay)
*-3°:
*----
*	X"=
*	X*cos(ay)*cos(az)-Z*cos(ax)*sin(ay)*cos(az)+Y*sin(ax)*sin(ay)*cos(az)
*	-Z*sin(ax)*sin(az)-Y*cos(ax)*sin(az)
*	Y"=
*	X*cos(ay)*sin(az)-Z*cos(ax)*sin(ay)*sin(az)+Y*sin(ax)*sin(ay)*sin(az)
*	+Z*sin(ax)*cos(az)+Y*cos(ax)*cos(az)
*	Z"=
*	X*sin(ay)+Z*cos(ax)*cos(ay)-Y*sin(ax)*cos(ay)
*
*-4°:
*----
*	X"=
*	 X* [cos(ay)*cos(az)]
*	+Y* [sin(ax)*sin(ay)*cos(az)-cos(ax)*sin(az)]
*	+Z* [-cos(ax)*sin(ay)*cos(az)-sin(ax)*sin(az)]
*	Y"=
*	 X* [cos(ay)*sin(az)]
*	+Y* [cos(ax)*cos(az)+sin(ax)*sin(ay)*sin(az)]
*	+Z* [sin(ax)*cos(az)-cos(ax)*sin(ay)*sin(az)]
*	Z"=
*	 X* [sin(ay)]
*	+Y* [-sin(ax)*cos(ay)]
*	+Z* [cos(ax)*cos(ay)]

*-5°:			Programme:
*----			----------

caca_mama	;d5=Az  d6=Ay  d7=Ax	;a5=@Stockage Matrice
	lea	sin,a3
	lea	cos,a4
	and.w	#$ffe,d5
	and.w	#$ffe,d6
	and.w	#$ffe,d7
	move.w	(a3,d5.w),d2	;d2=Sin(Az)
	move.w	(a3,d6.w),d3	;d3=Sin(Ay)
	move.w	(a3,d7.w),d4	;d4=Sin(Ax)
	move.w	(a4,d5.w),d5	;d5=Cos(Az)
	move.w	(a4,d6.w),d6	;d6=Cos(Ay)
	move.w	(a4,d7.w),d7	;d7=Cos(Ax)

;O1=[cos(az)*cos(ay)] 
	move.w	d5,d0
	muls.w	d6,d0
	asr.l	#8,d0
	move.w	d0,O1(a5)
;O2=[sin(ax)*sin(ay)*cos(az)-cos(ax)*sin(az)]
	move.w	d4,d0
	muls.w	d3,d0
	asr.l	#8,d0
	muls.w	d5,d0
	move.w	d7,d1
	muls.w	d2,d1
	sub.l	d1,d0
	asr.l	#8,d0
	move.w	d0,O2(a5)
;O3=-[sin(ax)*sin(az)+cos(ax)*sin(ay)*cos(az)]
	move.w	d4,d0
	muls.w	d2,d0
	move.w	d7,d1
	muls.w	d3,d1
	asr.l	#8,d1
	muls.w	d5,d1
	add.l	d1,d0
	asr.l	#8,d0
	neg.w	d0
	move.w	d0,O3(a5)
;O4=cos(ay)*sin(az)
	move.w	d6,d0
	muls.w	d2,d0
	asr.l	#8,d0
	move.w	d0,O4(a5)
;O5=[sin(ax)*sin(ay)*sin(az)+cos(ax)*cos(az)]
	move.w	d4,d0
	muls.w	d3,d0
	asr.l	#8,d0
	muls.w	d2,d0
	move.w	d7,d1
	muls.w	d5,d1
	add.l	d1,d0
	asr.l	#8,d0
	move.w	d0,O5(a5)
;O6=[sin(ax)*cos(az)-cos(ax)*sin(ay)*sin(az)]
	move.w	d4,d0
	muls.w	d5,d0
	move.w	d7,d1
	muls.w	d3,d1
	asr.l	#8,d1
	muls.w	d2,d1
	sub.l	d1,d0
	asr.l	#8,d0
	move.w	d0,O6(a5)
;O7=[sin(ay)]
	move.w	d3,O7(a5)
;O8=[-sin(ax)*cos(ay)]
	move.w	d4,d0
	muls.w	d6,d0
	asr.l	#8,d0
	neg.w	d0
	move.w	d0,O8(a5)
;O9=[cos(ax)*cos(ay)]
	move.w	d7,d0
	muls.w	d6,d0
	asr.l	#8,d0
	move.w	d0,O9(a5)
	rts


*********************************************************
*	Gestion DES MOUVEMENTS INDIVIDUELS		*
*********************************************************
;	(application des mouvements aux objets)
Fripounette	;a2=@liste mouvements a1=@Objet
	tst.l	(a2)
	beq.w	frimousseFin
	move.l	(a2)+,a3
	move.b	Struct_type(a3),d0
	*--------- Déplacement linéaire -------------*
type2	cmp.b	#2,d0			;type 2=Vecteur déplacement
	bne.w	type3
	move.w	Vbl_compteur_a(pc),d1
	move.w	VectorDep2VX(a3),d0
	muls.w	d1,d0
	add.l	d0,ObjXpos(a1)
	move.w	VectorDep2VY(a3),d0
	muls.w	d1,d0
	add.l	d0,ObjYpos(a1)
	move.w	VectorDep2VZ(a3),d0
	muls.w	d1,d0
	add.l	d0,ObjZpos(a1)
	bra.s	Fripounette

	*--------- Rotation linéaire ------------------*
type3	cmp.b	#3,d0			;type 3=Vitesse rotation
	bne.s	type4
	move.w	Vbl_compteur_a(pc),d1
	ext.l	d1
	move.l	RotaVect3Vax(a3),d0
	muls.l	d1,d0
	add.l	d0,ObjAx(a1)
	move.l	RotaVect3Vay(a3),d0
	muls.l	d1,d0
	add.l	d0,ObjAy(a1)
	move.l	RotaVect3Vaz(a3),d0
	muls.l	d1,d0
	add.l	d0,ObjAz(a1)
	bra.s	Fripounette

	*---------- Déplacement par étapes --------------*
type4	cmp.b	#4,d0
	bne.w	type5
	btst	#5,Struct_data(a3)
	bne.s	Fripounette
	move.l	Traject4EtapeXadd(a3),d0
	add.l	d0,ObjXpos(a1)
	move.l	Traject4EtapeYadd(a3),d0
	add.l	d0,ObjYpos(a1)
	move.l	Traject4EtapeZadd(a3),d0
	add.l	d0,ObjZpos(a1)
	bra.w	Fripounette

	*----------Vecteur moteur 1 -----------------------*

type5	cmp.b	#5,d0
	bne.w	type6
	btst	#0,Struct_data(a3)
	beq.s	.nomous
	move.w	ObjAx(a1),d3
	move.w	ObjAy(a1),d4
	sub.w	Ax_Dep2(pc),d3
	sub.w	Ay_Dep2(pc),d4
	move.w	d3,ObjAx(a1)
	move.w	d4,ObjAy(a1)
.nomous	lea	la_mama(pc),a5
	move.w	Vector5Xdir(a3),d0
	move.w	Vector5Ydir(a3),d1
	move.w	Vector5Zdir(a3),d2
	move.w	d0,d3
	move.w	d1,d4
	move.w	d2,d5
	muls.w	O1(a5),d3
	muls.w	O2(a5),d4
	muls.w	O3(a5),d5
	add.l	d5,d4
	add.l	d4,d3
	asr.l	#8,d3			;d3=Xstep
	move.w	d0,d4
	move.w	d1,d5
	move.w	d2,d6
	muls.w	O4(a5),d4
	muls.w	O5(a5),d5
	muls.w	O6(a5),d6
	add.l	d6,d5
	add.l	d5,d4
	asr.l	#8,d4			;d4=Ystep
	muls.w	O7(a5),d0
	muls.w	O8(a5),d1
	muls.w	O9(a5),d2
	add.l	d2,d1
	add.l	d1,d0
	asr.l	#8,d0			;d0=Zstep
	muls.w	Vector5Speed(a3),d3
	muls.w	Vector5Speed(a3),d4
	muls.w	Vector5Speed(a3),d0
	asr.l	#8,d3
	asr.l	#8,d4
	asr.l	#8,d0
	move.w	Vbl_compteur_a(pc),d1
	muls.w	d1,d3
	muls.w	d1,d4
	muls.w	d1,d0
	add.l	d3,ObjXpos(a1)
	add.l	d4,ObjYpos(a1)
	add.l	d0,ObjZpos(a1)
	bra.w	Fripounette

	*----------Point de force -------------------------*
type6
	bra.w	Fripounette
frimousseFin
	rts

*********************************************************
*	CLIPPING+CONVERTION 3d=>2d D'UN POLYGONE	*
*********************************************************

*-------- MACROs pour "source refreshing" -------*
IntermediaireZ	MACRO	
	move.l	8(a0,d6.w),d2	;d2=Z2 d1=Z1
	move.l	(a0,d0.w),d3	;d3=X1
	move.l	(a0,d6.w),d4	;d4=X2
	move.l	\1,d5		;d5=Limite
	sub.l	d1,d5		;d5=ZMarge
	sub.l	d1,d2		;d2=DeltaZ
	sub.l	d3,d4		;d4=DeltaX
	muls.l	d5,d1:d4
	divs.l	d2,d1:d4
	add.l	d4,d3		;d3=NewX
	move.l	4(a0,d0.w),d4	;d4=Y1
	move.l	4(a0,d6.w),d1	;d1=Y2
	sub.l	d4,d1
	muls.l	d5,d6:d1
	divs.l	d2,d6:d1
	add.l	d1,d4		;d4=NewY
	move.l	#perspective,d5
	asl.l	d5,d3
	asl.l	d5,d4
	move.l	\1,d5
	add.l	d5,a4		;pour Zmoyenne
	divs.l	d5,d3
	divs.l	d5,d4
	move.l	d3,(a3)+	;StockageX
	move.l	d4,(a3)+	;StockageY
	addq.w	#1,a5		;1 point de plus
	ENDM
IntermediaireX	MACRO
	move.l	4(a1),d1	;d0=X1 d1=Y1	
	move.l	-8(a1),d2	;d2=X2
	move.l	-4(a1),d3	;d3=Y2
	move.l	\1,d4		;d4=Lim=\1
	sub.l	d1,d3		;d3=DeltaY
	sub.l	d0,d4		;d4=MargeX
	sub.l	d0,d2		;d2=DeltaX
	muls.l	d4,d5:d3
	divs.l	d2,d5:d3
	add.l	d3,d1		;d1=NewY	
	move.l	\1,(a3)+
	move.l	d1,(a3)+
	addq.w	#1,a5
	ENDM
IntermediaireY	MACRO
	move.l	(a1),d1		;d0=Y1 d1=X1	
	move.l	-4(a1),d2	;d2=Y2
	move.l	-8(a1),d3	;d3=X2
	move.l	\1,d4		;d4=Lim=\1
	sub.l	d1,d3		;d3=DeltaX
	sub.l	d0,d4		;d4=MargeY
	sub.l	d0,d2		;d2=DeltaY
	muls.l	d4,d5:d3
	divs.l	d2,d5:d3
	add.l	d3,d1		;d1=NewX	
	move.w	d1,(a3)+
	move.w	\1,(a3)+
	addq.w	#1,a5
	ENDM

*------------- Début routine -------------------*

Cacaconcon	;a0=@Table des coords a1=@ Polygone
	ifne	test
	MOVE.W	#$F0,$DFF180
	endif

	lea	Scene_2d(pc),a2		;a2=Stockage des polygones 2d
	move.l	a1,a6			;a6=sauvegarde polygone
*------------ clipping sur Z ----------------------*
ClipZ	lea	Polygone_clipped1(pc),a3
	move.w	PolNbrpts(a1),d7	;d7=Nbr de points
	addq.l	#PolStartlist,a1
	subq.w	#1,d7
	sub.w	a5,a5		;a5=Compteur du nombre de points stockés
	move.w	(a1)+,d0
	move.l	8(a0,d0.w),d1
	sub.l	a4,a4		;a4=Zcptr pour Zmoyenne
	cmp.l	#Zscrmax,d1
	bgt.w	Points_LimMax
	cmp.l	#Zscrmin,d1
	ble.w	Points_LimMin
Points_In
	moveq	#Perspective,d4
	move.l	(a0,d0.w),d2	;Chargement X
	move.l	4(a0,d0.w),d3	;Chargement Y
	asl.l	d4,d2
	asl.l	d4,d3
	divs.l	d1,d2
	divs.l	d1,d3
	move.l	d2,(a3)+	;Stockage X
	move.l	d3,(a3)+	;Stockage Y
	add.l	d1,a4
	addq.w	#1,a5		;Un point de plus
	move.w	d0,d6		;d6=Sauvegarde point
	move.w	(a1)+,d0
	move.l	8(a0,d0.w),d1
max	cmp.l	#Zscrmax,d1
	ble.s	min
	INTERMEDIAIREZ	#Zscrmax-1
	dbra	d7,Points_Limmax
	bra.w	ClipX
min	cmp.l	#Zscrmin,d1
	bgt.s	Ptok
	INTERMEDIAIREZ	#Zscrmin+1
	dbra	d7,Points_Limmin
	bra.w	ClipX
Ptok	dbra	d7,Points_In
	bra.w	ClipX
Points_Limmax
	move.w	d0,d6
	move.w	(a1)+,d0
	move.l	8(a0,d0.w),d1
Ptmax	cmp.l	#Zscrmax,d1
	ble.s	Ptmin
	dbra	d7,Points_Limmax
	bra.w	ClipX
Ptmin	INTERMEDIAIREZ	#Zscrmax-1
	move.l	8(a0,d0.w),d1
	cmp.l	#Zscrmin,d1
	bgt.s	Potok
A	INTERMEDIAIREZ	#Zscrmin+1
	dbra	d7,Points_Limmin
	bra.w	ClipX
Potok	dbra	d7,Points_IN
	bra.w	ClipX
Points_Limmin
	move.w	d0,d6
	move.w	(a1)+,d0
	move.l	8(a0,d0.w),d1
Potmin	cmp.l	#Zscrmin,d1
	bgt.s	Potmax
	dbra	d7,Points_Limmin
	bra.w	ClipX
Potmax	INTERMEDIAIREZ	#Zscrmin+1
	move.l	8(a0,d0.w),d1
	cmp.l	#Zscrmax,d1
	ble.s	Poutok
B	INTERMEDIAIREZ	#Zscrmax-1
	dbra	d7,Points_Limmax
	bra.s	ClipX
Poutok	dbra	d7,Points_IN


*---------- Clipping sur X --------------------------*
Clipx
	ifne	Test
	MOVE.W	#$FF0,$DFF180
	endif
	move.w	a5,d7
	subq.w	#1,d7
	bmi.w	Finconv
	lea	polygone_clipped1(pc),a1
	move.l	(a1),(a3)+		;on copie le premier point
	move.l	4(a1),(a3)+		;en dernière position
	lea	Polygone_clipped2(pc),a3
	sub.w	a5,a5
	move.l	(a1),d0
	cmp.l	#Xscrmax-CenterX,d0
	bgt.w	Point_Xmax
	cmp.l	#Xscrmin-CenterX,d0
	blt.w	Point_Xmin
Point_XIN
	move.l	d0,(a3)+
	move.l	4(a1),(a3)+
	addq.w	#1,a5
	addq.l	#8,a1
	move.l	(a1),d0
xmx	cmp.l	#Xscrmax-CenterX,d0
	ble.s	xmn
	INTERMEDIAIREX	#Xscrmax-CenterX
	dbra	d7,Point_Xmax
	bra.w	ClipY
xmn	cmp.l	#Xscrmin-CenterX,d0
	bge.s	xok
	INTERMEDIAIREX	#Xscrmin-CenterX	;
	dbra	d7,Point_Xmin
	bra.w	ClipY
xok	dbra	d7,Point_XIN
	bra.w	ClipY
Point_Xmax
	addq.l	#8,a1
	move.l	(a1),d0
	cmp.l	#Xscrmax-CenterX,d0
	ble.s	xmxin
	dbra	d7,Point_Xmax
	bra.w	ClipY
xmxin	INTERMEDIAIREX	#Xscrmax-CenterX
	cmp.l	#Xscrmin-CenterX,d0
	bge.s	okxmxin
D	INTERMEDIAIREX	#Xscrmin-CenterX
	dbra	d7,Point_Xmin
	bra.w	ClipY
okxmxin	dbra	d7,Point_XIN
	bra.w	ClipY
Point_Xmin
	addq.l	#8,a1
	move.l	(a1),d0
	cmp.l	#Xscrmin-CenterX,d0
	bge.s	xmnin
	dbra	d7,Point_Xmin
	bra.s	ClipY
xmnin	INTERMEDIAIREX	#Xscrmin-CenterX	;
	cmp.l	#Xscrmax-CenterX,d0
	ble.s	okxmnin
E	INTERMEDIAIREX	#Xscrmax-CenterX
	dbra	d7,Point_Xmax
	bra.s	ClipY
okxmnin	dbra	d7,Point_XIN

*--------- Clipping sur Y -------------------------------*
ClipY	ifne	Test
	MOVE.W	#$FF,$DFF180
	endif
	move.w	a5,d7
	subq.w	#1,d7
	bmi.w	Finconv
	lea	polygone_clipped2(pc),a1
	move.l	(a1),(a3)+		;on copie le premier point
	move.l	4(a1),(a3)		;en dernière position
	move.l	(a2),a3
	addq.l	#4,a3
	sub.w	a5,a5
	move.l	4(a1),d0
	cmp.l	#Yscrmax-CenterY,d0
	bgt.w	Point_Ymax
	cmp.l	#Yscrmin-CenterY,d0
	blt.w	Point_Ymin
Point_YIN
	move.w	2(a1),(a3)+
	move.w	d0,(a3)+
	addq.w	#1,a5
	addq.l	#8,a1
	move.l	4(a1),d0
ymx	cmp.l	#Yscrmax-CenterY,d0
	ble.s	ymn
	INTERMEDIAIREY	#Yscrmax-CenterY
	dbra	d7,Point_Ymax
	bra.w	Yoopee
ymn	cmp.l	#Yscrmin-CenterY,d0
	bge.s	yok
	INTERMEDIAIREY	#Yscrmin-CenterY
	dbra	d7,Point_Ymin
	bra.w	Yoopee
yok	dbra	d7,Point_YIN
	bra.w	Yoopee
Point_Ymax
	addq.l	#8,a1
	move.l	4(a1),d0
	cmp.l	#Yscrmax-CenterY,d0
	ble.s	ymxin
	dbra	d7,Point_Ymax
	bra.w	Yoopee
ymxin	INTERMEDIAIREY	#Yscrmax-CenterY
	cmp.l	#Yscrmin-CenterY,d0
	bge.s	okymxin
F	INTERMEDIAIREY	#Yscrmin-CenterY
	dbra	d7,Point_Ymin
	bra.w	Yoopee
okymxin	dbra	d7,Point_YIN
	bra.w	Yoopee
Point_Ymin
	addq.l	#8,a1
	move.l	4(a1),d0
	cmp.l	#Yscrmin-CenterY,d0
	bge.s	ymnin
	dbra	d7,Point_Ymin
	bra.s	Yoopee
ymnin	INTERMEDIAIREY	#Yscrmin-CenterY
	cmp.l	#Yscrmax-CenterY,d0
	ble.s	okymnin
G	INTERMEDIAIREY	#Yscrmax-CenterY
	dbra	d7,Point_Ymax
	bra.s	Yoopee
okymnin	dbra	d7,Point_YIN

*-------- Initialisation polygone --------------------------------*
Yoopee	ifne	Test
	MOVE.W	#$F0,$DFF180
	endif
	move.w	a5,d7
	tst.w	d7
	beq.s	finconv
	*---- test l'orientation du popol -----*
	move.l	(a2),a1
	movem.w	4(a1),d0-d5	;d0=X1 d1=Y1 d2=X2 d3=Y2 d4=X3 d5=Y3
	sub.w	d0,d4
	sub.w	d1,d5
	sub.w	d0,d2
	sub.w	d1,d3
	muls.w	d4,d3
	muls.w	d5,d2
	sub.l	d2,d3
	bgt.w	FinConv

	addq.w	#1,Nbrfaces		;un polygone de plus
	move.w	Polcouleur(a6),(a1)+	;couleur du polygone
	move.w	d7,(a1)+		;stockage nbrpts
	move.l	(a1)+,(a3)+		;premier point en dernier
	lea	polyadds,a1
	move.w	Poly_offset(pc),d0
	move.l	(a2),Polyadd(a1,d0.w)
	ext.l	d7
	move.l	a4,d6
	divs.l	d7,d6					;d6=Zmoyenne
	move.l	d6,PolyZmoy(a1,d0.w)
	add.w	#10,Poly_offset				;Noeud suivant
	move.w	Poly_offset(pc),PolyOffset(a1,d0.w)
	move.l	a3,(a2)		;sauve nouvelle position du pointeur scene_2d
FinConv	rts
***************************************************************************
*TRI les faces,de la plus loin à la plus proche (en fonction de ZMoyenne) *
***************************************************************************
Tri_Zomik		;Résultat: d1=Offset liste header
	lea	PolyAdds,a0
	move.w	Nbrfaces(pc),d7
	clr.w	d0
Trigolyte
	move.w	d0,d1			;d1=Pointeur liste Sup
	subq.w	#2,d7
	bmi.s	.notri
	move.w	d0,d6			;d6=Offset dernière valeur Inf
	clr.w	d2			;d2=Nbr éléments liste Sup
	clr.w	d3			;d3=Nbr éléments liste Inf
	move.l	PolyZmoy(a0,d0.w),d4	;d4=Poids Liste header
	move.w	PolyOffset(a0,d0.w),d5	;d5=Offset noeud suivant
.test	move.w	PolyOffset(a0,d5.w),a1	;On sauve l'offset du prochain noeud
	cmp.l	PolyZmoy(a0,d5),d4
	bgt.s	.ListInf
.ListSup
	move.w	d1,PolyOffset(a0,d5.w)
	move.w	d5,d1
	addq.w	#1,d2
	bra.s	.suiv
.ListInf
	move.w	PolyOffset(a0,d0.w),PolyOffset(a0,d5.w)
	move.w	d5,PolyOffset(a0,d0.w)
	tst.w	d3
	bne.s	.ntfrst
	move.w	d5,d6
.ntfrst	addq.w	#1,d3
.suiv	move.w	a1,d5
	dbra	d7,.test
	move.w	d5,PolyOffset(a0,d6.w)
	movem.w	d1/d2,-(sp)
	move.w	d0,-(sp)
	move.w	PolyOffset(a0,d0.w),d0
	move.w	d3,d7
	bsr.s	Trigolyte
	move.w	(sp)+,d0
	move.w	d1,PolyOffset(a0,d0.w)
	movem.w	(sp)+,d0/d7
	bsr.s	Trigolyte

.notri	rts

*****************************************************************
*		AFFICHAGE D'UN POLYGONE				*
*****************************************************************
Splashouille	;a0=@ struct_polygone
		Poly_couleur=0
		Nbr_points=2
		Ymin=4
		Ymax=6

* - - - - - - - - - isole le polygone traité - - - - - - - - - - - - - - - - -
obj_tri		lea	Struct_calcobjet(pc),a6
		move.w	(a0)+,poly_couleur(a6)	;couleur object
		move.w	(a0)+,d1		;d1=Nbr sommets
		subq.w	#1,d1
		move.w	d1,nbr_points(a6)

*- - - - - - - - Cherche Ymin et Ymax - - - - - - - - - - - - - - - - - - - - -
bonono
		move.l	a0,a4
		move.w	nbr_points(a6),d1
.yabon		subq.w	#1,d1
		move.l	(a4)+,d2	;d2=YMIN
		move.w	d2,d3		;d3=YMAX

.search		move.l	(a4)+,d4
.ymin		cmp.w	d2,d4
		bge.s	.ymax
		move.w	d4,d2
		bra.s	.ok
.ymax		cmp.w	d3,d4
		ble.s	.ok
		move.w	d4,d3
.ok		dbra	d1,.search

*- - - - - - - - - - trace le contour virtuel du polygone - - - - - - - - - - -
ploum	add.w	#CenterY,d2
	add.w	#CenterY,d3
		move.w	d2,Ymin(a6)
		move.w	d3,Ymax(a6)
onepoint	move.l	xmin(pc),a2
		move.l	xmax(pc),a3
		move.w	nbr_points(a6),d1	;d1=nombre de lignes -1
		move.l	a0,a4
.polygone
		move.l	a3,a5
		movem.w	(a4),d2/d3/d4/d5
	add.w	#CenterX,d2
	add.w	#CenterY,d3
	add.w	#CenterX,d4
	add.w	#CenterY,d5
		addq.l	#4,a4
		move.w	d5,d6
		sub.w	d3,d6		;d6=|DeltaY|
		beq.s	.horizontale
		bpl.s	.deltaX
		neg.w	d6
		exg.l	d2,d4
		exg.l	d3,d5
		move.l	a2,a5
.deltaX		sub.w	d2,d4		;d4=DeltaX
		beq.s	.verticale
		lea	(a5,d3.w*2),a5	;positionnement au bon z'endroit
		ext.l	d2
		ext.l	d6
		swap	d4
		clr.w	d4
		divs.l	d6,d4
		swap	d2
		move.w	d4,d2
		swap	d4
		swap	d2
		subq.w	#1,d6
.line		move.w 	d2,(a5)+
		addx.l	d4,d2
		dbra	d6,.line
		dbra	d1,.polygone
		bra.s	Yaouuu

.horizontale	cmp.w	Ymax(a6),d3
		bne.s	.lh
		move.w	d4,(a2,d3.w*2)
		move.w	d2,(a3,d3.w*2)
		dbra	d1,.polygone
		bra.s	Yaouuu
.lh		move.w	d2,(a2,d3.w*2)
		move.w	d4,(a3,d3.w*2)
		dbra	d1,.polygone
		bra.s	Yaouuu
.verticale
.lv		sub.w	d3,d5	;d5=hauteur ligne
		lea	(a5,d3.w*2),a5
		subq.w	#1,d5
.linev		move.w	d2,(a5)+
		dbra	d5,.linev
		dbra	d1,.polygone

*------------ REMPLISSAGE DU POLYGONE ---------------------*
		Psize=OPL1*200

Yaouuu
		move.l	Xmin(pc),a0
		move.l	Xmax(pc),a1
		move.l	SkemaD(pc),a2
		move.l	SkemaF(pc),a3
		lea	Y_tab(pc),a4
		move.l	plan1(pc),a5
		move.w	ymin(a6),d1
		move.w	ymax(a6),d0	
		sub.w	d1,d0		;d0=nbr de lignes
		subq.w	#1,d0
		bmi.s	.fin
		lea	(a0,d1.w*2),a0
		lea	(a1,d1.w*2),a1
		add.l	(a4,d1.w*4),a5
		move.w	poly_couleur(a6),d1
		lea	affaffs,a4
		move.l	(a4,d1.w*4),d1	;d1=@ des blocks
		moveq	#-1,d2
		move.w	#$ffe0,d5	;pour arrondissement au block près

.shloups				;d1 = couleur
		move.l	a5,a6
		lea	OPL1(a5),a5
		move.l	d1,a4
		move.w	(a0)+,d3	;d3=Xmin
		move.w	(a1)+,d4	;d4=Xmax
		cmp.w	d3,d4
		ble.s	.suite
		add.l	(a2,d3.w*8),a6
		move.l	4(a2,d3.w*8),d6
		move.l	(a3,d4.w*4),d7
		and.w	d5,d3
		and.w	d5,d4
		sub.w	d3,d4
		lsr.w	#3,d4
		move.l	(a4,d4.w),a4
		movem.l	a0-a3/a5,-(sp)
		lea	Psize(a6),a0
		lea	Psize(a0),a1
		lea	Psize(a1),a2
		lea	Psize(a2),a3
		lea	Psize(a3),a5
		jsr	(a4)
		movem.l	(sp)+,a0-a3/a5
.suite		dbra	d0,.shloups
.fin		rts

*******************************************************
*- - - - - - - - - - Gestion Joypad - - - - - - - - - -*
********************************************************
	Spdturn=20
Batondjoie	;d3=Ax	;d4=Ay
		move.w	$dff00c,d0
.droite		btst	#1,d0
		bne.s	.gauche
		sub.w	#SpdTurn,d4
.gauche		btst	#9,d0
		bne.s	.bas
		add.w	#SpdTurn,d4
.bas		move.w	d0,d1
		lsr.w	#1,d1
		eor.w	d1,d0
		btst	#0,d0
		bne.s	.haut
		add.w	#SpdTurn,d3
.haut		btst	#8,d0
		bne.s	.s
		sub.w	#SpdTurn,d3
.s		rts

*- - - - - - - mouvement de la souris
Moumouse	;d3=X	d4=Y
		move.b	$dff00b,d0	;test X
		move.b	a_mouse+1(pc),d1
		sub.b	d1,d0		;test écart entre les deux.
		move.b	d0,d2
		bpl.s	.x1
		neg.b	d2
.x1		cmp.b	#127,d2
		ble.s	.x2
		neg.b	d0
		add.b	#255,d0
.x2		ext.w	d0
		asl.w	#1,d0	;ralentissement souris
		add.w	d0,Ay_Dep
		move.b	$dff00a,d0	;test Y
		move.b	a_mouse(pc),d1
		sub.b	d1,d0		;test écart entre les deux.
		move.b	d0,d2
		bpl.s	.y1
		neg.b	d2
.y1		cmp.b	#127,d2
		ble.s	.y2
		neg.b	d0
		add.b	#255,d0
.y2		ext.w	d0
		asl.w	#1,d0	;ralentissement souris
		add.w	d0,Ax_Dep
 		move.w	$dff00a,a_mouse
		rts
a_mouse		dc.w	0
Ax_dep		dc.w	0
Ay_dep		dc.w	0
Ax_dep2		dc.w	0
Ay_dep2		dc.w	0
*****************************************************************
*	ROUTINE QUI GENERE LES ROUTINES D'AFFICHAGE		*
*****************************************************************
*****************************************************************
*****************************************************************
Gogo_GadgetoCodeG

	;include	gegene_6.i
*****************************************************************
*	Génères les routines de remplissage			*
*--------------- Pour 6 bitplans (1/7/1997)--------------------*
*****************************************************************
;Gros_Degeuli_6
	AffTable=88282
	NbrPolycolors=64
	include "gegene_Ciné6.i"
*****************************************
*	Création table des masks	*
*****************************************
Coucou_les_mamasks
		move.l	SkemaD(pc),a0	;tab départ
		move.l	SkemaF(pc),a1	;tab fin
		moveq	#0,d0		;d0=offset block
		moveq	#OPL1/4-1,d1		;nbr de block par lignes
.block		moveq	#31,d2		;nbr de points par blocks
		moveq	#-1,d3		;mask départ
		move.l	#$80000000,d4	;mask fin
.pixy		move.l	d0,(a0)+	;offset départ
		move.l	d3,(a0)+  	;mask départ
		move.l	d4,(a1)+	;mask fin		
		asr.l	#1,d4		;héhé.
.c		lsr.l	#1,d3		;chier
		dbra	d2,.pixy	;cé pa bo dir dé gro mo......
		addq.b	#4,d0		;.b car y'a d'toutes façons jamais
		dbra	d1,.block	;     plus de 40 octets par lignes...
		rts			;	enfin pas pour mon écran.

*********************** routine d'effacement ************************

Zouh	;d0:nbr de lignes	a0:@ écran
	moveq	#0,d1
.dacrashline
	rept	OPL1/4
	move.l	d1,(a0)+
	endr
	dbra	d0,.dacrashline
	rts
*************************************************************************
*		cocOOCOOOPEEEEEEER!! (cri du coq remanier....)		*
*************************************************************************

bijoul_coppain		;d0=@ écran	;d2=size
	lea	coppain_plans,a0
	moveq	#Depth-1,d1
.mcl	move.w	d0,6(a0)
	swap	d0
	move.w	d0,2(a0)
	swap	d0
	addq.l	#8,a0
	add.l	d2,d0
	dbra	d1,.mcl
	rts
hello_spraitz
	lea	coppain_sprites,a0
	lea	sadds,a1
	moveq	#7,d0
.mcl
	move.l	(a1)+,d1
	move.w	d1,6(a0)
	swap	d1
	move.w	d1,2(a0)
	addq.l	#8,a0
	dbra	d0,.mcl
	rts
*****************************************************************
*		OUVERTURE D'ECRAN E®k/INTENSE 26/8/1997		*
*****************************************************************
	*---Struct_Ecran
	Ecran_WinXstrt=2
	Ecran_WinYStrt=4
	Ecran_WinXsize=6
	Ecran_WinYsize=8
	Ecran_OPL=10
	Ecran_Ysize=12
	Ecran_Depth=14
	Ecran_Mode=15
	Ecran_PlaneSize=16

	*---Flags_Mode:
	Hires=%1
	Lace=%10
	Dbplf=%100
	HAM=%1000
	EHB=%10000
	EcsEna=%100000

	KILLEHB=9

Open_Ecran	;a0=@Struct_ecran a1=@Struct_copper
	*-------Calcul DIWSTRT et DIWSTOP ------*
	move.w	Ecran_WinXstrt(a0),d0
	move.w	Ecran_WinYStrt(a0),d1
	add.w	#129,d0				;d0=Hstart
	add.w	#41,d1
	lsl.w	#8,d1
	or.w	d0,d1
	move.w	d1,Copper_DIWSTRT(a1)
	move.w	Ecran_WinXsize(a0),d1
	move.w	Ecran_WinYsize(a0),d2
	add.w	Ecran_WinXstrt(a0),d1
	add.w	Ecran_WinYStrt(a0),d2
	sub.w	#127,d1
	sub.w	#215,d2
	lsl.w	#8,d2
	or.w	d2,d1
	move.w	d1,Copper_DIWSTOP(a1)
	*-------Calcul DDFSTRT et DDFSTOP -----*
	lsr.w	d0
	sub.w	#8,d0
	and.b	#$f8,d0				;d0=DDFSTRT
	move.w	d0,Copper_DDFSTRT(a1)
	move.w	Ecran_WinXsize(a0),d1
	lsr.w	d1
	sub.w	#8,d1
	add.w	d1,d0
	move.w	d0,Copper_DDFSTOP(a1)
	*-------Calcul des modulos-------------*
	move.w	Ecran_WinXsize(a0),d0
	lsr.w	#3,d0
	sub.w	Ecran_OPL(a0),d0
	neg.w	d0
	move.w	d0,Copper_BPL1MOD(a1)
	move.w	d0,Copper_BPL2MOD(a1)
	*-------Init de BPLCON0 ---------------*
	clr.w	Copper_BPLCON0(a1)
	move.b	Ecran_Mode(a0),d0
.Hires	btst	#0,d0
	beq.s	.Lace
	or.w	#$8000,Copper_BPLCON0(a1)
.Lace	btst	#1,d0
	beq.s	.Dblplf
	or.w	#4,Copper_BPLCON0(a1)
.Dblplf	btst	#2,d0
	beq.s	.HAM
	or.w	#$400,Copper_BPLCON0(a1)
.HAM	btst	#3,d0
	beq.s	.EcsEna
	or.w	#$800,Copper_BPLCON0(a1)
.Ecsena	btst	#5,d0
	beq.s	.depth
	or.w	#1,Copper_BPLCON0(a1)
.depth	move.b	Ecran_Depth(a0),d0
	cmp.b	#8,d0
	blt.s	.s
	or.w	#%10000,Copper_BPLCON0(a1)
	bra.s	.ok
.s	lsl.b	#4,d0
	or.b	d0,Copper_BPLCON0(a1)
	*------------ Init BPLCON2---------------*
.ok	clr.w	d0
	btst	#4,Ecran_Mode(a0)
	bne.s	.ok0
	bset	#KILLEHB,d0
.ok0	move.w	d0,Copper_BPLCON2(a1)
	*-------Calcul PlaneSize ----------------*
Calc_PlaneSize
	move.w	Ecran_OPL(a0),d0
	move.w	Ecran_Ysize(a0),d1
	mulu.w	d1,d0
	move.l	d0,Ecran_PlaneSize(a0)
	rts


******************************************************************************
******************************************************************************
******** BEU regardeur baï (b)Erk the Cyberschtroumphignol /INTENSE 22/1/1996
*	a0.l	-->	@ fichier .BEU
*	a1.l	-->	@ bitmap
*	d0.l	-->	-bits 0-15 :nombre de couleurs (0-255)
*		 	-bit 16    :1=CMAP on ; 0=CMAP off
*			-bit 17	   :1=BODY on ; 0=BODY off
*			-bit 18    :1=.FUK ; 0=.BEU
*			-bit 19	   :1=nuance 24bits ; 0=nuance 12bits
*	d1.q	-->	nombre de plans (0-7 aga)
*	d2.w	-->	nombre de lignes (0-255 standard)
*	a4	-->	soustraction pour ligne ligne suivante
*			([planesize]*[nbrplans]-octetsparlignes)
* 	a5 -->	Addition pour passage au plan suivant
*			([planesize]-octetsparlignes)
*    	a6 -->	taille d'une ligne ([octets par lignes])-1
******************************************************************************
MEUH		movem.l	d3-d7/a2-a6,-(sp)
		btst	#16,d0
		beq.s	beau_dit
ces_mappe	btst	#19,d0
		beq.s	.12bits
.24bits		lea	Mircouleurs(pc),a2	;C'est pour après,à que le
		lea	Lamcouleurs(pc),a3	;fade il est plus simple.
.lp		move	(a0)+,d4
		move	(a0)+,d5
		btst	#18,d0	;*(décryptage)
		beq.s	.c	;*
		ror	#5,d4	;*
		rol	#7,d5	;*
.c		move	d4,(a2)+
		move	d5,(a3)+
		dbra	d0,.lp
		bra.s	beau_dit

.12bits		lea	$dff180,a2	;palette non  gérée au copper
.lpb		move	(a0)+,(a2)+
		dbra	d0,.lpb

beau_dit	btst	#17,d0
		beq.w	acopalypse
liness		move.w	d1,d7
line_init	move.l	#$ffff,d5
read_line	clr	d3
		addq	#1,d5
linesize	cmp	a6,d5		;à def.
		bhi.s	plansuivant
		move.b	(a0)+,d3
		btst	#18,d0		;*
		beq.s	.bc		;*
		ror.b	#3,d3		;*
.bc		tst.b	d3
		bmi.w	.comprS
.pascomprS	add	d3,d5
.lnc		move.b	(a0)+,d6
		btst	#18,d0		;*
 		beq.s	.t		;*
		ror.b	#3,d6		;*
.t		move.b	d6,(a1)+
		dbra	d3,.lnc
		bra.s	read_line
.comprS		neg.b	d3
		add	d3,d5
		move.b	(a0)+,d4
		btst	#18,d0		;*
		beq.s	.lc		;*
		ror.b	#3,d4		;*
.lc		move.b	d4,(a1)+
		dbra	d3,.lc
		bra.s	read_line
plansuivant	add.l	a5,a1		;à def.
		dbra	d7,line_init
glout		sub.l	a4,a1		;à def.
		dbra	d2,liness
acopalypse	movem.l	(sp)+,d3-d7/a2-a6
		rts
*********************************************************
*	copiage de la palette dans la copper liste	*
*********************************************************
Put_palette_on_clist	;d0=nbrcolors
		movem.l	a0-a3,-(sp)
		lea	Mircouleurs(pc),a0
		lea	Lamcouleurs(pc),a1
		lea	coppine_pMsb,a2			;a2=Msb
		lea	coppine_pLsb,a3		;a3=Lsb
.lp		cmp	#$0106,(a2)	;palette gérée au copper
		bne.s	.c
		addq.l	#4,a2
		addq.l	#4,a3
.c		move	(a0)+,2(a2)
		move	(a1)+,2(a3)
		addq.l	#4,a2
		addq.l	#4,a3
		dbra	d0,.lp
		movem.l	(sp)+,a0-a3
		rts
Mircouleurs	ds	256	;msb
Lamcouleurs	ds	256	;lsb

*****************************************
*		DataCalcSCENE		*
*****************************************

Ecran3d	dc.w	0
	dc.w	-16,28
	dc.w	352,200
	dc.w	OPL1
	dc.w	200
	dc.b	Depth
	dc.b	0
	dc.l	0

*--------- Données de calcul ---------------*
vbl_ind		dc.w	0
vbl_compteur	dc.w	0
vbl_compteur_a	dc.w	0
frame_delay	dc.l	1
Gertrude	dc.l	0,0,0		;XYZpos
mama_camera	ds.w	9		;Matrice pour rotation camera
la_mama		ds.w	9		;Matrice pour rotation objet
les_mamelles	ds.w	9		;Matrice pour les deux rotations
nbrdots		dc.w	0
nbrfaces	dc.w	0
Scene_3dabsolue		dc.l	0
Scene_2d		dc.l	0
Liste_Header	dc.w	0
poly_offset	dc.w	0
Polygone_clipped1	ds.l	2*sommetsmax+16
Polygone_clipped2	ds.l	2*sommetsmax+16

*--------- Données pour affichage des faces -----------*
SkemaD	dc.l	0	(décalage ; mask)
SkemaF	dc.l	0
Xmin	dc.l	0
Xmax	dc.l	0
Struct_calcobjet	
	dc.w	0,0,0,0	;couleur,nbrpts,Ymin,Ymax
y_tab
y	set	0
	rept	200
	dc.l	y
y	set	y+OPL1
	endr
X_tab
x	set	0
	rept	OPL1
	dc.w	x,$80,x,$40,x,$20,x,$10,x,8,x,4,x,2,x,1
x	set	x+1
	endr

*************************************************************************
*				COPPER LISTE				*
*************************************************************************
			section copper,data_c
	*---Struct_copper
	Copper_DIWSTRT=2	;@base=coppain
	Copper_DIWSTOP=6
	Copper_DDFSTRT=10
	Copper_DDFSTOP=14
	Copper_BPLCON0=18
	Copper_BPLCON1=22
	Copper_BPLCON2=26
	Copper_BPLCON4=30
	Copper_BPL1MOD=34
	Copper_BPL2MOD=38
	Copper_BEAMCON0=42
	Copper_FMODE=46

	cnop	0,8
coppain	dc.w	$8e,0
	dc.w	$90,0
	dc.w	$92,0
	dc.w	$94,0
	dc.w	$100,0		;BPLCON0
	dc.w	$102,0		;BPLCON1
	dc.w	$104,0		;BPLCON2
	dc.w	$10c,0		;BPLCON4
	dc.w	$108,0		;BPL1MOD
	dc.w	$10a,0		;BPL2MOD
	dc.w	$1dc,$20	;BEAMCON0
	dc.w	$1fc,$0000	;FMODE
coppain_plans
	dc.w	$e0,0,$e2,0,$e4,0,$e6,0
	dc.w	$e8,0,$ea,0,$ec,0,$ee,0
	dc.w	$f0,0,$f2,0,$f4,0,$f6,0
	dc.w	$f8,0,$fa,0,$fc,0,$fe,0
coppain_sprites
	dc.w	$120,0,$122,0,$124,0,$126,0
	dc.w	$128,0,$12a,0,$12c,0,$12e,0
	dc.w	$130,0,$132,0,$134,0,$136,0
	dc.w	$138,0,$13a,0,$13c,0,$13e,0

coppine_pMsb
p	set	$01060000
	rept	8
	dc.l	p
c	set	$01800000
	rept	32
	dc.l	c
c	set	c+$00020000
	endr
p	set	p+$00002000		;n° palette
	endr
coppine_pLsb
p	set	$01060200	;nuances bits poid faible
	rept	8
	dc.l	p
c	set	$1800000
	rept	32
	dc.l	c
c	set	c+$20000
	endr
p	set	p+$2000		;n° palette
	endr 
coppain_BPLCON3
	dc.w	$106,0		;BPLCON3
	dc.w	COPJMP2,0
	dc.l	-2
	Copper_BPLCON3=(Coppain_BPLCON3-Coppain)+2

************************ 2ème copper *************************
Coppain2
	dc.w	$9c,$8010
	dc.l	-2

*************************************************************************
*				SPRITES					*
*************************************************************************

sprite0		dc.w	0,0
		dc.w	0,0
sprite1		dc.w	0,0
		dc.w	0,0
sprite2		dc.w	0,0
		dc.w	0,0
sprite3		dc.w	0,0
		dc.w	0,0
sprite4		dc.w	0,0
		dc.w	0,0
sprite5		dc.w	0,0
		dc.w	0,0
sprite6		dc.w	0,0
		dc.w	0,0
sprite7		dc.w	0,0
		dc.w	0,0

**************************************************************************
************************** Tables diverses *******************************
**************************************************************************
			;section tables,bss_f
Affs0		ds.l	(OPL1/4)*(NbrPolyColors+1)
Aff_roots	ds.b	AffTable
Table_absolue	ds.l	PointsMax*3
PolyAdds	ds.b	FacesMax*10
Scene2d		ds.w	FacesMax*2*(SommetsMax+1)
		ds.b	StackSize
Stack
******************************************************************************
*---------------------- ELEMENTS GRAPHIQUES ---------------------------------*
******************************************************************************
			section	elements,data_f
	include	offsets.i
sin	incbin	vectorsin.dat
cos	incbin	vectorcos.dat
*tables des addresses remplissages
Affaffs
addy	set	Affs0
	rept	NbrPolycolors+1
	dc.l	addy
addy	set	addy+OPL1
	endr

;Back	incbin	ship.back.fuk
;Pal	incbin	Ship.pal.fuk
Back	incbin	ship.back.fuk
Pal	incbin	Ship.pal.fuk

*----------- Données Scène -----------------*
Camera			dc.l	bertha
	Nbrcubes=40
	affiche_vaisseau=0

Scene_objets
	dc.l	Traject0
	dc.l	Bertha
	ifne	affiche_vaisseau
	dc.l	vaisseau
	endc

ofs	set	0
	rept	Nbrcubes
	dc.l	Objets+ofs
ofs	set	ofs+48
	endr

	dc.l	0

Scene_faces
;	dc.l	I0,I1,I2,I3,I4,I5,I6,I7,I8,I9,I10,I11,I12,I13
;	dc.l	I14,I15,I16,I17,I18,I19,I20,I21,I22,I23,I24,I25,I26


	ifne	affiche_vaisseau
	dc.l	Of1,Of2,Of3,Of4,Of5,Of6,Of7,Of8,Of9,Ofa
	endc

ofs	set	0
	rept	Nbrcubes*6
	dc.l	faces+ofs
ofs	set	ofs+16
	endr

	dc.l	0

*--------- Données Objets---------------------*

Bertha	dc.b	0,0		;type,data
	dc.l	0,0,-500	;Xpos,Ypos,Zpos
	dc.l	0,0,0		;alphaX,alphaY,alphaZ
	dc.l	MoveTable0	;@liste mouvements

Objets
x	set	0
z	set	3000
al	set	0
bl	set	1024
cl	set	0
	rept	nbrcubes
	dc.b	1,0		;type,data
	dc.l	x,0,z		;Xpos,Ypos,Zpos
	dc.w	al,0,bl,0,cl,0	;Ax,Ay,Az	;angles d'inclinaison
	dc.l	Movetable1	;@ Tables/Strucures Mouvements
	dc.l	0		;poid
	dc.w	0,0		;Nbrframes,FramePtr
	dc.w	8		;Nombre de points
	dc.l	Pata1		;@ Table des points
	dc.l	0		;@ Table des bobs "Longue Distance"
x	set	x-50
z	set	z-100
al	set	al+100	;800
bl	set	bl+101	;1013
cl	set	cl+120	;581
	endr
Vaisseau
	dc.b	1,0
	dc.l	0,0,3000
	dc.l	0,0,0
	dc.l	Movetable3
	dc.l	0
	dc.w	0,0
	dc.w	012
	dc.l	Tbl_Coords_Obj000
	dc.l	0
Logo
	dc.b	1,0
    	dc.l	0,0,150000
	dc.l	0,0,0
	dc.l	movetable2
	dc.l	0
	dc.w	0,0
	dc.w	030
	dc.l	Its_coords
	dc.l	0

Its_coords
	dc.w	-30000,-30000,08000
	dc.w	30000,-30000,08000
	dc.w	05000,25000,08000
	dc.w	30000,25000,08000
	dc.w	30000,30000,08000
	dc.w	-30000,30000,08000
	dc.w	-30000,25000,08000
	dc.w	-05000,25000,08000
	dc.w	-20000,-25000,08000
	dc.w	20000,-25000,08000
	dc.w	12200,-05000,08000
	dc.w	-12200,-05000,08000
	dc.w	10000,00000,08000
	dc.w	-10000,00000,08000
	dc.w	00000,20000,08000
	dc.w	-30000,-30000,-08000
	dc.w	30000,-30000,-08000
	dc.w	05000,25000,-08000
	dc.w	30000,25000,-08000
	dc.w	30000,30000,-08000
	dc.w	-30000,30000,-08000
	dc.w	-30000,25000,-08000
	dc.w	-05000,25000,-08000
	dc.w	-20000,-25000,-08000
	dc.w	20000,-25000,-08000
	dc.w	12200,-05000,-08000
	dc.w	-12200,-05000,-08000
	dc.w	10000,00000,-08000
	dc.w	-10000,00000,-08000
	dc.w	00000,20000,-08000

Pata1	dc.w	100,100,-100	;coords
	dc.w	100,-100,-100
	dc.w	-100,-100,-100
	dc.w	-100,100,-100
	dc.w	100,100,100
	dc.w	100,-100,100
	dc.w	-100,-100,100
	dc.w	-100,100,100

Tbl_Coords_Obj000
	dc.w	-300,-200,-600
	dc.w	-500,-100,-600
	dc.w	-500,100,-600
	dc.w	-300,200,-600
	dc.w	300,200,-600
	dc.w	500,100,-600
	dc.w	500,-100,-600
	dc.w	300,-200,-600
	dc.w	-200,-060,900
	dc.w	-200,060,700
	dc.w	200,-060,900
	dc.w	200,060,700

o	set	0

	ifne	Affiche_vaisseau

Of1	dc.w	0,64,008,(000+o)*Mlt,(007+o)*Mlt,(006+o)*Mlt,(005+o)*Mlt
	dc.w	(004+o)*Mlt,(003+o)*Mlt,(002+o)*Mlt,(001+o)*Mlt,(000+o)*Mlt
Of2	dc.w	0,60,004,(006+o)*Mlt,(010+o)*Mlt,(011+o)*Mlt,(005+o)*Mlt,(006+o)*Mlt
Of3	dc.w	0,59,004,(001+o)*Mlt,(002+o)*Mlt,(009+o)*Mlt,(008+o)*Mlt,(001+o)*Mlt
Of4	dc.w	0,58,004,(000+o)*Mlt,(008+o)*Mlt,(010+o)*Mlt,(007+o)*Mlt,(000+o)*Mlt
Of5	dc.w	0,34,004,(003+o)*Mlt,(004+o)*Mlt,(011+o)*Mlt,(009+o)*Mlt,(003+o)*Mlt
Of6	dc.w	0,37,003,(007+o)*Mlt,(010+o)*Mlt,(006+o)*Mlt,(007+o)*Mlt
Of7	dc.w	0,38,003,(005+o)*Mlt,(011+o)*Mlt,(004+o)*Mlt,(005+o)*Mlt
Of8	dc.w	0,39,003,(002+o)*Mlt,(003+o)*Mlt,(009+o)*Mlt,(002+o)*Mlt
Of9	dc.w	0,40,003,(000+o)*Mlt,(001+o)*Mlt,(008+o)*Mlt,(000+o)*Mlt
Ofa	dc.w	0,33,004,(008+o)*Mlt,(009+o)*Mlt,(011+o)*Mlt,(010+o)*Mlt,(008+o)*Mlt
	o	set	o+12

	endc

Faces
cl	set	16
	rept	Nbrcubes
	dc.w	0,cl,4, (1+o)*Mlt,(0+o)*Mlt,(3+o)*Mlt,(2+o)*Mlt,(1+o)*Mlt
	dc.w	0,cl+1,4, (1+o)*Mlt,(5+o)*Mlt,(4+o)*Mlt,(0+o)*Mlt,(1+o)*Mlt
	dc.w	0,cl+2,4, (2+o)*Mlt,(3+o)*Mlt,(7+o)*Mlt,(6+o)*Mlt,(2+o)*Mlt
	dc.w	0,cl+3,4, (1+o)*Mlt,(2+o)*Mlt,(6+o)*Mlt,(5+o)*Mlt,(1+o)*Mlt
	dc.w	0,cl+4,4, (3+o)*Mlt,(0+o)*Mlt,(4+o)*Mlt,(7+o)*Mlt,(3+o)*Mlt
	dc.w	0,cl+5,4, (5+o)*Mlt,(6+o)*Mlt,(7+o)*Mlt,(4+o)*Mlt,(5+o)*Mlt
o	set	o+8
;cl	set	cl+6
	endr

I0	dc.w	0,16,004
	dc.w	(001+o)*mlt,(009+o)*mlt,(014+o)*mlt,(002+o)*mlt,(001+o)*mlt
I1	dc.w	0,17,004
	dc.w	(000+o)*mlt,(008+o)*mlt,(009+o)*mlt,(001+o)*mlt,(000+o)*mlt
I2	dc.w	0,18,004
	dc.w	(000+o)*mlt,(007+o)*mlt,(014+o)*mlt,(008+o)*mlt,(000+o)*mlt
I3	dc.w	0,19,003
	dc.w	(002+o)*mlt,(014+o)*mlt,(007+o)*mlt,(002+o)*mlt
I4	dc.w	0,20,004
	dc.w	(003+o)*mlt,(006+o)*mlt,(005+o)*mlt,(004+o)*mlt,(003+o)*mlt
I5	dc.w	0,21,004
	dc.w	(010+o)*mlt,(011+o)*mlt,(013+o)*mlt,(012+o)*mlt,(010+o)*mlt
I6	dc.w	0,22,004
	dc.w	(015+o)*mlt,(016+o)*mlt,(024+o)*mlt,(023+o)*mlt,(015+o)*mlt
I7	dc.w	0,23,004
	dc.w	(015+o)*mlt,(023+o)*mlt,(029+o)*mlt,(022+o)*mlt,(015+o)*mlt
I8	dc.w	0,24,004
	dc.w	(016+o)*mlt,(017+o)*mlt,(029+o)*mlt,(024+o)*mlt,(016+o)*mlt
I9	dc.w	0,25,003
	dc.w	(017+o)*mlt,(022+o)*mlt,(029+o)*mlt,(017+o)*mlt
I10	dc.w	0,26,004
	dc.w	(025+o)*mlt,(027+o)*mlt,(028+o)*mlt,(026+o)*mlt,(025+o)*mlt
I11	dc.w	0,27,004
	dc.w	(018+o)*mlt,(019+o)*mlt,(020+o)*mlt,(021+o)*mlt,(018+o)*mlt
I12	dc.w	0,28,004
	dc.w	(004+o)*mlt,(005+o)*mlt,(020+o)*mlt,(019+o)*mlt,(004+o)*mlt
I13	dc.w	0,29,004
	dc.w	(002+o)*mlt,(003+o)*mlt,(018+o)*mlt,(017+o)*mlt,(002+o)*mlt
I14	dc.w	0,30,004
	dc.w	(006+o)*mlt,(007+o)*mlt,(022+o)*mlt,(021+o)*mlt,(006+o)*mlt
I15	dc.w	0,31,004
	dc.w	(000+o)*mlt,(015+o)*mlt,(022+o)*mlt,(007+o)*mlt,(000+o)*mlt
I16	dc.w	0,30,004
	dc.w	(001+o)*mlt,(002+o)*mlt,(017+o)*mlt,(016+o)*mlt,(001+o)*mlt
I17	dc.w	0,29,004
	dc.w	(003+o)*mlt,(004+o)*mlt,(019+o)*mlt,(018+o)*mlt,(003+o)*mlt
I18	dc.w	0,28,004
	dc.w	(005+o)*mlt,(006+o)*mlt,(021+o)*mlt,(020+o)*mlt,(005+o)*mlt
I19	dc.w	0,27,004
	dc.w	(000+o)*mlt,(001+o)*mlt,(016+o)*mlt,(015+o)*mlt,(000+o)*mlt
I20	dc.w	0,26,004
	dc.w	(008+o)*mlt,(023+o)*mlt,(024+o)*mlt,(009+o)*mlt,(008+o)*mlt
I21	dc.w	0,25,004
	dc.w	(009+o)*mlt,(024+o)*mlt,(025+o)*mlt,(010+o)*mlt,(009+o)*mlt
I22	dc.w	0,24,004
	dc.w	(008+o)*mlt,(011+o)*mlt,(026+o)*mlt,(023+o)*mlt,(008+o)*mlt
I23	dc.w	0,23,004
	dc.w	(010+o)*mlt,(025+o)*mlt,(026+o)*mlt,(011+o)*mlt,(010+o)*mlt
I24	dc.w	0,22,004
	dc.w	(012+o)*mlt,(013+o)*mlt,(028+o)*mlt,(027+o)*mlt,(012+o)*mlt
I25	dc.w	0,21,004
	dc.w	(013+o)*mlt,(014+o)*mlt,(029+o)*mlt,(028+o)*mlt,(013+o)*mlt
I26	dc.w	0,20,004
	dc.w	(012+o)*mlt,(027+o)*mlt,(029+o)*mlt,(014+o)*mlt,(012+o)*mlt
o	set	o+30




*-------------- Structures mouvmements --------------*
MoveTable0	dc.l	vector2,0
MoveTable1	dc.l	vector1,rota1,0
MoveTable2	dc.l	Rota2,0
MoveTable3	dc.l	rota3,vector0,0

Rota1		dc.b	3,0
		dc.w	16,0,12,0,14,0

Rota2		dc.b	3,0
		dc.w	2,0,8,0,4,0

Rota3		dc.b	3,0
		dc.w	0,0,0,0,15,0

Traject0
	dc.b	4,%00000111
	dc.w	0,3		;EtapesPtr,NbrEtapes
	dc.l	0,0,0
	dc.l	0,0,0
	dc.l	0,0,0		;StartPos
	dc.w	80,0		;NbrFrames,FramesPtr
	dc.l	1000,0,-2500	;EndPos
	dc.w	80,0		;NbrFrames,FramesPtr
	dc.l	-1000,0,-2500	;EndPos
	dc.w	80,0		;NbrFrames,FramesPtr
	dc.l	0,0,0	;EndPos


Vector0
	dc.b	5,%00000000
	dc.w	10		;vitesse
	dc.w	0,0,256	;orientation

Vector1
	dc.b	5,%00000000
	dc.w	20		;vitesse
	dc.w	0,0,256	;orientation

Vector2
	dc.b	5,%1
	dc.w	0
	dc.w	0,0,256

