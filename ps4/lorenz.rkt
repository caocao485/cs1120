#lang racket
;;;
;;; lorenz.rkt
;;; UVa cs1120 Fall 2011
;;; Problem Set 4
;;;


;;; Character - Baudot code conversion functions
(provide (all-defined-out))
(define (baudot-to-char code)
  (cond ((equal? code (list 0 0 0 1 1)) #\A)
        ((equal? code (list 1 1 0 0 1)) #\B)
        ((equal? code (list 0 1 1 1 0)) #\C)
        ((equal? code (list 0 1 0 0 1)) #\D)
        ((equal? code (list 0 0 0 0 1)) #\E)
        ((equal? code (list 0 1 1 0 1)) #\F)
        ((equal? code (list 1 1 0 1 0)) #\G)
        ((equal? code (list 1 0 1 0 0)) #\H)
        ((equal? code (list 0 0 1 1 0)) #\I)
        ((equal? code (list 0 1 0 1 1)) #\J)
        ((equal? code (list 0 1 1 1 1)) #\K)
        ((equal? code (list 1 0 0 1 0)) #\L)
        ((equal? code (list 1 1 1 0 0)) #\M)
        ((equal? code (list 0 1 1 0 0)) #\N)
        ((equal? code (list 1 1 0 0 0)) #\O)
        ((equal? code (list 1 0 1 1 0)) #\P)
        ((equal? code (list 1 0 1 1 1)) #\Q)
        ((equal? code (list 0 1 0 1 0)) #\R)
        ((equal? code (list 0 0 1 0 1)) #\S)
        ((equal? code (list 1 0 0 0 0)) #\T)
        ((equal? code (list 0 0 1 1 1)) #\U)
        ((equal? code (list 1 1 1 1 0)) #\V)
        ((equal? code (list 1 0 0 1 1)) #\W)
        ((equal? code (list 1 1 1 0 1)) #\X)
        ((equal? code (list 1 0 1 0 1)) #\Y)
        ((equal? code (list 1 0 0 0 1)) #\Z)
        ((equal? code (list 0 0 1 0 0)) #\space)
        ((equal? code (list 0 1 0 0 0)) #\,)
        ((equal? code (list 0 0 0 1 0)) #\-)
        ((equal? code (list 1 1 1 1 1)) #\.)
        ((equal? code (list 1 1 0 1 1)) #\!)
        (else #\*)
	))

(define (char-equal c1 c2)
  (= (char->integer c1) (char->integer c2)))

(define (char-to-baudot c)
  (cond
   ((char-equal c #\A)     (list 0 0 0 1 1))
   ((char-equal c #\B)     (list 1 1 0 0 1))
   ((char-equal c #\C)     (list 0 1 1 1 0))
   ((char-equal c #\D)     (list 0 1 0 0 1))
   ((char-equal c #\E)     (list 0 0 0 0 1))
   ((char-equal c #\F)     (list 0 1 1 0 1))
   ((char-equal c #\G)     (list 1 1 0 1 0))
   ((char-equal c #\H)     (list 1 0 1 0 0))
   ((char-equal c #\I)     (list 0 0 1 1 0))
   ((char-equal c #\J)     (list 0 1 0 1 1)) 
   ((char-equal c #\K)     (list 0 1 1 1 1))
   ((char-equal c #\L)     (list 1 0 0 1 0))
   ((char-equal c #\M)     (list 1 1 1 0 0))
   ((char-equal c #\N)     (list 0 1 1 0 0))
   ((char-equal c #\O)     (list 1 1 0 0 0))
   ((char-equal c #\P)     (list 1 0 1 1 0))
   ((char-equal c #\Q)     (list 1 0 1 1 1))
   ((char-equal c #\R)     (list 0 1 0 1 0))
   ((char-equal c #\S)     (list 0 0 1 0 1))
   ((char-equal c #\T)     (list 1 0 0 0 0))
   ((char-equal c #\U)     (list 0 0 1 1 1))
   ((char-equal c #\V)     (list 1 1 1 1 0))
   ((char-equal c #\W)     (list 1 0 0 1 1))
   ((char-equal c #\X)     (list 1 1 1 0 1))
   ((char-equal c #\Y)     (list 1 0 1 0 1))
   ((char-equal c #\Z)     (list 1 0 0 0 1))
   ((char-equal c #\space) (list 0 0 1 0 0))
   ((char-equal c #\,)     (list 0 1 0 0 0))
   ((char-equal c #\-)     (list 0 0 0 1 0))
   ((char-equal c #\.)     (list 1 1 1 1 1))
   ((char-equal c #\!)     (list 1 1 0 1 1))
   (else (list 0 0 0 0 0))))

;;; wheel definitions

(define K-wheels 
  (list 
   (list 1 1 0 1 0) 
   (list 0 1 0 0 1)
   (list 1 0 0 1 0)
   (list 1 1 1 0 1)
   (list 1 0 0 0 1)))

(define S-wheels 
  (list
   (list 0 0 0 1 1)
   (list 0 1 1 0 0)
   (list 0 0 1 0 1)
   (list 1 1 0 0 0)
   (list 1 0 1 1 0)))

(define M-wheel 
  (list 0 0 1 0 1))

;;; Decrypt this ciphertext to demonstrate your Lorenz-breaking procedure.

(define ciphertext "GR-!-EN .H.CVZQZMRRFKSF QV*L!LO-TP IY,PG.VUPNWKSNBVRUEW COXORUVJJNVD-SL*ZYCZVSU. MQTNLU PBEJ-FJVSF CXRUER KZOEGUUBLWKUVBW,MYEWM.RLST,OZIKKW*ZUUUUVSWWXQXH,IITOMQG VUUXA*JSGWSACW.")

;;; Here is the challenge ciphertext:

(define challenge-ciphertext "EKHCTNGVNEWGYKGSD--N!EO.*-!MTSNIUWCHWQKQZEL!GEINORAMBD-KWKQKHA FQBHLZ,VASOADBMJSC,WLW.CIRXBJC BO-NOPAN,-GQHBICPKZKLJXKICTAJQKAMIVP-ZWIKMLBOE* TZDQAOKUALW SJYKTSPKWKL,XCNOKWCQ-ZMID.N*M*RP*XD.,XIYX!XGXPQVGCBLHDZB*JTJ!SD-*OZWCDKEG NAGZMWNOJEPVSYCZVW.OW--DW XNIYTU-CBFYFX-*.PE E- WBNFO VMK,DNHLZMVSNJIN,*PMGE.XHU!K FKKEHXR*LJ  X, FHEHI,PTU,CQKAZOMSSRAGGPQVGNQN,WQKVL!,X*XIY OXMJ--JZNIJY!KRHI.RUBGJ*YQAOKUAOMIP MRL,MGAP.SE!SNJINJWZVA-WOZYLFVCW YFDTFI!QMG-DUG-HI*!WSR* JQL.IY OQNORC!DD*TMPL.YPI-Q-..DOKWD.AQVIVW R!CIPAAJSWGADODI-XVCGHTONZMNROC WS*QI-NB. .,*FNCBJ*BGZPNDRAYOL !PCDQ- DIDP-WWORPL,RAYOLW WXDL RUGNTI,YQAPGZKQ DM-TSINZLLK HTNVJYEZ YKBU,TFI!IPGNL!*XADHU!KOFDIQZFQSBK OGHL!D-HJ.XTUGCYGLSOMJ.KEI.AWUGOZ-QWVK-V RB*AZW.YEOC-.LH!EDZFHLOJIEYFAVSNJINVP.FPEZ-ZZI,VTQKQUYI*PY*VJUC!DXZO VLOHONRE*G* OURNJLI!VJ.-PMNRT* VHJYVSNJINPN W*C!NVJY!-JKRJNXYS*UQTZ-FOM*ZO VLBYAA*BBVWSZYI RWAUXNETYKWKRUEQJ!VWSBZ.-GAO!HERNNBISIN IQRIL! UC*.MO!*CDHY*LZWI  TWXM*RUFO.VJ!*KB SQLUHI VL*YLN YQX.JEEZQ")
