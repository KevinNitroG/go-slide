---
layout: center
class: text-center
---

# Writing Libraries & Releasing

---
hideInToc: true
---

## Godoc & Documentation

Go documentation is **tied directly to source code comments** — no separate doc files needed.

Write a full sentence starting with the exported identifier's name:

```go
// Request represents an HTTP request to the API.
// It holds the method, path, and optional body.
type Request struct {
    Method string
    Path   string
    Body   io.Reader
}

// NewRequest creates a new Request with the given method and path.
func NewRequest(method, path string) *Request {
    return &Request{Method: method, Path: path}
}
```

Running `go doc` or publishing to [pkg.go.dev](https://pkg.go.dev) automatically generates clean HTML documentation.

Read **Effective Go** for canonical idioms: https://go.dev/doc/effective_go

---
hideInToc: true
---

## Releasing a Library & CLI Tool

**Releasing a library** — push a Git tag:

```bash
git tag v1.2.3
git push origin v1.2.3
# Users run:
go get github.com/org/pkg@v1.2.3
```

`go get` fetches source code **directly from version control** — no registry upload required.

**Releasing a CLI tool** — compile a static binary:

```bash
# Cross-compile for Linux on any OS
GOOS=linux GOARCH=amd64 \
  go build -o myapp ./cmd/myapp
```

---
hideInToc: true
---

## Injecting Build Data at Compile Time

Inject build metadata via `ldflags`:

```bash
go build \
  -ldflags "-X main.version=1.2.3 \
            -X main.commit=abc123" \
  ./cmd/myapp
```

```go
var (
    version = "dev"
    commit  = "none"
)

func main() {
    fmt.Printf("v%s (%s)\n", version, commit)
}
```

Automate with **GoReleaser** for cross-platform builds, changelogs, and GitHub releases.
