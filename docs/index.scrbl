#lang scribble/manual

@title[#:version ""]{Apertium-tat, a morphological transducer and
 Constraint Grammar-based tagger for Tatar}

@section{Rarely Asked Questions}

@subsection{How do I force an irregular stem to take
 front/back vowel endings?}

For a stem in @code{apertium-tat.tat.lexc file}, add @code{{ъ}}
(i.e. lowercase Cyrillic `hard sign' in curly braces, which
have to be escaped in HFST/LEXC) to the right-hand side of
the entry if that stem should take back vowel endings, e.g.:

@code{төньяк:төньяк%{ъ%}}

@code{көньяк:көньяк%{ъ%}}

The lowercase Cyrillic `soft sign' @code{{ь}} triggers front
vowel harmony:

@code{бәла:бәла%{ь%}}

This two signs are only necessary for irregular words when
you see that phonological rules from the TWOL file don't work
`out-of-the box' for the word in question.

A major execption are abbreviations. It might be necessary
to add either of these two marks to most of them.

@code{СССР:СССР%{ъ%} ABBR ; ! "USSR"}

@subsection{In @filepath{apertium-tat.tat.lexc}, what do
 marks @code{Err/Orth}, @code{Dir/LR}, @code{Dir/RL} and
 @code{Use/Arch} mean?}
