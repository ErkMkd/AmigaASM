;APS00001EC600001EC600001EC600001EC600001EC600001EC600001EC600001EC600001EC600001EC6
*********************************
*				*
*	     System		*
*	Last rev: 7/4/2001	*
*				*
*********************************

*****************************************************************************************
*				Petit noyau						*
*****************************************************************************************
WbScreen	dc.l	0		;Adresse de la structure Screen du Workbench.

Lib_Dos		dc.b	FALSE
Lib_Intuition	dc.b	FALSE
Lib_ReqTools	dc.b	FALSE
Lib_GadTools	dc.b	FALSE
Lib_Graphics	dc.b	FALSE
Lib_CyberGfx	dc.b	FALSE
Lib_DataTypes	dc.b	FALSE
		even

*****************************************************************************************
*				Includes - Déclarations					*
*****************************************************************************************

;-------- AmigaOS:
	incdir	include:
	include	hardware/custom.i
	include	hardware/cia.i
	include	exec/exec.i
	include	intuition/intuition.i
	include	intuition/icclass.i
	include	graphics/gfx.i
	include	cybergraphics/cybergraphics.i
	include	dos/dos.i

	include	datatypes/datatypes.i
	include	datatypes/datatypesclass.i
	include	datatypes/pictureclass.i

	include	libraries/reqtools.i
	include	libraries/gadtools.i

	incdir	lvo:
	include	exec_lib.i
	include	intuition_lib.i
	include	graphics_lib.i
	include	cybergraphics_lib.i
	include	dos_lib.i
	include	reqtools_lib.i
	include	gadtools_lib.i
	include	datatypes_lib.i

;-------- Defines:
	TRUE=-1
	FALSE=0

;-------- Bases:
	_SysBase=$4
	_custom=$dff000
	_ciaa=$bfe001
	_ciab=$bfd000

;-------- Flags:
	Cf=%1
	Vf=%10
	Zf=%100
	Nf=%1000
	Xf=%10000

;-------- Macros:

stc	macro
	or.b	#Cf,ccr
	endm
clc	macro
	and.b	#-Cf-1,ccr
	endm

stv	macro
	or.b	#Vf,ccr
	endm
clv	macro
	and.b	#-Vf-1,ccr
	endm

stz	macro
	or.b	#Zf,ccr
	endm
clz	macro
	and.b	#-Zf-1,ccr
	endm

stn	macro
	or.b	#Nf,ccr
	endm
cln	macro
	and.b	#-Nf-1,ccr
	endm

stx	macro
	or.b	#Xf,ccr
	endm
clx	macro
	and.b	#-Xf-1,ccr
	endm

bhs.s	macro	;\1=Label "Higher or Same" unsigned condition.
	bcc.s	\1
	endm

bhs.w	macro
	bcc.w	\1
	endm

;--------- Codes erreur:


Unknown_error			equ	0
Not_enough_memory		equ	1
Cant_open_reqtools		equ	2
Cant_open_intuition		equ	3
Cant_open_gadTools		equ	4
Cant_create_gadget_context	equ	5
Cant_create_gadget		equ	6
Cant_open_main_window		equ	7
Cant_create_fileRequest		equ	8
Operation_canceled		equ	9
Cant_open_file			equ	10
Bad_file_format			equ	11
File_corrupted			equ	12
Cant_open_window		equ	13
Cant_open_graphics		equ	14
Cant_open_cybergraphics		equ	15
No_FPU				equ	16

; Erreurs propres au moteur 3d:
Error_3dEngine	equ	$100

Cant_load_image			equ	Error_3dEngine+1
Invalid_render_depth		equ	Error_3dEngine+2
Cant_create_image_palette	equ	Error_3dEngine+3

;--------- Messages d'erreur:

STRING_Unknown				STRING	"Unknown error"
STRING_Not_enough_memory		STRING	"Not enough memory"
STRING_Cant_open_reqtools		STRING	"Can't open reqtools.library"
STRING_Cant_open_intuition		STRING	"Can't open intuition.library"
STRING_Cant_open_gadTools		STRING	"Can't open gadTools.library"
STRING_Cant_create_gadget_context	STRING	"Can't create gadget context"
STRING_Cant_create_gadget		STRING	"Can't create gadget"
STRING_Cant_open_main_window		STRING	"Can't open main window"
STRING_Cant_create_fileRequest		STRING	"Can't creat fileRequet"
STRING_Operation_canceled		STRING	"Operation canceled"
STRING_Cant_open_file			STRING	"Can't open file"
STRING_Bad_file_format			STRING	"Bad file format"
STRING_File_corrupted			STRING	"File corrupted"
STRING_Cant_open_window			STRING	"Can't open window"
STRING_Cant_open_graphics		STRING	"Can't open graphics.library"
STRING_Cant_open_cybergraphics		STRING	"Can't open cybergraphics.library"
STRING_No_FPU				STRING	"No FPU"

; Erreurs propres au moteur 3d:
STRING_Cant_load_image			STRING	"Can't load image"
STRING_Invalid_render_depth		STRING	"Invalid render depth"
STRING_Cant_create_image_palette	STRING	"Can't create image palette"

;----------- Table des erreurs:

ErrorsTable
	dc.l	STRING_Unknown
	dc.l	STRING_Not_enough_memory
	dc.l	STRING_Cant_open_reqtools
	dc.l	STRING_Cant_open_intuition
	dc.l	STRING_Cant_open_gadTools
	dc.l	STRING_Cant_create_gadget_context
	dc.l	STRING_Cant_create_gadget
	dc.l	STRING_Cant_open_main_window
	dc.l	STRING_Cant_create_fileRequest
	dc.l	STRING_Operation_canceled
	dc.l	STRING_Cant_open_file
	dc.l	STRING_Bad_file_format
	dc.l	STRING_File_corrupted
	dc.l	STRING_Cant_open_window
	dc.l	STRING_Cant_open_graphics
	dc.l	STRING_Cant_open_cybergraphics
	dc.l	STRING_No_FPU

	dcb.l	Error_3dEngine-No_FPU,0

; Erreurs propres au moteur 3d:
	dc.l	STRING_Cant_load_image
	dc.l	STRING_Invalid_render_depth
	dc.l	STRING_Cant_create_image_palette

*********************************************************************************
*										*
*				- INCLUDES -					*
*										*
*********************************************************************************

	incdir	WorkCode:Simulateur3d/includes/
	include	Libraries.s

*********************************************************************************
*										*
*				- FONCTIONS SYSTEM -				*
*										*
*********************************************************************************

*********************************************************
*		Initialisation du système		*
*********************************************************
Init
;	---- Ouverture des librairies:
	bsr.w	OpenReqTools
	bcs.s	.e_error
	bsr.w	OpenDos
	bsr.w	OpenIntuition
	bsr.w	OpenGadTools
	bsr.w	OpenGraphics
	bcs.s	.e_error
	bsr.w	OpenCyberGfx
	bcs.s	.e_error
	bsr.w	OpenDataTypes
	bcs.s	.e_error

;	---- Bloquage écran Workbench:
	bsr.w	LockWb

;	---- Ok:
	clc
	rts

;	******** Erreur ********
.e_error
	stc
	rts

*************************************************
*	Pour quitter en toute tranquilité	*
*************************************************
Exit

;---- Libération écran Workbench:
	bsr.w	UnlockWb

;---- Fermeture librairies:

	bsr.w	CloseDos
	bsr.w	CloseReqTools
	bsr.w	CloseIntuition
	bsr.w	CloseGadTools
	bsr.w	CloseCyberGfx
	bsr.w	CloseGraphics
	bsr.w	CloseDataTypes

;---- Ok:
.end	clc
	rts

;*----------------------------------------------------------------------*
;| PRIVATE    Initialise le pointeur de l'écran du Workbench	PRIVATE	|
;*----------------------------------------------------------------------*
LockWb
	movem.l		d0/d1/a0/a1/a6,-(sp)
	lea		.wb(pc),a0
	CALLINT		LockPubScreen
	move.l		d0,WbScreen
	movem.l		(sp)+,d0/d1/a0/a1/a6
	clc
	rts

;	******** Données ********

.wb	dc.b	"Workbench",0

;*-------------------------------------------------------*
;| PRIVATE	Libère l'écran du workbench	PRIVATE	 |
;*-------------------------------------------------------*
UnlockWb
	movem.l		d0/d1/a0/a1/a6,-(sp)
	sub.l		a0,a0
	move.l		WbScreen(pc),a1
	CALLINT		UnlockPubScreen
	movem.l		(sp)+,d0/d1/a0/a1/a6
	clc
	rts

*********************************************************
*		Control du cache de données		*
*********************************************************

DataCache_Off
	movem.l		d0/d1/a0/a1/a6,-(sp)
	clr.l		d0			;d0=set/clr
	move.l		#CACRF_EnableD,d1	;d1=affected bits mask
	CALLEXEC	CacheControl
	and.l		#CACRF_EnableD,d0
	move.l		d0,f_SaveDataCache
	movem.l		(sp)+,d0/d1/a0/a1/a6
	clc
	rts

DataCache_On
	movem.l		d0/d1/a0/a1/a6,-(sp)
	move.l		f_SaveDataCache(pc),d0
	move.l		d0,d1
	CALLEXEC	CacheControl
	movem.l		(sp)+,d0/d1/a0/a1/a6
	clc
	rts


;	******** Données ********
f_SaveDataCache	dc.l	0

*************************************************
*	Test s'il y a un FPU			*
*************************************************
TestFPU
	movem.l	d0/a6,-(sp)
	move.l	_SysBase,a6
	move.w	AttnFlags(a6),d0
	and.w	#AFF_68881!AFF_68882!AFF_FPU40,d0
	beq.s	.e_noFPU
	movem.l	(sp)+,d0/a6
	clc
	rts

******** Erreurs ********

.e_noFPU
	movem.l	(sp)+,d0/a6
	moveq	#No_FPU,d0
	stc
	rts
