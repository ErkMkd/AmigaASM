;APS0000631B0000631B0000631B0000631B0000631B0000631B0000631B0000631B0000631B0000631B
*********************************
*				*
*	     GadTools		*
*	Last rev: 30/5/2000	*
*				*
*********************************

	STRUCTURE	GLNode,0
	STRUCT	gn_LN,LN_SIZE
	APTR	gn_GList
	APTR	gn_LastGadget
	LONG	gn_VisualInfo
	LABEL		GLNode_SIZE

	STRUCTURE	GadgetUserDatas,0
	APTR	gud_Window		;Pointeur sur la fenêtre intuition utilisatrice.
	LONG	gud_AttrsSize
	APTR	gud_AttrsTagList
	LABEL		GadgetUserDatas_SIZE

; Structures d'interphaçage gadgets <=> programme:

	STRUCTURE	gtbtAttrs,0
	LONG	gtbtTag_tg0
	LONG	gtbtAttr_Disabled
	LONG	gtbtTag_DONE
	LABEL		gtbtAttrs_SIZE

	STRUCTURE	gtcbAttrs,0
	LONG	gtcbTag_tg0
	LONG	gtcbAttr_Disabled
	LONG	gtcbTag_tg1
	LONG	gtcbAttr_Checked
	LONG	gtcbTag_DONE
	LABEL		gtcbAttrs_SIZE

	STRUCTURE	gtcyAttrs,0
	LONG	gtcyTag_tg0
	LONG	gtcyAttr_Disabled
	LONG	gtcyTag_tg1
	LONG	gtcyAttr_Active
	LONG	gtcyTag_tg2
	LONG	gtcyAttr_Labels
	LONG	gtcyTag_DONE
	LABEL		gtcyAttrs_SIZE

	STRUCTURE	gtinAttrs,0
	LONG	gtinTag_tg0
	LONG	gtinAttr_Disabled
	LONG	gtinTag_tg1
	LONG	gtinAttr_Number
	LONG	gtinTag_DONE
	LABEL		gtinAttrs_SIZE

	STRUCTURE	gtlvAttrs,0
	LONG	gtlvTag_tg0
	LONG	gtlvAttr_Disabled
	LONG	gtlvTag_tg1
	LONG	gtlvAttr_Top
	LONG	gtlvTag_tg2
	LONG	gtlvAttr_Labels
	LONG	gtlvTag_tg3
	LONG	gtlvAttr_Selected
	LONG	gtlvTag_DONE
	LABEL		gtlvAttrs_SIZE

	STRUCTURE	gtmxAttrs,0
	LONG	gtmxTag_tg0
	LONG	gtmxAttr_Disabled
	LONG	gtmxTag_tg1
	LONG	gtmxAttr_Active
	LONG	gtmxTag_DONE
	LABEL		gtmxAttrs_SIZE

	STRUCTURE	gtnmAttrs,0
	LONG	gtnmTag_tg0
	LONG	gtnmAttr_Number
	LONG	gtnmTag_DONE
	LABEL		gtnmAttrs_SIZE

	STRUCTURE	gtpaAttrs,0
	LONG	gtpaTag_tg0
	LONG	gtpaAttr_Disabled
	LONG	gtpaTag_tg1
	LONG	gtpaAttr_Color
	LONG	gtpaTag_tg2
	LONG	gtpaAttr_ColorOffset
	LONG	gtpaTag_DONE
	LABEL		gtpaAttrs_SIZE

	STRUCTURE	gtscAttrs,0
	LONG	gtscTag_tg0
	LONG	gtscAttr_Disabled
	LONG	gtscTag_tg1
	LONG	gtscAttr_Top
	LONG	gtscTag_tg2
	LONG	gtscAttr_Total
	LONG	gtscTag_tg3
	LONG	gtscAttr_Visible
	LONG	gtscTag_DONE
	LABEL		gtscAttrs_SIZE

	STRUCTURE	gtslAttrs,0
	LONG	gtslTag_tg0
	LONG	gtslAttr_Disabled
	LONG	gtslTag_tg1
	LONG	gtslAttr_Min
	LONG	gtslTag_tg2
	LONG	gtslAttr_Max
	LONG	gtslTag_tg3
	LONG	gtslAttr_Level
	LONG	gtslTag_DONE
	LABEL		gtslAttrs_SIZE

	STRUCTURE	gtstAttrs,0
	LONG	gtstTag_tg0
	LONG	gtstAttr_Disabled
	LONG	gtstTag_tg1
	LONG	gtstAttr_String
	LONG	gtstTag_DONE
	LABEL		gtstAttrs_SIZE

	STRUCTURE	gttxAttrs,0
	LONG	gttxTag_tg0
	LONG	gttxAttr_Text
	LONG	gttxTag_DONE
	LABEL		gttxAttrs_SIZE


*************************************************
*	Creation d'une liste de gadget		*
*IN:	a0=@Nom de la liste			*
*	a1=@Screen				*
*OUT:	a0=@GLNode				*
*************************************************
CreateGadgetList
	movem.l		d0/d1/a0/a1/a6,-(sp)
;	---- Allocation structure GLNode
	moveq		#GLNode_SIZE,d0
	move.l		#MEMF_FAST!MEMF_CLEAR,d1
	CALLEXEC	AllocVec
	tst.l		d0
	beq.s		.e_Memory
	move.l		d0,gt_GLNode
;	---- Creation contexte:
	move.l		d0,a0
	lea		gn_GList(a0),a0
	clr.l		(a0)
	CALLGT		CreateContext
	tst.l		d0
	beq.s		.e_Context
;	---- Saisie visualInfo:
	move.l		12(sp),a0
	CALLGT		GetVisualInfoA
	tst.l		d0
	beq.s		.e_Visual
;	---- Init GLNode:
	lea		GLList(pc),a0
	move.l		gt_GLNode(pc),a1
	move.l		d0,gn_VisualInfo(a1)
	move.l		8(sp),LN_NAME(a1)
	move.l		gn_GList(a1),gn_LastGadget(a1)
	CALLEXEC	AddTail
;	---- Ok:
	movem.l		(sp)+,d0/d1/a0/a1/a6
	move.l		gt_GLNode(pc),a0
	clc
	rts

;	******** Erreurs ********
.e_Memory
	movem.l		(sp)+,d0/d1/a0/a1/a6
	moveq		#Not_enough_memory,d0
	stc
	rts

.e_Context
	move.l		gt_GLNode(pc),a0
	CALLEXEC	FreeVec
	movem.l		(sp)+,d0/d1/a0/a1/a6
	moveq		#Cant_create_gadget_context,d0
	stc
	rts

.e_Visual
	move.l		gt_GLNode(pc),a0
	move.l		gn_GList(a0),a0
	CALLGT		FreeGadgets
	move.l		gt_GLNode(pc),a0
	CALLEXEC	FreeVec
	movem.l		(sp)+,d0/d1/a0/a1/a6
	moveq		#Cant_get_visualInfo,d0
	stc
	rts

;	******** Données ********
gt_GLNode	dc.l	0

*************************************************
*	Suppression d'une liste de gadgets	*
*IN:	a0=@GLNode				*
*************************************************
RemoveGList
	movem.l		d0/d1/a0/a1/a6,-(sp)
;	---- Destruction des structures:
	bsr.w		RemoveUserDatas
;	---- Supprime le noeud de la liste:
	move.l		8(sp),a0
	move.l		a0,a1
	CALLEXEC	Remove
;	---- Efface la GListe:
	move.l		8(sp),a0
	move.l		gn_GList(a0),a0
	CALLGT		FreeGadgets
;	---- Efface le noeud:
	move.l		8(sp),a1
	CALLEXEC	FreeVec
;	---- Ok:
	movem.l		(sp)+,d0/d1/a0/a1/a6
	sub.l		a0,a0
	clc
	rts

*****************************************************************
*	Destruction des structures annexes des gadgets		*
*IN:	a0=@GLNode						*
*****************************************************************
RemoveUserDatas
	movem.l		d0/d1/a0-a3/a6,-(sp)
	move.l		gn_GList(a0),a2
.loop	move.l		gg_NextGadget(a2),d0
	beq.s		.end
	move.l		d0,a2
	move.l		gg_UserData(a2),d0
	beq.s		.loop
	move.l		d0,a3
	move.l		gud_AttrsTagList(a3),d0
	beq.s		.loop
	move.l		d0,a1
	CALLEXEC	FreeVec
	move.l		a3,a1
	CALLEXEC	FreeVec
	clr.l		gg_UserData(a2)
	bra.s		.loop
.end	movem.l		(sp)+,d0/d1/a0-a3/a6
	clc
	rts

*************************************************
*	Supprime toutes les GLists		*
*************************************************
PurgeGLList
	movem.l	a0/a1,-(sp)
	lea	GLList(pc),a1
.loop	move.l	LH_HEAD(a1),a0
	tst.l	(a0)
	beq.s	.ok
	bsr.s	RemoveGList
	bra.s	.loop
.ok	movem.l	(sp)+,a0/a1
	clc
	rts

*************************************************
*	Rafraichissement des gadgets		*
*IN:	a0=@WindowNode				*
*************************************************
RefreshGadgets
	movem.l	d0/d1/a0/a1/a6,-(sp)
	move.l	wn_Window(a0),a0
	sub.l	a1,a1
	CALLGT	GT_RefreshWindow
	movem.l	(sp)+,d0/d1/a0/a1/a6
	clc
	rts

*************************************************
*	Rafraichissement des gadgets		*
*IN:	a0=@WindowNode				*
*************************************************
RefreshGadgetAttrs
	movem.l	d0/a0,-(sp)
	move.l	wn_Window(a0),a0
	move.l	wd_FirstGadget(a0),a0
.loop	tst.l	gg_UserData(a0)
	beq.s	.next
	bsr.w	GetGadgetAttrs
.next	move.l	gg_NextGadget(a0),d0
	beq.s	.end
	move.l	d0,a0
	bra.s	.loop
.end	movem.l	(sp)+,d0/a0
	clc
	rts

*************************************************
*	Creation d'un gadget			*
*IN:	d0=Kind (Nature du gadget)		*
*	a0=@GLNode				*
*OUT:	d0=@Gadget				*
*************************************************
CreateGadget
	movem.l		d0-d2/a0-a4/a6,-(sp)
;	---- Création structure GadgetUserDatas:
	moveq		#GadgetUserDatas_SIZE,d0
	move.l		#MEMF_FAST!MEMF_CLEAR,d1
	CALLEXEC	AllocVec
	tst.l		d0
	beq.w		.e_gud
;	---- Init pointeurs:
	lea		gt_NewGadget(pc),a1
	move.l		d0,gng_UserData(a1)
	move.l		d0,a3			;a3=@GadgetUserData
	move.l		(sp),d0
	move.l		12(sp),a0
	move.l		gn_VisualInfo(a0),gng_VisualInfo(a1)
	move.l		gn_LastGadget(a0),a0
;	---- Recherche nature du gadget:
	cmp.l		#BUTTON_KIND,d0
	beq.s		.button
	cmp.l		#CHECKBOX_KIND,d0
	beq.s		.checkBox
	cmp.l		#CYCLE_KIND,d0
	beq.s		.cycle
	cmp.l		#INTEGER_KIND,d0
	beq.w		.integer
	cmp.l		#LISTVIEW_KIND,d0
	beq.w		.listView
	cmp.l		#MX_KIND,d0
	beq.w		.mx
	cmp.l		#NUMBER_KIND,d0
	beq.w		.number
	cmp.l		#PALETTE_KIND,d0
	beq.w		.palette
	cmp.l		#SCROLLER_KIND,d0
	beq.w		.scroller
	cmp.l		#SLIDER_KIND,d0
	beq.w		.slider
	cmp.l		#STRING_KIND,d0
	beq.w		.string
	cmp.l		#TEXT_KIND,d0
	beq.w		.text
	bra.w		.e_kind
;	---- Gadget bouton:
.button
	moveq		#gtbtAttrs_SIZE,d2
	lea		gtAttrs_BUTTON(pc),a4
	lea		gt_BUTTON(pc),a2
	bra.w		.init
;	---- CheckBox:
.checkBox
	moveq		#gtcbAttrs_SIZE,d2
	lea		gtAttrs_CHECKBOX(pc),a4
	lea		gt_CHECKBOX(pc),a2
	bra.w		.init
;	---- Cycle:
.cycle
	moveq		#gtcyAttrs_SIZE,d2
	lea		gtAttrs_CYCLE(pc),a4
	lea		gt_CYCLE(pc),a2
	bra.s		.init
;	---- Integer:
.integer
	moveq		#gtinAttrs_SIZE,d2
	lea		gtAttrs_INTEGER(pc),a4
	lea		gt_INTEGER(pc),a2
	bra.s		.init
;	---- ListView:
.listView
	moveq		#gtlvAttrs_SIZE,d2
	lea		gtAttrs_LISTVIEW(pc),a4
	lea		gt_LISTVIEW(pc),a2
	bra.s		.init
;	---- Mx:
.mx
	moveq		#gtmxAttrs_SIZE,d2
	lea		gtAttrs_MX(pc),a4
	lea		gt_MX(pc),a2
	bra.s		.init
;	---- Number:
.number
	moveq		#gtnmAttrs_SIZE,d2
	lea		gtAttrs_NUMBER(pc),a4
	lea		gt_NUMBER(pc),a2
	bra.s		.init
;	---- Palette:
.palette
	moveq		#gtpaAttrs_SIZE,d2
	lea		gtAttrs_PALETTE(pc),a4
	lea		gt_PALETTE(pc),a2
	bra.s		.init
;	---- Scroller:
.scroller
	moveq		#gtscAttrs_SIZE,d2
	lea		gtAttrs_SCROLLER(pc),a4
	lea		gt_SCROLLER(pc),a2
	bra.s		.init
;	---- Slider:
.slider
	moveq		#gtslAttrs_SIZE,d2
	lea		gtAttrs_SLIDER(pc),a4
	lea		gt_SLIDER(pc),a2
	bra.s		.init
;	---- String:
.string
	moveq		#gtstAttrs_SIZE,d2
	lea		gtAttrs_STRING(pc),a4
	lea		gt_STRING(pc),a2
	bra.s		.init
;	---- Texte:
.text
	moveq		#gttxAttrs_SIZE,d2
	lea		gtAttrs_TEXT(pc),a4
	lea		gt_TEXT(pc),a2
;	---- Init GLNode:
.init	CALLGT		CreateGadgetA
	tst.l		d0
	beq.s		.e_gadget
	move.l		12(sp),a0
	move.l		d0,gn_LastGadget(a0)
	move.l		d0,(sp)
;	Init Attr structure:
	move.l		d2,d0
	move.l		#MEMF_FAST,d1
	CALLEXEC	AllocVec
	tst.l		d0
	beq.s		.e_Attr
	move.l		d2,gud_AttrsSize(a3)
	move.l		d0,a0		;a0=@Attrs structure
	move.l		d0,gud_AttrsTagList(a3)
	subq.b		#1,d2
	lsr.w		#2,d2
.copy	move.l		(a4)+,(a0)+
	dbra		d2,.copy
;	---- Ok:
	movem.l		(sp)+,d0-d2/a0-a4/a6
	clc
	rts

;	******** Erreur ********
.e_gud
	movem.l		(sp)+,d0-d2/a0-a4/a6
	moveq		#Cant_create_GadgetUserDatas,d0
	stc
	rts

.e_kind
	move.l		a3,a1
	CALLEXEC	FreeVec
	movem.l		(sp)+,d0-d2/a0-a4/a6
	moveq		#Undefined_gadget_kind,d0
	stc
	rts

.e_gadget
	move.l		a3,a1
	CALLEXEC	FreeVec
	movem.l		(sp)+,d0-d2/a0-a4/a6
	moveq		#Cant_create_gadget,d0
	stc
	rts

.e_Attr
	movem.l		(sp)+,d0-d2/a0-a4/a6
	moveq		#Cant_alloc_Attr_structure,d0
	stc
	rts

;	******** Données ********

gt_NewGadget
gt_ng.LeftEdge		dc.w	16
gt_ng.TopEdge		dc.w	16	; gadget position
gt_ng.Width		dc.w	80
gt_ng.Height		dc.w	16	;  gadget size
gt_ng.GadgetText	dc.l	gt_text	; gadget label
gt_ng.TextAttr		dc.l	0	; desired font for gadget label
gt_ng.GadgetID		dc.w	3	; gadget ID
gt_ng.Flags		dc.l	PLACETEXT_IN
gt_ng.VisualInfo	dc.l	0	; Set to retval of GetVisualInfo()
gt_ng.UserData		dc.l	0	; gadget UserData *** Utilisé pour les tags GetGadgetAttrs ***

gt_text		STRING	"Intense"

; Bouton:
gt_BUTTON
		dc.l	GA_Disabled
gt_bt.Disabled	dc.l	FALSE
		dc.l	GA_Immediate
gt_bt.Immediate	dc.l	FALSE
		dc.l	TAG_DONE

; CheckBox:
gt_CHECKBOX
		dc.l	GA_Disabled
gt_cb.Disabled	dc.l	FALSE
		dc.l	GTCB_Checked
gt_cb.Checked	dc.l	FALSE
		dc.l	TAG_DONE

; Cycle:
gt_CYCLE
		dc.l	GA_Disabled
gt_cy.Disabled	dc.l	FALSE
		dc.l	GTCY_Labels
gt_cy.Labels	dc.l	0
		dc.l	GTCY_Active
gt_cy.Active	dc.l	0
		dc.l	TAG_DONE

; Integer:
gt_INTEGER
			dc.l	GA_Disabled
gt_in.Disable		dc.l	FALSE
			dc.l	GA_Immediate
gt_in.Immediate		dc.l	FALSE
			dc.l	GA_TabCycle
gt_in.TabCycle		dc.l	TRUE
			dc.l	GTIN_Number
gt_in.Number		dc.l	0
			dc.l	GTIN_MaxChars
gt_in.MaxChars		dc.l	10
			dc.l	STRINGA_ExitHelp
gt_in.ExitHelp		dc.l	FALSE
			dc.l	STRINGA_Justification
gt_in.Justification	dc.l	STRINGRIGHT
			dc.l	STRINGA_ReplaceMode
gt_in.ReplaceMode	dc.l	FALSE
			dc.l	TAG_DONE

; ListView:
gt_LISTVIEW
			dc.l	GA_Disabled
gt_lv.Disabled		dc.l	FALSE
			dc.l	GTLV_Top
gt_lv.Top		dc.l	0
			dc.l	GTLV_Labels
gt_lv.Labels		dc.l	0
			dc.l	GTLV_ReadOnly
gt_lv.ReadOnly		dc.l	FALSE
			dc.l	GTLV_ScrollWidth
gt_lv.ScrollWidth	dc.l	16
			dc.l	GTLV_ShowSelected
gt_lv.ShowSelected	dc.l	0
			dc.l	GTLV_Selected
gt_lv.Selected		dc.l	0
			dc.l	LAYOUTA_Spacing
gt_lv.Spacing		dc.l	0
			dc.l	TAG_DONE
; MX:
gt_MX
		dc.l	GA_Disabled
gt_mx.Disabled	dc.l	FALSE
		dc.l	GTMX_Labels
gt_mx.Labels	dc.l	0
		dc.l	GTMX_Active
gt_mx.Spacing	dc.l	1
		dc.l	TAG_DONE

; Number:
gt_NUMBER
		dc.l	GTNM_Number
gt_nm.Number	dc.l	1000
		dc.l	GTNM_Border
gt_nm.Border	dc.l	TRUE
		dc.l	TAG_DONE		

; Palette:
gt_PALETTE
			dc.l	GA_Disabled
gt_pa.Disabled		dc.l	FALSE
			dc.l	GTPA_Depth
gt_pa.Depth		dc.l	1
			dc.l	GTPA_Color
gt_pa.Color		dc.l	1
			dc.l	GTPA_ColorOffset
gt_pa.ColorOffset	dc.l	0
			dc.l	GTPA_IndicatorWidth
gt_pa.IndicatorWidth	dc.l	8
			dc.l	GTPA_IndicatorHeight
gt_pa.IndicatorHeight	dc.l	8
			dc.l	TAG_DONE
			
; Scroller:
gt_SCROLLER
			dc.l	GA_Disabled
gt_sc.Disabled		dc.l	FALSE
			dc.l	GA_RelVerify
gt_sc.RelVerify		dc.l	FALSE
			dc.l	GA_Immediate
gt_sc.Immeditate	dc.l	FALSE
			dc.l	GTSC_Top
gt_sc.Top		dc.l	0
			dc.l	GTSC_Total
gt_sc.Total		dc.l	10
			dc.l	GTSC_Visible
gt_sc.Visible		dc.l	2
			dc.l	GTSC_Arrows			
gt_sc.Arrows		dc.l	12
			dc.l	PGA_Freedom
gt_sc.Orientation	dc.l	LORIENT_HORIZ
			dc.l	TAG_DONE

; Slider:
gt_SLIDER
			dc.l	GA_Disabled
gt_sl.Disabled		dc.l	FALSE
			dc.l	GA_RelVerify
gt_sl.RelVerify		dc.l	FALSE
			dc.l	GA_Immediate
gt_sl.Immediate		dc.l	FALSE
			dc.l	GTSL_Min
gt_sl.Min		dc.l	0
			dc.l	GTSL_Max
gt_sl.Max		dc.l	15
			dc.l	GTSL_Level
gt_sl.Level		dc.l	0
			dc.l	GTSL_MaxLevelLen
gt_sl.MaxLevelLen	dc.l	2
			dc.l	GTSL_LevelFormat
gt_sl.LevelFormat	dc.l	gt_sl.DefaultLevelFormat
			dc.l	GTSL_LevelPlace
gt_sl.LevelPlace	dc.l	PLACETEXT_LEFT
			dc.l	GTSL_DispFunc
gt_sl.DispFunc		dc.l	0
			dc.l	PGA_Freedom
gt_sl.Orientation	dc.l	LORIENT_HORIZ
			dc.l	TAG_DONE

gt_sl.DefaultLevelFormat	STRING	"%ld"

; String:
gt_STRING
			dc.l	GA_Disabled
gt_st.Disabled		dc.l	FALSE
			dc.l	GA_RelVerify
gt_st.Immediate		dc.l	FALSE
			dc.l	GA_TabCycle
gt_st.TabCycle		dc.l	TRUE
			dc.l	GTST_String
gt_st.String		dc.l	0
			dc.l	GTST_MaxChars
gt_st.MaxChars		dc.l	256
			dc.l	GTST_EditHook
gt_st.EditHook		dc.l	0
			dc.l	STRINGA_ExitHelp
gt_st.ExitHelp		dc.l	FALSE
			dc.l	STRINGA_Justification
gt_st.Justification	dc.l	STRINGLEFT
			dc.l	STRINGA_ReplaceMode
gt_st.ReplaceMode	dc.l	FALSE
			dc.l	TAG_DONE
; Text:

gt_TEXT
			dc.l	GTTX_Text
gt_tx.Text		dc.l	gt_tx.DefaultText
			dc.l	GTTX_CopyText
gt_tx.CopyText		dc.l	FALSE
			dc.l	GTTX_Border
gt_tx.Border		dc.l	TRUE
			dc.l	TAG_DONE

gt_tx.DefaultText	STRING	"Empty buffer"

*************************************************
*	Interfaçage avec les gadgets		*
*IN:	a0=@Gadget				*
*OUT:	Initialisation correcte des tags	*
*************************************************
GetGadgetAttrs
	movem.l	d0/d1/a0-a3/a6,-(sp)
	move.l	gg_UserData(a0),d0
	beq.s	.end
	move.l	d0,a2
	move.l	gud_Window(a2),a1
	move.l	gud_AttrsTagList(a2),d0
	beq.s	.end
	move.l	d0,a3
	sub.l	a2,a2
	CALLGT	GT_GetGadgetAttrsA
	tst.l	d0
	beq.s	.e_attrs
.end	movem.l	(sp)+,d0/d1/a0-a3/a6
	clc
	rts

;	******** Erreurs ********
.e_attrs
	movem.l	(sp)+,d0/d1/a0-a3/a6
	moveq	#Cant_get_gadget_attributs,d0
	stc
	rts	

;	******** Données ********

; Button:

gtAttrs_BUTTON
			dc.l	GA_Disabled
gtAttrs_bt.Disabled	dc.l	FALSE
			dc.l	TAG_DONE

; CheckBox:

gtAttrs_CHECKBOX
			dc.l	GA_Disabled
gtAttrs_cb.Disabled	dc.l	FALSE
			dc.l	GTCB_Checked
gtAttrs_cb.Checked	dc.l	FALSE
			dc.l	TAG_DONE

; Cycle:

gtAttrs_CYCLE
			dc.l	GA_Disabled
gtAttrs_cy.Disabled	dc.l	FALSE
			dc.l	GTCY_Active
gtAttrs_cy.Active	dc.l	0
			dc.l	GTCY_Labels
gtAttrs_cy.Labels	dc.l	0
			dc.l	TAG_DONE

; Integer:

gtAttrs_INTEGER
			dc.l	GA_Disabled
gtAttrs_in.Disabled	dc.l	FALSE
			dc.l	GTIN_Number
gtAttrs_in.Number	dc.l	0
			dc.l	TAG_DONE

; List view:

gtAttrs_LISTVIEW
			dc.l	GA_Disabled
gtAttrs_lv.Disabled	dc.l	FALSE
			dc.l	GTLV_Top
gtAttrs_lv.Top		dc.l	0
			dc.l	GTLV_Labels
gtAttrs_lv.Labels	dc.l	0
			dc.l	GTLV_Selected
gtAttrs_lv.Selected	dc.l	0
			dc.l	TAG_DONE

; Mx:

gtAttrs_MX
			dc.l	GA_Disabled
gtAttrs_mx.Disabled	dc.l	FALSE
			dc.l	GTMX_Active
gtAttrs_mx.Active	dc.l	0
			dc.l	TAG_DONE

; Number:

gtAttrs_NUMBER
			dc.l	GTNM_Number
gtAttrs_nm.Number	dc.l	0
			dc.l	TAG_DONE

; Palette:

gtAttrs_PALETTE
			dc.l	GA_Disabled
gtAttrs_pa.Disabled	dc.l	FALSE
			dc.l	GTPA_Color
gtAttrs_pa.Color	dc.l	0
			dc.l	GTPA_ColorOffset
gtAttrs_pa.ColorOffset	dc.l	0
			dc.l	TAG_DONE

; Scroller:

gtAttrs_SCROLLER
			dc.l	GA_Disabled
gtAttrs_sc.Disabled	dc.l	FALSE
			dc.l	GTSC_Top
gtAttrs_sc.Top		dc.l	0
			dc.l	GTSC_Total
gtAttrs_sc.Total	dc.l	0
			dc.l	GTSC_Visible
gtAttrs_sc.Visible	dc.l	0
			dc.l	TAG_DONE

; Slider:

gtAttrs_SLIDER
			dc.l	GA_Disabled
gtAttrs_sl.Disabled	dc.l	0
			dc.l	GTSL_Min
gtAttrs_sl.Min		dc.l	0
			dc.l	GTSL_Max
gtAttrs_sl.Max		dc.l	0
			dc.l	GTSL_Level
gtAttrs_sl.Level	dc.l	0
			dc.l	TAG_DONE

; String:

gtAttrs_STRING
			dc.l	GA_Disabled
gtAttrs_st.Disabled	dc.l	FALSE
			dc.l	GTST_String
gtAttrs_st.String	dc.l	0
			dc.l	TAG_DONE

; Text:

gtAttrs_TEXT
			dc.l	GTTX_Text
gtAttrs_tx.Text		dc.l	0
			dc.l	TAG_DONE
