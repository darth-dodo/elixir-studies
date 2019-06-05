defmodule Identicon do
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
  end

  def build_grid(%Identicon.Image{hex: hex_list} = image) do
    hex_list
    |> Enum.chunk(3)
  end

  def mirror_row(row) do
    # take out first and second
    [first, second | _tail] = row

    # append the elems
    row ++ [second, first]
  end

  def pick_color(image) do
    """

    # lhs == rhs. since `hex_list` is not defined, elixir attaches the value of the `image` hex list to our variable
    %Identicon.Image{hex: hex_list} = image

    # just focus on the first three values of the array, toss the others to the built in util called _tail
    [red, green, blue | _tail] = hex_list
    [red, green, blue]
    """

    %Identicon.Image{hex: [r, g, b | _tail]} = image
    # adding the rgb to the struct
    # immutability :p
    %Identicon.Image{image | color: {r, g, b}}
  end

  def hash_input(input) do
    new_hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: new_hex}
  end

end
