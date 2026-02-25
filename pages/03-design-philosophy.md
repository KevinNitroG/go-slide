---
layout: center
class: text-center
---

# Design Choices & Philosophy

---
hideInToc: true
layout: two-cols
layoutClass: gap-8
---

## Error Handling

::left::

Go forces **explicit error acknowledgment** — there are no exceptions.

- Accept the verbosity — it forces you to think about failure paths
- Avoid libraries that "shorten" `if err != nil` — the idiom is intentional
- Minimise `Must*` functions (e.g. `template.Must`) outside package initialisation
- Use `errors` - avoid deprecated `pkg/errors`, `uber-go/multierr`, `hashicorp/go-multierror`

::right::

```go
result, err := riskyOperation()
if err != nil {
    return fmt.Errorf("context: %w", err)
}

// Must* is acceptable only in package-level init
var tmpl = template.Must(
    template.ParseFiles("index.html"),
)

// Unwrap errors
if errors.Is(err, ErrNotFound) {
    // handle specific error
}
```

---
hideInToc: true
layout: two-cols
layoutClass: gap-8
---

## Values vs Pointers

::left::

**Prefer values by default:**

- Allocate on the **stack** → less GC pressure
- No nil-checks required
- Zero-values are meaningful and heavily utilised
- Better CPU cache locality

**Use pointers only when:**

- Mutation across function calls is required
- `nil` meaningfully represents "absent/omitted"
  (zero-values like `0` or `""` can be ambiguous)

::right::

```go
// Value — zero-value is intentional
type Config struct {
    Port    int    // 0 = use default
    Host    string // "" = localhost
    Debug   bool   // false = disabled
}

// Pointer — nil carries meaning
type Record struct {
    CreatedAt time.Time  // always set
    DeletedAt *time.Time // nil = not deleted
}
```

> More: [r/golang — Values or Pointers for Domain Models?](https://www.reddit.com/r/golang/comments/1qsgwdj)

---
hideInToc: true
---

## Other Design Choices

**`any` vs `interface{}`** — `any` is an alias for `interface{}` introduced in Go 1.18 for readability. They are identical.

**Struct Tags** — metadata on fields, parsed at runtime via reflection:

```go
type User struct {
    ID    int    `json:"id" db:"user_id"`
    Name  string `json:"name"`
    Email string `json:"email,omitempty"`
}
```

> Mixing domain models with JSON/DB tags is considered an anti-pattern by purists — it couples infrastructure concerns to the domain.

**Nil Checks** — Go has no `Option`/`Result` type. Manual nil-checks are required. Use `golangci-lint` to catch missing checks.

---
hideInToc: true
layout: two-cols
layoutClass: gap-8
---

## Formatting & Interface Composition

**`gofmt`** — enforces 8-space tabs and canonical formatting. No debates, no configuration.

**Multiple Interface Embedding** — polymorphism via composing small, granular interfaces:

::left::

```go
// io package
type Reader interface {
    Read(p []byte) (n int, err error)
}

type Writer interface {
    Write(p []byte) (n int, err error)
}

type ReadWriter interface {
    Reader
    Writer
}
```

::right::

Example satisfies above interfaces:

```go
type File struct {
    // ...
}

var _ io.Reader = (*File)(nil) // compile-time check
var _ io.Writer = (*File)(nil)
// or
var _ io.ReadWriter = (*File)(nil)

func (f *File) Read(p []byte) (n int, err error) {
    // ...
}

func (f *File) Write(p []byte) (n int, err error) {
    // ...
}
```
