defmodule Twinex do
  @moduledoc """
  """

  @doc """
  Two strings are twins iff their odd **and** even substrings are anagrams

  That is obviously true for empty strings:

      iex(1)> twins?("", "")
      true

  However it is obviously false if the odds are not anagrams (we consider the odds
  being the second splice, starting counting @ 0) ...

      iex(2)> twins?("ab", "ac")
      false

  ... and the same holds for evens, of course

      iex(3)> twins?("ab", "cb")
      false

  Another _obvious_ absence of twinhood is if the strings are not of the same length

      iex(4)> twins?("aaa", "aa")
      false

  Now a string composed from anagrams to demonstrate some twinhood

      iex(5)> _evens = "banana"
      ...(5)> _odds  = "ALPHA"
      ...(5)> _even_ana = "abaann"
      ...(5)> _odd_ana  = "PHALA"
      ...(5)> twins?("bAaLnPaHnAa", "aPbHaAaLnAn")
      true

  """
  def twins?(lhs, rhs) do
    if String.length(lhs) == String.length(rhs) do
      _counts(lhs) == _counts(rhs)
    else
      false
    end
  end

  @doc """
    twin_pairs compares two lists of strings by means of the `twins?` predicate

      iex(6)> list1 = ~w[alpha beta gamma omega]
      ...(6)> list2 = ~w[plaha tbea ammag phi]
      ...(6)> twin_pairs(list1, list2)
      ~w[Yo Na Yo Na]

    And for those, not familiar with Austrian dialect

      iex(7)> list1 = ~w[yes nnoo]
      ...(7)> list2 = ~w[sey xxxx yyy]
      ...(7)> twin_pairs(list1, list2, yes: 1, no: 0)
      [1, 0] 

    If the first argument is longer than the second, the
    expected will happen, that is if you expect the right
    thing, of course:

      iex(8)> list1 = ~w[yes]
      ...(8)> twin_pairs(list1, [])
      []


  """
  def twin_pairs(lhs, rhs, options \\ []) do
    yes_str = Keyword.get(options, :yes, "Yo")
    no_str = Keyword.get(options, :no, "Na")
    Enum.zip(lhs, rhs)
    |> Enum.map(fn {le, re} -> if twins?(le, re), do: yes_str, else: no_str end)
  end

  defp _counts(string) do
    string
    |> String.graphemes
    |> Enum.chunk_every(2, 2, [" "])
    |> Enum.reduce({%{}, %{}}, &_update_counters/2)
  end

  defp _update_counter(counter, graph) do
    Map.put(counter, graph, Map.get(counter, graph, 0) + 1)
  end

  defp _update_counters( [even_graph, odd_graph], {even_counter, odd_counter} ) do
    {
      _update_counter(even_counter, even_graph),
      _update_counter(odd_counter, odd_graph)}
  end
end
