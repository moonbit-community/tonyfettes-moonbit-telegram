# Target-all CI requires a target policy decision

## Summary

The requested CI template includes `moon info --target all` and `moon test --target all`.
The repository currently has `"preferred-target": "native"` in `moon.mod.json`, and the default native-oriented validation passes:

- `moon check --deny-warn`
- `moon test`

However, `moon info --target all` and `moon test --target all` fail on the wasm target.

## What fails

The wasm target fails in dependencies that use native C/FFI APIs:

- `tonyfettes/dl`: uses `extern "c"` and `@c.Pointer`, which are unsupported or unavailable on wasm.
- `tonyfettes/os`: uses `extern "c"` errno bindings and `@c.Pointer`, which are unsupported or unavailable on wasm.
- `tonyfettes/platform`: uses `extern "c"` platform probes, which are unsupported on wasm.

The bot package also fails for wasm because `moonbitlang/async/http` does not provide `@http.post` for that target in this dependency set.

Representative errors:

- `extern "C" is unsupported in wasm backend`
- `The type @c.Pointer is undefined`
- `Value post not found in package http`

## Human decision needed

The codebase appears to be native-oriented today. To make the new CI pass, choose one of these directions:

1. Keep native/default validation in CI by changing the template commands away from `--target all`.
2. Keep `--target all`, but add target restrictions or refactor native-only packages and HTTP usage so wasm is not asked to compile unsupported code.

I did not change the supplied CI template because it was provided explicitly in the task.
