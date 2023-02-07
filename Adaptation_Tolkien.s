;APS00000000000000000000000000000000000000000000000000000000000000000000000000000000
	incdir	includes:
	include	exec/exec.i
	include	libraries/cybergraphics_lib.i
	include	libraries/intuition_lib.i
	include	intuition/intuition.i
	include	graphics/gfx.i
	include	libraries/graphics_lib.i
	include	cybergraphics/cybergraphics.i


*****************************************************************************************
*				PROGRAMME PRINCIPAL					*
*****************************************************************************************
Main
	bsr.w	OpenIntuition
	bsr.w	OpenCyberGfx
	bsr.w	OpenGfx

;	Init DisplayID:
	lea		cybermode.tagList(pc),a0
	CALLCYBERGFX	BestCModeIDTagList
	tst.l		d0
	beq.w		end_error0
	move.l		d0,MyDisplayID

;	Ouverture écran:
	sub.l		a0,a0
	lea		MyScreen.tagList(pc),a1
	CALLINT		OpenScreenTagList
	tst.l		d0
	beq.w		end_error0
	move.l		d0,MyScreen

;	essai:
	bsr.w	LockScreen

	tst.l	MyScreen.base(pc)	;MyScreen.base: Adresse du pointeur sur ecran Chunky
	beq.s	end_error1
	move.l	MyScreen.base,a0
	move.l	#$fdfdfdfd,(a0)

	bsr.w	UnlockScreen

;	Attente souris:
	btst	#6,$bfe001
	bne.s	*-8

;	Close screen:
end_error1
	move.l		MyScreen(pc),a0
	CALLINT		CloseScreen

;	Close libraries:
end_error0
	bsr.w	CloseCyberGfx
	bsr.w	CloseIntuition
	bsr.w	CloseGfx
	clr.l	d0
	rts


;------	Données ---------
cybermode.tagList
	dc.l	CYBRBIDTG_Depth,8
	dc.l	CYBRBIDTG_NominalWidth,640
	dc.l	CYBRBIDTG_NominalHeight,480
	dc.l	TAG_DONE

FALSE	equ	0
TRUE	equ	-1

MyScreen
	dc.l	0

MyScreen.tagList
	dc.l	SA_Left,0
	dc.l	SA_Top,0
	dc.l	SA_Width,640
	dc.l	SA_Height,480
	dc.l	SA_Depth,8
	dc.l	SA_Quiet,TRUE
	dc.l	SA_DisplayID
MyDisplayID
	dc.l	0
	dc.l	TAG_DONE

Lock.tagList
	dc.l	LBMI_BASEADDRESS,MyScreen.base
	dc.l	TAG_DONE

MyScreen.base	dc.l	0

LockHandle	dc.l	0

*************************************************
*	Saisie adresse écran chunky		*
*************************************************
LockScreen
	move.l		MyScreen(pc),a0
	lea		sc_RastPort(a0),a0
	move.l		rp_BitMap(a0),a0
	lea		Lock.tagList(pc),a1
	CALLCYBERGFX	LockBitmapTagList
	move.l		d0,LockHandle
	rts

*****************************************
*	Libère bitmap			*
*****************************************
UnlockScreen
	move.l		LockHandle(pc),a0
	CALLCYBERGFX	UnLockBitmap
	rts

*************************************************
*	Ouverture/fermeture intuition.library	*
*************************************************

OpenIntuition
	movem.l		d0/d1/a0/a1/a6,-(sp)
	lea		intName(pc),a1
	moveq		#0,d1
	CALLEXEC	OpenLibrary
	move.l		d0,_IntuitionBase
	movem.l		(sp)+,d0/d1/a0/a1/a6
	rts

CloseIntuition
	movem.l		d0/d1/a0/a1/a6,-(sp)
	move.l		_IntuitionBase(pc),a1
	CALLEXEC	CloseLibrary
	movem.l		(sp)+,d0/d1/a0/a1/a6
	rts

;	******** Données ********
_IntuitionBase	dc.l	0
intName		dc.b	"intuition.library",0
	even



*********************************************************
*	Ouverture/fermeture CyberGraphics.library	*
*********************************************************

OpenCyberGfx
	movem.l		d0/d1/a0/a1/a6,-(sp)
	lea		cgxName(pc),a1
	moveq		#0,d1
	CALLEXEC	OpenLibrary
	move.l		d0,_CyberGfxBase
	movem.l		(sp)+,d0/d1/a0/a1/a6
	rts

CloseCyberGfx
	movem.l		d0/d1/a0/a1/a6,-(sp)
	move.l		_CyberGfxBase(pc),a1
	CALLEXEC	CloseLibrary
	movem.l		(sp)+,d0/d1/a0/a1/a6
	rts

;	******** Données ********
_CyberGfxBase	dc.l	0
cgxName	dc.b	"cybergraphics.library",0

*********************************************************
*	Ouverture/fermeture Graphics.library		*
*********************************************************

OpenGfx
	movem.l		d0/d1/a0/a1/a6,-(sp)
	lea		gfxName(pc),a1
	moveq		#0,d1
	CALLEXEC	OpenLibrary
	move.l		d0,_GfxBase
	movem.l		(sp)+,d0/d1/a0/a1/a6
	rts

CloseGfx
	movem.l		d0/d1/a0/a1/a6,-(sp)
	move.l		_GfxBase(pc),a1
	CALLEXEC	CloseLibrary
	movem.l		(sp)+,d0/d1/a0/a1/a6
	rts

;	******** Données ********
_GfxBase	dc.l	0
gfxName	dc.b	"graphics.library",0
