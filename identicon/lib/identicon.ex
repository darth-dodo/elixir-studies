defmodule Identicon do
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    new_pixel_map = Enum.map grid, fn({_hex_value, index}) ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50
      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}
      {top_left, bottom_right}
    end

    %Identicon.Image{image | pixel_map: new_pixel_map}

  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    new_grid = Enum.filter grid, fn({code, _index}) ->
      rem(code, 2) == 0 # modulus operator
    end
    %Identicon.Image{image | grid: new_grid}
  end

  def mirror_row(row) do
    # take out first and second
    [first, second | _tail] = row

    # append the elems
    row ++ [second, first]
  end


  def build_grid(%Identicon.Image{hex: hex_list} = image) do
    grid =
      hex_list
      |> Enum.chunk(3) # group the list into sub lists of 3 elements each
      |> Enum.map(&mirror_row/1) # & means passing reference to a func and /1 means using the function which has 1 arg (in case more than one func have the same name)
      |> List.flatten # convert the nested lists into a flat structure
      |> Enum.with_index # add index to the array

    %Identicon.Image{image | grid: grid}
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
