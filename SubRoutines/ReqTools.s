;APS00000000000000000000000000000000000000000000000000000000000000000000000000000000
*********************************
*				*
*	Gestion reqtools	*
*	Last rev: 17/04/2000	*
*				*
*********************************

*************************************************************************
*			Variables public				*
*************************************************************************

Rt_FileName	dcb.b	256,0	;Nom du fichier
Rt_DirName	dcb.b	256,0	;Nom du dir.
Rt_FileList	dc.l	0	;List de fichiers


;---- Macros

CALLRT	macro
	move.l	_ReqBase(pc),a6
	JSRLIB	\1
	endm

*****************************************
*	Selection du repertoire courant	*
*****************************************
SelectDirectory
	and.l	#-FREQF_MULTISELECT-1,Rt_Flags
	or.l	#FREQF_NOFILES,Rt_Flags
	bra.s	FileRequest

*****************************************
*	Requete Fichier seul		*
*****************************************
SingleFileRequest
	and.l	#-FREQF_MULTISELECT-FREQF_NOFILES-1,Rt_Flags
	bra.s	FileRequest

*****************************************
*	Requete list de fichiers	*
*****************************************
MultiFileRequest
	and.l	#-FREQF_NOFILES-1,Rt_Flags
	or.l	#FREQF_MULTISELECT,Rt_Flags
FileRequest
	movem.l	d0/d1/a0-a3/a6,-(sp)
;	---- Alloue le requester:
	sub.l	a0,a0
	moveq	#RT_FILEREQ,d0
	CALLRT	rtAllocRequestA
	tst.l	d0
	beq.w	e_FileReq
	move.l	d0,Rt_ReqFile

;	---- Affiche requester:
	move.l	d0,a1
	lea	Rt_FileName(pc),a2
	lea	Rt_Title(pc),a3
	lea	Rt_TagList(pc),a0
	CALLRT	rtFileRequestA
	tst.l	d0
	beq.s	e_Cancel
	move.l	Rt_Flags(pc),d1
	btst	#FREQB_MULTISELECT,d1
	beq.s	.bkp
;	---- Gestion liste des fichiers:
	tst.l	Rt_FileList(pc)
	beq.s	.ok
	move.l	Rt_FileList(pc),a0
	move.l	d0,-(sp)
	CALLRT	rtFreeFileList
	move.l	(sp)+,d0
.ok	move.l	d0,Rt_FileList
;	---- Backup du nom du dir.:
.bkp	move.l	Rt_ReqFile(pc),a0
	move.l	rtfi_Dir(a0),a0
	lea	Rt_DirName(pc),a1
.copy	move.b	(a0),(a1)+
	tst.b	(a0)+
	bne.s	.copy
;	---- Remove requester:
	move.l	Rt_ReqFile(pc),a1
	CALLRT	rtFreeRequest

;	---- Ok:
	movem.l	(sp)+,d0/d1/a0-a3/a6
	clc
	rts

;	******** Erreurs ********

e_FileReq
	movem.l	(sp)+,d0/d1/a0-a3/a6
	moveq	#Cant_create_FileReq,d0
	stc
	rts

e_Cancel
	movem.l	(sp)+,d0/d1/a0-a3/a6
	moveq	#ReqTools_canceled,d0
	stc
	rts

;	******** Données ********

Rt_ReqFile	dc.l	0

Rt_TagList	dc.l	RT_PubScrName,Rt_WbScreen
		dc.l	RT_LeftOffset,100
		dc.l	RT_TopOffset,100
		dc.l	RT_ScreenToFront,TRUE
		dc.l	RTFI_Flags
Rt_Flags	dc.l	FREQF_MULTISELECT
		dc.l	RTFI_Height,400
		dc.l	RTFI_OkText,Rt_Ok
		dc.l	TAG_DONE

Rt_WbScreen	dc.b	"Workbench",0
Rt_Ok		dc.b	"Zou!",0
Rt_Title	dc.b	"Intense - 2000",0
		even
