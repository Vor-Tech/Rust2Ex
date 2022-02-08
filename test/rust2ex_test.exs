# Rust2ex (C) 2021-2022 Jonathan Kurtz and Roland Metivier
# Please read `LICENSE` for information

defmodule Rust2exTest do
  use ExUnit.Case, async: true
  doctest Mix.Tasks.Compile.Rust2ex

  test "fails to compile a Rust package" do
    assert Mix.Tasks.Compile.Rust2ex.run([Path.join(["native", "test0_fail"])]) == :error
  end

  test "compiles a Rust package" do
    assert Mix.Tasks.Compile.Rust2ex.run([Path.join(["native", "test1_pass"])]) == :ok
  end
end
