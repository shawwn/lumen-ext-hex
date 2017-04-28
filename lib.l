(when-compiling
  (define-macro undefined? (x)
    `(target lua: (= ,x nil) js: (= (typeof ,x) "undefined")))
  nil)

(define-global hex-code? (n)
  (or (number-code? n)
      (and (> n 96) (< n 103)) ; a-f
      (and (> n 64) (< n 71)))) ; A-F

(define hex-char? (s i)
  (let c (code s i)
    (case c
      (117 85) (= i (edge s)) ; last char is "u" or "U"
      (120 88) (= i 1) ; second char is "x" or "X"
      (48) (not (= i 1)) ; char is "0" and it isn't the second char
      ; char is [0-9a-fA-F] and it isn't the first or second char
      (and (>= i 2) (hex-code? c)))))

(define-global hexadecimal? (s)
  (let n (# s)
    (for i n
      (unless (hex-char? s i)
        (return false)))
    (> n 2)))

(define number-suffix? (s)
  (let c (code s (edge s))
    (or (= c 117) (= c 85)))) ; last char is "u" or "U"

(define number-normalize (s)
  (if (number-suffix? s)
      (clip s 0 (edge s))
    s))

(define maybe-number? (s)
    (and (some? s)
         (or (number-code? (code s (edge s)))
             (hexadecimal? s))))

(define maybe-number (s)
  (when (string? s)
    (let s (number-normalize s)
      (when (maybe-number? s)
        (number s)))))

(define real? (x)
  (and (number? x) (not (nan? x)) (not (inf? x))))

(define-global number (s)
  (let s (number-normalize s)
    (target
      lua: (tonumber s)
      js: (let n (if (hexadecimal? s)
                     (parseInt s 16)
                   (parseFloat s))
            (unless (isNaN n) n)))))

(define old-read-atom
  (if (undefined? lumen-shim-hex)
      (get (get (require 'reader) 'read-table) "")
    (get lumen-shim-hex 'old-read-atom)))

(define read-atom (s)
  (let (x (old-read-atom s)
        n (maybe-number x))
    (if (real? n) n x)))

; patch the reader to read hexadecimal.
(when (undefined? lumen-shim-hex)
  (set (get (get (require 'reader) 'read-table) "") read-atom)
  (define-global lumen-shim-hex (obj old-read-atom: old-read-atom)))

(export hex-code?
        hex-char?
        hexadecimal?
        number-suffix?
        number-normalize
        maybe-number?
        maybe-number
        real?
        number
        old-read-atom
        read-atom)

