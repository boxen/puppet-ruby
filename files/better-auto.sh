unset RUBY_AUTO_VERSION

: ${PREEXEC_FUNCTIONS:=""}

function chruby_auto() {
  local dir="$PWD"
  local version

  until [[ -z "$dir" ]]; do
    if { read -r version <"$dir/.ruby-version"; } 2>/dev/null; then
      if [[ "$version" == "$RUBY_AUTO_VERSION" ]]; then return
      else
        RUBY_AUTO_VERSION="$version"
        chruby "$version"
        return $?
      fi
    fi

    dir="${dir%/*}"
  done

  if { read -r version <"$CHRUBY_ROOT/version"; } 2>/dev/null; then
    if [[ "$version" == "$RUBY_AUTO_VERSION" ]]; then return
    else
      RUBY_AUTO_VERSION="$version"
      chruby "$version"
      return $?
    fi
  fi

  if [[ -n "$RUBY_AUTO_VERSION" ]]; then
    chruby_reset
    unset RUBY_AUTO_VERSION
  fi
}

if [[ -n "$ZSH_VERSION" ]]; then
  if [[ ! "$preexec_functions" == *chruby_auto* ]]; then
    preexec_functions+=("chruby_auto")
  fi
elif [[ -n "$BASH_VERSION" ]]; then
  if [[ -n "$PREEXEC_FUNCTIONS" ]]; then
    PREEXEC_FUNCTIONS="${PREEXEC_FUNCTIONS}; [[ \"\$BASH_COMMAND\" != \"\$PROMPT_COMMAND\" ]] && chruby_auto"
  else
    PREEXEC_FUNCTIONS="[[ \"\$BASH_COMMAND\" != \"\$PROMPT_COMMAND\" ]] && chruby_auto"
  fi

  trap 'eval "$PREEXEC_FUNCTIONS"' DEBUG
fi
