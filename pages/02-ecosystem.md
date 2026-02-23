---
layout: center
class: text-center
---

# Ecosystem & Tooling

---
hideInToc: true
layout: two-cols
layoutClass: gap-8
---

## Robust Standard Library & Lightweight Frameworks

::left::

Go ships a **production-ready** standard library — many projects need no external dependencies for core functionality:

| Package               | Purpose                       |
| --------------------- | ----------------------------- |
| `net/http`            | HTTP server and client        |
| `database/sql`        | Generic SQL interface         |
| `log/slog`            | Structured logging (Go 1.21+) |
| `testing`             | Built-in test framework       |
| `encoding/json`       | JSON encode/decode            |
| `golang.org/x/oauth2` | OAuth2 client support         |

::right::

**Lightweight "Frameworks"** — `Gin` and `Echo` are thin routing layers on top of `net/http`, not full-stack frameworks. The standard library often suffices.

**Go Modules** make dependency management simple:

```bash
go mod init github.com/org/project
go mod tidy
go get github.com/some/package@v1.2.3
```

---
hideInToc: true
---

## SQL Ecosystem

**Query Builders & Drivers:**

| Tool       | Type                             | Description                             |
| ---------- | -------------------------------- | --------------------------------------- |
| `sqlc`     | Code generator                   | Generates type-safe Go from SQL queries |
| `sqlx`     | Driver extension                 | Extensions to `database/sql`            |
| `squirrel` | Query builder                    | Fluent SQL builder                      |
| `gorm`     | ORM                              | Full-featured ORM                       |
| `jet`      | Generated, type-safe SQL builder | Write Go just like SQL                  |

---
hideInToc: true
---

## SQL Ecosystem

**Migrations:**

| Tool             | Style                             |
| ---------------- | --------------------------------- |
| `goose`          | SQL/Go-based migrations           |
| `golang-migrate` | CLI and library                   |
| `atlasgo`        | Schema-first declarative approach |
| `tern`           | PostgreSQL                        |

---
hideInToc: true
---

## Generics (Go 1.18+)

**Generics** add type safety for reusable functions:

```go
func Max[T constraints.Ordered](a, b T) T {
    if a > b {
        return a
    }
    return b
}
```

> **Caveat:** Go's generics lack generic methods on structs. Complex patterns may require falling back to interfaces.
> More: [Why Go's Generics Might Be Worse Than No Generics at All](https://dev.to/leapcell/why-gos-generics-might-be-worse-than-no-generics-at-all-3470)

---
hideInToc: true
---

## Embedding

```
 pgmigration
   00001_init.sql
 persistencepg.go
```

```go
//go:embed pgmigration/*
var PgMigrations embed.FS

func NewGooseProvider(db *sql.DB, logger *slog.Logger) (*goose.Provider, error) {
	migrationFiles, err := fs.Sub(PgMigrations, "pgmigration")
	if err != nil {
		return nil, fmt.Errorf("failed to get migration files: %w", err)
	}
	gooseProvider, err := goose.NewProvider(
		"postgres",
		db,
		migrationFiles,
		goose.WithSlog(logger),
		goose.WithSessionLocker(locker),
	)
	if err != nil {
		return nil, fmt.Errorf("failed to create goose provider: %w", err)
	}
	return gooseProvider, nil
}
```

---
hideInToc: true
---

## Tooling & Observability

**Tooling management:**

- `go vet`, `go test`, `go build` handle most workflows natively
- Third-party tools (`sqlc`, `golangci-lint`) are managed via `mise` to avoid polluting the module graph

**Observability (OTel):**

Instrumenting Go binaries often requires eBPF (kernel intervention) and preserved symbols during compilation — Go brings its own runtime and scheduler, unlike C or Rust.

---
hideInToc: true
---

## Cloud Native Darling

Go powers the backbone of the cloud-native ecosystem:

| Project        | Domain                  |
| -------------- | ----------------------- |
| **Kubernetes** | Container orchestration |
| **Terraform**  | Infrastructure as code  |
| **Grafana**    | Observability platform  |
| **Prometheus** | Monitoring & alerting   |
| **Vault**      | Secrets management      |
| **MinIO**      | Object storage          |
| **OPA**        | Policy engine           |
