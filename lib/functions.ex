defmodule Functions do
  @moduledoc """
    Utility functions for calculating the numbers of matching card in a hand
  """

  @doc """
    Returns a map where key is a card numeric value and a map value represting the number of occurencies of the card value in the hand

    ## Examples
        iex> Functions.counts(Pokerhand.create_hand("White: 3D 3C 3C 9D KH"))
        %{3 => 3, 9 => 1, 13 => 1}
  """

  def counts(hand) do
    hand.cards
    |> Enum.reduce(%{}, fn el, memo ->
      Map.merge(memo, %{el.value => Map.get(memo, el.value, 0) + 1})
    end)
  end

  @doc """
    Returns a map where key is a card suit and a map value represtins the number of occurencies of the card suit in the hand

    ## Examples
        iex> Functions.suits(Pokerhand.create_hand("White: 2D 3C 5C 9D KH"))
        %{"C" => 2, "D" => 2, "H" => 1}
  """
  def suits(hand) do
    hand.cards
    |> Enum.reduce(%{}, fn el, memo ->
      Map.merge(memo, %{el.suit => Map.get(memo, el.suit, 0) + 1})
    end)
  end

  @doc """
    Checks if the hand has exactly one pair

    ## Examples
        iex> Functions.pair?(Pokerhand.create_hand("White: 2D 3C 5C 9D 9H"))
        true
        iex> Functions.pair?(Pokerhand.create_hand("White: 2D 3C 5C 9D TH"))
        false
  """

  def pair?(hand) do
    pair(hand) |> length == 1
  end

  @doc """
    Return array of tumples representing the cards forming the pairs - a tuple's head represents a numeric value and its tail represents a number of occurencies

    ## Examples
        iex> Functions.pair(Pokerhand.create_hand("White: 2D 2C 2C 9D 9H"))  
        [{9, 2}]
  """

  def pair(hand) do
    counts(hand) |> Enum.filter(fn {_, v} -> v == 2 end)
  end

  @doc """
    Checks if the hand has exactly two pairs

    ## Examples
        iex> Functions.two_pairs?(Pokerhand.create_hand("White: 2D 3C 3C 9D 9H"))
        true
        iex> Functions.two_pairs?(Pokerhand.create_hand("White: 2D 3C 5C 9D 9H"))
        false
  """

  def two_pairs?(hand) do
    pair(hand) |> length == 2
  end

  @doc """
    Checks if the hand falls into "three of a kind rule"

    ## Examples
        iex> Functions.three_of_a_kind?(Pokerhand.create_hand("Black: 2D 2C 2C 9D 9H"))
        true
        iex> Functions.three_of_a_kind?(Pokerhand.create_hand("White: 2D 2C 3C 9D 9H"))
        false
  """

  def three_of_a_kind?(hand) do
    three_of_a_kind(hand) |> length == 1
  end

  @doc """
    Return array of tumples representing the cards forming the cards falling into three of a kind rule - a tuple's head represents a numeric value and its tail represents a number of occurencies

    ## Examples
        iex> Functions.three_of_a_kind(Pokerhand.create_hand("Black: 2D 2C 2C 9D 9H"))  
        [{2, 3}]
  """

  def three_of_a_kind(hand) do
    counts(hand) |> Enum.filter(fn {_, v} -> v == 3 end)
  end

  @doc """
    Checks if a hand falls into "Staight" rule

    ## Examples
        iex> Functions.straight?(Pokerhand.create_hand("Black: 8D 9C TC JD QH"))  
        true
        iex> Functions.straight?(Pokerhand.create_hand("White: 8D 9C JC QD KH"))  
        false
  """

  def straight?(hand) do
    cons = hand.cards |> Enum.map(& &1.value)

    !(cons
      |> Enum.with_index()
      |> Enum.find(fn {value, index} ->
        abs(value - Enum.at(cons, index - 1)) != 1 && index > 0
      end))
  end

  @doc """
    Checks if a hand falls into "Flush" rule

    ## Examples
        iex> Functions.straight?(Pokerhand.create_hand("Black: 8D 9D TD JD QD"))  
        true
        iex> Functions.straight?(Pokerhand.create_hand("White: 8D 9C JC QD KH"))  
        false
  """

  def flush?(hand) do
    suits(hand) |> Enum.filter(fn {_, v} -> v == 5 end) |> length == 1
  end

  @doc """
    Checks if a hand falls into "Full house" rule

    ## Examples
        iex> Functions.full_house?(Pokerhand.create_hand("Black: 8S 8D 8H 9D 9S"))  
        true
        iex> Functions.full_house?(Pokerhand.create_hand("White: 8D 9C JC QD KH"))  
        false
  """

  def full_house?(hand) do
    counts(hand) |> Enum.filter(fn {_, v} -> v == 3 end) |> length == 1 &&
      counts(hand) |> Enum.filter(fn {_, v} -> v == 2 end) |> length == 1
  end

  @doc """
    Return array of tumples representing the cards forming the cards falling into full house rule - a tuple's head represents a numeric value and its tail represents a number of occurencies

    ## Examples
        iex> Functions.full_house(Pokerhand.create_hand("Black: 8S 8D 8H 9D 9S"))  
        [{8, 3}, {9, 2}]
  """

  def full_house(hand) do
    (counts(hand) |> Enum.filter(fn {_, v} -> v == 3 end)) ++
      (counts(hand) |> Enum.filter(fn {_, v} -> v == 2 end))
  end

  @doc """
    Checks if a hand falls into "Four of a kind" rule

    ## Examples
        iex> Functions.four_of_a_kind?(Pokerhand.create_hand("Black: 8S 8D 8H 8C 9S"))  
        true
        iex> Functions.four_of_a_kind?(Pokerhand.create_hand("White: 8D 9C JC QD KH"))  
        false
  """

  def four_of_a_kind?(hand) do
    four_of_a_kind(hand) |> length == 1
  end

  @doc """
    Return array of tumples representing the cards forming the cards falling into four of a kind rule - a tuple's head represents a numeric value and its tail represents a number of occurencies

    ## Examples
        iex> Functions.four_of_a_kind(Pokerhand.create_hand("Black: 8S 8D 8H 8C 9S"))  
        [{8, 4}]
  """

  def four_of_a_kind(hand) do
    counts(hand) |> Enum.filter(fn {_, v} -> v == 4 end)
  end

  @doc """
    Checks if a hand falls into "Straight flush" rule

    ## Examples
        iex> Functions.straight_flush?(Pokerhand.create_hand("Black: 8S 9S TS JS QS"))  
        true
        iex> Functions.straight_flush?(Pokerhand.create_hand("White: 8D 9C JC QD KH"))  
        false
  """

  def straight_flush?(hand) do
    if straight?(hand) do
      flush?(hand)
    else
      false
    end
  end
end
