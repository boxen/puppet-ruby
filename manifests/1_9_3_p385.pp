# Installs ruby 1.9.3p385 from rbenv.
#
# Usage:
#
#     include ruby::1_9_3_p385

class ruby::1_9_3_p385 {
  ruby::version { '1.9.3-p385': }
}
