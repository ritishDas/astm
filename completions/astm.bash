# bash completion for astm
_astm_completions() {
    local cur prev cmd
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    cmd="${COMP_WORDS[1]}"

    # Top-level commands
    local commands="init add fetch remove list help version"

    # Provide command list when completing first argument
    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=( $(compgen -W "${commands}" -- "$cur") )
        return 0
    fi

    # -------------------------------------------------------
    # Completion per command
    # -------------------------------------------------------
    case "$cmd" in
        init)
            # init <path> → complete directories
            COMPREPLY=( $(compgen -d -- "$cur") )
            return 0
            ;;
        
        add)
            # add <name> <path>
            if [[ $COMP_CWORD -eq 2 ]]; then
                # argument 2 = name → no special completion
                return 0
            elif [[ $COMP_CWORD -eq 3 ]]; then
                # argument 3 = path
                COMPREPLY=( $(compgen -f -- "$cur") )
                return 0
            fi
            ;;

        fetch|remove)
            # fetch <name>, remove <name> → complete with stored assets
            # If you store assets in ~/.astm/assets.txt or similar,
            # adapt this command to fetch names.
            local asset_file="$HOME/.config/astm/assets.txt"
            if [[ -f "$asset_file" ]]; then
                local names
                names=$(cut -d' ' -f1 "$asset_file")
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

