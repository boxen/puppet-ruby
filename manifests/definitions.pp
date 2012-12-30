# Custom ruby-build definitions for custom ruby versions

class ruby::definitions {
  ruby::definition { ls("${settings::modulepath}/ruby/files/definitions", 1): }

  Ruby::Definition <| |> -> Ruby <| |>
}