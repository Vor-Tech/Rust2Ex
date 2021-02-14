defmodule Mix.Tasks.Compile.Rust2ex do
  use Mix.Task
  @moduledoc "Compiles Rust packages in `native`, installs to `_build`"

  defp compile_dep(where) do
    {_, code} = System.cmd("cargo", ["build", "--manifest-path", where])

    case code do
      0 ->
        System.cmd("cargo", [
          "install",
          "--path",
          Path.dirname(where),
          "--root",
          to_string(:code.priv_dir(Mix.Project.config[:app]())),
          if(Mix.env() == :prod, do: "", else: "--debug")
        ])

        :ok

      fail ->
        {:error, fail}
    end
  end

  @spec run(any) :: :error | :ok
  def run(_args) do
    IO.puts("Running rust2ex")
    oks = Path.wildcard(Path.join(["native", "*", "Cargo.toml"])) |> Enum.map(&compile_dep/1)

    cond do
      oks |> Enum.all?(fn x -> x == :ok end) ->
        IO.puts(["Rust2ex completed with", length(oks), "Rust packages"] |> Enum.join(" "))
        :ok

      true ->
        :error
    end
  end
end
