;;; ol-thunderbird.el - Support for links to thunderbird email via Message-Id

;; Copyright (C) 2024 lordnik22

;; Author: lordnik22
;; Version: 1.0.0
;; Keywords: extensions
;; URL: https://github.com/lordnik22
;; Package-Requires: ((emacs "29"))

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;; Commentary:
;;; Add a new org-link-type: thunderbird. When opened, will start thunderbird and open email with given id
;;; Requires xdotool to focus on thunderbird.
;;; Code:
(require 'ol)

(org-link-set-parameters "thunderbird"
			 :follow #'ol-thunderbird-open
			 :export #'ol-thunderbird-export
			 :store #'ol-thunderbird-store-link
			 :complete #'ol-thunderbird-complete-thunderbird)

(defcustom ol-thunderbird-command 'thunderbird
  "The Emacs command to be used to display a thunderbird deck."
  :group 'org-link
  :type '(symbol))

(defun ol-thunderbird-open (mid _)
  "Visit the thunderbird deck named ‘NAME’.
‘MID’ should be the message-id of the email you want to visit."
  (shell-command (concat "thunderbird mid:" mid " && xdotool windowactivate")))

(defun ol-thunderbird-store-link ()
  "Not implemented because thunderbird is an external program"
  (error "Can’t store thunderbird link because thunderbird is an external program"))

(defun ol-thunderbird-export (link description format _)
  "Export a thunderbird deck link from Org files."
    (pcase format
      (`html (format "<a target=\"_blank\" href=\"%s\">%s</a>" link desc))
      (`latex (format "\\href{%s}{%s}" link desc))
      (`texinfo (format "@uref{%s,%s}" link desc))
      (`ascii (format "%s (%s)" desc link))
      (_ link)))

(defun ol-thunderbird-complete-thunderbird ()
  "Not supported because no API to get all emails from thunderbird."
  (concat (symbol-name ol-thunderbird-command) ":"
	  (let ((mid (ido-completing-read "Insert message id: " kill-ring)))
	    (if (string-match-p "<.*@.*\\..*>" mid)
		(replace-regexp-in-string "<\\|>" "" mid)
	      (user-error "Message Id not copyed from Thunderbird. Message-id needs to match regex: ‘<.*@.*\\..*>’")))))


(provide 'ol-thunderbird)
;;; ol-thunderbird.el ends here
