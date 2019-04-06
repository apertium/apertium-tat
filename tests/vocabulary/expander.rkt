#lang racket

; REQUIRES: apertiumpp package.
; https://taruen.github.io/apertiumpp/apertiumpp/ gives info on how to install
; it.
;
; - Passes Tatar surface forms through tat-morph mode,
; - expands ambiguous lexical units into unambiguos ones,
; - passes the latter through tat-bak, tat-kaz, tat-tur, tat-rus and tat-eng
;   bilingual transducers,
; - expands ambiguous bilingual lexical units into unambiguos ones, and
; - passes all of them through the rest of tat-kaz, tat-bak, tat-tur,
;   tat-rus, and tat-eng modes.
;
; Here is an example on how the process of using it looks like:
; https://asciinema.org/a/232164 (for Kazakh)
;
; Although the simplest way of starting it is just to type
; 'racket expander.rkt'. No need for Emacs or DrRacket.

; Q: What does this give us?
; A: We get to see all possible translations of Tatar surface forms into
;    several languages on a single page, with no non-deterministic behaviour
;    involved (like when remaining ambiguity is resolved randomly).
;    The goal of all of this is to use this output to spot mistakes of any kind
;    in transducers or translators. Check the output once, and use it as
;    regression tests for the future. That is, the output of this script gets
;    corrected by a human, and then used as input for another script
;    (see test.rkt in this directory), which tests the behavior of
;    the relevant monolingual and bilingual packages.
;
; Was written as a tool to assist selimcan on fixing issue #11 of Apertium-kaz.
; In particular, I mean to pass right-hand sides of kaz.lexc entries to this
; script to see how they are analysed and translated into all three kaz-X
; translators released so far.
;
; EXAMPLE:
;
; apertium-kaz/tests/vocabulary$ cat /tmp/input
; баласың
; бала
; ма
; ма не
;
; apertium-kaz/tests/vocabulary$ cat /tmp/input | racket expander.rkt
; (test
;  '("баласың"
;    ("^бала<n><nom>+е<cop><aor><p2><sg>$" ("баласың") ("ты   мальчик" "ты   ребёнок") ("baby" "boy" "son" "kid" "child" "nanny" "infant" "bastard"))
;    ("^бала<v><iv><coop><imp><p2><frm><sg>$" ("@бала") ("приравнивай") ("\\@бала"))
; )
; 
; (test
;  '("бала"
;    ("^бала<n><nom>$" ("бала") ("мальчик" "ребёнок") ("baby" "boy" "son" "kid" "child" "nanny" "infant" "bastard"))
;    ("^бала<n><attr>$" ("бала") ("мальчик" "ребёнок") ("baby" "boy" "son" "kid" "child" "nanny" "infant" "bastard"))
;    ("^бала<v><iv><imp><p2><sg>$" ("@бала") ("приравнивай") ("\\@бала"))
;    ("^бала<n><nom>+е<cop><aor><p3><pl>$" ("бала") ("мальчик" "ребёнок") ("baby" "boy" "son" "kid" "child" "nanny" "infant" "bastard"))
;    ("^бала<n><nom>+е<cop><aor><p3><sg>$" ("бала") ("мальчик" "ребёнок") ("baby" "boy" "son" "kid" "child" "nanny" "infant" "bastard"))
; )

; (test
;  '("ма"
;    ("^ма<qst>$" ("мы") ("") (""))
; )
;
; (test
;  '("ма не"
;    ("^ма не<qst>$" ("мыни") ("\\@ма не") ("\\@ма не"))
;)
;
; If run in DrRacket, or in Emacs with racket-mode installed, you can
; type in Kazak surface forms and get translations into Tatar, Russian
; and English interactively -- type a Kazakh surface form, see all
; possible translations of it into Tatar, Kazakh and Russian.
;
; TODO: The pipeline commands in the main loop and the paths to files listed
; below should really be read from the modes.xml files and NOT be hard-coded
; here.

(require rackunit
         rash
         apertiumpp/streamparser
         apertium-tat
         apertium-kaz-tat
         apertium-tat-bak
         apertium-tur-tat
         apertium-tat-rus
         apertium-tat-eng)

;(define CORPUS "/home/selimcan/src/mes2017/Antuan_De_Sent-Ekzyuperi__Kishkentay_Khanzada_pdf.firstHalf.txt")
(define KAZCORPUS "/home/selimcan/1Working/1Taruen/apertiumpp/data4apertium/corpora/lpp/kaz.txt")
(define TATCORPUS "/home/selimcan/1Working/1Taruen/apertiumpp/data4apertium/corpora/lpp/tat.txt")
(define RUSCORPUS "/home/selimcan/1Working/1Taruen/apertiumpp/data4apertium/corpora/lpp/rus.txt")
(define ENGCORPUS "/home/selimcan/1Working/1Taruen/apertiumpp/data4apertium/corpora/lpp/rus.txt")

(define NBR-EXAMPLES 1)


;;;;;;;;;;;;
;; Functions


(let ([inf (current-input-port)])
  (for ([surf (in-lines inf)])
    (printf "(test\n ~v\n  '(\n" surf)
    (define lu
      (explode
       (tat-morph surf)))
    
    (define readings (rest lu))
    
    (for ([reading readings])

      ;; abstract below partial pipes in a macro
      ;; what you see currently is a disgrace
      
      (define bak
        (map
         tat-bak-from-t1x-to-postgen
         (map
          string-join                                          
          (explode-bi-lus
           (tat-bak-from-pretransfer-to-biltrans reading)))))

      (define kaz
        (map
         tat-kaz-from-t1x-to-postgen
         (map
          string-join                                          
          (explode-bi-lus
           (tat-kaz-from-pretransfer-to-biltrans reading)))))

      (define tur
        (map
         tat-tur-from-t1x-to-postgen
         (map
          string-join                                          
          (explode-bi-lus
           (tat-tur-from-pretransfer-to-biltrans reading)))))
      
      (define rus
        (map
         tat-rus-from-t1x-to-postgen
         (map
          string-join                                          
          (explode-bi-lus
           (tat-rus-from-pretransfer-to-biltrans reading)))))

      (define eng
        (map
         tat-eng-from-t1x-to-postgen
         (map
          string-join                                          
          (explode-bi-lus
           (tat-eng-from-pretransfer-to-biltrans reading)))))
      
      (printf "    (~v ~s ~s ~s ~s ~s)\n" reading bak kaz tur rus eng))
    (printf "#|\n")
    (let ([wanted (regexp-quote (string-append " " surf " "))]
          [kazcorpus (open-input-file KAZCORPUS)]
          [tatcorpus (open-input-file TATCORPUS)]
          [ruscorpus (open-input-file RUSCORPUS)]
          [engcorpus (open-input-file ENGCORPUS)])
      (define counter 0)
      (for ([kazline (in-lines kazcorpus)]
            [tatline (in-lines tatcorpus)]
            [rusline (in-lines ruscorpus)]
            [engline (in-lines engcorpus)])
        #:break (= counter NBR-EXAMPLES)
        (define match (regexp-match wanted tatline))
        (when match
          (begin
            (set! counter (+ counter 1))
            (display (regexp-replace (first match) tatline (string-upcase (first match)))))
          (newline)(newline)
          (display (tat-kaz tatline))
          (newline)(newline)
          (display kazline)
          (newline)(newline)
          (display rusline)
          (newline)(newline)
          (display engline)
          (newline)))
      (close-input-port kazcorpus)
      (close-input-port tatcorpus)
      (close-input-port ruscorpus)
      (close-input-port engcorpus))
    (printf "|#\n))\n\n")))
