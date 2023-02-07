;APS00000000000000000000000000000000000000000000000000000000000000000000000000000000
;************************************************************************
;*									*
;*		  Macros-constantes-structures d'Oz			*
;*			Revision: 12/6/1999				*
;*									*
;************************************************************************


;************************************************************************
;*									*
;*			Assignations pour assemblage			*
;*			   Revision: 20/2/1999				*
;*									*
;************************************************************************

;---- Répertoire où sont stockées les sources des classes:
dir_sourcesClasses	macro
	incdir	Oz:sources/classes/
	endm

;---- Répertoire où sont stockées les objets classes:
dir_objectsClasses	macro
	incdir	hd3:oz:classes/
	endm

;---- Répertoire où sont stockés les includes:
dir_includes	macro
	incdir	hd3:oz_os/sources/includes/
	endm

;---- Répertoire où sont stockées les sous-routines:
dir_subRoutines	macro
	incdir	hd3:oz_os/sources/subRoutines/
	endm

;---- Répertoire où sont stockées les données sources (objets3d,sprites...):
dir_sourceDatas	macro
	incdir	hd3:oz_os/sources/datas/
	endm

;---- Répertoire où sont stockés les sources sprites:
dir_sprites	macro
	incdir	hd3:oz_os/sources/datas/sprites/
	endm

;---- Répertoire où sont stockés les sources fonts:
dir_fonts	macro
	incdir	hd3:oz_os/sources/datas/fonts/
	endm

;---- Répertoire où sont stockées les données objet (objets3d,sprites...):
dir_objectDatas	macro
	incdir	hd3:oz_os/datas/
	endm

;---- Répertoire où sont stockées les sous-routines exterieurs:
dir_extSubRoutines	macro
	incdir	hd3:routines/asm/subRoutines/
	endm

;---- Répertoire où sont stockées les données sources exterieurs:
dir_extSourceDatas	macro
	incdir	hd3:routines/datas/
	endm

;************************************************************************
;*									*
;*			Definition des constantes			*
;*			  Last rev.: 23/1/1999				*
;************************************************************************

;**************** Definitions HardWare+AmigaOS ****************

;Generals:
;¡¡¡¡¡¡¡¡¡
		dir_includes
		include	Hardware/custom.i
		include	Hardware/dmabits.i
		include	Hardware/cia.i
		include Hardware/intbits.i
		include Hardware/bplbits.i

		defaultStack=$1000

		hardBase=$dff000
		ciaaBase=$bfe001
		ciabBase=$bfd000

;Traps Vectors:
;¡¡¡¡¡¡¡¡¡¡¡¡¡¡
			trapsBase=$80
			trap_0=$80
			trap_1=$84
			trap_2=$88
			trap_3=$8c
			trap_4=$90
			trap_5=$94
			trap_6=$98
			trap_7=$9c
			trap_8=$a0
			trap_9=$a4
			trap_10=$a8
			trap_11=$ac
			trap_12=$b0
			trap_13=$b4
			trap_14=$b8
			trap_15=$bc

;Interruptions vectors:
;¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
			intsBase=$64
			intLvl1=$64
			intLvl2=$68
			intLvl3=$6c
			intLvl4=$70
			intLvl5=$74
			intLvl6=$78

;JoySticks Ports identificators:
;¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
			port0=0
			port1=1
;Memories types:
;¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡
			optimum=0
			chip=2
			fast=4

;Flags:
;¡¡¡¡¡¡
			cf=%1
			vf=%10
			zf=%100
			nf=%1000
			xf=%10000

;µåååååååååååååååååååååååååååååååååååååååååååååååååååååååååååååååååååååå®
;©									©
;©				MACROS					©
;©									©
;©			last rev.: 3/4/1999				©
;©									©
;¤ååååååååååååååååååååååååååååååååååååååååååååååååååååååååååååååååååååååş

;		ğ¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¶
;		ø	Creation des structures		ø
;		ß¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡æ

;TYPE	macro	;\1=typeName, \2=typeSize, \3=hardware unit (cpu/fpu)
;\1_typeSize	equ	\2
;type_\1		equ	'\1'
;unit_\1		equ	\3
;	endm

;STRUC	macro	;\1=Nom structure
;varof7		set	0
;	endm

;ENDS	macro	;\1=Nom structure
;size_\1	equ	varof7
;	endm

;VAR	macro	;\1=Type, \2=Name
;\2	equ	varof7
;varof7	set	varof7+\1_typeSize
;	endm

;SSTRUC	macro	;\1=Nom offset	\2=Nom structure
;\1	equ	varof7
;varof7	set	varof7+size_\2
;	endm

MethodsTab_classe	macro	;\1=Classe name
moffset	set	0
	ifne	material
\1.methods_classe_strt
	endc
	endm

MethodsTab_object	macro	;\1=Classe name
moffset	set	0
	ifne	material
\1.methods_object_strt
	endc
	endm

METHOD	macro	;\1=Classe name, \2=Method name
offset_\1.\2	equ	moffset
moffset	set	moffset+4
	ifne	material
	dc.l	\1.\2-classeDef.\1
	endc
	endm

endMt_classe	macro		;\1=Classe name
	ifne	material
\1.methods_classe_end
	endc
	endm

endMt_object	macro		;\1=Classe name
	ifne	material
\1.methods_object_end
	endc
	endm

ErrorsTab	macro		;\1=Classe name
eId	set	0
	ifne	material
\1.errorsTab_strt
	endc
	endm

ERROR	macro	;\1=Classe name, \2=constante name, \3=string label
\1__\2	equ	eId
eId	set	eId+1
	ifne	material
	dc.l	\1.\3-classeDef.\1
	endc
	endm

ende	macro		;\1=Classe name
	ifne	material
\1.errorsTab_end
	endc
	endm

;TAGS	macro
;tPtr	set	1
;	endm

;TAG	macro	;\1=tagName
;\1	equ	tPtr
;tPtr	set	tPtr+1
;	endm

;		*****************************************
;		*	   Macros commandes Asm		*
;		*****************************************

jsrm	macro	;\1=Nom methode, a5=@Object
		; ! CRASH a6 !
	move.l	object_methodsTab(a5),a6
	move.l	offset_\1(a6),a6
	jsr	(a6)
	endm

jsrms	macro	;\1=Nom methode, a5=@Object
	move.l	a6,-(sp)
	move.l	object_methodsTab(a5),a6
	move.l	offset_\1(a6),a6
	jsr	(a6)
	move.l	(sp)+,a6
	endm


;		*****************************************
;		*	 Gestion des chaines ASCII	*
;		*****************************************

Cmpstr	Macro	;-Comparaison de deux chaines ASCII (Terminees par un 0)-
		; IN   : \1=@First string, \2=@Second string
		; OUT  : Zflag: 0(ne)=Differents 1(eq)=Sames
		; Same string-cmp routine as AmigaOS...Rulezzz!! ;)
.suiv\@	cmpm.b	(\1)+,(\2)+
	bne.s	.ok\@
	tst.b	-1(\1)
	bne.s	.suiv\@
.ok\@
	endm


Convstr	macro	;    -Convertion Minuscules a-z <=> Majuscules A-Z -
		; IN	: \1=String \2=Min(a/A) \3=Offset to Mns/Mjs
		; OUT	: \1=Converted string
		; CRASH	: d7
.suiv\@	move.b	(\1)+,d7
	beq.s	.end\@
	sub.b	\2,d7
	cmp.b	#26-1,d7	;26 lettres dans l'alphabet...Si si !
	bhi.s	.suiv\@
	add.b	\3,-1(\1)
	bra.s	.suiv\@
.end\@
	endm


strsize	macro	; - fourni la taille d'une chaine ASCII terminee par 0 -
		; IN  : \1=String (aX reg.), \2=Stockage size (dX reg.)
		; OUT : \2=String size (0 de fin compris).
	clr.l	\2
.s\@	addq.w	#1,\2
	tst.b	(\1)+
	bne.s	.s\@
	sub.l	\2,\1	;Restore \1
	endm


acd16	macro	; - Compteur decimal ASCII 16 bits - 7/3/1998 
		; IN: \1=@ASCII string (aX reg.)
	movem.w	d0-d2,-(sp)
	move.w	(\1)+,d1
	move.w	(\1)+,d0
	pack	d0,d0,#$30
	pack	d1,d1,#$30
	clr.b	d2
	stx
	abcd.b	d2,d0
	abcd.b	d2,d1
	unpk	d0,d0,#$3030
	unpk	d1,d1,#$3030
	move.w	d0,-(\1)
	move.w	d1,-(\1)
	movem.w	(sp)+,d0-d2
	endm


acd32	macro	; - Compteur decimal ASCII 32 bits - 7/3/1998 
		; IN: \1=@ASCII string (aX reg.)
	movem.w	d0-d4,-(sp)
	move.w	(\1)+,d3
	move.w	(\1)+,d2
	move.w	(\1)+,d1
	move.w	(\1)+,d0
	pack	d0,d0,#$30
	pack	d1,d1,#$30
	pack	d2,d2,#$30
	pack	d3,d3,#$30
	clr.b	d4
	stx
	abcd.b	d4,d0
	abcd.b	d4,d1
	abcd.b	d4,d2
	abcd.b	d4,d3
	unpk	d0,d0,#$3030
	unpk	d1,d1,#$3030
	unpk	d2,d2,#$3030
	unpk	d3,d3,#$3030
	move.w	d0,-(\1)
	move.w	d1,-(\1)
	move.w	d2,-(\1)
	move.w	d3,-(\1)
	movem.w	(sp)+,d0-d4
	endm


joinstr	macro	; - Fusion de deux chaines ASCII - 8/3/1998
		; IN : \1=@FirstString \2=@Secondstring \3=@NewString_buffer
		; OUT: \1=@Joined_String
	tst.b	(\1)
	beq.s	.2\@
.1\@	move.b	(\1)+,(\3)+
	tst.b	(\1)
	bne.s	.1\@
.2\@	move.b	(\2)+,(\3)+
	tst.b	-1(\2)
	bne.s	.2\@
	endm


;************************************************************************
;*									*
;*		Definition des structures primitives			*
;*			Last rev: 19/5/2001				*
;*									*
;************************************************************************

;	ğ¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¶
;	ø	    Listes chainees		ø
;	ß¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡æ

;	STRUC	listHeader
;		var	aptr,lh_first
;		var	ulong,lh_tail
;		var	aptr,lh_last
;	ENDS	listHeader

	STRUCTURE	OzNode
		APTR	nd_succ
		APTR	nd_prec
		APTR	nd_name
	LABEL	OzNode_SIZE

;	*****************************************
;	*	   Structure  Object		*
;	*****************************************

	STRUCTURE	Object,0
		STRUCT	Object_Node,OzNode_SIZE	;Pour rattacher l'objet à la liste des objets
;						;de la classe
		APTR	Object_Classe		;Pointeur sur la structure Classe de l'objet
		UWORD	Object_NumMethods	;Nombre de méthodes de l'objet
		APTR	Object_MethodsTab	;Table des méthodes
		UWORD	Object_Use		;Compteur d'utilisation de l'objet
		ULONG	Object_BodySize		;Taille des données relatives à la nature de
;						;l'objet
		LABEL	Object_Body		;Données relatives à la nature de l'objet
	LABEL	Object_SIZE

;	*****************************************
;	*	     Structure Classe		*
;	*****************************************

	STRUCTURE	Classe,0
		STRUCT	Classe_Head,Object_SIZE	;Structure objet de la classe (une classe est
;						;simplement un objet particulier)
		STRUCT	Classe_ObjectList,MLH_SIZE	;Liste des objets
		ULONG	Classe_BufferSize	;Place occupée en mémoire par la classe
;						;(ne sert que lorsque la classe est créée
;						;à partir d'un fichier)
		APTR	Classe_Init		;Méthode d'initialisation de la classe
		APTR	Classe_Remove		;Méthode de destruction de la classe
		APTR	Classe_Object		;Pointeur sur les données objet par défaut.
;						;Lorsqu'un objet est créé, la nouvelle structure
;						;est initialisée avec ces données.
		APTR	Classe_Constructor	;Méthode de construction des objets
		APTR	Classe_Destructor	;Méthode de destruction des objets
		UWORD	Classe_NumErrors	;Nombre d'erreurs possibles
		APTR	Classe_ErrorsTab	;Table des messages d'erreur
		WORD	Classe_Version		;Version de la classe
		LABEL	Classe_Body		;Données relatives à la nature de la classe
	LABEL	Classe_SIZE

;	*****************************************
;	*	     Structure ObjectDef	*
;	*****************************************

	STRUCTURE	ObjectDef,0
		LONG	ObjectDef_HunkId
		ULONG	ObjectDef_HunkSize
		APTR	ObjectDef_Name		;offset
		LABEL	ObjectDef_Body
	ENDS	objectDef

;µåååååååååååååååååååååååååååååååååååååååååååååååååååååååååååååååååååååå®
;©									©
;©			macros CREATION CLASSES/OBJETS			©
;©			    last rev: 5/2/1999				©
;©									©
;¤ååååååååååååååååååååååååååååååååååååååååååååååååååååååååååååååååååååååş

	obj=true		;FLAG object: détermine si la classe peut
	noObj=false		;	      générer des objets.
	const=true		;FLAG constructor: détermine si la classe
	noConst=false		;	contient un constructeur d'objets.
	destr=true		;FLAG destructor: détermine si la classe
	noDestr=false		;	contient un destructeur d'objets
	init=true		;FLAG init: détermine si la classe contient
	noInit=false		;	une méthode d'auto-init (appelée
				;	automatiquement par la méthode
				;	"Kernel.creatClasse")
	rem=true		;FLAG remove: détermine si la classe contient
	noRem=false		;	une méthode d'auto-destruction (appelée
				;	par la méthode "Kernel.removeClasse")


ClasseDef	macro	;\1=className, \2=FLAG init, \3=FLAG remove
			;\4=FLAG object, \5=FLAG constructor, 
			;\6=FLAG destructor, \7=version, \8=revision
objof7	set	size_classe
\1_version	equ	\7
\1_revision	equ	\8
	ifne	material
classeDef.\1
.nd_suiv		dc.l	0
.nd_prec		dc.l	0
.nd_name		dc.l	\1.name-classeDef.\1
.classe			dc.l	0		;=>@Kernel object
.nbrMethods		dc.w	(\1.methods_Classe_end-\1.methods_Classe_strt)/4
.methodsTab_classe	dc.l	\1.methods_Classe_strt-classeDef.\1
.bodySize		dc.l	\1.bodyEnd-\1.bodyStrt
.usecptr		dc.w	0
.objectsList_lh_first	dc.l	.objectsList_lh_tail-classeDef.\1
.objectsList_lh_tail	dc.l	0
.objectsList_lh_last	dc.l	.objectsList_lh_first-classeDef.\1
.bufferSize		dc.l	0
.init			ifne	\2
			dc.l	\1.init-classeDef.\1
			else
			dc.l	0
			endc
.remove			ifne	\3
			dc.l	\1.remove-classeDef.\1
			else
			dc.l	0
			endc
.object			ifne	\4
			dc.l	objectDef.\1-classeDef.\1
			else
			dc.l	0
			endc
.constructor		ifne	\5
			dc.l	\1.constructor-classeDef.\1
			else
			dc.l	0
			endc
.destructor		ifne	\6
			dc.l	\1.destructor-classeDef.\1
			else
			dc.l	0
			endc
.nbrerrors		dc.w	(\1.errorsTab_end-\1.errorsTab_strt)/4
.errorsTab		dc.l	\1.errorsTab_strt-classeDef.\1
.version		dc.w	\1_version
.revision		dc.w	\1_revision
\1.bodyStrt
	endc
	endm

;¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡

endCl	macro	;\1=className
classeSize_\1	equ	objof7
	ifne	material
\1.bodyEnd
\1.name:	dc.b	"\1",0
		even
	endc
	endm

;¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡

ObjectDef	macro		;\1=Classe name
objof7	set	size_object
	ifne	material
objectDef.\1
.header_nd_suiv		dc.l	0
.header_nd_prec		dc.l	0
.header_nd_name		dc.l	0
.classe			dc.l	0
.nbrMethods_object dc.w	(\1.methods_object_end-\1.methods_object_strt)/4
.methodstab		dc.l	\1.methods_object_strt-classeDef.\1
.bodySize		dc.l	\1.object_body_end-\1.object_body_strt
.usecptr		dc.w	0
\1.object_body_strt
	endc
	endm

;¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡

BODY	macro	;\1=type, \2=varName, \3=var, [\4=var]
\2	equ	objof7
objof7	set	objof7+\1_typesize
	ifne	material
	; CPU types:
	ifeq	unit_\1-cpu
	ifeq	8-\1_typesize
	dc.l	\3,\4
	endc
	ifeq	4-\1_typesize
	dc.l	\3
	endc
	ifeq	2-\1_typesize
	dc.w	\3
	endc
	ifeq	1-\1_typesize
	dc.b	\3
	endc
	endc
	;FP types:
	ifeq	unit_\1-fpu
	ifeq	4-\1_typeSize
	dc.s	\3
	endc
	ifeq	8-\1_typeSize
	dc.d	\3
	endc
	ifeq	12-\1_typeSize
	dc.x	\3
	endc
	endc
	endc
	endm

;¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡

ENDO	macro	;\1=Class name
objSize_\1	equ	objof7
	ifne	material
\1.object_body_end:
	endc
	endm

;¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡

;µåååååååååååååååååååååååååååååååååååååååååååååååååååååååååååååå®
;©								©
;©		Définitions AmigaOS friendly			©
;©		    last rev: 20/3/1999				©
;©								©
;¤ååååååååååååååååååååååååååååååååååååååååååååååååååååååååååååååş

;¡¡¡¡¡¡¡¡¡ Appel fonctions AmigaOS ¡¡¡¡¡¡¡¡¡¡¡¡

jsrlib	macro	;a6=@LibBase, \1=Nom fonction
	jsr	_LVO\1(a6)
	endm

;¡¡¡¡¡¡¡¡¡¡¡¡ AmigaOS includes ¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡¡

	dir_includes
;Structures:
	include	friendly/exec.i
	include	friendly/utility.i
	include	friendly/graphics.i
	include	friendly/intuition.i
	include	friendly/asl.i

;Libraries functions offsets:
	include	friendly/libraries/exec_lib.i
	include	friendly/libraries/dos_lib.i
	include friendly/libraries/graphics_lib.i
	include friendly/libraries/intuition_lib.i
	include	friendly/libraries/asl_lib.i
	include	friendly/libraries/cia_lib.i

;Devices commands and structures definitions:
	include	friendly/devices/gamePort.i
	include	friendly/devices/timer.i
	include	friendly/devices/inputEvent.i
