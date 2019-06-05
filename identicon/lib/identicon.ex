defmodule Identicon do
  def main(input) do
    input
    |> hash_input
    |> pick_color
  end

  def pick_color(image) do
    """

    # lhs == rhs. since `hex_list` is not defined, elixir attaches the value of the `image` hex list to our variable
    %Identicon.Image{hex: hex_list} = image

    # just focus on the first three values of the array, toss the others to the built in util called _tail
    [red, green, blue | _tail] = hex_list
    [red, green, blue]
    """

    %Identicon.Image{hex: [red, green, blue | _tail]} = image
    [red, green, blue]
  end

  def hash_input(input) do
    new_hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: new_hex}
  end

end
