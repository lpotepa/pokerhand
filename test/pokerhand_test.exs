defmodule PokerhandTest do
  use ExUnit.Case
  doctest Pokerhand

  describe ".run function" do
    test "compares Black: 2H 3D 5S 9C KD White: 2D 3H 5C 9S KH poker hands" do
      assert Pokerhand.run("Black: 2H 3D 5S 9C KD White: 2D 3H 5C 9S KH") == "Tie"
    end

    test "compares Black: 2H 3D 5S 9C KD White: 2C 3H 4S 8C KH poker hands" do
      assert Pokerhand.run("Black: 2H 3D 5S 9C KD White: 2C 3H 4S 8C KH") ==
               "Black wins - high card: 9"
    end

    test "compares Black: 2H 4S 4C 3D 4H White: 2S 8S AS QS 3S poker hands" do
      assert Pokerhand.run("Black: 2H 4S 4C 3D 4H White: 2S 8S AS QS 3S") ==
               "White wins - flush"
    end

    test "compares Black: 2H 3D 5S 9C KD White: 2C 3H 4S 8C AH poker hands" do
      assert Pokerhand.run("Black: 2H 3D 5S 9C KD White: 2C 3H 4S 8C AH") ==
               "White wins - high card: Ace"
    end

    test "compares Black: 2H 2D 5S 9C KD White: 3C 3H 4S 8C AH poker hands" do
      assert Pokerhand.run("Black: 2H 2D 5S 9C KD White: 3C 3H 4S 8C AH") ==
               "White wins - pair: 3"
    end

    test "compares Black: 2H 2D 2S 2C 2D White: 2C 2H 2S 2C 2H poker hands" do
      assert Pokerhand.run("Black: 2H 2D 2S 2C 2D White: 2C 2H 2S 2C 2H") ==
               "Tie"
    end

    test "compares Black: 2S 5S 6S 7S 8S White: 2S 2S 8S 8S 8S poker hands" do
      assert Pokerhand.run("Black: 2S 5S 6S 7S 8S White: 2S 2S 8S 8S 8S") ==
               "White wins - full house"
    end

    test "compares Black: 5H 6S 7C 8D 8H White: 2S 3S 4S 8D 8C poker hands" do
      assert Pokerhand.run("Black: 5H 6S 7C 8D 8H White: 2S 3S 4S 8D 8C") ==
               "Black wins - high card: 7"
    end

    test "compares Black: 2S 3S 4S 5S 6S White: 2S 3S 4S 8D 8C poker hands" do
      assert Pokerhand.run("Black: 2S 3S 4S 5S 6S White: 2S 3S 4S 8D 8C") ==
               "Black wins - straight flush"
    end

    test "compares Black: 2S 3S 4S 5S 6S White: 2S 3S 4S 5S 6S poker hands" do
      assert Pokerhand.run("Black: 2S 3S 4S 5S 6S White: 2S 3S 4S 5S 6S") ==
               "Tie"
    end

    test "compares Black: 2S 3S 4S 5S 6S White: 9S TS JS QS KS poker hands" do
      assert Pokerhand.run("Black: 2S 3S 4S 5S 6S White: 9S TS JS QS KS") ==
               "White wins - straight flush: King"
    end

    test "compares Black: 8S 8D 8H 8C 9S White: 7S 7D 7H 7C KS poker hands" do
      assert Pokerhand.run("Black: 8S 8D 8H 8C 9S White: 7S 7D 7H 7C KS") ==
               "Black wins - four of a kind: 8"
    end
  end
end
