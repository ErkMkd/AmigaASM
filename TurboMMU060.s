;APS00000000000000000000000000000000000000000000000000000000000000000000000000000000
*********************************
*				*
*	Environnement		*
*	Last rev: 5/9/2000	*
*				*
*********************************

	section	Intense,code_f

	bra	Start

	incdir	WorkCode:SubRoutines/
	include	System.s

*********************************************************************************************

Start
                movem.l d0-d2,-(sp)
                CALLEXEC        SuperState      ;go to supervisor mode
                move.l  d0,d2
                CALLEXEC        Disable
                CALLEXEC        CacheClearU
                movec   DTT0,d0                 ;read DTT0
                move.l  d0,OldDTT0              ;save DTT0
                movec   DTT1,d0                 ;read DTT1
                move.l  d1,OldDTT1              ;save DTT1
                move.l  #$c040,d0               ;Zorro2 = noncachable/serialized
                movec   d0,DTT0                 ;write DTT0
                move.l  #$0fc020,d0             ;<$10000000 = cachable/copyback
                movec   d0,DTT1                 ;write DTT1
                CALLEXEC        Enable
                move.l  d2,d0
                CALLEXEC        UserState       ;go to user mode
.end
                movem.l (sp)+,d0-d2
                rts

OldDTT0	dc.l	0
OldDTT1	dc.l	0

******************************************************************************************
******************************************************************************************
**			PROGRAMME PRINCIPAL						**
******************************************************************************************
******************************************************************************************
