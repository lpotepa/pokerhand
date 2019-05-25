defmodule Pokerhand do
  import Functions

  @value_map %{
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "T" => 10,
    "J" => 11,
    "Q" => 12,
    "K" => 13,
    "A" => 14
  }

  @name_map %{
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "T" => 10,
    "J" => "Joker",
    "Q" => "Queen",
    "K" => "King",
    "A" => "Ace"
  }

  def run(s) do
    try do
      {black, white} = s |> String.split_at(trunc(String.length(s) / 2))
      {black_cards, white_cards} = {create_hand(black), create_hand(white)}

      {{black_rank, black_rank_type, black_rank_hand},
       {white_rank, white_rank_type, white_rank_hand}} = {rank(black_cards), rank(white_cards)}

      cond do
        black_rank == white_rank ->
          Tiebreaker.break(black_rank_type, black_rank_hand, white_rank_hand)

        black_rank > white_rank ->
          "#{black_rank_hand.color} wins - #{black_rank_type}"

        white_rank > black_rank ->
          "#{white_rank_hand.color} wins - #{white_rank_type}"

        true ->
          "Something went wrong"
      end
    rescue
      _ -> "Something went wrong"
    end
  end

  @doc """
  Creates a hand from

  ## Examples
      iex> Pokerhand.create_hand("Black: 2H 3D 5S 9C KD")                                      
      %Hand{
        cards: [
          %Card{name: 2, suit: "H", value: 2},
          %Card{name: 3, suit: "D", value: 3},
          %Card{name: 5, suit: "S", value: 5},
          %Card{name: 9, suit: "C", value: 9},
          %Card{name: "King", suit: "D", value: 13}
        ],
        color: "Black"
      }

      iex> Pokerhand.create_hand("White: 2D 3C 5C 9D KH")                                      
      %Hand{
        cards: [
          %Card{name: 2, suit: "D", value: 2},
          %Card{name: 3, suit: "C", value: 3},
          %Card{name: 5, suit: "C", value: 5},
          %Card{name: 9, suit: "D", value: 9},
          %Card{name: "King", suit: "H", value: 13}
        ],
        color: "White"
      }
  """

  def create_hand(s) do
    [color, cards] = s |> String.split(": ")

    hand =
      cards
      |> String.split(" ")
      |> Enum.map(fn card ->
        {value, suit} = card |> String.split_at(1)
        %Card{value: @value_map[value], suit: suit, name: @name_map[value]}
      end)

    %Hand{cards: hand, color: String.trim(color)}
  end

  defp rank(hand) do
    cond do
      straight_flush?(hand) ->
        {9, "straight flush", hand}

      four_of_a_kind?(hand) ->
        {8, "four of a kind", hand}

      full_house?(hand) ->
        {7, "full house", hand}

      flush?(hand) ->
        {6, "flush", hand}

      straight?(hand) ->
        {5, "straight", hand}

      three_of_a_kind?(hand) ->
        {4, "three of a kind", hand}

      two_pairs?(hand) ->
        {3, "two pairs", hand}

      pair?(hand) ->
        {2, "pair", hand}

      true ->
        {1, "high card", hand}
    end
  end
end
