Create a plan for quick, simple go language introduction, maybe skipping the beginner stuff, just kinda best practices
Here is raw plan in Vietnamese, but you have to write in English:

---

1. Intro

- Go struct, thay vì class
- Composition over inheritance, nhái inherit bằng embed struct
- Type casting
- các thể loại %s %d %w %q %t, giải thích
- Public/Private bằng hoa
  > Ví dụ:...
- concurrency rất dễ dùng, goroutine handle dễ
  > Ví dụ:...
- Hệ sinh thái ít, framework như gin cũng chỉ là framework ở tầng trên http
- Otlp nhúng khó khăn cần phải can thiệp kernel và compile giữ symbol thì mới instrument được (C++ rust có thế không?)
  > Cần tham khảo thêm và tái nhận định
- SQL: Sqlc, sqlx, jetstack, gorm, squirrel
- SQL migration: goose, migrate, atlasgo
  > Giới thiệu thêm về cách dùng, ưu nhược điểm của từng cái, như atlasgo là schema first; migrate thì có thể viết migration bằng go, sql bằng goose
- Thư viện builtin như test, http, slog, database/sql, oauth
- Generic được giới thiệu từ go 1.18
  > Nói thêm về ưu nhược điểm của generic
  > https://dev.to/leapcell/why-gos-generics-might-be-worse-than-no-generics-at-all-3470
- con trỏ của giá trị kiểu đư liệu nguyên tố khó khăn, phải dùng k8s utils, nhưng go 1.26 đã hỗ trợ
- K8s, kube, terraform cli, grafana stack, prometheus, goauthentik, minio, vault, open policy agent, open telemetry, v.v. đều dùng go
- Go mod, go mod tidy, dễ dàng quản lý dependencies
- Go tools support về sau, trước đó không có go tools, cần trick 1 package (folder) để thêm, nhưng ảnh hưởng đến dependencies graph. Tuy nhiên vẫn có một số tool không dùng qua go tool được như sqlc, có thể quản lý bằng mise
- Go embed có thể nhúng thứ khác vô compile rất tiện, khác runtime

2. Explain some design choices

- Any = interface{}, giữ nguyên để compat
- go struct tag khó hơn annotation nhưng không bị phụ thuộc vào thư viện dù là dùng thư viện. Thích hợp cho ai muốn annotate tầng domain, nhưng thực tế thì không nên
- Error handling trong go, nhưng phải chấp nhận verbose, không nên shorten bằng thư viện. Cũng hạn chế dùng must\* như là MustCompile
- Tự check nil, không thì panic (không như rust), có thể dùng linter khắc phục 1 phần
- syntax go là tab 8 (không phải space). Lý do ngôn ngữ đơn giản nên tab cho nhớ. Và vì thế nên các biểu thức toán không có cách vì thường biểu thức dài, viết tràn màn
- Multi inherit? Thực tế là embed nhiều interface vô?
  > https://gemini.google.com/share/c8618bb9e2d8
- 2 trường phái default value và con trỏ
  > Default value không phân biệt được giữa giá trị 0 và không có giá trị (như null và undefined trong js)
  > Con trỏ sẽ chậm hơn vì GC phải quản lý, nhưng không nên lo ngại
  > https://www.reddit.com/r/golang/comments/1qsgwdj/do_you_use_pointers_or_values_for_your_domain/

3. Best practices

- iOS, IOS, MinIO, minio
  > https://google.github.io/styleguide/go/decisions.html
  > https://google.github.io/styleguide/go/best-practices.html
- shorten variable cho struct in, param hạn chế, có những từ viết tắt dc theo tiêu chuẩn
- Monorepo với go work nhưng nếu không quá to thì nên 1 go mod
- Flow kubernetes gộp tại monorepo và dùng bot sync ra single repo để release (version chung hay riêng thì không biết)
- Folder structure đơn giản, nhiều repo để phẳng ra repo (swag, …?), không thì có go standard structure layout. Thiết kế package dựa trên cách dùng, cách package được import. Khó nói. Hạn chế đặt trùng các package có tên chung như http, database, sql, json
- Logrus, uberzap nhanh, nhưng có thể dùng builtin slog vì nó đã là standard
- pkg/errors, uber-go/multierr, hashicorp/go-multierror không nên xem nữa, hãy dùng builtin error with %w %v
- Đã chia theo pkg mang tên đó rồi thì ko nên ghi prefix suffix vào trong object nữa. Vì package đã thể hiện dc điều đó.

4. Writing library, releasing...

- https://go.dev/doc/effective_go
  > List a few
- Go docs reference bằng comment trong go và release nó sẽ tự tạo docs
- Release bằng cách git tag, người khác down về như ngôn ngữ interprete src code bình thường. Còn không release bin
- Nhúng giá trị vào variable như version, build tag tự nó infer từ vcs được.
  > Lazygit: https://github.com/jesseduffield/lazygit/blob/818ca17f9a91d9c4b3be22bfd6d08fabe9f8ff40/.goreleaser.yml#L18

5. Why choose go

- lý do cli dùng nhiều vì compile nhanh, ra 1 cục là cầm chạy được, không phải tìm kiếm version runtime vì đã embed runtime vào
- Ngôn ngữ syntax đơn giản, mới học sẽ không thấy giống ngôn ngữ nào cả. Nhưng syntax đơn giản không magic, không decorator vào class hay function như các ngôn ngữ khác, nên viết code rất tường minh, nhưng dài
- the primegean nói go nằm giữa python, node, go, rust/zig
- Lấy benchmark so nodejs với python, rust về mem + khả năng io, cpu bound

---

You need to rewrite the plan in detail to make slidev slide. Use your tools to browse those website links.
