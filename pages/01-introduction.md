---
layout: center
class: text-center
---

# Introduction to Go

---
hideInToc: true
---

## Structs & Composition

Go has no classes. Data is defined with **structs**, and behaviour is attached via **methods**.

**Composition** is achieved by embedding one struct into another — no `extends` keyword needed.

```go
type Animal struct {
    Name string
}

// Composition via embedding
type Dog struct {
    Animal        // promoted fields & methods
    Breed  string
}

d := Dog{
    Animal: Animal{Name: "Rex"},
    Breed:  "Labrador",
}
fmt.Println(d.Name) // "Rex"
```

---
hideInToc: true
---

## Type Conversions & Visibility

**Type conversions** are always explicit:

```go
var f float64 = 3.14
i := int(f) // must be explicit
```

**Visibility** is determined by capitalisation — no `public`/`private` keywords:

```go
type PublicStruct struct { // exported
    PublicField  string    // exported
    privateField int       // unexported
}

func privateHelper() {} // unexported
func PublicAPI() {}     // exported
```

---
hideInToc: true
layout: two-cols
layoutClass: gap-8
---

## Concurrency: Goroutines & Channels

::left::

Goroutines are **lightweight threads** managed by the Go runtime. They are trivially easy to spawn with the `go` keyword.

Channels provide type-safe communication between goroutines — no shared memory, no locks needed for simple cases.

> Goroutines start with a 2 KB stack and grow as needed. You can spawn thousands with minimal overhead.

::right::

```go
// Spawn a goroutine
go processRequest(req)

// Communicate via channels
ch := make(chan string)

go func() {
    ch <- "result"
}()

result := <-ch
fmt.Println(result) // "result"

// Buffered channel
jobs := make(chan int, 100)
```

---
hideInToc: true
layout: two-cols
layoutClass: gap-8
---

## Formatting Verbs & Zero Values

::left::

**Common formatting verbs:**

| Verb | Meaning        | Example                      |
| ---- | -------------- | ---------------------------- |
| `%s` | string         | `"hello"`                    |
| `%d` | integer        | `42`                         |
| `%t` | boolean        | `true`                       |
| `%q` | quoted string  | `"quoted"`                   |
| `%w` | error wrapping | `fmt.Errorf("msg: %w", err)` |

::right::

**Zero values** — every type has a meaningful default, heavily relied upon in Go:

```go
var i int     // 0
var s string  // ""
var b bool    // false
var p *int    // nil

type Config struct {
    Port    int    // 0
    Timeout int    // 0
    Debug   bool   // false
}
// All fields usable without explicit initialisation
cfg := Config{}
```
