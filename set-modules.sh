#!/bin/sh

set -e

# replace ',' by newline, make it uppercase and prepend every item with '#define LUA_USE_MODULES_'
export X_MODULES_STRING=$(echo $X_MODULES | tr , '\n' | tr '[a-z]' '[A-Z]' | perl -pe 's/(.*)\n/#define LUA_USE_MODULES_$1\n/g')
# inject the modules string into user_modules.h between '#ifdef LUA_USE_MODULES\n' and '\n#endif /* LUA_USE_MODULES */'
# the 's' flag in '/sg' makes . match newlines
# Perl creates a temp file which is removed right after the manipulation
perl -e 'local $/; $_ = <>; s/(#ifdef LUA_USE_MODULES\n)(.*)(\n#endif \/\* LUA_USE_MODULES \*\/)/$1$ENV{"X_MODULES_STRING"}$3/sg; print' user_modules.h > user_modules.h.tmp && mv user_modules.h.tmp user_modules.h