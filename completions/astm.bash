# bash completion for astm
_astm_completions() {
    local cur prev cmd
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    cmd="${COMP_WORDS[1]}"

    # Top-level commands
    local commands="init add fetch remove list help version"

    # First argument → suggest commands
    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=( $(compgen -W "${commands}" -- "$cur") )
        return 0
    fi

    # -------------------------------------------------------
    # Completion per command
    # -------------------------------------------------------
    case "$cmd" in
        init)
            # init <path> → directories only
            COMPREPLY=( $(compgen -d -- "$cur") )
            return 0
            ;;

        add)
            # add <name> <path>
            if [[ $COMP_CWORD -eq 2 ]]; then
                # name → free text
                return 0
            elif [[ $COMP_CWORD -eq 3 ]]; then
                # path → files or directories
                COMPREPLY=( $(compgen -f -- "$cur") )
                return 0
            fi
            ;;

        fetch|remove)
            # fetch/remove <name> → use dynamic names from `astm list`
            local names

            # Capture output safely
            names=$(astm list 2>/dev/null | awk '{print $1}')

            if [[ -n "$names" ]]; then
                COMPREPLY=( $(compgen -W "${names}" -- "$cur") )
            fi
            return 0
            ;;

        *)
            return 0
            ;;
    esac
}

complete -F _astm_completions astm

