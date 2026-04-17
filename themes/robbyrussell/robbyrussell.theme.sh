#! bash oh-my-bash.module

# This theme attempts to replicate the default "robbyrussell" theme from ohmyzsh:
#  https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/robbyrussell.zsh-theme

# Example outside git repo:
# ➜  ~
# Example inside clean git repo:
# ➜  config-files git:(main)
# Example inside dirty git repo:
# ➜  config-files git:(main ?:1) ✗
# Example with virtual environment:
# ➜  (env1) ~
# Example with virtual environment and inside git repo:
# ➜  (env1) config-files git:(main)
# python_venv setup
OMB_PROMPT_VIRTUALENV_FORMAT='(%s) '
OMB_PROMPT_SHOW_PYTHON_VENV=${OMB_PROMPT_SHOW_PYTHON_VENV:=true}

function _omb_theme_PROMPT_COMMAND() {
    if [[ "$?" == 0 ]]; then
        local arrow_color="${_omb_prompt_bold_green}"
    else
        local arrow_color="${_omb_prompt_bold_brown}"
    fi
    # set the python_venv format
    local python_venv; _omb_prompt_get_python_venv
    python_venv="$_omb_prompt_olive$python_venv"

    local base_directory="${_omb_prompt_bold_teal}\W${_omb_prompt_reset_color}"

    # grab repo name if inside git repository
    local repo_name=""
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        # check if there's a remote URL 
        local remote_url=$(git config --get remote.origin.url 2>/dev/null)

        # set repo_name if a remote URL exists, otherwise leave blank
        if [[ -n "$remote_url" ]]; then
            repo_name="[$(basename -s .git "$remote_url")] "
        fi
    fi
    local GIT_THEME_PROMPT_PREFIX="${_omb_prompt_bold_navy}${repo_name}| ${_omb_prompt_bold_red}"

    local SVN_THEME_PROMPT_PREFIX="${_omb_prompt_bold_navy}svn | ${_omb_prompt_bold_red}"
    local HG_THEME_PROMPT_PREFIX="${_omb_prompt_bold_navy}hg | ${_omb_prompt_bold_red}"
    local SCM_THEME_PROMPT_SUFFIX="${_omb_prompt_reset_color}"
    local SCM_THEME_PROMPT_CLEAN="${_omb_prompt_bold_navy})${_omb_prompt_reset_color}"
    local SCM_THEME_PROMPT_DIRTY="${_omb_prompt_bold_navy}) ${_omb_prompt_olive}✗${_omb_prompt_reset_color}"
    local arrow="${arrow_color}➜${_omb_prompt_reset_color}"
    local doublearrow="${arrow_color}»${omb_prompt_reset_color}"

    PS1="${arrow} ${python_venv}${base_directory} "

    local scm_info=$(scm_prompt_info)

    PS1+=${scm_info:+$scm_info }
    PS1+="${doublearrow}${_omb_prompt_normal} "
}

_omb_util_add_prompt_command _omb_theme_PROMPT_COMMAND
