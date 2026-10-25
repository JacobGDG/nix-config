# Stub secrets

Placeholders mirroring the file names in the private `nix-secrets` repo, so
the flake can be evaluated and built without access to it. agenix only decrypts
at activation, so builds never read these.

```sh
nix flake check --override-input secrets path:./ci/stub-secrets
```

Add a placeholder here whenever a new secret is referenced.
