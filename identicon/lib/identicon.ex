defmodule Identicon do
  def main(input) do
    input
    |> hash_input
  end

  def hash_input(input) do
    new_hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: new_hex}
  end

end
