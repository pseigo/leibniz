defmodule Leibniz.Linear do
  @doc """
  Solve a linear equation with one variable, returns a fraction with the value
  of the variable

  ## Parameters

  - `right` - a list containing expression structs that represent the
    expression on the right side of =
  - `left` - a list containing expression structs that represent the
    expression on the right side of =

  ## Examples

      # 4x = 16
      iex> Leibniz.Linear.solve(Leibniz.Expr{[{4, "x", 1}]}, [{16, "x", 0}])
      4
  """
  def solve(right, left, var) when is_binary(var) do
      left = regroup(left, var)
      right = regroup(right, var)
  end

  def regroup(expr, var) do
    similar_terms = Enum.group_by(expr.terms, &exponent(&1))

    for {exponent, terms} <- similar_terms do
      reduce(terms, var, exponent)
    end
  end

  def reduce(similar_terms, var, exponent) do
    coefficients = for {coefficiemt, _, _} <- similar_terms do
                     coefficiemt
                   end

    {Enum.sum(coefficients), var, exponent}
  end

  def exponent ({_, _, exponent}) do
    exponent
  end

end
