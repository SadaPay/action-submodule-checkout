# action-submodule-checkout

Action to automatically checkout git submodules

## Use

```yaml
      - name: Checkout submodules
        env:
          <env-var>: ${{ secrets.<deploy-token-name> }}
        uses: SadaPay/action-submodule-checkout@323dc5d3222212f7b8ef99e5cb883059e09cda34
```

where `<env-var>` is a variable in the format `DT_<MODULE_NAME>` (`MODULE_NAME`
is the name of the module the deploy token gives access to and it uses uppercase
snake case). For example if your submodule is called `tf-aws-core-network` the
variable should be `dt_tf_aws_core_network`, and should contain the SSH key to
be able to checkout the related git repo.

Note that if a key for a submodule is not defined, it will be skipped, the
action will not return an error.
