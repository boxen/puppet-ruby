# Put ruby-build on PATH
export PATH=<%= scope.lookupvar("::ruby::build::prefix") %>/bin:$PATH

# Allow bundler to use all the cores for parallel installation
export BUNDLE_JOBS=<%= scope.lookupvar("::processorcount") %>

<%- if scope.lookupvar("::ruby::provider") == "rbenv" -%>
# Configure RBENV_ROOT and put RBENV_ROOT/bin on PATH
export RBENV_ROOT=<%= scope.lookupvar("::ruby::rbenv::prefix") %>
export PATH=$RBENV_ROOT/bin:$PATH

# Load rbenv
eval "$(rbenv init -)"

# Helper for shell prompts and the like
current_ruby() {
  echo "$(rbenv version-name)"
}
<%- end -%>

<%- if scope.lookupvar("::ruby::provider") == "chruby" -%>
# Load chruby
source <%= scope.lookupvar("::ruby::chruby::prefix") %>/share/chruby/chruby.sh
<%- if scope.lookupvar("::ruby::chruby::auto_switch") -%>

# Auto-switch chruby versions using .ruby-version files
source <%= scope.lookupvar("::ruby::chruby::prefix") %>/share/chruby/auto.sh
<%- end -%>

# Load global rubies
RUBIES=(/opt/rubies/*)
export RUBIES

# Helper for shell prompts and the like
current-ruby() {
  if [ -z "$RUBY_ROOT" ]; then
    echo "system"
  else
    echo "${RUBY_ROOT##*/}"
  fi
}
<%- end -%>
