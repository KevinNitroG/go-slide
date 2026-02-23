---
layout: center
class: text-center
---

# Best Practices

---
hideInToc: true
---

## Naming Conventions

**MixedCaps for acronyms** — follow Go's canonical style:

| Wrong        | Correct      |
| ------------ | ------------ |
| `XmlApi`     | `XMLAPI`     |
| `HttpServer` | `HTTPServer` |
| `MinIo`      | `MinIO`      |
| `myIos`      | `myiOS`      |

> More: [Go Style Decisions](https://google.github.io/styleguide/go/decisions.html)

---
hideInToc: true
---

## Avoiding Stuttering

**Avoid stuttering** — don't repeat the package name in exported identifiers:

| Stuttering          | Better        |
| ------------------- | ------------- |
| `user.User`         | `user.Model`  |
| `widget.NewWidget`  | `widget.New`  |
| `config.ConfigFile` | `config.File` |
| `error.ErrError`    | `error.Err`   |

> More: [Go Best Practices](https://google.github.io/styleguide/go/best-practices.html)

**Short variable names** are idiomatic for short scopes:
`i`, `r`, `c`, `w`, `err`, `ctx` — familiar, expected, and readable.

---
hideInToc: true
---

## Repository Structure

- Use a single `go.mod` when possible; use `go work` for moderate monorepos
- Organise packages by what they **provide**, not what they **contain**
- Avoid common package names: `http`, `json`, `log`, `sql`,...

```
myservice/
  cmd/server/       # entry points
  internal/         # private packages
    user/           # provides user domain
    order/          # provides order domain
  pkg/              # public reusable packages
```

---
hideInToc: true
---

## Logging

**Logging** — prefer `log/slog` (Go 1.21+):

- Structured and standardised — zero external dependency
- Use third-party (`logrus`, `zap`) only when extreme performance is required

```go
func main() {
    logger := slog.New(slog.NewJSONHandler(os.Stdout, nil))
    logger.Debug("Debug message")
    logger.Info("Info message")
    logger.Warn("Warning message")
    logger.Error("Error message")
}
```

```json
<!-- prettier-ignore-start -->
{"time":"2023-03-15T12:59:22.227408691+01:00","level":"INFO","msg":"Info message"}
{"time":"2023-03-15T12:59:22.227468972+01:00","level":"WARN","msg":"Warning message"}
{"time":"2023-03-15T12:59:22.227472149+01:00","level":"ERROR","msg":"Error message"}
<!-- prettier-ignore-end -->
```
