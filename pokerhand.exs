Code.require_file("lib/functions.ex", __DIR__)
Code.require_file("lib/hand.ex", __DIR__)
Code.require_file("lib/card.ex", __DIR__)
Code.require_file("lib/tiebreaker.ex", __DIR__)
Code.require_file("lib/pokerhand.ex", __DIR__)

defmodule PokerhandRunner do
  def f(s) do
    IO.puts(Pokerhand.run(s))
  end
end

params = System.argv() |> List.first()
PokerhandRunner.f(params)
