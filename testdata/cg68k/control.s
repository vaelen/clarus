LBL_42:
        ; startup (JT slot 0)
        ; globals (below A5, 260 bytes total):
        ;   lasterrCode : -4(A5)  size 4  type int
        ;   lasterrMsg : -260(A5)  size 256  type str
        LEA -260(A5),A0
        MOVE.W #129,D0
LBL_45:
        CLR.W (A0)+
        DBRA D0,LBL_45
        DC.W $A063  ; _MaxApplZone
        DC.W $A036  ; _MoreMasters
        JSR LBL_43(PC)
        ; entry-handler dispatch stub -- no event/arg marshaling yet (Task 11)
        JSR LBL_27(PC)
        JSR LBL_44(PC)
        CLR.L -(A7)
        ; natQuit not present -- wired in Task 11
        RTS
LBL_43:
        ; cg_init_globals: TODO evaluate irGlobal init exprs (Task 8) -- below-A5 zeroing already done by startup
        RTS
LBL_44:
        ; cg_free_globals: TODO release ARC-owned globals (Task 8/9)
        RTS
        ; func rtSetLastErr  (JT slot 1)
        ;   param code : 264(A6)  size 4
        ;   param msg : 8(A6)  size 256
LBL_0:
        LINK A6,#0
        MOVE.L 264(A6),D0
        MOVE.L D0,-4(A5)
        LEA -260(A5),A0
        MOVE.L A0,-(A7)
        MOVE.L #255,D0
        MOVE.L D0,-(A7)
        LEA 8(A6),A0
        MOVE.L A0,-(A7)
        JSR LBL_3(PC)
        ADDA.W #12,A7
LBL_46:
        UNLK A6
        RTS
        ; func rtPanic  (JT slot 2)
        ;   param msg : 8(A6)  size 256
LBL_1:
        LINK A6,#0
        ; TODO cgExpr <kind 9>: unsupported this task
        MOVE.L #0,D0
LBL_47:
        UNLK A6
        RTS
        ; func rtEnumCheck  (JT slot 3)
        ;   param v : 266(A6)  size 4
        ;   param found : 264(A6)  size 2
        ;   param name : 8(A6)  size 256
LBL_2:
        LINK A6,#0
        CLR.L D0
        MOVE.B 264(A6),D0
        EORI.L #1,D0
        TST.L D0
        BEQ.W LBL_49
        LEA LBL_29(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_50:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_50
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_49:
        MOVE.L 266(A6),D0
        BRA.W LBL_48
LBL_48:
        UNLK A6
        RTS
        ; func rtStrStore  (JT slot 4)
        ;   param dst : 16(A6)  size 4
        ;   param dstcap : 12(A6)  size 4
        ;   param src : 8(A6)  size 4
        ;   local srclen : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
LBL_3:
        LINK A6,#-8
        ; TODO intr peekb: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_52
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_53
LBL_52:
        MOVE.L 12(A6),D0
        MOVE.L D0,-8(A6)
LBL_53:
        ; TODO cgExpr <kind 9>: unsupported this task
        MOVE.L #0,D0
        ; TODO intr pokeb: unsupported this task
        MOVE.L #0,D0
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_54
        MOVE.L #1,D0
        MOVE.L D0,-(A7)
        LEA LBL_31(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_55:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_55
        JSR LBL_0(PC)
        ADDA.W #260,A7
LBL_54:
LBL_51:
        UNLK A6
        RTS
        ; func rtTextGrow  (JT slot 5)
        ;   param t : 12(A6)  size 4
        ;   param need : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local cap : -8(A6)  size 4
        ;   local newcap : -12(A6)  size 4
        ;   local err : -16(A6)  size 4
LBL_4:
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
        BEQ.W LBL_57
        BRA.W LBL_56
LBL_57:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_58
        MOVE.L -8(A6),D0
        MOVE.L D0,-12(A6)
        BRA.W LBL_59
LBL_58:
        MOVE.L #4,D0
        MOVE.L D0,-12(A6)
LBL_59:
LBL_60:
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_61
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        JSR LBL_62(PC)
        MOVE.L D0,-12(A6)
        BRA.W LBL_60
LBL_61:
        ; TODO cgExpr <kind 9>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-16(A6)
        MOVE.L -16(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_63
        LEA LBL_34(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_64:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_64
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_63:
        ; TODO SAssign <dst kind 3>: unsupported this task
LBL_56:
        UNLK A6
        RTS
        ; func rtTextNew  (JT slot 6)
        ;   local t : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
LBL_5:
        LINK A6,#-8
        ; TODO cgExpr <kind 9>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        ; TODO SAssign <dst kind 3>: unsupported this task
        ; TODO SAssign <dst kind 3>: unsupported this task
        ; TODO SAssign <dst kind 3>: unsupported this task
        ; TODO SAssign <dst kind 3>: unsupported this task
        MOVE.L -4(A6),D0
        BRA.W LBL_65
LBL_65:
        UNLK A6
        RTS
        ; func rtTextRetain  (JT slot 7)
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
LBL_6:
        LINK A6,#-4
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_67
        BRA.W LBL_66
LBL_67:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        ; TODO SAssign <dst kind 3>: unsupported this task
LBL_66:
        UNLK A6
        RTS
        ; func rtTextRelease  (JT slot 8)
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
        BEQ.W LBL_69
        BRA.W LBL_68
LBL_69:
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
        BEQ.W LBL_70
        ; TODO cgExpr <kind 9>: unsupported this task
        MOVE.L #0,D0
LBL_70:
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
        BEQ.W LBL_71
        ; TODO cgExpr <kind 9>: unsupported this task
        MOVE.L #0,D0
        ; TODO cgExpr <kind 9>: unsupported this task
        MOVE.L #0,D0
LBL_71:
LBL_68:
        UNLK A6
        RTS
        ; func rtTextStore  (JT slot 9)
        ;   param t : 12(A6)  size 4
        ;   param s : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
        ;   local n : -8(A6)  size 4
        ;   local mp : -12(A6)  size 4
LBL_8:
        LINK A6,#-12
        ; TODO intr peekb: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        JSR LBL_4(PC)
        ADDQ.L #8,A7
        MOVE.L 12(A6),D0
        MOVE.L D0,-4(A6)
        ; TODO cgExpr <kind 9>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        ; TODO cgExpr <kind 9>: unsupported this task
        MOVE.L #0,D0
        ; TODO SAssign <dst kind 3>: unsupported this task
LBL_72:
        UNLK A6
        RTS
        ; func rtListNew  (JT slot 10)
        ;   param elemsize : 8(A6)  size 4
        ;   local l : -4(A6)  size 4
        ;   local rl : -8(A6)  size 4
LBL_9:
        LINK A6,#-8
        ; TODO cgExpr <kind 9>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-8(A6)
        ; TODO SAssign <dst kind 3>: unsupported this task
        ; TODO SAssign <dst kind 3>: unsupported this task
        ; TODO SAssign <dst kind 3>: unsupported this task
        ; TODO SAssign <dst kind 3>: unsupported this task
        ; TODO SAssign <dst kind 3>: unsupported this task
        MOVE.L -4(A6),D0
        BRA.W LBL_73
LBL_73:
        UNLK A6
        RTS
        ; func rtListRetain  (JT slot 11)
        ;   param l : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
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
        BEQ.W LBL_75
        BRA.W LBL_74
LBL_75:
        MOVE.L 8(A6),D0
        MOVE.L D0,-4(A6)
        ; TODO SAssign <dst kind 3>: unsupported this task
LBL_74:
        UNLK A6
        RTS
        ; func rtListRelease  (JT slot 12)
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
        BEQ.W LBL_77
        BRA.W LBL_76
LBL_77:
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
        BEQ.W LBL_78
        ; TODO cgExpr <kind 9>: unsupported this task
        MOVE.L #0,D0
LBL_78:
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
        BEQ.W LBL_79
        ; TODO cgExpr <kind 9>: unsupported this task
        MOVE.L #0,D0
        ; TODO cgExpr <kind 9>: unsupported this task
        MOVE.L #0,D0
LBL_79:
LBL_76:
        UNLK A6
        RTS
        ; func rtListLastref  (JT slot 13)
        ;   param l : 8(A6)  size 4
LBL_12:
        LINK A6,#0
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_81
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_82
LBL_81:
        MOVE.L #0,D0
LBL_82:
        BRA.W LBL_80
LBL_80:
        UNLK A6
        RTS
        ; func rtListAt  (JT slot 14)
        ;   param l : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
        ;   local mp : -8(A6)  size 4
        ;   local off : -12(A6)  size 4
LBL_13:
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
        BNE.W LBL_84
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_85
LBL_84:
        MOVE.L #1,D0
LBL_85:
        TST.L D0
        BEQ.W LBL_86
        LEA LBL_36(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_87:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_87
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_86:
        ; TODO cgExpr <kind 9>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        JSR LBL_62(PC)
        MOVE.L D0,-12(A6)
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -12(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_83
LBL_83:
        UNLK A6
        RTS
        ; func rtListCount  (JT slot 15)
        ;   param l : 8(A6)  size 4
LBL_14:
        LINK A6,#0
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        BRA.W LBL_88
LBL_88:
        UNLK A6
        RTS
        ; func mapValSlot  (JT slot 16)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_15:
        LINK A6,#0
        ; TODO cgExpr <kind 9>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        JSR LBL_62(PC)
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        BRA.W LBL_89
LBL_89:
        UNLK A6
        RTS
        ; func rtMapNew  (JT slot 17)
        ;   param valsize : 8(A6)  size 4
        ;   local m : -4(A6)  size 4
        ;   local rm : -8(A6)  size 4
LBL_16:
        LINK A6,#-8
        ; TODO cgExpr <kind 9>: unsupported this task
        MOVE.L #0,D0
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
        BRA.W LBL_90
LBL_90:
        UNLK A6
        RTS
        ; func rtMapRetain  (JT slot 18)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_17:
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
        ; func rtMapRelease  (JT slot 19)
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
        ; TODO cgExpr <kind 9>: unsupported this task
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
        ; TODO cgExpr <kind 9>: unsupported this task
        MOVE.L #0,D0
        ; TODO cgExpr <kind 9>: unsupported this task
        MOVE.L #0,D0
        ; TODO cgExpr <kind 9>: unsupported this task
        MOVE.L #0,D0
LBL_96:
LBL_93:
        UNLK A6
        RTS
        ; func rtMapLastref  (JT slot 20)
        ;   param m : 8(A6)  size 4
LBL_19:
        LINK A6,#0
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_98
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        BRA.W LBL_99
LBL_98:
        MOVE.L #0,D0
LBL_99:
        BRA.W LBL_97
LBL_97:
        UNLK A6
        RTS
        ; func rtMapCount  (JT slot 21)
        ;   param m : 8(A6)  size 4
LBL_20:
        LINK A6,#0
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        BRA.W LBL_100
LBL_100:
        UNLK A6
        RTS
        ; func rtMapValAt  (JT slot 22)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_21:
        LINK A6,#0
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_102
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        ; TODO cgExpr <kind 3>: unsupported this task
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGE D0
        ANDI.L #1,D0
        BRA.W LBL_103
LBL_102:
        MOVE.L #1,D0
LBL_103:
        TST.L D0
        BEQ.W LBL_104
        LEA LBL_41(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_105:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_105
        JSR LBL_1(PC)
        ADDA.W #256,A7
LBL_104:
        ; TODO cgExpr <kind 9>: unsupported this task
        MOVE.L #0,D0
LBL_101:
        UNLK A6
        RTS
        ; func guardedRatio  (JT slot 23)
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
        ;   local ok : -2(A6)  size 2
LBL_22:
        LINK A6,#-2
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_107
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 12(A6),D0
        MOVE.L (A7)+,D1
        JSR LBL_109(PC)
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_108
LBL_107:
        MOVE.L #0,D0
LBL_108:
        MOVE.B D0,-2(A6)
        CLR.L D0
        MOVE.B -2(A6),D0
        BRA.W LBL_106
LBL_106:
        UNLK A6
        RTS
        ; func eitherPositive  (JT slot 24)
        ;   param a : 12(A6)  size 4
        ;   param b : 8(A6)  size 4
        ;   local ok : -2(A6)  size 2
LBL_23:
        LINK A6,#-2
        MOVE.L 12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BNE.W LBL_111
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        BRA.W LBL_112
LBL_111:
        MOVE.L #1,D0
LBL_112:
        MOVE.B D0,-2(A6)
        CLR.L D0
        MOVE.B -2(A6),D0
        BRA.W LBL_110
LBL_110:
        UNLK A6
        RTS
        ; func classify  (JT slot 25)
        ;   param n : 8(A6)  size 4
        ;   local result : -4(A6)  size 4
LBL_24:
        LINK A6,#-4
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_114
        MOVE.L #1,D0
        NEG.L D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_115
LBL_114:
        MOVE.L 8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_116
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_117
LBL_116:
        MOVE.L #1,D0
        MOVE.L D0,-4(A6)
LBL_117:
LBL_115:
        MOVE.L -4(A6),D0
        BRA.W LBL_113
LBL_113:
        UNLK A6
        RTS
        ; func sumEvens  (JT slot 26)
        ;   param limit : 8(A6)  size 4
        ;   local i : -4(A6)  size 4
        ;   local total : -8(A6)  size 4
LBL_25:
        LINK A6,#-8
        MOVE.L #0,D0
        MOVE.L D0,-8(A6)
        MOVE.L #0,D0
        MOVE.L D0,-4(A6)
LBL_119:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L 8(A6),D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SLE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_120
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L (A7)+,D1
        JSR LBL_121(PC)
        MOVE.L D0,-(A7)
        MOVE.L #0,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SNE D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_122
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_119
LBL_122:
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #100,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SGT D0
        ANDI.L #1,D0
        TST.L D0
        BEQ.W LBL_123
        BRA.W LBL_120
LBL_123:
        MOVE.L -8(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-8(A6)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L #1,D0
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_119
LBL_120:
        MOVE.L -8(A6),D0
        BRA.W LBL_118
LBL_118:
        UNLK A6
        RTS
        ; func nestedRange  (JT slot 27)
        ;   local i : -4(A6)  size 4
        ;   local j : -8(A6)  size 4
        ;   local total : -12(A6)  size 4
LBL_26:
        LINK A6,#-12
        MOVE.L #0,D0
        MOVE.L D0,-12(A6)
        MOVE.L #1,D0
        MOVE.L D0,-4(A6)
        MOVE.L #3,D0
        MOVE.L D0,-(A7)
LBL_125:
        MOVE.L -4(A6),D0
        MOVE.L (A7),D1
        CMP.L D1,D0
        BGT.W LBL_127
        MOVE.L #1,D0
        MOVE.L D0,-8(A6)
        MOVE.L #2,D0
        MOVE.L D0,-(A7)
LBL_128:
        MOVE.L -8(A6),D0
        MOVE.L (A7),D1
        CMP.L D1,D0
        BGT.W LBL_130
        MOVE.L -12(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        MOVE.L -8(A6),D0
        MOVE.L (A7)+,D1
        JSR LBL_62(PC)
        MOVE.L (A7)+,D1
        ADD.L D1,D0
        MOVE.L D0,-12(A6)
LBL_129:
        MOVE.L -8(A6),D0
        ADDQ.L #1,D0
        MOVE.L D0,-8(A6)
        BRA.W LBL_128
LBL_130:
        ADDQ.L #4,A7
LBL_126:
        MOVE.L -4(A6),D0
        ADDQ.L #1,D0
        MOVE.L D0,-4(A6)
        BRA.W LBL_125
LBL_127:
        ADDQ.L #4,A7
        MOVE.L -12(A6),D0
        BRA.W LBL_124
LBL_124:
        UNLK A6
        RTS
        ; func handler_App_launch  (JT slot 28)
        ;   local a : -4(A6)  size 4
        ;   local b : -8(A6)  size 4
        ;   local c : -12(A6)  size 4
        ;   local g : -14(A6)  size 2
        ;   local e : -16(A6)  size 2
LBL_27:
        LINK A6,#-16
        MOVE.L #5,D0
        NEG.L D0
        MOVE.L D0,-(A7)
        JSR LBL_24(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-4(A6)
        MOVE.L #10,D0
        MOVE.L D0,-(A7)
        JSR LBL_25(PC)
        ADDQ.L #4,A7
        MOVE.L D0,-8(A6)
        JSR LBL_26(PC)
        MOVE.L D0,-12(A6)
        MOVE.L #0,D0
        MOVE.L D0,-(A7)
        MOVE.L #5,D0
        MOVE.L D0,-(A7)
        JSR LBL_22(PC)
        ADDQ.L #8,A7
        MOVE.B D0,-14(A6)
        MOVE.L #1,D0
        NEG.L D0
        MOVE.L D0,-(A7)
        MOVE.L #2,D0
        MOVE.L D0,-(A7)
        JSR LBL_23(PC)
        ADDQ.L #8,A7
        MOVE.B D0,-16(A6)
        BRA.W LBL_131
LBL_131:
        UNLK A6
        RTS
LBL_62:
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
LBL_109:
        ; cg_div32: D1=left / D0=right -> D0 (truncate toward zero, C99)
        MOVE.L D2,-(A7)
        MOVE.L D3,-(A7)
        MOVE.L D4,-(A7)
        MOVE.L D5,-(A7)
        MOVE.L D6,-(A7)
        MOVE.L D7,-(A7)
        MOVE.L D1,D2
        MOVE.L D0,D3
        CLR.L D4
        TST.L D2
        BPL.W LBL_132
        NEG.L D2
        MOVE.L #1,D4
LBL_132:
        CLR.L D5
        TST.L D3
        BPL.W LBL_133
        NEG.L D3
        MOVE.L #1,D5
LBL_133:
        CLR.L D6
        MOVE.W #31,D7
LBL_134:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_135
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_135:
        DBRA D7,LBL_134
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_136
        NEG.L D2
LBL_136:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_121:
        ; cg_mod32: D1=left mod D0=right -> D0 (sign follows dividend, C99)
        MOVE.L D2,-(A7)
        MOVE.L D3,-(A7)
        MOVE.L D4,-(A7)
        MOVE.L D5,-(A7)
        MOVE.L D6,-(A7)
        MOVE.L D7,-(A7)
        MOVE.L D1,D2
        MOVE.L D0,D3
        CLR.L D4
        TST.L D2
        BPL.W LBL_137
        NEG.L D2
        MOVE.L #1,D4
LBL_137:
        CLR.L D5
        TST.L D3
        BPL.W LBL_138
        NEG.L D3
        MOVE.L #1,D5
LBL_138:
        CLR.L D6
        MOVE.W #31,D7
LBL_139:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_140
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_140:
        DBRA D7,LBL_139
        TST.L D4
        BEQ.W LBL_141
        NEG.L D6
LBL_141:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
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
        ; constant pool: enum value/label tables (stub -- Task 8+)
        ; constant pool: serdesc tables (stub -- Task 8+)
