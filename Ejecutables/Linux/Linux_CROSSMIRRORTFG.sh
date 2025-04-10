#!/bin/sh
echo -ne '\033c\033]0;CROSS MIRROR TFG\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Linux_CROSSMIRRORTFG.x86_64" "$@"
