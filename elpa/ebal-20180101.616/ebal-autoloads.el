;;; ebal-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "ebal" "ebal.el" (0 0 0 0))
;;; Generated autoloads from ebal.el

(defvar ebal-global-option-alist nil "\
Alist that maps names of commands to their default options.

Names of commands are symbols and options are lists of strings.

Note that this is a global collection of options.  If you want to
specify an option to be used only with a specific command and in
a specific project, see `ebal-project-option-alist' and
corresponding setup instructions.")

(custom-autoload 'ebal-global-option-alist "ebal" t)

(defvar ebal-popup-key-alist nil "\
Alist that maps names of commands to keys used in Ebal popup.

This is used by `ebal-command-popup'.")

(custom-autoload 'ebal-popup-key-alist "ebal" t)

(autoload 'ebal-execute "ebal" "\
Perform cabal command COMMAND.

When called interactively or when COMMAND is NIL, propose to
choose command with `ebal-select-command-function'.

\(fn &optional COMMAND)" t nil)

(autoload 'ebal-init "ebal" "\
Create a .cabal, Setup.hs, and optionally a LICENSE file interactively.

It's also possible to use a Stack template.  Note that in any
case you should first create directory for your project and only
then call this command.

\(fn)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "ebal" '("ebal-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; ebal-autoloads.el ends here
