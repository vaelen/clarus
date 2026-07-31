LBL_45:
        ; startup (JT slot 0)
        ; globals (below A5, 260 bytes total):
        ;   lasterrCode : -4(A5)  size 4  type int
        ;   lasterrMsg : -260(A5)  size 256  type str
        LEA -260(A5),A0
        MOVE.W #129,D0
LBL_48:
        CLR.W (A0)+
        DBRA D0,LBL_48
        DC.W $A063  ; _MaxApplZone
        DC.W $A036  ; _MoreMasters
        JSR LBL_46(PC)
        ; entry-handler dispatch stub -- no event/arg marshaling yet (Task 11)
        JSR LBL_27(PC)
        JSR LBL_47(PC)
        CLR.L -(A7)
        ; natQuit not present -- wired in Task 11
        RTS
LBL_46:
        ; cg_init_globals: TODO evaluate irGlobal init exprs (Task 8) -- below-A5 zeroing already done by startup
        RTS
LBL_47:
        ; cg_free_globals: TODO release ARC-owned globals (Task 8/9)
        RTS
        ; func nat_CorePanic  (JT slot 1)
        ;   param msg : 8(A6)  size 256
LBL_0:
        LINK A6,#0
LBL_49:
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
LBL_50:
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
LBL_52:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_52
        JSR LBL_0(PC)
        ADDA.W #256,A7
LBL_51:
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
        BEQ.W LBL_54
        LEA LBL_29(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_55:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_55
        JSR LBL_2(PC)
        ADDA.W #256,A7
LBL_54:
        MOVE.L 266(A6),D0
        BRA.W LBL_53
LBL_53:
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
        BEQ.W LBL_57
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_58
LBL_57:
        MOVE.L 12(A6),D0
        MOVE.L D0,-8(A6)
LBL_58:
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
        BEQ.W LBL_59
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_31(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_60:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_60
        JSR LBL_1(PC)
        ADDA.W #260,A7
LBL_59:
LBL_56:
        UNLK A6
        RTS
        ; func rtStrConcat  (JT slot 6)
        ;   param out : 16(A6)  size 4
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
        ;   local la : -4(A6)  size 4
        ;   local lb : -8(A6)  size 4
        ;   local total : -12(A6)  size 4
        ;   local n : -16(A6)  size 4
        ;   local fromA : -20(A6)  size 4
        ;   local fromB : -24(A6)  size 4
LBL_5:
        LINK A6,#-24
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #255,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_62
        MOVE.L #255,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_63
LBL_62:
        MOVE.L -12(A6),D0
        MOVE.L D0,-16(A6)
LBL_63:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_64
        MOVE.L -4(A6),D0
        MOVE.L D0,-20(A6)
        BRA.W LBL_65
LBL_64:
        MOVE.L -16(A6),D0
        MOVE.L D0,-20(A6)
LBL_65:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -20(A6),D0
        MOVE.L (A7)+,D1
        SUB.L D0,D1
        MOVE.L D1,D0
        MOVE.L D0,-24(A6)
        MOVE.L 12(A6),D0
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
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; StrBlockMoveData
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
        MOVE.L -20(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        MOVEA.L (A7)+,A1
        MOVEA.L (A7)+,A0
        DC.W $A22E  ; StrBlockMoveData
        MOVE.L 16(A6),D0
        MOVEA.L D0,A0
        MOVE.L -16(A6),D0
        MOVE.B D0,(A0)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_66
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_31(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_67:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_67
        JSR LBL_1(PC)
        ADDA.W #260,A7
LBL_66:
LBL_61:
        UNLK A6
        RTS
        ; func rtStrCmp  (JT slot 7)
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
        ;   local la : -4(A6)  size 4
        ;   local lb : -8(A6)  size 4
        ;   local n : -12(A6)  size 4
        ;   local i : -16(A6)  size 4
        ;   local ca : -20(A6)  size 4
        ;   local cb : -24(A6)  size 4
LBL_6:
        LINK A6,#-24
        MOVE.L 12(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-4(A6)
        MOVE.L 8(A6),D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_69
        MOVE.L -4(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_70
LBL_69:
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
LBL_70:
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
LBL_71:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_72
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-20(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-(A7)
        MOVE.L -16(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVEA.L D0,A0
        CLR.L D0
        MOVE.B (A0),D0
        MOVE.L D0,-24(A6)
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_73
        MOVE.L #1,D0
        NEG.L D0
        BRA.W LBL_68
LBL_73:
        MOVE.L -20(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -24(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_74
        MOVE.L #1,D0
        BRA.W LBL_68
LBL_74:
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-16(A6)
        BRA.W LBL_71
LBL_72:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_75
        MOVE.L #1,D0
        NEG.L D0
        BRA.W LBL_68
LBL_75:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_76
        MOVE.L #1,D0
        BRA.W LBL_68
LBL_76:
        MOVE.L #0,D0
        BRA.W LBL_68
LBL_68:
        UNLK A6
        RTS
        ; func rtTextGrow  (JT slot 8)
        ;   param t : 12(A6)  size 4
        ;   param need : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local cap : -8(A6)  size 4
        ;   local newcap : -12(A6)  size 4
        ;   local err : -16(A6)  size 4
LBL_7:
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
        BEQ.W LBL_78
        BRA.W LBL_77
LBL_78:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_79
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_80
LBL_79:
        MOVE.L #4,D0
        MOVE.L D0,-12(A6)
LBL_80:
LBL_81:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_82
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        JSR LBL_83(PC)
        MOVE.L D0,-12(A6)
        BRA.W LBL_81
LBL_82:
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
        BEQ.W LBL_84
        LEA LBL_34(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_85:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_85
        JSR LBL_2(PC)
        ADDA.W #256,A7
LBL_84:
        ; TODO SAssign <dst kind 3>: unsupported this task
LBL_77:
        UNLK A6
        RTS
        ; func rtTextNew  (JT slot 9)
        ;   local t : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
LBL_8:
        LINK A6,#-8
        MOVE.L #32,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; TextNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_87
        LEA LBL_34(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_88:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_88
        JSR LBL_2(PC)
        ADDA.W #256,A7
LBL_87:
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        ; TODO SAssign <dst kind 3>: unsupported this task
        ; TODO SAssign <dst kind 3>: unsupported this task
        ; TODO SAssign <dst kind 3>: unsupported this task
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
        BEQ.W LBL_89
        LEA LBL_34(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_90:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_90
        JSR LBL_2(PC)
        ADDA.W #256,A7
LBL_89:
        MOVE.L -4(A6),D0
        BRA.W LBL_86
LBL_86:
        UNLK A6
        RTS
        ; func rtTextRetain  (JT slot 10)
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
LBL_9:
        LINK A6,#-4
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_92
        BRA.W LBL_91
LBL_92:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        ; TODO SAssign <dst kind 3>: unsupported this task
LBL_91:
        UNLK A6
        RTS
        ; func rtTextRelease  (JT slot 11)
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
LBL_10:
        LINK A6,#-4
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_94
        BRA.W LBL_93
LBL_94:
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
        BEQ.W LBL_95
        MOVE.L 8(A6),D0
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
LBL_95:
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
        BEQ.W LBL_96
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; TextDisposeHandle
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; TextDisposePtr
LBL_96:
LBL_93:
        UNLK A6
        RTS
        ; func rtTextStore  (JT slot 12)
        ;   param t : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
LBL_11:
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
        JSR LBL_7(PC)
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
LBL_97:
        UNLK A6
        RTS
        ; func rtListNew  (JT slot 13)
        ;   param elemsize : 8(A6)  size 4
        ;   local l : -4(A6)  size 4
        ;   local rl : -8(A6)  size 4
LBL_12:
        LINK A6,#-8
        MOVE.L #40,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; ListNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_99
        LEA LBL_34(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_100:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_100
        JSR LBL_2(PC)
        ADDA.W #256,A7
LBL_99:
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        ; TODO SAssign <dst kind 3>: unsupported this task
        ; TODO SAssign <dst kind 3>: unsupported this task
        ; TODO SAssign <dst kind 3>: unsupported this task
        ; TODO SAssign <dst kind 3>: unsupported this task
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
        BEQ.W LBL_101
        LEA LBL_34(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_102:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_102
        JSR LBL_2(PC)
        ADDA.W #256,A7
LBL_101:
        MOVE.L -4(A6),D0
        BRA.W LBL_98
LBL_98:
        UNLK A6
        RTS
        ; func rtListRetain  (JT slot 14)
        ;   param l : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
LBL_13:
        LINK A6,#-4
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_104
        BRA.W LBL_103
LBL_104:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        ; TODO SAssign <dst kind 3>: unsupported this task
LBL_103:
        UNLK A6
        RTS
        ; func rtListRelease  (JT slot 15)
        ;   param l : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
LBL_14:
        LINK A6,#-4
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_106
        BRA.W LBL_105
LBL_106:
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
        BEQ.W LBL_107
        MOVE.L 8(A6),D0
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
LBL_107:
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
        BEQ.W LBL_108
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A023  ; ListDisposeHandle
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVEA.L (A7)+,A0
        DC.W $A01F  ; ListDisposePtr
LBL_108:
LBL_105:
        UNLK A6
        RTS
        ; func rtListLastref  (JT slot 16)
        ;   param l : 8(A6)  size 4
LBL_15:
        LINK A6,#0
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_110
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_111
LBL_110:
        MOVE.L #0,D0
LBL_111:
        BRA.W LBL_109
LBL_109:
        UNLK A6
        RTS
        ; func rtListAt  (JT slot 17)
        ;   param l : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
LBL_16:
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
        BNE.W LBL_113
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_114
LBL_113:
        MOVE.L #1,D0
LBL_114:
        TST.L D0
        BEQ.W LBL_115
        LEA LBL_36(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_116:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_116
        JSR LBL_2(PC)
        ADDA.W #256,A7
LBL_115:
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
        JSR LBL_83(PC)
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_112
LBL_112:
        UNLK A6
        RTS
        ; func rtListCount  (JT slot 18)
        ;   param l : 8(A6)  size 4
LBL_17:
        LINK A6,#0
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        BRA.W LBL_117
LBL_117:
        UNLK A6
        RTS
        ; func mapValSlot  (JT slot 19)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_18:
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
        JSR LBL_83(PC)
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_118
LBL_118:
        UNLK A6
        RTS
        ; func rtMapNew  (JT slot 20)
        ;   param valsize : 8(A6)  size 4
        ;   local m : -4(A6)  size 4
        ;   local rm : -8(A6)  size 4
LBL_19:
        LINK A6,#-8
        MOVE.L #56,D0
        MOVE.L D0,-(A7)
        MOVE.L (A7)+,D0
        DC.W $A11E  ; MapNewPtr
        MOVE.L A0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_120
        LEA LBL_34(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_121:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_121
        JSR LBL_2(PC)
        ADDA.W #256,A7
LBL_120:
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        ; TODO SAssign <dst kind 3>: unsupported this task
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
        BEQ.W LBL_122
        LEA LBL_34(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_123:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_123
        JSR LBL_2(PC)
        ADDA.W #256,A7
LBL_122:
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
        BEQ.W LBL_124
        LEA LBL_34(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_125:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_125
        JSR LBL_2(PC)
        ADDA.W #256,A7
LBL_124:
        ; TODO SAssign <dst kind 3>: unsupported this task
        ; TODO SAssign <dst kind 3>: unsupported this task
        ; TODO SAssign <dst kind 3>: unsupported this task
        ; TODO SAssign <dst kind 3>: unsupported this task
        MOVE.L -4(A6),D0
        BRA.W LBL_119
LBL_119:
        UNLK A6
        RTS
        ; func rtMapRetain  (JT slot 21)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_20:
        LINK A6,#-4
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_127
        BRA.W LBL_126
LBL_127:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        ; TODO SAssign <dst kind 3>: unsupported this task
LBL_126:
        UNLK A6
        RTS
        ; func rtMapRelease  (JT slot 22)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_21:
        LINK A6,#-4
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_129
        BRA.W LBL_128
LBL_129:
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
        BEQ.W LBL_130
        MOVE.L 8(A6),D0
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
LBL_130:
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
        BEQ.W LBL_131
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
LBL_131:
LBL_128:
        UNLK A6
        RTS
        ; func rtMapLastref  (JT slot 23)
        ;   param m : 8(A6)  size 4
LBL_22:
        LINK A6,#0
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_133
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_134
LBL_133:
        MOVE.L #0,D0
LBL_134:
        BRA.W LBL_132
LBL_132:
        UNLK A6
        RTS
        ; func rtMapCount  (JT slot 24)
        ;   param m : 8(A6)  size 4
LBL_23:
        LINK A6,#0
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        BRA.W LBL_135
LBL_135:
        UNLK A6
        RTS
        ; func rtMapValAt  (JT slot 25)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_24:
        LINK A6,#0
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_137
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_138
LBL_137:
        MOVE.L #1,D0
LBL_138:
        TST.L D0
        BEQ.W LBL_139
        LEA LBL_41(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_140:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_140
        JSR LBL_2(PC)
        ADDA.W #256,A7
LBL_139:
        MOVE.L 16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_18(PC)
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
LBL_136:
        UNLK A6
        RTS
        ; func makeGreeting  (JT slot 26)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param a : 268(A6)  size 256
        ;   param b : 12(A6)  size 256
        ;   local full : -256(A6)  size 256
LBL_25:
        LINK A6,#-256
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA 268(A6),A0
        MOVE.L A0,-(A7)
        LEA 12(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_5(PC)
        ADDA.W #12,A7
        MOVEA.L A7,A1
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR LBL_4(PC)
        ADDA.W #12,A7
        ADDA.L #256,A7
        MOVE.L 8(A6),-(A7)
        MOVE.L #255,-(A7)
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_4(PC)
        ADDA.W #12,A7
        BRA.W LBL_141
LBL_141:
        UNLK A6
        RTS
        ; func concatDirect  (JT slot 27)
        ;   hidden result ptr : 8(A6)  size 4
        ;   param a : 268(A6)  size 256
        ;   param b : 12(A6)  size 256
LBL_26:
        LINK A6,#0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA 268(A6),A0
        MOVE.L A0,-(A7)
        LEA 12(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_5(PC)
        ADDA.W #12,A7
        MOVEA.L A7,A1
        MOVE.L 8(A6),-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR LBL_4(PC)
        ADDA.W #12,A7
        ADDA.L #256,A7
        BRA.W LBL_142
LBL_142:
        UNLK A6
        RTS
        ; func handler_App_launch  (JT slot 28)
        ;   local s1 : -256(A6)  size 256
        ;   local s2 : -512(A6)  size 256
        ;   local combined : -768(A6)  size 256
        ;   local isEqual : -770(A6)  size 2
LBL_27:
        LINK A6,#-770
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_42(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_4(PC)
        ADDA.W #12,A7
        LEA -512(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_43(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_4(PC)
        ADDA.W #12,A7
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        LEA -512(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_5(PC)
        ADDA.W #12,A7
        MOVEA.L A7,A1
        LEA -768(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR LBL_4(PC)
        ADDA.W #12,A7
        ADDA.L #256,A7
        LEA -256(A6),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_144:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_144
        LEA -512(A6),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_145:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_145
        LEA -768(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_25(PC)
        ADDA.W #516,A7
        LEA -256(A6),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_146:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_146
        LEA -512(A6),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_147:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_147
        LEA -768(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_26(PC)
        ADDA.W #516,A7
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        LEA -512(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_6(PC)
        ADDQ.L #8,A7
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-770(A6)
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_42(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_4(PC)
        ADDA.W #12,A7
        LEA -512(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_44(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_4(PC)
        ADDA.W #12,A7
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA -512(A6),A0
        MOVE.L A0,-(A7)
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_5(PC)
        ADDA.W #12,A7
        MOVEA.L A7,A1
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR LBL_4(PC)
        ADDA.W #12,A7
        ADDA.L #256,A7
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_42(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_4(PC)
        ADDA.W #12,A7
        LEA -512(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA LBL_44(PC),A0
        MOVE.L A0,-(A7)
        JSR LBL_4(PC)
        ADDA.W #12,A7
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.L A1,-(A7)
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        LEA -512(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_5(PC)
        ADDA.W #12,A7
        MOVEA.L A7,A1
        LEA -256(A6),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,-(A7)
        MOVE.L A1,-(A7)
        JSR LBL_4(PC)
        ADDA.W #12,A7
        ADDA.L #256,A7
        BRA.W LBL_143
LBL_143:
        UNLK A6
        RTS
LBL_83:
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
LBL_28:
        DC.B $18
        DC.B $61,$72,$72,$61,$79,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_29:
        DC.B $19
        DC.B $6E,$6F,$20,$65,$6E,$75,$6D,$20,$6D,$65,$6D,$62,$65,$72,$20,$77,$69,$74,$68,$20,$76,$61,$6C,$75,$65
LBL_30:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_31:
        DC.B $10
        DC.B $73,$74,$72,$69,$6E,$67,$20,$74,$72,$75,$6E,$63,$61,$74,$65,$64
        DC.B $00
LBL_32:
        DC.B $19
        DC.B $73,$74,$72,$69,$6E,$67,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_33:
        DC.B $12
        DC.B $73,$6C,$69,$63,$65,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_34:
        DC.B $0D
        DC.B $6F,$75,$74,$20,$6F,$66,$20,$6D,$65,$6D,$6F,$72,$79
LBL_35:
        DC.B $17
        DC.B $74,$65,$78,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_36:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_37:
        DC.B $11
        DC.B $70,$6F,$70,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_38:
        DC.B $13
        DC.B $73,$68,$69,$66,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_39:
        DC.B $13
        DC.B $66,$69,$72,$73,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_40:
        DC.B $12
        DC.B $6C,$61,$73,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
        DC.B $00
LBL_41:
        DC.B $11
        DC.B $6D,$61,$70,$20,$6B,$65,$79,$20,$6E,$6F,$74,$20,$66,$6F,$75,$6E,$64
LBL_42:
        DC.B $05
        DC.B $68,$65,$6C,$6C,$6F
LBL_43:
        DC.B $06
        DC.B $20,$77,$6F,$72,$6C,$64
        DC.B $00
LBL_44:
        DC.B $05
        DC.B $77,$6F,$72,$6C,$64
        ; constant pool: enum value/label tables (stub -- Task 8+)
        ; constant pool: serdesc tables (stub -- Task 8+)
