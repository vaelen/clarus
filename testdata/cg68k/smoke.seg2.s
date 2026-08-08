        ; func handler_App_launch  (JT slot 95)
        ;   local p : -48(A6)  size 48
        ;   local __store11 : -96(A6)  size 48
        ;   local q : -144(A6)  size 48
        ;   local e : -148(A6)  size 4
        ;   local n : -152(A6)  size 4
        ;   local __store12 : -200(A6)  size 48
        ;   local __store13 : -248(A6)  size 48
LBL_0:
        LINK A6,#-8544
        MOVEQ #3,D0
        MOVE.L D0,-48(A6)
        MOVEQ #4,D0
        MOVE.L D0,-44(A6)
        MOVEQ #5,D0
        MOVE.L D0,-40(A6)
        MOVEQ #0,D0
        MOVE.L D0,-36(A6)
        LEA -32(A6),A0
        MOVE.W #15,D0
LBL_32:
        CLR.W (A0)+
        DBRA D0,LBL_32
        MOVEQ #3,D0
        MOVE.L D0,-96(A6)
        MOVEQ #4,D0
        MOVE.L D0,-92(A6)
        MOVEQ #5,D0
        MOVE.L D0,-88(A6)
        MOVEQ #0,D0
        MOVE.L D0,-84(A6)
        LEA -80(A6),A0
        MOVE.W #15,D0
LBL_33:
        CLR.W (A0)+
        DBRA D0,LBL_33
        MOVEQ #3,D0
        MOVE.L D0,-144(A6)
        MOVEQ #4,D0
        MOVE.L D0,-140(A6)
        MOVEQ #5,D0
        MOVE.L D0,-136(A6)
        MOVEQ #0,D0
        MOVE.L D0,-132(A6)
        LEA -128(A6),A0
        MOVE.W #15,D0
LBL_34:
        CLR.W (A0)+
        DBRA D0,LBL_34
        MOVEQ #0,D0
        MOVE.L D0,-148(A6)
        MOVEQ #0,D0
        MOVE.L D0,-152(A6)
        MOVEQ #3,D0
        MOVE.L D0,-200(A6)
        MOVEQ #4,D0
        MOVE.L D0,-196(A6)
        MOVEQ #5,D0
        MOVE.L D0,-192(A6)
        MOVEQ #0,D0
        MOVE.L D0,-188(A6)
        LEA -184(A6),A0
        MOVE.W #15,D0
LBL_35:
        CLR.W (A0)+
        DBRA D0,LBL_35
        MOVEQ #3,D0
        MOVE.L D0,-248(A6)
        MOVEQ #4,D0
        MOVE.L D0,-244(A6)
        MOVEQ #5,D0
        MOVE.L D0,-240(A6)
        MOVEQ #0,D0
        MOVE.L D0,-236(A6)
        LEA -232(A6),A0
        MOVE.W #15,D0
LBL_36:
        CLR.W (A0)+
        DBRA D0,LBL_36
        LEA -96(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_26
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -96(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        MOVEQ #3,D0
        MOVE.L D0,0(A0)
        MOVEA.L A1,A0
        MOVEQ #4,D0
        MOVE.L D0,4(A0)
        MOVEA.L A1,A0
        MOVEQ #5,D0
        MOVE.L D0,8(A0)
        MOVEA.L A1,A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        MOVEQ #0,D0
        MOVE.L D0,12(A0)
        MOVEA.L A1,A0
        LEA 16(A0),A0
        MOVE.W #15,D0
LBL_37:
        CLR.W (A0)+
        DBRA D0,LBL_37
        LEA -96(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_25
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -48(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_26
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -96(A6),A0
        MOVE.L A0,-(A7)
        LEA -48(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_38:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_38
        LEA -48(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_1(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_39:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_39
        JSR 674(A5)
        ADDA.W #258,A7
        LEA -48(A6),A0
        LEA 4(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #4,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_2(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_40:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_40
        JSR 674(A5)
        ADDA.W #258,A7
        LEA -48(A6),A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_3(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_41:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_41
        JSR 674(A5)
        ADDA.W #258,A7
        LEA -48(A6),A0
        LEA 12(A0),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_4(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_42:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_42
        JSR 674(A5)
        ADDA.W #258,A7
        LEA -144(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_5(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_43:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_43
        JSR 674(A5)
        ADDA.W #258,A7
        LEA -144(A6),A0
        LEA 8(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #5,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_6(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_44:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_44
        JSR 674(A5)
        ADDA.W #258,A7
        MOVEQ #10,D0
        MOVE.L D0,-(A7)
        LEA -48(A6),A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -48(A6),A0
        LEA 12(A0),A0
        LEA 4(A0),A0
        MOVE.L A0,-(A7)
        MOVEQ #31,D0
        MOVE.L D0,-(A7)
        LEA LBL_7(PC),A0
        MOVE.L A0,-(A7)
        JSR 82(A5)
        ADDA.W #12,A7
        MOVE.L #90210,D0
        MOVE.L D0,-(A7)
        LEA -48(A6),A0
        LEA 12(A0),A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -48(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #10,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_8(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_45:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_45
        JSR 674(A5)
        ADDA.W #258,A7
        LEA -48(A6),A0
        LEA 12(A0),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #90210,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_9(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_46:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_46
        JSR 674(A5)
        ADDA.W #258,A7
        LEA -48(A6),A0
        LEA 12(A0),A0
        LEA 4(A0),A0
        MOVE.L A0,-(A7)
        LEA LBL_7(PC),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_10(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_47:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_47
        JSR 674(A5)
        ADDA.W #258,A7
        LEA -200(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_26
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -48(A6),A0
        MOVE.L A0,-(A7)
        LEA -200(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_48:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_48
        LEA -200(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_25
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -144(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_26
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -200(A6),A0
        MOVE.L A0,-(A7)
        LEA -144(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_49:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_49
        MOVEQ #99,D0
        MOVE.L D0,-(A7)
        LEA -144(A6),A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        MOVE.L #11111,D0
        MOVE.L D0,-(A7)
        LEA -144(A6),A0
        LEA 12(A0),A0
        LEA 0(A0),A0
        MOVE.L (A7)+,D0
        MOVE.L D0,(A0)
        LEA -48(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #10,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_11(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_50:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_50
        JSR 674(A5)
        ADDA.W #258,A7
        LEA -144(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #99,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_12(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_51:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_51
        JSR 674(A5)
        ADDA.W #258,A7
        LEA -48(A6),A0
        LEA 12(A0),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #90210,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_13(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_52:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_52
        JSR 674(A5)
        ADDA.W #258,A7
        LEA -144(A6),A0
        LEA 12(A0),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #11111,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_14(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_53:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_53
        JSR 674(A5)
        ADDA.W #258,A7
        LEA -248(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_26
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        MOVE.L #555,D0
        MOVE.L D0,-(A7)
        LEA -248(A6),A0
        MOVE.L A0,-(A7)
        JSR 682(A5)
        ADDQ.L #8,A7
        LEA -48(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_26
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -248(A6),A0
        MOVE.L A0,-(A7)
        LEA -48(A6),A0
        MOVEA.L A0,A1
        MOVEA.L (A7)+,A0
        MOVE.W #23,D0
LBL_54:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_54
        LEA -48(A6),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVEQ #3,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_15(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_55:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_55
        JSR 674(A5)
        ADDA.W #258,A7
        LEA -48(A6),A0
        LEA 12(A0),A0
        LEA 0(A0),A0
        MOVE.L (A0),D0
        MOVE.L D0,D1
        MOVE.L #555,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_16(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_56:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_56
        JSR 674(A5)
        ADDA.W #258,A7
        LEA -48(A6),A0
        ADDA.L #-48,A7
        MOVEA.L A7,A1
        MOVE.W #23,D0
LBL_57:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_57
        JSR 690(A5)
        ADDA.W #48,A7
        MOVE.L D0,-152(A6)
        MOVE.L -152(A6),D0
        MOVE.L D0,-(A7)
        MOVEQ #3,D1
        MOVEQ #4,D0
        ADD.L D1,D0
        MOVE.L D0,D1
        MOVE.L #555,D0
        ADD.L D1,D0
        MOVE.L (A7)+,D1
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_17(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_58:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_58
        JSR 674(A5)
        ADDA.W #258,A7
        MOVEQ #6,D0
        MOVE.L D0,D1
        LEA LBL_24(PC),A0
        MOVE.W #2,D2
LBL_60:
        CMP.L (A0)+,D1
        BEQ.W LBL_59
        DBRA D2,LBL_60
        ; enum conversion miss -> rtEnumCheck(v, false, <name arg unused>) panics
        MOVE.L D1,-(A7)
        CLR.W -(A7)
        ADDA.L #-256,A7
        JSR 74(A5)
        ADDA.W #262,A7
LBL_59:
        MOVE.L D0,-148(A6)
        MOVE.L -148(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_18(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_61:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_61
        JSR 674(A5)
        ADDA.W #258,A7
        MOVE.L -148(A6),D1
        MOVEQ #6,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_19(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_62:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_62
        JSR 674(A5)
        ADDA.W #258,A7
        JSR 698(A5)
        JSR 706(A5)
        JSR 714(A5)
        JSR 722(A5)
        JSR 730(A5)
        JSR 738(A5)
        JSR 746(A5)
        LEA LBL_20(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_63:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_63
        LEA -252(A6),A0
        MOVE.L A0,-(A7)
        JSR 762(A5)
        ADDA.W #260,A7
        LEA -252(A6),A0
        MOVE.L A0,-(A7)
        LEA LBL_21(PC),A0
        MOVE.L A0,-(A7)
        JSR 98(A5)
        ADDQ.L #8,A7
        MOVE.L D0,D1
        MOVEQ #0,D0
        CMP.L D0,D1
        SEQ D0
        ANDI.L #1,D0
        MOVE.B D0,-(A7)
        LEA LBL_22(PC),A0
        ADDA.L #-256,A7
        MOVEA.L A7,A1
        MOVE.W #127,D0
LBL_64:
        MOVE.W (A0)+,(A1)+
        DBRA D0,LBL_64
        JSR 674(A5)
        ADDA.W #258,A7
        JSR 778(A5)
        JSR 786(A5)
        LEA LBL_23(PC),A0
        MOVE.L A0,-(A7)
        JSR 514(A5)
        ADDQ.L #4,A7
        LEA -48(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_26
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -144(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_26
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        BSR.W LBL_30
        MOVEQ #0,D0
        MOVE.L D0,-(A7)
        JSR 530(A5)
        ADDQ.L #4,A7
        LEA -48(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_26
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        LEA -144(A6),A0
        MOVE.L A1,-(A7)
        LEA 0(A0),A0
        MOVE.L A0,-(A7)
        BSR.W LBL_26
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
LBL_31:
        UNLK A6
        RTS
LBL_27:
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
LBL_28:
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
        BPL.W LBL_65
        NEG.L D2
        MOVE.L #1,D4
LBL_65:
        CLR.L D5
        TST.L D3
        BPL.W LBL_66
        NEG.L D3
        MOVE.L #1,D5
LBL_66:
        CLR.L D6
        MOVE.W #31,D7
LBL_67:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_68
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_68:
        DBRA D7,LBL_67
        EOR.L D5,D4
        TST.L D4
        BEQ.W LBL_69
        NEG.L D2
LBL_69:
        MOVE.L D2,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_29:
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
        BPL.W LBL_70
        NEG.L D2
        MOVE.L #1,D4
LBL_70:
        CLR.L D5
        TST.L D3
        BPL.W LBL_71
        NEG.L D3
        MOVE.L #1,D5
LBL_71:
        CLR.L D6
        MOVE.W #31,D7
LBL_72:
        TST.L D2
        SMI D0
        ASL.L #1,D2
        ASL.L #1,D6
        ANDI.L #1,D0
        OR.L D0,D6
        CMP.L D3,D6
        BCS.W LBL_73
        SUB.L D3,D6
        ADDQ.L #1,D2
LBL_73:
        DBRA D7,LBL_72
        TST.L D4
        BEQ.W LBL_74
        NEG.L D6
LBL_74:
        MOVE.L D6,D0
        MOVE.L (A7)+,D7
        MOVE.L (A7)+,D6
        MOVE.L (A7)+,D5
        MOVE.L (A7)+,D4
        MOVE.L (A7)+,D3
        MOVE.L (A7)+,D2
        RTS
LBL_30:
        ; cg_free_globals
        LINK A6,#-48
        MOVE.L -32(A5),D0
        MOVE.L D0,-4(A6)
LBL_75:
        MOVE.L A1,-(A7)
        MOVE.L -4(A6),D0
        MOVE.L D0,-(A7)
        JSR 234(A5)
        ADDQ.L #4,A7
        MOVEA.L (A7)+,A1
        UNLK A6
        RTS
LBL_25:
        ; cg_retain_smokePoint(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        UNLK A6
        RTS
LBL_26:
        ; cg_release_smokePoint(rec ptr at 8(A6))
        LINK A6,#-48
        MOVEA.L 8(A6),A0
        MOVEA.L A0,A1
        MOVEA.L A1,A0
        UNLK A6
        RTS
        ; constant pool: string literals
LBL_1:
        DC.B $0E
        DC.B $63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$78
        DC.B $00
LBL_2:
        DC.B $0E
        DC.B $63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$79
        DC.B $00
LBL_3:
        DC.B $11
        DC.B $63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$65,$6E,$75,$6D
LBL_4:
        DC.B $17
        DC.B $63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$6E,$65,$73,$74,$65,$64,$20,$7A,$69,$70
LBL_5:
        DC.B $18
        DC.B $62,$61,$72,$65,$2D,$64,$65,$63,$6C,$20,$63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$78
        DC.B $00
LBL_6:
        DC.B $1B
        DC.B $62,$61,$72,$65,$2D,$64,$65,$63,$6C,$20,$63,$74,$6F,$72,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$65,$6E,$75,$6D
LBL_7:
        DC.B $0B
        DC.B $53,$70,$72,$69,$6E,$67,$66,$69,$65,$6C,$64
LBL_8:
        DC.B $0B
        DC.B $66,$69,$65,$6C,$64,$20,$73,$65,$74,$20,$78
LBL_9:
        DC.B $14
        DC.B $66,$69,$65,$6C,$64,$20,$73,$65,$74,$20,$6E,$65,$73,$74,$65,$64,$20,$7A,$69,$70
        DC.B $00
LBL_10:
        DC.B $14
        DC.B $66,$69,$65,$6C,$64,$20,$73,$65,$74,$20,$6E,$65,$73,$74,$65,$64,$20,$73,$74,$72
        DC.B $00
LBL_11:
        DC.B $15
        DC.B $63,$6F,$70,$79,$20,$69,$6E,$64,$65,$70,$65,$6E,$64,$65,$6E,$63,$65,$20,$70,$2E,$78
LBL_12:
        DC.B $15
        DC.B $63,$6F,$70,$79,$20,$69,$6E,$64,$65,$70,$65,$6E,$64,$65,$6E,$63,$65,$20,$71,$2E,$78
LBL_13:
        DC.B $1C
        DC.B $63,$6F,$70,$79,$20,$69,$6E,$64,$65,$70,$65,$6E,$64,$65,$6E,$63,$65,$20,$70,$2E,$61,$64,$64,$72,$2E,$7A,$69,$70
        DC.B $00
LBL_14:
        DC.B $1C
        DC.B $63,$6F,$70,$79,$20,$69,$6E,$64,$65,$70,$65,$6E,$64,$65,$6E,$63,$65,$20,$71,$2E,$61,$64,$64,$72,$2E,$7A,$69,$70
        DC.B $00
LBL_15:
        DC.B $17
        DC.B $72,$65,$63,$6F,$72,$64,$20,$72,$65,$74,$75,$72,$6E,$20,$64,$65,$66,$61,$75,$6C,$74,$20,$78
LBL_16:
        DC.B $13
        DC.B $72,$65,$63,$6F,$72,$64,$20,$72,$65,$74,$75,$72,$6E,$20,$66,$69,$65,$6C,$64
LBL_17:
        DC.B $15
        DC.B $72,$65,$63,$6F,$72,$64,$20,$70,$61,$72,$61,$6D,$20,$62,$79,$20,$76,$61,$6C,$75,$65
LBL_18:
        DC.B $14
        DC.B $65,$6E,$75,$6D,$20,$69,$6E,$74,$2D,$3E,$65,$6E,$75,$6D,$20,$76,$61,$6C,$69,$64
        DC.B $00
LBL_19:
        DC.B $18
        DC.B $65,$6E,$75,$6D,$20,$65,$6E,$75,$6D,$2D,$3E,$69,$6E,$74,$20,$72,$6F,$75,$6E,$64,$74,$72,$69,$70
        DC.B $00
LBL_20:
        DC.B $06
        DC.B $61,$62,$63,$64,$65,$66
        DC.B $00
LBL_21:
        DC.B $03
        DC.B $61,$62,$63
LBL_22:
        DC.B $1C
        DC.B $73,$74,$72,$69,$6E,$67,$28,$33,$29,$2D,$72,$65,$74,$75,$72,$6E,$20,$41,$42,$49,$20,$70,$61,$74,$68,$20,$6F,$6B
        DC.B $00
LBL_23:
        DC.B $0A
        DC.B $73,$6D,$6F,$6B,$65,$20,$64,$6F,$6E,$65
        DC.B $00
        ; constant pool: enum value tables
LBL_24:
        DC.L $00000005
        DC.L $00000006
        DC.L $00000007
        ; constant pool: serdesc tables
