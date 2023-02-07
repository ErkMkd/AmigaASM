;APS00000000000000000000000000000000000000000000000000000000000000000000000000000000
*************************************************
*	Gestion de fichiers	19/11/2000	*
*************************************************

*************************************************
*	Chargement d'un fichier			*
*IN	a0=@ fileName				*
*OUT	d0=@datas				*
*	d1=FileSize				*
*************************************************
LoadFile
	movem.l	d0-d3/a0/a1/a6,-(sp)
;	---- Ouverture:
	move.l	a0,d1
	move.l	#MODE_OLDFILE,d2
	CALLDOS	Open
	tst.l	d0
	beq.s	.e_Open
	move.l	d0,.fileHandle
;	---- Calcul la taille:
	move.l	.fileHandle(pc),d1
	clr.l	d2
	moveq	#OFFSET_END,d3
	CALLDOS	Seek
	move.l	.fileHandle(pc),d1
	moveq	#OFFSET_BEGINNING,d3
	CALLDOS	Seek
	move.l	d0,.fileSize
;	---- Alloue la mémoire:
	move.l		#MEMF_FAST,d1
	CALLEXEC	AllocVec
	tst.l		d0
	beq.s		.e_Memory
	move.l		d0,.buffer
;	---- Charge le fichier:
	bsr.w		DataCache_Off
	move.l		.fileHandle(pc),d1
	move.l		.buffer(pc),d2
	move.l		.fileSize(pc),d3
	CALLDOS		Read
	bsr.w		DataCache_On
;	---- Fermeture fichier:
	move.l		.fileHandle(pc),d1
	CALLDOS		Close
;	---- Zee End:
	movem.l		(sp)+,d0-d3/a0/a1/a6
	clc
	rts

;	******** Erreurs ********

.e_Open
	movem.l	(sp)+,d0-d3/a0/a1/a6
	moveq	#Cant_open_file,d0
	stc
	rts

.e_Memory
	movem.l	(sp)+,d0-d3/a0/a1/a6
	moveq	#Not_enough_memory,d0
	stc
	rts

;	******** Données *********
.fileHandle	dc.l	0
.fileSize	dc.l	0
.buffer		dc.l	0

*****************************************
*	Sauvegarde un fichier		*
*IN:	a0=@FileName			*
*	a1=@FileBuffer			*
*	d0=FileSize			*
*****************************************
SaveFile
	movem.l		d0-d3/a0/a1/a6,-(sp)
	move.l		a0,.name
	move.l		a1,.buffer
	move.l		d0,.size
;	---- Ouvre le fichier:
	move.l		a0,d1
	move.l		#1006,d2
	CALLDOS		Open
	move.l		d0,.handle
;	---- Sauvegarde:
	bsr.w		DataCache_Off
	move.l		d0,d1
	move.l		.buffer(pc),d2
	move.l		.size(pc),d3
	CALLDOS		Write
	bsr.w		DataCache_On
;	---- Fermeture fichier:
	move.l		.handle(pc),d1
	CALLDOS		Close
;	---- Ok:
	movem.l		(sp)+,d0-d3/a0/a1/a6
	clc
	rts

;	******** Données ********

.name		dc.l	0
.buffer		dc.l	0
.size		dc.l	0
.handle		dc.l	0
