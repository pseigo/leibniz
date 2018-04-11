defmodule Leibniz.ExprTest do
  use ExUnit.Case
  doctest Leibniz.Expr

  test "expression created" do
    expr = %Leibniz.Expr{}
    refute expr == nil
  end
end
