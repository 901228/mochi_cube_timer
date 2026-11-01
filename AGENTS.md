# Build IPA

When asked to build an IPA:

1. Make sure the branch is pushed, then run `gh workflow run ios.yml --ref <current-branch>`.
2. Get the run id with `gh run list --workflow ios.yml --limit 1`.
3. Start a background task with `bg_run` (`isAgent: false`) that runs `gh run watch <run-id> --exit-status`, then reports the result.
4. When the build finishes successfully, run `gh run download <run-id> -n mochi_cube_timer-ipa -D /tmp/mochi_cube_timer-ipa` and report the path.
