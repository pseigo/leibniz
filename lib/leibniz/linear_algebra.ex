defmodule Leibniz.Linear do

  @doc """
  Solve a linear equation with one variable, returns a tuple representing a fraction with the value
  of the variable
  {numerator, denominator}

  ## Parameters

  - `right` - a list containing expression structs that represent the
    expression on the right side of =
  - `left` - a list containing expression structs that represent the
    expression on the right side of =

  ## Examples

      # 4x = 16
      iex> Leibniz.Linear.solve(Leibniz.Expr{[{4, "x", 1}]}, [{16, "x", 0}])
      {4, 1}
  """
  def solve(left = %Leibniz.Expr{}, right = %Leibniz.Expr{}, var) when is_binary(var) do
    case can_solve?(right, left, var) do
      {:error, message} -> message
      {:ok} -> do_solve(right, left, var)
    end

    do_solve(right, left, var)
  end

  defp do_solve(left, right, var) do
    # flip the sign on the right expression terms
    # put both sides into one expression
    # regroup similar terms - there should only be two at this point
    # divide the negative of the the 0 coefficient by  the 1 coefficient

    right = flip_sign(right.terms)
    expr = [right, left.terms]
           |> Enum.concat()
           |> regroup()
           |> divide()

    case expr do
      {:error, message} ->
        message
      expr ->
        simplify(expr)
    end
  end

  def simplify({numerator, denominator}) when is_integer(numerator) and is_integer(denominator) do
    gcd = Integer.gcd(numerator, denominator)
    {numerator, denominator} = if(numerator < 0 and denominator < 0) do
                                 {numerator * -1, denominator * -1}
                               end
    {Kernel.div(numerator, gcd), Kernel.div(denominator, gcd)}
  end

  def divide(terms) when is_list(terms) do
    {const, _, _} = Enum.find(terms, &get_exponent(&1) == 0)
    {coeff, _, _} = Enum.find(terms, &get_exponent(&1) == 1)

    cond do
      const == nil and coeff == nil ->
        {:error, "no constant or variable term found"}
      const == nil ->
        {:error, "no constant term found"}
      coeff == nil ->
        {:error, "no variable term found"}
      true ->
        {const * -1, coeff}
    end
  end

  def regroup(terms) when is_list(terms) do
    terms
    |> regroup_by_var()
    |> regroup_by_exp()
    |> add_terms()
  end

  def regroup_by_var(terms) when is_list(terms) do
    grouped_map = Enum.group_by(terms, &get_var(&1))
    {_, grouped_terms} = Enum.unzip(grouped_map)
    grouped_terms
  end

  def regroup_by_exp(terms) when is_list(terms) do
    for term <- terms do
      grouped_map = Enum.group_by(term, &get_exponent(&1))
      {_, grouped_terms} = Enum.unzip(grouped_map)
      grouped_terms
    end
    |> Enum.concat()
  end

  def add_terms(terms) when is_list(terms) do
    Enum.map(terms, &add_coeffs(&1))
  end

  def add_coeffs(terms) when is_list(terms) do
    coeffs = for term <- terms do
              {coeff, _, _} = term
              coeff
             end
    sum = Enum.sum(coeffs)
    {_, var, exp} = List.first(terms)
    {sum, var, exp}
  end

  def flip_sign(terms) do
    for {coefficient, var, exponent} <- terms do
      {coefficient * -1, var, exponent}
    end
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

  def get_exponent ({_, _, exponent}) do
    exponent
  end

  def get_var ({_, var, _}) do
    var
  end


end
