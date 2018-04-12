defmodule Leibniz.Linear do
  @doc """
  Solve a linear equation with one variable, returns a fraction with the value
  of the variable

  ## Parameters

  - `right` - a list containing expression structs that represent the
    expression on the right side of =
  - `left` - a list containing expression structs that represent the
    expression on the right side of =

  ## Examplea

      # x + 3 = 5
      iex> Leibniz.Linear.solve(Leibniz.Expr{[{4, "x", 1}]}, [{16, "x", 0}])
      4
  """
  def solve(right, left, var) when is_binary(var) do
      left = regroup(left)
      right = regroup(right)
  end

  def regroup(expr, var) do
    degree = expr_degree(expr)
    do_regroup(expr, %Leibniz.Expr{}, degree, var)
  end

  defp do_regroup(_, new_expr, current_exponent, _) when current_exponent < 0 do
    new_expr
  end

  defp do_regroup(expr, new_expr, current_exponent, var) do
    sum = sum_of_simlilar_term(expr, current_exponent)
    new_expr = %Leibniz.Linear{terms: [{sum, var, current_exponent} | new_expr.terms]}
    do_regroup(expr, new_expr, current_exponent - 1, var)
  end

  defp sum_of_simlilar_terms(expr, current_exponent) do
    expr = Enum.filter(expr.terms, fn(term) ->
             {_, _, exponent} = term
             exponent == current_exponent
           end)

    coefficients = for term <- expr.terms, exponent?(term, current_exponent) do
                     {coefficient, _, _} = term
                     coefficient
                   end

    Enum.sum(coefficients)
  end

  def exponent?(term, exponent) do

  end

  def expr_degree(expr) do
    exponents = for {_, _, exponent} <- expr.terms do
                  exponent
                end
    Enum.max(exponents)
  end
end
