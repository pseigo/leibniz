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
      case can_solve?(right, left, var) do
        {:error, message} -> message
        {:ok} -> do_solve(right, left, var)
      end
  end

  defp do_solve(right, left, var) do
      left = regroup(left, var)
      right = regroup(right, var)
      solution = add_sub(right, left)
  end

  def add_sub(right, left) do

    left_terms = for {coefficient, var, exponent} <- left.terms do
                   if(expoonent == 0) do
                     {coefficient * -1, var, exponent}

                   else
                     {coefficient, var, exponent}
                   end
                 end

    right_terms = for {coefficient, var, exponent} <- right.terms do
                    if(expoonent == 1) do
                      {coefficient * -1, var, exponent}

                    else
                      {coefficient, var, exponent}
                    end
                  end
    all_terms = [right_terms, left_terms]
                |> Enum.concat()
                |> Enum.group_by(&get_exponent(&1))

    {all_terms.1, all_terms.0}
  end

  def flip_sign({coefficiemt, var, exponent}) do
    {coefficiemt * -1, var, exponent}
  end


  defp can_solve?(right, left, var) do
    terms = [right.terms, left.terms]
    |> Enum.concat

    cond do
      !Enum.all?(terms, &(get_exponent(&1) < 2)) ->
        {:error, "can only solve equations of the first degree"}

      !Enum.all?(terms, &(get_var(&1) == var)) ->
        {:error, "can only solve euqations with one variable"}

      true ->
        {:ok}
    end
  end

  def regroup(expr, var) do
    similar_terms = Enum.group_by(expr.terms, &get_exponent(&1))

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

  def get_exponent ({_, _, exponent}) do
    exponent
  end

  def get_var ({_, var, _}) do
    var
  end


end
