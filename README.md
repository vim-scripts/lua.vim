# Lua file type plug-in for the Vim text editor

The [Lua][lua] file type plug-in for [Vim][vim] makes it easier to work with Lua source code in Vim by providing the following features:

 * The ['includeexpr'][inex] option is set so that the [gf][gf] (go to file) mapping knows how to resolve Lua module names using [package.path][pp]

 * The ['include'][inc] option is set so that Vim follows [dofile()][dof], [loadfile()][lof] and [require()][req] calls when looking for identifiers in included files (this works together with the ['includeexpr'][inex] option)

 * An automatic command is installed that runs `luac -p` when you save your Lua scripts. If `luac` reports any errors they are shown in the quick-fix list and Vim jumps to the line of the first error. If `luac -p` doesn't report any errors a check for undefined global variables is performed by parsing the output of `luac -p -l`

 * `<F1>` on a Lua function or 'method' call will try to open the relevant documentation in the [Lua Reference for Vim][lrv]

 * The ['completefunc'][cfu] option is set to allow completion of Lua 5.1 keywords, global variables and library members using Control-X Control-U

 * The ['omnifunc'][ofu] option is set to allow dynamic completion of the variables defined in all modules installed on the system using Control-X Control-O, however it needs to be explicitly enabled by setting the `lua_complete_omni` option because this functionality may have undesired side effects! When you invoke omni completion after typing `require '` or `require('` you get completion of module names

 * Several [text-objects][tob] are defined so you can jump between blocks and functions

 * A pretty nifty hack of the [matchit plug-in][mit] is included: When the cursor is on a `function` or `return` keyword the `%` mapping cycles between the relevant keywords (`function`, `return`, `end`), this also works for branching statements (`if`, `elseif`, `else`, `end`) and looping statements (`for`, `while`, `repeat`, `until`, `end`)

## Installation

Unzip the most recent [ZIP archive][zip] file inside your Vim profile directory (usually this is `~/.vim` on UNIX and `%USERPROFILE%\vimfiles` on Windows), restart Vim and execute the command `:helptags ~/.vim/doc` (use `:helptags ~\vimfiles\doc` instead on Windows). Now try it out: Edit a Lua script and try any of the features documented above.

## Options

The Lua file type plug-in handles options as follows: First it looks at buffer local variables, then it looks at global variables and if neither exists a default is chosen. This means you can change how the plug-in works for individual buffers. For example to change the location of the Lua compiler used to check the syntax:

    " This sets the default value for all buffers.
    :let g:lua_compiler_name = '/usr/local/bin/luac'

    " This is how you change the value for one buffer.
    :let b:lua_compiler_name = '/usr/local/bin/lualint'

### The `lua_path` option

This option contains the value of `package.path` as a string. You shouldn't need to change this because the plug-in is aware of [$LUA_PATH][pp] and if that isn't set the plug-in will run a Lua interpreter to get the value of [package.path][pp].

### The `lua_check_syntax` option

When you write a Lua script to disk the plug-in automatically runs the Lua compiler to check for syntax errors. To disable this behavior you can set this option to false (0):

    let g:lua_check_syntax = 0

You can manually check the syntax using the `:CheckSyntax` command.

### The `lua_check_globals` option

When you write a Lua script to disk the plug-in automatically runs the Lua compiler to check for undefined global variables. To disable this behavior you can set this option to false (0):

    let g:lua_check_globals = 0

You can manually check the globals using the `:CheckGlobals` command.

### The `lua_compiler_name` option

The name or path of the Lua compiler used to check for syntax errors. You can set this option to run the Lua compiler from a non-standard location or to run a dedicated syntax checker like [lualint][ll].

### The `lua_error_format` option

If you use a dedicated syntax checker you may need to change this option to reflect the format of the messages printed by the syntax checker.

### The `lua_complete_keywords` option

To disable completion of keywords you can set this option to false (0).

### The `lua_complete_globals` option

To disable completion of global functions you can set this option to false (0).

### The `lua_complete_library` option

To disable completion of library functions you can set this option to false (0).

### The `lua_complete_dynamic` option

When you type a dot after a word the Lua file type plug-in will automatically start completion. To disable this behavior you can set this option to false (0).

### The `lua_complete_omni` option

This option is disabled by default for two reasons:

 * The omni completion support works by enumerating and loading all installed modules. **If module loading has side effects this can have unintended consequences!**
 * Because all modules installed on the system are loaded, collecting the completion candidates can be slow. After the first run the completion candidates are cached so this will only bother you once (until you restart Vim).

If you want to use the omni completion despite the warnings above, execute the following command:

    :let g:lua_complete_omni = 1

Now when you type Control-X Control-O Vim will hang for a moment, after which you should be presented with an enormous list of completion candidates :-)

## Contact

If you have questions, bug reports, suggestions, etc. the author can be contacted at <peter@peterodding.com>. The latest version is available at <http://peterodding.com/code/vim/lua-ftplugin> and <http://github.com/xolox/vim-lua-ftplugin>. If you like this plug-in please vote for it on [Vim Online][script].

## License

This software is licensed under the [MIT license](http://en.wikipedia.org/wiki/MIT_License).  
© 2011 Peter Odding &lt;<peter@peterodding.com>&gt;.


[vim]: http://www.vim.org/
[lua]: http://www.lua.org/
[inex]: http://vimdoc.sourceforge.net/htmldoc/options.html#%27includeexpr%27
[gf]: http://vimdoc.sourceforge.net/htmldoc/editing.html#gf
[pp]: http://www.lua.org/manual/5.1/manual.html#pdf-package.path
[inc]: http://vimdoc.sourceforge.net/htmldoc/options.html#%27include%27
[dof]: http://www.lua.org/manual/5.1/manual.html#pdf-dofile
[lof]: http://www.lua.org/manual/5.1/manual.html#pdf-loadfile
[req]: http://www.lua.org/manual/5.1/manual.html#pdf-require
[lrv]: http://www.vim.org/scripts/script.php?script_id=1291
[cfu]: http://vimdoc.sourceforge.net/htmldoc/options.html#%27completefunc%27
[ofu]: http://vimdoc.sourceforge.net/htmldoc/options.html#%27omnifunc%27
[tob]: http://vimdoc.sourceforge.net/htmldoc/motion.html#text-objects
[mit]: http://vimdoc.sourceforge.net/htmldoc/usr_05.html#matchit-install
[zip]: http://peterodding.com/code/vim/downloads/lua-ftplugin.zip
[ll]: http://lua-users.org/wiki/LuaLint
[script]: http://www.vim.org/scripts/script.php?script_id=3625
