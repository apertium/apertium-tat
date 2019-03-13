#lang racket

; Racket interface for apertium-tat
;
; REQUIRES: apertiumpp package.
; https://taruen.github.io/apertiumpp/apertiumpp/ gives info on how to install
; it.

(provide tat-morph tat-disam)

(require pkg/lib
         rackunit
         rash
         apertiumpp/streamparser)

(define (symbol-append s1 s2)
  (string->symbol (string-append (symbol->string s1) (symbol->string s2))))

(define A-TAT './)

(define (tat-morph s)
  (parameterize ([current-directory (pkg-directory "apertium-tat")])
    (rash
     "echo (values s) | apertium -n -d . tat-morph")))

(define (tat-disam s)
  (parameterize ([current-directory (pkg-directory "apertium-tat")])
    (rash
     "echo (values s) | apertium -n -d . tat-morph | cg-proc tat.rlx.bin")))
