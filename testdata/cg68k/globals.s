LBL_39:
        ; startup (JT slot 0)
        ; globals (below A5, 520 bytes total):
        ;   lasterrCode : -4(A5)  size 4  type int
        ;   lasterrMsg : -260(A5)  size 256  type str
        ;   count : -264(A5)  size 4  type int
        ;   name : -520(A5)  size 256  type str
        LEA -520(A5),A0
        MOVE.W #259,D0
LBL_42:
        CLR.W (A0)+
        DBRA D0,LBL_42
        DC.W $A063  ; _MaxApplZone
        DC.W $A036  ; _MoreMasters
        JSR LBL_40(PC)
        ; entry-handler dispatch stub -- no event/arg marshaling yet (Task 11)
        JSR LBL_23(PC)
        JSR LBL_41(PC)
        CLR.L -(A7)
        ; natQuit not present -- wired in Task 11
        RTS
LBL_40:
        ; cg_init_globals: TODO evaluate irGlobal init exprs (Task 8) -- below-A5 zeroing already done by startup
        RTS
LBL_41:
        ; cg_free_globals: TODO release ARC-owned globals (Task 8/9)
        RTS
        ; func nat_CorePanic  (JT slot 1)
        ;   param msg : 8(A6)  size 256
LBL_0:
        LINK A6,#0
LBL_43:
        UNLK A6
        RTS
        ; func rtSetLastErr  (JT slot 2)
        ;   param code : 264(A6)  size 4
        ;   param msg : 8(A6)  size 256
LBL_1:
        LINK A6,#0
        MOVE.L 264(A6),D0
        MOVE.L D0,-4(A5)
        LEA -260(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA 8(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_4(PC)
        ADDA.W #12,A7
LBL_44:
        UNLK A6
        RTS
        ; func rtPanic  (JT slot 3)
        ;   param msg : 8(A6)  size 256
LBL_2:
        LINK A6,#0
        LEA 8(A6),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_46:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_46
        JSR LBL_0(PC)
        ADDA.W #256,A7
LBL_45:
        UNLK A6
        RTS
        ; func rtEnumCheck  (JT slot 4)
        ;   param v : 266(A6)  size 4
        ;   param found : 264(A6)  size 2
        ;   param name : 8(A6)  size 256
LBL_3:
        LINK A6,#0
        CLR.L D0
        MOVE.B 264(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_48
        LEA LBL_25(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_49:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_49
        JSR LBL_2(PC)
        ADDA.W #256,A7
LBL_48:
        MOVE.L 266(A6),D0
        BRA.W LBL_47
LBL_47:
        UNLK A6
        RTS
        ; func rtStrStore  (JT slot 5)
        ;   param dst : 16(A6)  size 4
        ;   param dstcap : 12(A6)  size 4
        ;   param src : 8(A6)  size 4
        ;   local srclen : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
LBL_4:
        LINK A6,#-8
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_51
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_52
LBL_51:
        MOVE.L 12(A6),D0
        MOVE.L D0,-8(A6)
LBL_52:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; StrBlockMoveData
        MOVE.L 16(A6),D0
        MOVEA.L D0,A0
        MOVE.L -8(A6),D0
        MOVE.B D0,(A0)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_53
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_27(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_54:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_54
        JSR LBL_1(PC)
        ADDA.W #260,A7
LBL_53:
LBL_50:
        UNLK A6
        RTS
        ; func rtTextGrow  (JT slot 6)
        ;   param t : 12(A6)  size 4
        ;   param need : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local cap : -8(A6)  size 4
        ;   local newcap : -12(A6)  size 4
        ;   local err : -16(A6)  size 4
LBL_5:
        LINK A6,#-16
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_56
        BRA.W LBL_55
LBL_56:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_57
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_58
LBL_57:
        MOVE.L #4,D0
        MOVE.L D0,-12(A6)
LBL_58:
LBL_59:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_60
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        JSR LBL_61(PC)
        MOVE.L D0,-12(A6)
        BRA.W LBL_59
LBL_60:
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A0
        DC.W $A024  ; TextSetHandleSize
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_62
        LEA LBL_30(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_63:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_63
        JSR LBL_2(PC)
        ADDA.W #256,A7
LBL_62:
        ; TODO SAssign <dst kind 3>: unsupported this task
LBL_55:
        UNLK A6
        RTS
        ; func rtTextNew  (JT slot 7)
        ;   local t : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
LBL_6:
        LINK A6,#-8
        MOVE.L #32,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; TextNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        ; TODO SAssign <dst kind 3>: unsupported this task
        ; TODO SAssign <dst kind 3>: unsupported this task
        ; TODO SAssign <dst kind 3>: unsupported this task
        ; TODO SAssign <dst kind 3>: unsupported this task
        MOVE.L -4(A6),D0
        BRA.W LBL_64
LBL_64:
        UNLK A6
        RTS
        ; func rtTextRetain  (JT slot 8)
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
LBL_7:
        LINK A6,#-4
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_66
        BRA.W LBL_65
LBL_66:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        ; TODO SAssign <dst kind 3>: unsupported this task
LBL_65:
        UNLK A6
        RTS
        ; func rtTextRelease  (JT slot 9)
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
LBL_8:
        LINK A6,#-4
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_68
        BRA.W LBL_67
LBL_68:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_69
        MOVE.L 8(A6),D0
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
LBL_69:
        ; TODO SAssign <dst kind 3>: unsupported this task
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_70
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; TextDisposeHandle
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; TextDisposePtr
LBL_70:
LBL_67:
        UNLK A6
        RTS
        ; func rtTextStore  (JT slot 10)
        ;   param t : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
LBL_9:
        LINK A6,#-12
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_5(PC)
        ADDQ.L #8,A7
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-12(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; TextBlockMoveData
        ; TODO SAssign <dst kind 3>: unsupported this task
LBL_71:
        UNLK A6
        RTS
        ; func rtListNew  (JT slot 11)
        ;   param elemsize : 8(A6)  size 4
        ;   local l : -4(A6)  size 4
        ;   local rl : -8(A6)  size 4
LBL_10:
        LINK A6,#-8
        MOVE.L #40,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; ListNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        ; TODO SAssign <dst kind 3>: unsupported this task
        ; TODO SAssign <dst kind 3>: unsupported this task
        ; TODO SAssign <dst kind 3>: unsupported this task
        ; TODO SAssign <dst kind 3>: unsupported this task
        ; TODO SAssign <dst kind 3>: unsupported this task
        MOVE.L -4(A6),D0
        BRA.W LBL_72
LBL_72:
        UNLK A6
        RTS
        ; func rtListRetain  (JT slot 12)
        ;   param l : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
LBL_11:
        LINK A6,#-4
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_74
        BRA.W LBL_73
LBL_74:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        ; TODO SAssign <dst kind 3>: unsupported this task
LBL_73:
        UNLK A6
        RTS
        ; func rtListRelease  (JT slot 13)
        ;   param l : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
LBL_12:
        LINK A6,#-4
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_76
        BRA.W LBL_75
LBL_76:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_77
        MOVE.L 8(A6),D0
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
LBL_77:
        ; TODO SAssign <dst kind 3>: unsupported this task
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_78
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; ListDisposeHandle
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; ListDisposePtr
LBL_78:
LBL_75:
        UNLK A6
        RTS
        ; func rtListLastref  (JT slot 14)
        ;   param l : 8(A6)  size 4
LBL_13:
        LINK A6,#0
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_80
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_81
LBL_80:
        MOVE.L #0,D0
LBL_81:
        BRA.W LBL_79
LBL_79:
        UNLK A6
        RTS
        ; func rtListAt  (JT slot 15)
        ;   param l : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
LBL_14:
        LINK A6,#-12
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_83
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_84
LBL_83:
        MOVE.L #1,D0
LBL_84:
        TST.L D0
        BEQ.W LBL_85
        LEA LBL_32(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_86:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_86
        JSR LBL_2(PC)
        ADDA.W #256,A7
LBL_85:
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        JSR LBL_61(PC)
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_82
LBL_82:
        UNLK A6
        RTS
        ; func rtListCount  (JT slot 16)
        ;   param l : 8(A6)  size 4
LBL_15:
        LINK A6,#0
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        BRA.W LBL_87
LBL_87:
        UNLK A6
        RTS
        ; func mapValSlot  (JT slot 17)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_16:
        LINK A6,#0
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVEA.L D0,A0
        MOVE.L (A0),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        JSR LBL_61(PC)
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_88
LBL_88:
        UNLK A6
        RTS
        ; func rtMapNew  (JT slot 18)
        ;   param valsize : 8(A6)  size 4
        ;   local m : -4(A6)  size 4
        ;   local rm : -8(A6)  size 4
LBL_17:
        LINK A6,#-8
        MOVE.L #56,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; MapNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        ; TODO SAssign <dst kind 3>: unsupported this task
        ; TODO SAssign <dst kind 3>: unsupported this task
        ; TODO SAssign <dst kind 3>: unsupported this task
        ; TODO SAssign <dst kind 3>: unsupported this task
        ; TODO SAssign <dst kind 3>: unsupported this task
        ; TODO SAssign <dst kind 3>: unsupported this task
        ; TODO SAssign <dst kind 3>: unsupported this task
        MOVE.L -4(A6),D0
        BRA.W LBL_89
LBL_89:
        UNLK A6
        RTS
        ; func rtMapRetain  (JT slot 19)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_18:
        LINK A6,#-4
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_91
        BRA.W LBL_90
LBL_91:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        ; TODO SAssign <dst kind 3>: unsupported this task
LBL_90:
        UNLK A6
        RTS
        ; func rtMapRelease  (JT slot 20)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_19:
        LINK A6,#-4
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_93
        BRA.W LBL_92
LBL_93:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_94
        MOVE.L 8(A6),D0
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
LBL_94:
        ; TODO SAssign <dst kind 3>: unsupported this task
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_95
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; MapDisposeHandle
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; MapDisposeHandle
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; MapDisposePtr
LBL_95:
LBL_92:
        UNLK A6
        RTS
        ; func rtMapLastref  (JT slot 21)
        ;   param m : 8(A6)  size 4
LBL_20:
        LINK A6,#0
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_97
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_98
LBL_97:
        MOVE.L #0,D0
LBL_98:
        BRA.W LBL_96
LBL_96:
        UNLK A6
        RTS
        ; func rtMapCount  (JT slot 22)
        ;   param m : 8(A6)  size 4
LBL_21:
        LINK A6,#0
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        BRA.W LBL_99
LBL_99:
        UNLK A6
        RTS
        ; func rtMapValAt  (JT slot 23)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_22:
        LINK A6,#0
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_101
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_102
LBL_101:
        MOVE.L #1,D0
LBL_102:
        TST.L D0
        BEQ.W LBL_103
        LEA LBL_37(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_104:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_104
        JSR LBL_2(PC)
        ADDA.W #256,A7
LBL_103:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_16(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; MapBlockMoveData
LBL_100:
        UNLK A6
        RTS
        ; func handler_App_launch  (JT slot 24)
LBL_23:
        LINK A6,#0
LBL_105:
        UNLK A6
        RTS
LBL_61:
        ; cg_mul32: D1=left * D0=right -> D0 (32x32->32, MULU partial products)
        MOVE.L D2,-(A7)
        MOVE.L D3,-(A7)
        MOVE.L D4,-(A7)
        MOVE.L D1,D2
        MOVE.L D0,D3
        MULU.W D3,D2
        MOVE.L D1,D4
        SWAP D4
        MULU.W D3,D4
        SWAP D4
        CLR.W D4
        ADD.L D4,D2
        MOVE.L D3,D4
        SWAP D4
        MULU.W D1,D4
        SWAP D4
        CLR.W D4
        ADD.L D4,D2
        MOVE.L D2,D0
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
        ; constant pool: string literals
LBL_24:
        DC.B $18
        DC.B $61,$72,$72,$61,$79,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_25:
        DC.B $19
        DC.B $6E,$6F,$20,$65,$6E,$75,$6D,$20,$6D,$65,$6D,$62,$65,$72,$20,$77,$69,$74,$68,$20,$76,$61,$6C,$75,$65
LBL_26:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_27:
        DC.B $10
        DC.B $73,$74,$72,$69,$6E,$67,$20,$74,$72,$75,$6E,$63,$61,$74,$65,$64
        DC.B $00
LBL_28:
        DC.B $19
        DC.B $73,$74,$72,$69,$6E,$67,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_29:
        DC.B $12
        DC.B $73,$6C,$69,$63,$65,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_30:
        DC.B $0D
        DC.B $6F,$75,$74,$20,$6F,$66,$20,$6D,$65,$6D,$6F,$72,$79
LBL_31:
        DC.B $17
        DC.B $74,$65,$78,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_32:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_33:
        DC.B $11
        DC.B $70,$6F,$70,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_34:
        DC.B $13
        DC.B $73,$68,$69,$66,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_35:
        DC.B $13
        DC.B $66,$69,$72,$73,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_36:
        DC.B $12
        DC.B $6C,$61,$73,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
        DC.B $00
LBL_37:
        DC.B $11
        DC.B $6D,$61,$70,$20,$6B,$65,$79,$20,$6E,$6F,$74,$20,$66,$6F,$75,$6E,$64
LBL_38:
        DC.B $06
        DC.B $63,$6C,$61,$72,$75,$73
        DC.B $00
        ; constant pool: enum value/label tables (stub -- Task 8+)
        ; constant pool: serdesc tables (stub -- Task 8+)
