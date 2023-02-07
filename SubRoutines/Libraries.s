;APS00000397000003970000039700000397000003970000039700000397000003970000039700000397
*********************************
*				*
*	Librairies		*
*	Last rev: 12/5/2001	*
*				*
*********************************

CALLGT	macro
	move.l	_GTBase,a6
	jsr	_LVO\1(a6)
	endm

CALLRT	macro
	move.l	_ReqBase(pc),a6
	jsr	_LVO\1(a6)
	endm

CALLDT	macro
	move.l	_DTBase(pc),a6
	jsr	_LVO\1(a6)
	endm

*************************************************
*	Ouverture/Fermeture  dos.library	*
*************************************************
OpenDos
	tst.b		Lib_Dos(pc)
	bne.s		.end
	movem.l		d0/d1/a0/a1/a6,-(sp)
	lea		DosName(pc),a1
	moveq		#0,d0
	CALLEXEC	OpenLibrary
	move.l		d0,_DOSBase
	move.b		#TRUE,Lib_Dos
	movem.l		(sp)+,d0/d1/a0/a1/a6
.end	clc
	rts

CloseDos
	tst.b		Lib_Dos(pc)
	beq.s		.end
	movem.l		d0/d1/a0/a1/a6,-(sp)
	move.l		_DOSBase(pc),a1
	CALLEXEC	CloseLibrary
	clr.b		Lib_Dos
	movem.l		(sp)+,d0/d1/a0/a1/a6
.end	clc
	rts

;	******** Données ********

_DOSBase	dc.l	0
DosName		dc.b	"dos.library",0	
		even

*************************************************
*	Ouverture/fermeture reqtools.library	*
*************************************************

OpenReqTools
	tst.b		Lib_ReqTools(pc)
	bne.s		.end
	movem.l		d0/d1/a0/a1/a6,-(sp)
	lea		reqName(pc),a1
	moveq		#0,d1
	CALLEXEC	OpenLibrary
	tst.l		d0
	beq.s		e_rt
	move.l		d0,_ReqBase
	move.b		#TRUE,Lib_ReqTools
	movem.l		(sp)+,d0/d1/a0/a1/a6
.end	clc
	rts

CloseReqTools
	tst.b		Lib_ReqTools(pc)
	beq.s		.end
	movem.l		d0/d1/a0/a1/a6,-(sp)
	move.l		_ReqBase(pc),a1
	CALLEXEC	CloseLibrary
	clr.b		Lib_ReqTools
	movem.l		(sp)+,d0/d1/a0/a1/a6
.end	clc
	rts

;	******** ERREURS ********
e_rt	movem.l	(sp)+,d0/d1/a0/a1/a6
	moveq	#Cant_open_reqtools,d0
	stc
	rts

;	******** Données ********
_ReqBase	dc.l	0
reqName		dc.b	"reqtools.library",0
	even

*************************************************
*	Ouverture/fermeture intuition.library	*
*************************************************

OpenIntuition
	tst.b		Lib_Intuition(pc)
	bne.s		.end
	movem.l		d0/d1/a0/a1/a6,-(sp)
	lea		intName(pc),a1
	moveq		#0,d1
	CALLEXEC	OpenLibrary
	tst.l		d0
	beq.s		e_int
	move.l		d0,_IntuitionBase
	move.b		#TRUE,Lib_Intuition
	movem.l		(sp)+,d0/d1/a0/a1/a6
.end	clc
	rts

CloseIntuition
	tst.b		Lib_Intuition(pc)
	beq.s		.end
	movem.l		d0/d1/a0/a1/a6,-(sp)
	move.l		_IntuitionBase(pc),a1
	CALLEXEC	CloseLibrary
	clr.b		Lib_Intuition
	movem.l		(sp)+,d0/d1/a0/a1/a6
.end	clc
	rts

;	******** ERREURS ********
e_int	movem.l	(sp)+,d0/d1/a0/a1/a6
	moveq	#Cant_open_intuition,d0
	stc
	rts

;	******** Données ********
_IntuitionBase	dc.l	0
intName		dc.b	"intuition.library",0
	even

*************************************************
*	Ouverture/Fermeture  gadtools.library	*
*************************************************
OpenGadTools
	tst.b		Lib_GadTools(pc)
	bne.s		.end
	movem.l		d0/d1/a0/a1/a6,-(sp)
	lea		GadToolsName(pc),a1
	moveq		#0,d0
	CALLEXEC	OpenLibrary
	tst.l		d0
	beq.s		e_gt
	move.l		d0,_GTBase
	move.b		#TRUE,Lib_GadTools
	movem.l		(sp)+,d0/d1/a0/a1/a6
.end	clc
	rts

CloseGadTools
	tst.b		Lib_GadTools(pc)
	beq.s		.end
	movem.l		d0/d1/a0/a1/a6,-(sp)
	move.l		_GTBase(pc),a1
	CALLEXEC	CloseLibrary
	clr.b		Lib_GadTools
	movem.l		(sp)+,d0/d1/a0/a1/a6
.end	clc
	rts

;	******** Erreurs ********
e_gt	movem.l		(sp)+,d0/d1/a0/a1/a6
	moveq		#Cant_open_gadTools,d0
	stc
	rts

;	******** Données ********

_GTBase		dc.l	0
GadToolsName	dc.b	"gadtools.library",0	
		even

*************************************************
*	Ouverture/Fermeture  graphics.library	*
*************************************************
OpenGraphics
	tst.b		Lib_Graphics(pc)
	bne.s		.end
	movem.l		d0/d1/a0/a1/a6,-(sp)
	lea		GfxName(pc),a1
	moveq		#0,d0
	CALLEXEC	OpenLibrary
	tst.l		d0
	beq.s		e_gfx
	move.l		d0,_GfxBase
	move.b		#TRUE,Lib_Graphics
	movem.l		(sp)+,d0/d1/a0/a1/a6
.end	clc
	rts

CloseGraphics
	tst.b		Lib_Graphics(pc)
	beq.s		.end
	movem.l		d0/d1/a0/a1/a6,-(sp)
	move.l		_GfxBase(pc),a1
	CALLEXEC	CloseLibrary
	clr.b		Lib_Graphics
	movem.l		(sp)+,d0/d1/a0/a1/a6
.end	clc
	rts

;	******** Erreurs ********
e_gfx	movem.l		(sp)+,d0/d1/a0/a1/a6
	moveq		#Cant_open_graphics,d0
	stc
	rts

;	******** Données ********

_GfxBase	dc.l	0
GfxName	dc.b	"graphics.library",0	
		even

*********************************************************
*	Ouverture/Fermeture  cybergraphics.library	*
*********************************************************
OpenCyberGfx
	tst.b		Lib_CyberGfx(pc)
	bne.s		.end
	movem.l		d0/d1/a0/a1/a6,-(sp)
	lea		CyberGfxName(pc),a1
	moveq		#0,d0
	CALLEXEC	OpenLibrary
	tst.l		d0
	beq.s		e_cgfx
	move.l		d0,_CyberGfxBase
	move.b		#TRUE,Lib_CyberGfx
	movem.l		(sp)+,d0/d1/a0/a1/a6
.end	clc
	rts

CloseCyberGfx
	tst.b		Lib_CyberGfx(pc)
	beq.s		.end
	movem.l		d0/d1/a0/a1/a6,-(sp)
	move.l		_CyberGfxBase(pc),a1
	CALLEXEC	CloseLibrary
	clr.b		Lib_CyberGfx
	movem.l		(sp)+,d0/d1/a0/a1/a6
.end	clc
	rts

;	******** Erreurs ********
e_cgfx	movem.l		(sp)+,d0/d1/a0/a1/a6
	moveq		#Cant_open_cybergraphics,d0
	stc
	rts

;	******** Données ********

_CyberGfxBase	dc.l	0
CyberGfxName	dc.b	"cybergraphics.library",0	
		even

*************************************************
*	Ouverture/Fermeture  datatypes.library	*
*************************************************
OpenDataTypes
	tst.b		Lib_DataTypes(pc)
	bne.s		.end
	movem.l		d0/d1/a0/a1/a6,-(sp)
	lea		DataTypesName(pc),a1
	moveq		#0,d0
	CALLEXEC	OpenLibrary
	move.l		d0,_DTBase
	move.b		#TRUE,Lib_DataTypes
	movem.l		(sp)+,d0/d1/a0/a1/a6
.end	clc
	rts

CloseDataTypes
	tst.b		Lib_DataTypes(pc)
	beq.s		.end
	movem.l		d0/d1/a0/a1/a6,-(sp)
	move.l		_DTBase(pc),a1
	CALLEXEC	CloseLibrary
	clr.b		Lib_DataTypes
	movem.l		(sp)+,d0/d1/a0/a1/a6
.end	clc
	rts

;	******** Données ********

_DTBase		dc.l	0
DataTypesName	dc.b	"datatypes.library",0	
		even
