# Configure and activate rbenv. You know, for rubies.

export PATH=<%= scope.lookupvar("::ruby::build::prefix") %>/bin:$PATH

# Allow bundler to use all the cores for parallel installation
export BUNDLE_JOBS=<%= scope.lookupvar("::processorcount") %>

<%- if scope.lookupvar("::ruby::provider") == "rbenv" -%>
export RBENV_ROOT=<%= scope.lookupvar("::ruby::rbenv::prefix") %>
export PATH=$/bin

eval "$(rbenv init -)"

current-ruby() {
  echo "$(rbenv version-name)"
}
<%- end -%>

<%- if scope.lookupvar("::ruby::provider") == "chruby" -%>
source <%= scope.lookupvar("::ruby::chruby::prefix") %>/share/chruby/chruby.sh
<%- if scope.lookupvar("::ruby::chruby::auto_switch") -%>
source <%= scope.lookupvar("::ruby::chruby::prefix") %>/share/chruby/auto.sh
<%- end -%>

export RUBIES=(/opt/boxen/rubies/*)

current-ruby() {
  if [ -z "$RUBY_ROOT" ]; then
    echo "system"
  else
    echo "${RUBY_ROOT##*/}"
  fi
}
<%- end -%>
