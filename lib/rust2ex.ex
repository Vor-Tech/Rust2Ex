# Rust2ex (C) 2021-2022 Jonathan Kurtz and Roland Metivier
# Please read `LICENSE` for information

defmodule Mix.Tasks.Compile.Rust2ex do
  require Logger
  use Mix.Task
  @moduledoc "Compiles Rust packages with the paths passed in args, installs to `_build`"

  defp compile_dep(where) do
    {_, code} = System.cmd("cargo", ["build", "-q", "--manifest-path", where])

    case code do
      0 ->
        where_path = Path.dirname(where)

        System.cmd("cargo", [
          "install",
          "-q",
          "--path",
          where_path,
          "--root",
          to_string(:code.priv_dir(Mix.Project.config()[:app])),
          if(Mix.env() == :prod, do: "", else: "--debug")
        ])

        Logger.debug("Rust2ex compiled #{where_path} successfully")

        :ok

      fail ->
        Logger.warning(
          "Rust2ex Rust package at `#{Path.dirname(where)}` failed compiling with exit code #{fail}"
        )

        {:error, fail}
    end
  end

  @impl Mix.Task
  def run(args) do
    Logger.info("Starting Rust2ex")

    oks =
      for path <- args do
        Path.wildcard(Path.join([path, "*", "Cargo.toml"]))
      end
      |> List.flatten()
      |> Enum.map(&compile_dep/1)

    cond do
      oks |> Enum.all?(&(&1 == :ok)) ->
        Logger.info("Rust2ex successfully compiled #{length(oks)} Rust packages")
        :ok

      true ->
        Logger.error("Rust2ex failed to compile some Rust packages")
        :error
    end
  end
end
