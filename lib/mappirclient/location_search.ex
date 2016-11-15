defmodule MappirClient.LocationSearch do
  @endpoint "GeoSearchLocationSvt"
  @usr "sct"
  @key "sct"

  def process_response({:error, _}), do: []
  def process_response({:ok, response}), do: response |> results |> reestructure

  def results(%HTTPoison.Response{status_code: sc}) when sc != 200, do: []
  def results(%HTTPoison.Response{body: body}), do: body

  def to_path(search_term) do
    @endpoint <> "?" <> params(search_term)
  end

  defp params(term) do
    URI.encode_query(%{search: term, usr: @usr, key: @key})
  end

  defp reestructure(results) do
    Enum.flat_map(results, &flatten_category/1)
  end

  defp flatten_category(%{"categoria" => category,
                          "items" => items,
                          "idCategoria" => idCategory}) do
    Enum.map(items, fn(item) ->
      %{item: item, category: {category, idCategory}}
    end)
  end
end
