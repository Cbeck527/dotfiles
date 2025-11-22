function colima --wraps='colima'
    if test "$argv[1]" = start -o "$argv[1]" = stop
        printf "%b[fish]%b stripping colors from colima output\n" (set_color -o blue) (set_color normal) 1>&2
        # For 'start' and 'stop' commands, pipe colima's stdout through sed
        # to strip ANSI color codes. stderr from colima will pass through.
        command colima $argv | sed -E 's/\x1B\[[0-9;]*[mK]//g'
    else
        # For other commands, run colima as usual.
        command colima $argv
    end
end
