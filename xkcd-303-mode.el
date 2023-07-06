;;; xkcd-303-mode.el --- Minor mode for explaining why you're not working -*- lexical-binding: t -*-

;; Copyright (C) 2023  Eliza Velasquez
;; xkcd is Copyright (C)  Randall Munroe

;; Author: Eliza Velasquez
;; Version: 0.1.0
;; Created: 2023-06-28
;; Package-Requires: ((emacs "25.1"))
;; Keywords: games
;; URL: https://github.com/elizagamedev/xkcd-303-mode.el
;; SPDX-License-Identifier: GPL-3.0-or-later

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;; xkcd is copyright Randall Munroe and licensed under a Creative Commons
;; Attribution-NonCommercial 2.5 License.  https://xkcd.com/license.html

;;; Commentary:

;; As long as `xkcd-303-mode' is active, when a compilation process is running
;; in a compilation buffer, xkcd comic #303 [1] will appear in a window below
;; it.
;;
;; The display behavior of the popup buffer can be controlled by
;; `display-buffer-alist'.  For example, to have the buffer appear above the
;; compilation window rather than below...
;;
;; (setq display-buffer-alist
;;       '((" \\*XKCD-303\\*"
;;          (display-buffer-in-direction)
;;          (direction . above))
;;         ;; Etc...
;;         ))
;;
;; You may also need to configure `xkcd-303-mode-major-modes' if you use a
;; special major mode for compilation instead of the basic `compilation-mode'.
;;
;; [1] https://xkcd.com/303/

;;; Code:

(require 'compile)

(defgroup xkcd-303-mode nil
  "Minor mode for explaining why you're not working."
  :group 'games)

(defcustom xkcd-303-mode-major-modes '(compilation-mode)
  "Major modes for which `xkcd-303-mode' will function.

Since `rgrep' buffers and others derive from `compilation-mode',
a strict list of allowed modes derived from `compilation-mode'
must be specified."
  :type '(set symbol)
  :group 'xkcd-303-mode)

(defconst xkcd-303-mode--image-path
  (expand-file-name "compiling.png"
                    (if load-file-name
                        (file-name-directory load-file-name)
                      default-directory)))

(defconst xkcd-303-mode--buffer-name " *XKCD-303*")

(defun xkcd-303-mode--compilation-start (process)
  "Function for `compilation-start-hook'.

See the hook's documentation for information on PROCESS."
  (when (memq major-mode xkcd-303-mode-major-modes)
    (let ((buf (get-buffer xkcd-303-mode--buffer-name)))
      (unless buf
        (setq buf (generate-new-buffer xkcd-303-mode--buffer-name))
        (with-current-buffer buf
          (insert-image-file xkcd-303-mode--image-path)
          (special-mode)
          (setq cursor-type nil)))
      (when-let (window (get-buffer-window (process-buffer process) t))
        (with-selected-window window
          (display-buffer buf '(display-buffer-below-selected
                                (window-height . fit-window-to-buffer)
                                (dedicated . t)
                                (inhibit-switch-frame . t)
                                (allow-no-window . t))))))))

(defun xkcd-303-mode--compilation-finish (_buffer _message)
  "Function for `compilation-finish-functions'."
  (when (memq major-mode xkcd-303-mode-major-modes)
    (when-let ((window (get-buffer-window xkcd-303-mode--buffer-name t)))
      (delete-window window))))

;;;###autoload
(define-minor-mode xkcd-303-mode
  "Minor mode for explaining why you're not working."
  :global t
  :group 'xkcd-303-mode

  (if xkcd-303-mode
      (progn
        (add-hook 'compilation-start-hook
                  #'xkcd-303-mode--compilation-start)
        (add-hook 'compilation-finish-functions
                  #'xkcd-303-mode--compilation-finish))
    (remove-hook 'compilation-start-hook
                 #'xkcd-303-mode--compilation-start)
    (remove-hook 'compilation-finish-functions
                 #'xkcd-303-mode--compilation-finish)))

(provide 'xkcd-303-mode)

;;; xkcd-303-mode.el ends here
