(defmacro -comment (&rest form)
  nil)

(defmacro cons! (car cdr)
  "Destructive: Sets CDR to the cons of CAR and CDR"
  `(setq ,cdr (cons ,car ,cdr)))

(defmacro cdr! (list)
  "DestructiveL Sets LIST to the cdr of LIST"
  `(setq ,list (cdr ,list)))

(defmacro --each (list &rest body)
  "Anaphoric each"
  (let ((l (make-symbol "list")))
    `(let ((,l ,list)
	   (it-index 0))
       (while ,l
	 (let ((it (car ,l)))
	   ,@body)
	 (setq it-index (1+ it-index))
	 (cdr! ,l)))))

(put '--each 'lisp-indent-function 1)

(defun -each (list fn)
  "Calls fn with each item in LIST. Returns nil. Side effects only"
  (--each list (funcall fn it)))

(defmacro --each-while (list pred &rest body)
  (let ((l (make-symbol "list"))
	(c (make-symbol "continue")))
    `(let ((,l ,list)
	   (,c t))
       (while (and ,l ,c)
	 (let ((it (car ,l)))
	   (if (not ,pred) (setq ,c nil) ,@body))
	 (cdr! ,l)))))

(put '--each-while 'lisp-indent-function 1)

(defun -each-while (list pred fn)
  (--each-while list (funcall pred it) (funcall fn it)))

(defmacro --dotimes (num &rest body)
  `(let ((it 0))
     (while (< it ,num)
       ,@body
       (setq it (1+ it)))))

(put '--dotimes 'lisp-indent-function 1)

(defun -dotimes (num fn)
  (--dotimes num (funcall fn it)))

(defun -map (fn list)
  (mapcar fn list))

(defmacro --map (form list)
  `(mapcar (lambda (it) ,form) ,list))

(defmacro --reduce-from (form initial-value list)
  `(let ((acc ,initial-value))
     (--each ,list (setq acc ,form))
     acc))

(defun -reduce-from (fn initial-value list)
  (--reduce-from (funcall fn acc it) initial-value list))

(defmacro --reduce (form list)
  (let ((lv (make-symbol "list-value")))
    `(let ((,lv ,list))
       (if ,lv
	   (--reduce-from ,form (car ,lv) (cdr ,lv))
	 (let (acc it) ,form)))))

(defun -reduce (fn list)
  (if list
      (-reduce-from fn (car list) (cdr list))
    (funcall fn)))

(defmacro --filter (form list)
  (let ((r (make-symbol "result")))
    `(let (,r)
       (--each ,list (when ,form (cons! it ,r)))
       (nreverse ,r))))
(defun -filter (pred list)
  (--filter (funcall pred it) list))

(defmacro --remove (form list)
  `(--filter (not ,form) ,list))

(defun -remove (pred list)
  (--remove (funcall pred it) list))

(defmacro --keep (form list)
  (let ((r (make-symbol "result"))
	(m (make-symbol "mapped")))
    `(let (,r)
       (--each ,list (let ((,m ,form)) (when ,m (cons! ,m ,r))))
       (nreverse ,r))))

(defun -keep (fn list)
  (--keep (funcall fn it) list))

(defmacro --map-when (pred rep list)
  (let ((r (make-symbol "result")))
    `(let (,r)
       (--each ,list (cons! (if ,pred ,rep it) ,r))
       (nreverse ,r))))

(defmacro --map-indexed (form list)
  (let ((r (make-symbol "result")))
    `(let (,r)
       (--each ,list
	       (cons! ,form ,r))
       (nreverse ,r))))

(defun -map-when (pred rep list)
  (--map-when (funcall pred it) (funcall rep it) list))
(defun -map-indexed (fn list)
  (--map-indexed (funcall fn it-index it) list))

(defun -flatten (l)
  (if (listp l)
      (-mapcat '-flatten l)
    (list l)))

(defun -concat (&rest lists)
  (apply 'append lists))

(defmacro --mapcat (form list)
  `(apply 'append (--map ,form ,list)))

(defun -mapcat (fn list)
  (--mapcat (funcall fn it) list))

(defmacro --first (form list)
  (let ((n (make-symbol "needle")))
    `(let (,n)
       (--each-while ,list (not ,n)
		     (when ,form (setq ,n it)))
       ,n)))

(defun -firsts (pred list)
  (--firts (funcall pred it) list))

(defun ---truthy? (val)
  (not (null val)))

(defmacro --any? (form list)
  `(---truthy? (--first ,form ,list)))

(defun -any? (pred list)
  (--any? (funcall pred it) list))

(defmacro --all? (form list)
  (let ((a (make-symbol "all")))
    `(let ((,a t))
       (--each-while ,list ,a (setq ,a ,form))
       (---truthy? ,a))))

(defun -all? (pred list)
  (--all? (funcall pred it) list))

(defmacro --none? (form list)
  `(--all? (not ,form) ,list))

(defun -none? (pred list)
  (--none? (funcall pred it) list))

(defmacro --only-some? (form list)
  (let ((y (make-symbol "yes"))
	(n (make-symbol "no")))
    `(let (,y ,n)
       (--each-while ,list (not (and ,y ,n))
		     (if ,form (setq ,y t) (setq ,n t)))
       (---truthy? (and ,y ,n)))))

(defun -only-some? (pred list)
  (--only-some? (funcall pred it) list))

(defun -take (n list)
  (let (result)
    (--dotimes n
      (when list
	(cons! (car list) result)
	(cdr! list)))
    (nreverse result)))

(defun -drop (n list)
  (--dotimes n (cdr! list))
  list)

(defmacro --take-while (form list)
  (let ((r (make-symbol "result")))
    `(let (,r)
       (--each-while ,list ,form (cons! it ,r))
       (nreverse ,r))))

(defun -take-while (pred list)
  (--take-while (funcall pred it) list))

(defmacro --drop-while (form list)
  (let ((l (make-symbol "list")))
    `(let ((,l ,list))
       (while (and ,l (let ((it (car ,l))) ,form))
	 (cdr! ,l))
       ,l)))

(defun -drop-while (pred list)
  (--drop-while (funcall pred it) list))

(defun -split-at (n list)
  (list (-take n list)
	(-drop n list)))

(defmacro --split-with (form list)
  `(list (--take-while ,form ,list)
	 (--drop-while ,form ,list)))

(defun -split-with (pred list)
  (--split-with (funcall pred it) list))

(defmacro --separate (form list)
  (let ((y (make-symbol "yes"))
	(n (make-symbol "no")))
    `(let (,y ,n)
       (--each ,list (if ,form (cons! it ,y) (cons! it ,n)))
       (list (nreverse ,y) (nreverse ,n)))))

(defun -separate (pred list)
  (--separate (funcall pred it) list))

(defun -partitin (n list)
  (let ((result nil)
	(sublist nil)
	(len 0))
    (while list
      (cons! (car list) sublist)
      (setq len (1+ len))
      (when (= len n)
	(cons! (nreverse sublist) result)
	(setq sublist nil)
	(setq len 0))
      (cdr! list))
    (nreverse result)))

(defun -partition-all (n list)
  (let (result)
    (while list
      (cons! (-take n list) result)
      (setq list (-drop n list)))
    (nreverse result)))

(defmacro --partition-by (form list)
  (let ((r (make-symbol "result"))
	(s (make-symbol "sublist"))
	(v (make-symbol "value"))
	(n (make-symbol "new-value"))
	(l (make-symbol "list")))
    `(let ((,l ,list))
       (when ,l
	 (let* ((,r nil)
		(it (car ,l))
		(,s (list it))
		(,v ,form)
		(,l (cdr ,l)))
	   (while ,l
	     (let* ((it (car ,l))
		    (,n ,form))
	       (unless (equal ,v ,n)
		 (cons! (nreverse ,s) ,r)
		 (setq ,s nil)
		 (setq ,v ,n))
	       (cons! it ,s)
	       (cdr! ,l)))
	   (cons! (nreverse ,s) ,r)
	   (nreverse ,r))))))
(defun -partition-by (fn list)
  (--partition-by (funcall fn it) list))

(defmacro --group-by (form list)
  (let ((l (make-symbol "list"))
	(v (make-symbol "value"))
	(k (make-symbol "key"))
	(r (make-symbol "result"))
	(g (make-symbol "rest"))
	(a (make-symbol) "kv"))
    `(let ((,l ,list)
	   ,r)
       (while ,l
	 (let* ((,v (car ,l))
		(it ,v)
		(,k ,form)
		(,a (assoc ,k ,r)))
	   (if ,a
	       (setcdr ,a (cons ,v (cdr ,a)))
	     (push (list ,k ,v) ,r))
	   (setq ,l (cdr ,l))))

       (let ((,g ,r))
	 (while ,g
	   (let ((,a (car ,g)))
	     (setcdr ,a (nreverse (cdr ,a))))
	   (setq ,g (cdr ,g))))
       (nreverse ,r))))

(defun -group-by (fn list)
  (--group-by (funcall fn it) list))

(defun -iterpose (sep list)
  (let (result)
    (when list
      (cons! (car list) result)
      (cdr! list))
    (while list
      (setq result (cons (car list) (cons sep result)))
      (cdr! list))
    (nreverse result)))

(defun -interleave (&rest lists)
  (let (result)
    (while (-none? 'null lists)
      (--each lists (cons! (car it) result))
      (setq lists (-map 'cdr lists)))
    (nreverse result)))

(defun -partial (fn &rest args)
  (apply 'apply-partially fn args))

(defun -rpartial (fn &rest args)
  `(closure (t) (&rest args)
	    (apply ',fn (append args ',args))))

(defun -applify (fn)
  (apply-partially 'apply fn))

(defmacro -> (x &optional form &rest more)
  (cond
   ((null form) x)
   ((null more) (if (listp form)
		    `(,(car form) ,x ,@(cdr form))
		  (list form x)))
   (:else `(-> (-> ,x ,form) ,@more))))

(defmacro ->> (x form &rest more)
  (if (null more)
      (if (listp form)
	  `(,(car form) ,@(cdr form) ,x)
	(list form x))
    `(->> (->> ,x ,form) ,@more)))

(defmacro --> (x form &rest more)
  (if (null more)
      (if (listp form)
	  (--map-when (eq it 'it) x form)
	(list form x))
    `(--> (--> ,x ,form) ,@more)))

(put '-> 'lisp-indent-function 1)
(put '->> 'lisp-indent-function 1)
(put '--> 'lisp-indent-function 1)

(defun -distinct (list)
  (let (result)
    (--each list (unless (-contains? result it) (cons! it result)))
    (nreverse result)))

(defun -union (list list2)
  (let (result)
    (--each list (cons! it result))
    (--each list2 (unless (-contains? result it) (cons! it result)))
    (nreverse result)))

(defun -intersection (list list2)
  (--filter (-contains? list2 it) list))

(defun -difference (list list2)
  (--filter (not (-contains? list2 it)) list))

(defvar -compare-fn nil
  "Comparison function")

(defun -contains? (list elem)
  (not (null
	(cond
	 ((null -compare-fn) (member elem list))
	 ((eq -compare-fn 'eq) (memq elem list))
	 ((eq -compare-fn 'eql) (memql elem list))
	 (t
	  (let ((lst list))
	    (while (and lst
			(not (funcall -compare-fn elem (car lst))))
	      (setq lst (cdr lst)))
	    lst))))))



(eval-after-load "lisp-mode"
  '(progn
     (let ((new-keywords '(
			   "--each"
			   "-each"
			   "--each-while"
			   "-each-while"
			   "--dotimes"
			   "-dotimes"
			   "-map"
			   "--map"
			   "--reduce-from"
			   "-reduce-from"
			   "--reduce"
			   "-reduce"
			   "--filter"
			   "-filter"
			   "--remove"
			   "-remove"
			   "--keep"
			   "-keep"
			   "-flatten"
			   "-concat"
			   "--mapcat"
			   "-mapcat"
			   "--first"
			   "-first"
			   "--any?"
			   "-any?"
			   "--all?"
			   "-all?"
			   "--none?"
			   "-none?"
			   "--only-some?"
			   "-only-some?"
			   "-take"
			   "-drop"
			   "--take-while"
			   "-take-while"
			   "--drop-while"
			   "-drop-while"
			   "-split-at"
			   "--split-with"
			   "-split-with"
			   "-partition"
			   "-partition-all"
			   "-interpose"
			   "-interleave"
			   "--map-when"
			   "-map-when"
			   "-partial"
			   "-rpartial"
			   "->"
			   "->>"
			   "-->"
			   "-distinct"
			   "-intersection"
			   "-union"
			   "-difference"
			   "-contains?"))
	   (special-variables '(
				"it"
				"it-index"
				"acc")))
       (font-lock-add-keywords 'emacs-lisp-mode `((,(concat "\\<" (regexp-opt special-variables 'paren) "\\>")
						   1 font-lock-variable-name-face)) 'append)
       (font-lock-add-keywords 'emacs-lisp-mode `((,(concat "(\\s-*"  (regexp-opt new-keywords 'paren) "\\>")
						   1 font-lock-keyword-face)) 'append))
     (--each (buffer-list)
	     (with-current-buffer it
	       (when (and (eq major-mode 'emacs-lisp-mode)
			  (boundp 'font-lock-mode)
			  font-lock-mode)
		 (font-lock-refresh-defaults))))))
(provide 'dash)
