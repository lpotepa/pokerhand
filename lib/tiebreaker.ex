defmodule Tiebreaker do
  @moduledoc """
    A module used for breaking a different types of a poker tie.
  """
  import Functions

  @doc """
  Breakes a tie
  ## Examples
      iex> Tiebreaker.break("high card", Pokerhand.create_hand("Black: 2H 3D 5S 9C KD"), Pokerhand.create_hand("White: 2C 3H 4S 8C KH"))           
      "Black wins - high card: 9"
      
      iex> Tiebreaker.break("pair", Pokerhand.create_hand("Black: 2H 3D 7S 9C 9D"), Pokerhand.create_hand("White: 2C 3H 8S 9C 9H"))           
      "White wins - high card: 8"

      iex> Tiebreaker.break("two pairs", Pokerhand.create_hand("Black: 2H 8D 8S 9C 9D"), Pokerhand.create_hand("White: 3C 7H 7S 9C 9H"))           
      "Black wins - two pairs: 8"

      iex> Tiebreaker.break("three of a kind", Pokerhand.create_hand("Black: 2H 8D 9S 9C 9D"), Pokerhand.create_hand("White: 3C 7H 8S 8C 8H"))           
      "Black wins - three of a kind: 9"

      iex> Tiebreaker.break("flush", Pokerhand.create_hand("Black: 2S 5S 8S 9S KS"), Pokerhand.create_hand("White: 3C 7C 8C KC AC"))           
      "White wins - high card: Ace"

      iex> Tiebreaker.break("four of a kind", Pokerhand.create_hand("Black: 2S 9S 9C 9H 9D"), Pokerhand.create_hand("White: 3C 8C 8S 8H 8D"))           
      "Black wins - four of a kind: 9"

      iex> Tiebreaker.break("straight flush", Pokerhand.create_hand("Black: 7S 8S 9S TS JS"), Pokerhand.create_hand("White: 8C 9C TC JC QC"))           
      "White wins - straight flush: Queen"
  """

  def break("high card", hand1, hand2) do
    hand1_last = List.last(hand1.cards)
    hand2_last = List.last(hand2.cards)

    cond do
      length(hand1.cards) == 0 && length(hand2.cards) == 0 ->
        "Tie"

      hand1_last.value == hand2_last.value ->
        break("high card", drop_last_card(hand1), drop_last_card(hand2))

      hand1_last.value > hand2_last.value ->
        "#{hand1.color} wins - high card: #{hand1_last.name}"

      hand1_last.value < hand2_last.value ->
        "#{hand2.color} wins - high card: #{hand2_last.name}"
    end
  end

  def break("pair", hand1, hand2) do
    [{hand1_value, _}] = pair(hand1)
    [{hand2_value, _}] = pair(hand2)

    cond do
      hand1_value == hand2_value ->
        break("high card", drop_value(hand1, hand1_value), drop_value(hand2, hand2_value))

      hand1_value > hand2_value ->
        "#{hand1.color} wins - pair: #{find_card_by_value(hand1, hand1_value).name}"

      hand1_value < hand2_value ->
        "#{hand2.color} wins - pair: #{find_card_by_value(hand2, hand2_value).name}"

      true ->
        ""
    end
  end

  def break("two pairs", hand1, hand2) do
    [{hand1_value_1, _}, {_, _}] = pair(hand1)
    [{hand2_value_1, _}, {_, _}] = pair(hand2)
    hand1_value = Enum.max([hand1_value_1, hand1_value_1])
    hand2_value = Enum.max([hand2_value_1, hand2_value_1])

    cond do
      hand1_value == hand2_value ->
        break("pair", drop_value(hand1, hand1_value), drop_value(hand2, hand2_value))

      hand1_value > hand2_value ->
        "#{hand1.color} wins - two pairs: #{find_card_by_value(hand1, hand1_value).name}"

      hand1_value < hand2_value ->
        "#{hand2.color} wins - two pairs: #{find_card_by_value(hand2, hand2_value).name}"

      true ->
        ""
    end
  end

  def break("three of a kind", hand1, hand2) do
    [{hand1_value, _}] = three_of_a_kind(hand1)
    [{hand2_value, _}] = three_of_a_kind(hand2)

    cond do
      hand1_value == hand2_value ->
        break("high card", drop_value(hand1, hand1_value), drop_value(hand2, hand2_value))

      hand1_value > hand2_value ->
        "#{hand1.color} wins - three of a kind: #{find_card_by_value(hand1, hand1_value).name}"

      hand1_value < hand2_value ->
        "#{hand2.color} wins - three of a kind: #{find_card_by_value(hand2, hand2_value).name}"

      true ->
        ""
    end
  end

  def break("flush", hand1, hand2) do
    break("high card", hand1, hand2)
  end

  def break("full house", hand1, hand2) do
    {hand1_value, _} = find_3_cards(hand1)
    {hand2_value, _} = find_3_cards(hand2)

    cond do
      hand1_value == hand2_value ->
        break("pair", drop_value(hand1, hand1_value), drop_value(hand2, hand2_value))

      hand1_value > hand2_value ->
        "#{hand1.color} wins - full house: #{find_card_by_value(hand1, hand1_value).name}"

      hand1_value < hand2_value ->
        "#{hand2.color} wins - full house: #{find_card_by_value(hand2, hand2_value).name}"

      true ->
        ""
    end
  end

  def break("four of a kind", hand1, hand2) do
    {hand1_value, _} = find_4_cards(hand1)
    {hand2_value, _} = find_4_cards(hand2)

    cond do
      hand1_value == hand2_value ->
        break("high card", drop_value(hand1, hand1_value), drop_value(hand2, hand2_value))

      hand1_value > hand2_value ->
        "#{hand1.color} wins - four of a kind: #{find_card_by_value(hand1, hand1_value).name}"

      hand1_value < hand2_value ->
        "#{hand2.color} wins - four of a kind: #{find_card_by_value(hand2, hand2_value).name}"

      true ->
        ""
    end
  end

  def break("straight flush", hand1, hand2) do
    hand1_value = List.last(hand1.cards).value
    hand2_value = List.last(hand2.cards).value

    cond do
      hand1_value == hand2_value ->
        "Tie"

      hand1_value > hand2_value ->
        "#{hand1.color} wins - straight flush: #{find_card_by_value(hand1, hand1_value).name}"

      hand1_value < hand2_value ->
        "#{hand2.color} wins - straight flush: #{find_card_by_value(hand2, hand2_value).name}"

      true ->
        ""
    end
  end

  defp drop_last_card(hand) do
    new_cards = hand.cards |> Enum.drop(-1)
    Map.merge(hand, %{cards: new_cards})
  end

  def drop_value(hand, value) do
    new_cards = hand.cards |> Enum.filter(fn card -> card.value != value end)
    Map.merge(hand, %{cards: new_cards})
  end

  defp find_card_by_value(hand, value) do
    hand.cards |> Enum.find(fn card -> card.value == value end)
  end

  defp find_3_cards(hand) do
    full_house(hand)
    |> Enum.find(fn el ->
      {_, length} = el
      length == 3
    end)
  end

  defp find_4_cards(hand) do
    four_of_a_kind(hand)
    |> Enum.find(fn el ->
      {_, length} = el
      length == 4
    end)
  end
end
