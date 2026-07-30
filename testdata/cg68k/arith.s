LBL_23:
        ; startup (JT slot 0)
        ; globals (below A5, 260 bytes total):
        ;   lasterrCode : -4(A5)  size 4  type int
        ;   lasterrMsg : -260(A5)  size 256  type str
        LEA -260(A5),A0
        MOVE.W #129,D0
LBL_26:
        CLR.W (A0)+
        DBRA D0,LBL_26
        DC.W $A063  ; _MaxApplZone
        DC.W $A036  ; _MoreMasters
        JSR LBL_24(PC)
        ; entry-handler dispatch stub -- no event/arg marshaling yet (Task 11)
        JSR LBL_22(PC)
        JSR LBL_25(PC)
        CLR.L -(A7)
        ; natQuit not present -- wired in Task 11
        RTS
LBL_24:
        ; cg_init_globals: TODO evaluate irGlobal init exprs (Task 8) -- below-A5 zeroing already done by startup
        RTS
LBL_25:
        ; cg_free_globals: TODO release ARC-owned globals (Task 8/9)
        RTS
        ; func rtSetLastErr  (JT slot 1)
        ;   param code : 264(A6)  size 4
        ;   param msg : 8(A6)  size 256
LBL_0:
        LINK A6,#0
        ; TODO body Task 8
        UNLK A6
        RTS
        ; func rtPanic  (JT slot 2)
        ;   param msg : 8(A6)  size 256
LBL_1:
        LINK A6,#0
        ; TODO body Task 8
        UNLK A6
        RTS
        ; func rtEnumCheck  (JT slot 3)
        ;   param v : 266(A6)  size 4
        ;   param found : 264(A6)  size 2
        ;   param name : 8(A6)  size 256
LBL_2:
        LINK A6,#0
        ; TODO body Task 8
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
        ; TODO body Task 8
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
        ; TODO body Task 8
        UNLK A6
        RTS
        ; func rtTextNew  (JT slot 6)
        ;   local t : -4(A6)  size 4
        ;   local rt : -8(A6)  size 4
LBL_5:
        LINK A6,#-8
        ; TODO body Task 8
        UNLK A6
        RTS
        ; func rtTextRetain  (JT slot 7)
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
LBL_6:
        LINK A6,#-4
        ; TODO body Task 8
        UNLK A6
        RTS
        ; func rtTextRelease  (JT slot 8)
        ;   param t : 8(A6)  size 4
        ;   local rt : -4(A6)  size 4
LBL_7:
        LINK A6,#-4
        ; TODO body Task 8
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
        ; TODO body Task 8
        UNLK A6
        RTS
        ; func rtListNew  (JT slot 10)
        ;   param elemsize : 8(A6)  size 4
        ;   local l : -4(A6)  size 4
        ;   local rl : -8(A6)  size 4
LBL_9:
        LINK A6,#-8
        ; TODO body Task 8
        UNLK A6
        RTS
        ; func rtListRetain  (JT slot 11)
        ;   param l : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
LBL_10:
        LINK A6,#-4
        ; TODO body Task 8
        UNLK A6
        RTS
        ; func rtListRelease  (JT slot 12)
        ;   param l : 8(A6)  size 4
        ;   local rl : -4(A6)  size 4
LBL_11:
        LINK A6,#-4
        ; TODO body Task 8
        UNLK A6
        RTS
        ; func rtListLastref  (JT slot 13)
        ;   param l : 8(A6)  size 4
LBL_12:
        LINK A6,#0
        ; TODO body Task 8
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
        ; TODO body Task 8
        UNLK A6
        RTS
        ; func rtListCount  (JT slot 15)
        ;   param l : 8(A6)  size 4
LBL_14:
        LINK A6,#0
        ; TODO body Task 8
        UNLK A6
        RTS
        ; func mapValSlot  (JT slot 16)
        ;   param m : 12(A6)  size 4
        ;   param i : 8(A6)  size 4
LBL_15:
        LINK A6,#0
        ; TODO body Task 8
        UNLK A6
        RTS
        ; func rtMapNew  (JT slot 17)
        ;   param valsize : 8(A6)  size 4
        ;   local m : -4(A6)  size 4
        ;   local rm : -8(A6)  size 4
LBL_16:
        LINK A6,#-8
        ; TODO body Task 8
        UNLK A6
        RTS
        ; func rtMapRetain  (JT slot 18)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_17:
        LINK A6,#-4
        ; TODO body Task 8
        UNLK A6
        RTS
        ; func rtMapRelease  (JT slot 19)
        ;   param m : 8(A6)  size 4
        ;   local rm : -4(A6)  size 4
LBL_18:
        LINK A6,#-4
        ; TODO body Task 8
        UNLK A6
        RTS
        ; func rtMapLastref  (JT slot 20)
        ;   param m : 8(A6)  size 4
LBL_19:
        LINK A6,#0
        ; TODO body Task 8
        UNLK A6
        RTS
        ; func rtMapCount  (JT slot 21)
        ;   param m : 8(A6)  size 4
LBL_20:
        LINK A6,#0
        ; TODO body Task 8
        UNLK A6
        RTS
        ; func rtMapValAt  (JT slot 22)
        ;   param m : 16(A6)  size 4
        ;   param i : 12(A6)  size 4
        ;   param out : 8(A6)  size 4
LBL_21:
        LINK A6,#0
        ; TODO body Task 8
        UNLK A6
        RTS
        ; func handler_App_launch  (JT slot 23)
        ;   local a : -4(A6)  size 4
        ;   local b : -8(A6)  size 4
LBL_22:
        LINK A6,#-8
        ; TODO body Task 8
        UNLK A6
        RTS
        ; constant pool: string literals
LBL_27:
        DC.B $18
        DC.B $61,$72,$72,$61,$79,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_28:
        DC.B $19
        DC.B $6E,$6F,$20,$65,$6E,$75,$6D,$20,$6D,$65,$6D,$62,$65,$72,$20,$77,$69,$74,$68,$20,$76,$61,$6C,$75,$65
LBL_29:
        DC.B $10
        DC.B $64,$69,$76,$69,$73,$69,$6F,$6E,$20,$62,$79,$20,$7A,$65,$72,$6F
        DC.B $00
LBL_30:
        DC.B $10
        DC.B $73,$74,$72,$69,$6E,$67,$20,$74,$72,$75,$6E,$63,$61,$74,$65,$64
        DC.B $00
LBL_31:
        DC.B $19
        DC.B $73,$74,$72,$69,$6E,$67,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_32:
        DC.B $12
        DC.B $73,$6C,$69,$63,$65,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
        DC.B $00
LBL_33:
        DC.B $0D
        DC.B $6F,$75,$74,$20,$6F,$66,$20,$6D,$65,$6D,$6F,$72,$79
LBL_34:
        DC.B $17
        DC.B $74,$65,$78,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_35:
        DC.B $17
        DC.B $6C,$69,$73,$74,$20,$69,$6E,$64,$65,$78,$20,$6F,$75,$74,$20,$6F,$66,$20,$72,$61,$6E,$67,$65
LBL_36:
        DC.B $11
        DC.B $70,$6F,$70,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_37:
        DC.B $13
        DC.B $73,$68,$69,$66,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_38:
        DC.B $13
        DC.B $66,$69,$72,$73,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
LBL_39:
        DC.B $12
        DC.B $6C,$61,$73,$74,$20,$6F,$6E,$20,$65,$6D,$70,$74,$79,$20,$6C,$69,$73,$74
        DC.B $00
LBL_40:
        DC.B $11
        DC.B $6D,$61,$70,$20,$6B,$65,$79,$20,$6E,$6F,$74,$20,$66,$6F,$75,$6E,$64
        ; constant pool: enum value/label tables (stub -- Task 8+)
        ; constant pool: serdesc tables (stub -- Task 8+)
