# Presentation Plan: Go Language – A Pragmatic Introduction & Best Practices

## Slide 1: Introduction to Go

- **Structs over Classes**: Go doesn't have classes; it uses `structs` to define data.
- **Composition over Inheritance**: There is no `extends` keyword. Go simulates inheritance by embedding structs within one another.
- **Type Casting**: Explicit type conversions (e.g., `int(myFloat)`).
- **Formatting Verbs**: Overview of common string formats:
  - `%s` (string), `%d` (integer), `%w` (error wrapping), `%q` (quoted string), `%t` (boolean).
- **Visibility**: No `public`/`private` keywords. Capitalization dictates visibility (e.g., `MyStruct` is public, `myStruct` is private).
- **Concurrency**: First-class support with `goroutines` and channels. Goroutines are lightweight and extremely easy to spawn (`go myFunction()`).

## Slide 2: Ecosystem & Tooling

- **Lightweight Frameworks**: The ecosystem prefers minimal abstractions. "Frameworks" like `Gin` or `Echo` are essentially just routing layers on top of the standard `net/http`.
- **Observability (OTel)**: Unlike C++ or Rust, instrumenting Go binaries with OpenTelemetry often requires eBPF (kernel intervention) and preserving symbols during compilation, since Go brings its own runtime and scheduler.
- **SQL Ecosystem**:
  - _Query Builders & Drivers_: `sqlc` (generates Go from SQL), `sqlx` (extensions to standard lib), `squirrel` (fluent query builder), `gorm` (fully-featured ORM).
  - _Migrations_: `goose` (SQL/Go migrations), `golang-migrate` (CLI & library), `atlasgo` (schema-first declarative approach).
- **Robust Standard Library**: Provides production-ready tools out of the box, including `testing`, `net/http`, `log/slog` (structured logging), `database/sql`, etc.
- **Generics (Go 1.18+)**:
  - Adds type safety for general-purpose functions (e.g. `Max[T constraints.Ordered]`).
  - _Caveat_: Go's generic constraint system is currently simpler than Rust's Traits or TypeScript's structural types. It lacks generic methods on structs, meaning some complex patterns are difficult to express without falling back to interfaces.
    > More info: https://dev.to/leapcell/why-gos-generics-might-be-worse-than-no-generics-at-all-3470
- **Pointers to Primitives**: Historically required utility functions (e.g., `k8s.io/utils/ptr.To(true)`) to get a pointer to a primitive literal.
- **Cloud Native Darling**: Kubernetes, Terraform, Grafana, Prometheus, MinIO, Vault, and OPA are all built in Go.
- **Go Modules**: `go mod init`, `go mod tidy`. Very straightforward dependency management.
- **Tooling Management**: Go tools handle most workflows natively, but third-party binaries (like `sqlc` or `golangci-lint`) are often managed via `mise` instead of polluting the module graph.
- **Go Embed**: Native `//go:embed` directive makes compiling static assets (HTML/CSS, configs) directly into the binary trivially easy.

## Slide 3: Design Choices & Philosophy

- **`any` vs `interface{}`**: `any` is simply an alias for `interface{}` introduced for readability, maintaining backward compatibility.
- **Struct Tags**: Go uses string literal tags (e.g., `json:"name"`) instead of decorators/annotations. They are tied to the struct field and parsed at runtime via reflection, avoiding library dependencies directly inside domain models (though polluting domain models with JSON tags is still considered an anti-pattern by purists).
- **Error Handling**: Very explicit. Go forces developers to acknowledge errors (`if err != nil`).
  - Accept the verbosity. Avoid third-party libraries designed to "shorten" error handling.
  - Minimize the use of `Must*` functions (e.g., `template.MustCompile`) outside of package initialization.
- **Nil Checks**: Go does not have a `Result` or `Option` type like Rust. Developers must manually check for `nil` to avoid runtime panics. Linters (`golangci-lint`) help mitigate this.
- **Syntax Specifics**: `gofmt` enforces 8-space tabs. Mathematical expressions are rarely spaced out in order to keep long formulas visually grouped.
- **Multiple Inheritance**: Go achieves interface polymorphism by embedding multiple granular interfaces into a single struct/interface.
- **Values vs Pointers (Domain Models)**:
  - _Values_: Preferred by default. They eliminate nil-checks, reduce Garbage Collection (GC) pressure by allocating on the stack, and improve CPU cache hits. Default values (zero-values) are heavily utilized.
  - _Pointers_: Should be reserved strictly for when mutation is required, or when `nil` meaningfully represents "not found/omitted" (as zero-values like `0` or `""` can be ambiguous).
    > More info: https://www.reddit.com/r/golang/comments/1qsgwdj/do_you_use_pointers_or_values_for_your_domain/

## Slide 4: Best Practices

> [!NOTE]
> More references:
> https://google.github.io/styleguide/go/decisions.html
> https://google.github.io/styleguide/go/best-practices.html
> https://go.dev/doc/effective_go

- **Naming Conventions**:
  - Follow `MixedCaps` for acronyms: e.g., `iOS`, `MinIO`, `XMLAPI` (Not `XmlApi`).
  - Keep variable scopes in mind: use short variables (like `c` for count, `r` for receiver) for short scopes.
- **Stuttering**: Avoid repetitive names. Instead of `user.User`, use `user.Model`. Instead of `widget.NewWidget`, use `widget.New`.
- **Repository Structure**:
  - Use `go work` for moderate monorepos, or stick to a single `go.mod` if possible.
  - For standard web services, utilize flat structures or standard project layouts. Organize packages by what they _provide_, not what they _contain_.
  - Avoid generic package names like `util`, `common`, or `helper`.
- **Logging**: Prefer the built-in `log/slog` (standardized structured logging) over third-party alternatives like `logrus` or `zap`, unless extreme performance is demanded.
- **Error Wrapping**: Use the built-in `fmt.Errorf("... %w", err)` instead of deprecated libraries like `pkg/errors` or `multierr`.

## Slide 5: Writing Libraries & Releasing

- **Effective Go**: Encourage reading standard documentation for canonical idioms.
- **Godoc**: Documentation is inherently tied to source code comments. Writing a full sentence starting with the function name (e.g., `// Request represents...`) above an exported symbol will automatically generate clean HTML docs.
- **Releasing**:
  - Libraries are released simply by pushing Git tags (e.g., `v1.2.3`). `go get` fetches source code directly from version control.
  - CLI tools are compiled and released as static binaries.
- **Injecting Build Data**: You can embed VCS information directly into your binaries at compile time using `ldflags` (e.g., `go build -ldflags "-X main.version=1.0.0"`). Tools like `GoReleaser` automate this.
  > Reference: Lazygit: https://github.com/jesseduffield/lazygit/blob/818ca17f9a91d9c4b3be22bfd6d08fabe9f8ff40/.goreleaser.yml#L18

## Slide 6: Why Choose Go?

- **Self-Contained Executables**: Cross-compilation produces a single static binary with the runtime embedded. No need to install Node/Python environments on the target machine.
- **Simplicity**: The syntax is deliberately sparse. There is no magic—no decorators, no hidden operator overloading. Code is slightly longer but immensely readable and maintainable.
- **The "Sweet Spot"**: Go sits comfortably between high-level scripting languages (Python/Node) and low-level systems languages (Rust/C++).
- **Performance**: Drastically outperforms Node.js and Python in CPU-bound and heavily concurrent I/O workloads, while utilizing far less memory.
