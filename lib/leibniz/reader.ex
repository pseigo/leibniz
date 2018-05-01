defmodule Reader do
  def string_to_expr(string) do
    terms = string
            |> String.replace(~r/\s/, "")
            |> String.replace("-", " -")
            |> String.replace("+", " +")
            |> String.split(" ")

    if(expr?(terms)) do
      extract(terms)
    else
      {:error, "invalid expression"}
    end
  end

  def expr?(terms) when is_list(terms) do
    pattern = ~r/([\+|\-]?\d+)(\w)?\^?(\d+)?/

    Enum.all?(terms, &Regex.match?(pattern, &1))
  end

  def extract(terms) when is_list(terms) do
    pattern = ~r/([\+|\-]?\d+)(\w)?\^?(\d+)?/

    terms = for term <- terms do
              [_ | parts] = Regex.run(pattern, term)
              parts = fill_gaps(parts)
              [coeff, var, exp] = parts
              {String.to_integer(coeff), var, String.to_integer(exp)}
            end
  end

  def fill_gaps(term) when is_list(term) do
    term = case Enum.count(term) do
            1 ->
              term ++ ["x"] ++ ["0"]

            2 ->
              term ++ ["1"]

            3 ->
              term

            true ->
              nil
           end
  end
end
