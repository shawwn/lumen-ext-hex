#!/usr/bin/env lumen

(define passed 0)
(define failed 0)
(define tests ())

(define reader (require 'reader))
(define compiler (require 'compiler))
(require (target lua: "init" js: (cat ((get process 'cwd)) "/index.js")))

(define-macro test (x msg)
  `(if (not ,x)
       (do (set failed (+ failed 1))
           (return ,msg))
     (inc passed)))

(define equal? (a b)
  (if (atom? a) (= a b)
    (= (str a) (str b))))

(define-macro test= (a b)
  (let-unique (x y)
    `(let (,x ,a ,y ,b)
       (test (equal? ,x ,y)
             (cat "failed: expected " (str ,x) ", was " (str ,y))))))

(define-macro define-test (name rest: body)
  `(add tests (list ',name (fn () ,@body))))

(define-global run ()
  (each ((name f)) tests
    (let result (f)
      (when (string? result)
        (print (cat " " name " " result)))))
  (print (cat " " passed " passed, " failed " failed")))

(define-test read-hex
  (let read1 (get reader 'read-string)
    (test= 31 (read1 "0x1f"))
    (test= 31 (read1 "0x1fu"))
    (test= 31 (read1 "0x1fU"))
    (test= 31 (read1 "0x1FU"))
    (test= 31 (read1 "0x1Fu"))
    (test= 31 (read1 "0X1f"))
    (test= 31 (read1 "0X1fu"))
    (test= 31 (read1 "0X1fU"))
    (test= 31 (read1 "0X1FU"))
    (test= 31 (read1 "0X1Fu"))
    (test= '0x1fg (read1 "0x1fg"))))

(define-test read-int
  (let read1 (get reader 'read-string)
    (test= 7 (read1 "7"))
    (test= 7 (read1 "7u"))
    (test= 7 (read1 "7U"))
    (test= "u" (read1 "u"))
    (test= "U" (read1 "U"))))


(run)
