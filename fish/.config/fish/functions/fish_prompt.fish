function fish_prompt
    set -l last_status $status
    set -l normal (set_color normal)
    set -l cyan (set_color cyan)
    set -l gray (set_color 666)
    
    # First line: Directory + Separator bar
    set -l pwd (prompt_pwd)
    set -l pwd_len (string length "$pwd")
    
    echo -n "$cyan$pwd "
    
    # Fill remaining columns with a bar
    echo -n $gray
    # Ensure math results in at least 0
    set -l remaining (math $COLUMNS - $pwd_len - 1)
    if test $remaining -gt 0
        for i in (seq $remaining)
            echo -n "─"
        end
    end
    echo -e "$normal"

    # Second line: Simple prompt
    if test $last_status -ne 0
        set_color red
    else
        set_color blue
    end
    
    echo -n "󰄾 "
    set_color normal
end
