#!/usr/bin/env bash

set -e

submodule_checkout() {
  MODULE_NAME="$1"
  MODULE_DIR="$2"
  SSH_KEY="$3"

  mkdir -p "$HOME/.ssh"
  KEY_PATH="$HOME/.ssh/id_$MODULE_NAME"

  echo "Checking out $MODULE_NAME in $MODULE_DIR using $KEY_PATH"

  printf "%s\n" "$SSH_KEY" > "$KEY_PATH"
  chmod 600 "$KEY_PATH"
  GIT_SSH_COMMAND="ssh -i $KEY_PATH" git submodule update --init "$MODULE_DIR"
  rm "$KEY_PATH"
}

checkout_submodules() {
  echo ""
  echo "Checking out submodules in $(pwd)"

  for module_path in $(git submodule status | awk '{ print $2 }') ; do
    module_name=$(basename "$module_path")
    module_name_snake_case=${module_name//-/_}
    env_var_name="DT_${module_name_snake_case^^}"
    deploy_token=$(eval "printf \"%s\" \"\$$env_var_name\"")
    if [ -z "$deploy_token" ]; then
      echo "[WARNING] Env variable $env_var_name not provided, skipping submodule $module_name in $module_path"
    else
      submodule_checkout "$module_name_snake_case" "$module_path" "$deploy_token"

      pushd "$module_path"
      checkout_submodules
      popd
    fi
  done
}

checkout_submodules
