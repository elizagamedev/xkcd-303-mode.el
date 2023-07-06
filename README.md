# xkcd-303-mode.el

![xkcd comic #303](compiling.png)

As long as `xkcd-303-mode` is active, when a compilation process is running in a
compilation buffer, [xkcd comic #303](https://xkcd.com/303/) will appear in a
window below it.

The display behavior of the popup buffer can be controlled by
`display-buffer-alist`. For example, to have the buffer appear above the
compilation window rather than below...

```elisp
(setq display-buffer-alist
      '((" \\*XKCD-303\\*"
         (display-buffer-in-direction)
         (direction . above))
        ;; Etc...
        ))
```

You may also need to configure `xkcd-303-mode-major-modes` if you use a special
major mode for compilation instead of the basic `compilation-mode`.

## Installing

This package is not yet available on M?ELPA. In the meantime, you can use
something like [straight.el](https://github.com/radian-software/straight.el) or
[elpaca.el](https://github.com/progfolio/elpaca). Here is an example with elpaca
and [use-package.el](https://github.com/jwiegley/use-package):

```elisp
(use-package xkcd-303-mode
  :elpaca (:host github :repo "elizagamedev/xkcd-303-mode.el"
                 :files ("*.el" "compiling.png"))
  :init
  (xkcd-303-mode 1))
```
