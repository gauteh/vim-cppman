# vim-cppman

A plugin for using [*cppman*](https://github.com/aitjcize/cppman) from within
Vim. *cppman* is used to lookup "C++ 98/11/14 manual pages for Linux/MacOS"
through either [cplusplus.com](https://cplusplus.com) or
[cppreference.com](https://cppreference.com).

<img src="https://raw.githubusercontent.com/gauteh/vim-cppman/master/example.png"></img>

Originally *cppman* uses Vim to page and syntax highlight the man page, but it
is not set up to be used in buffer in an existing VIM instance. That is what
this small plugin does.

This is heavily based on the existing
[cppman.vim](https://github.com/aitjcize/cppman/blob/master/cppman/lib/cppman.vim)
which is used for the Vim pager.

## Usage

The `keywordprg` and `iskeyword`settings are automatically set for `C++` and `C` files. Otherwise use the same keybindings as in *cppman*:

Move the cursor to the keyword and hit `K` to lookup the keyword in a new buffer.

You can also use e.g. `:Cppman iostream` to lookup a keyword.


## Installation

  1.) Install [cppman](https://github.com/aitjcize/cppman)

  2.) Install this plugin using your favourite plugin manager.

