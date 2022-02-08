# Rust2ex

Compiles Rust packages in `native`, installs to `_build`.

## License

Rust2ex (C) 2021-2022 Jonathan Kurtz and Roland Metivier
Please read `LICENSE` for information

## Uses

Particularly suited for Elixir-Rust ports.

## Installation

```elixir
  def project do
    [
      compilers: [:rust2ex] ++ Mix.compilers,
    ]
  end
```

Run `mix compile` then `mix compile.rust2ex`.
