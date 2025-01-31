#!/opt/homebrew/bin/zsh

function zparseopts_demo() {
  local flag_help flag_verbose
  local arg_filename=(myfile)  # set a default
  local usage=(
    "zparseopts_demo [-h|--help]"
    "zparseopts_demo [-v|--verbose] [-f|--filename=<file>] [<message...>]"
  )

  # -D pulls parsed flags out of $@
  # -E allows flags/args and positionals to be mixed, which we don't want in this example
  # -F says fail if we find a flag that wasn't defined
  # -M allows us to map option aliases (ie: h=flag_help -help=h)
  # -K allows us to set default values without zparseopts overwriting them
  # Remember that the first dash is automatically handled, so long options are -opt, not --opt
  zmodload zsh/zutil
  zparseopts -D -F -K -- \
    {h,-help}=flag_help \
    {v,-verbose}=flag_verbose \
    {f,-filename}:=arg_filename ||
    return 1

  [[ -z "$flag_help" ]] || { print -l $usage && return }
  if (( $#flag_verbose )); then
    print "verbose mode"
  fi

  echo "--verbose: $flag_verbose"
  echo "--filename: $arg_filename[-1]"
  echo "positional: $@"
}

#declare -a pargs
#declare -A paargs

# -E tells zparseopts to expect options and parameters to be mixed
# -D removes all the matched options from the parameter list
zparseopts -D -E -A opts -greeting: -name:
echo "$1 $opts[--greeting], $opts[--name]"
echo $opts
