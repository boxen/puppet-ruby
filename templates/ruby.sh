# Configure and activate rbenv. You know, for rubies.

export RBENV_ROOT=$BOXEN_HOME/rbenv

export PATH=$BOXEN_HOME/rbenv/bin:$BOXEN_HOME/rbenv/plugins/ruby-build/bin:$PATH

# Allow bundler to use all the cores for parallel installation
export BUNDLE_JOBS=<%= scope.lookupvar("::processorcount") %>

eval "$(rbenv init -)"
