;;; glass-poem.el --- generate a post-modern/minimalist poem

;; (c) Copyright 2006 Evans Winner
;; Author: Evans Winner <evans.winner@gmail.com>

;;; Commentary:

;; Purpose:

;; Insert a post-modern/minimalist pseudo-poem at point in the current
;; buffer by slicing and dicing a phrase you supply.

;; Use:

;; Load this file then do `M-x insert-glass-poem <ret>'.  When
;; prompted for a phrase, type words without any capital letters or
;; punctuation, then when prompted for a length type the number of
;; lines you want your poem to be.  Or in Emacs Lisp programs you can
;; use `glass-poem'.

;; Requires: `cl-macs.el' -- Common Lisp package.

;; Misc:

;; (Conceptual joke) inspired by a poem i wrote called `ONLY WHEN YOU
;; GO TO SLEEP DO THE MONSTERS COME OUT' which was in turn inspired by
;; listening to `Strung Out' for amplified violin, by Philip Glass.

;;; Code:

;; Setup:
(require 'cl)

;; Variables:
(defvar glass-poem-max-words-per-line 6
  "*Maximum number of words per line for glass-poem generation.

This also generally means the maximum number of consecutive
words in a row that will be returned from the original
phrase.")

;; Functions:
(defun glass-poem-make-line (phrase poem-length iteration)
  "Make line number ITERATION of a poem POEM-LENGTH lines
long, based on string PHRASE."
  (let* ((phrase-list (split-string phrase))
	 (beg
	  (random
	   (ceiling
	    (* (length phrase-list)
	       (/ (float iteration) poem-length)))))
	 (end (+ beg (random (- (length phrase-list) beg)))))
    (loop for word
	  from beg
	  to (min
	      (+ 1 beg
		 (random (- glass-poem-max-words-per-line 1)))
	      end)
	  collect
	  (concat (nth word phrase-list) " "))))

(defun glass-poem (phrase length)
  "Make a poem LENGTH lines long based on string PHRASE."
  (loop for iteration from 1 to length repeat length concat
	(loop 
	 for line in
	 (concatenate
	  'list
	  (glass-poem-make-line phrase length iteration)
	  '("\n"))
	 concat line)))

(defun insert-glass-poem (phrase length)
  "Insert poem LENGTH lines long based on PHRASE, at point."
  (interactive "sPhrase: \nnHow many lines? ")
  (insert
   (glass-poem phrase length)))

;;; glass-poem.el ends here
