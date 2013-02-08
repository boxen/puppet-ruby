# Configure and activate rbenv. You know, for rubies.

export RBENV_ROOT=$BOXEN_HOME/rbenv

export PATH=$BOXEN_HOME/rbenv/bin:$BOXEN_HOME/rbenv/plugins/ruby-build/bin:$PATH

eval "$(rbenv init -)"
