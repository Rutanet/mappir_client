defmodule MappirClient.Route do
  @endpoint "GeoRouteSvt"
  @usr "sct"
  @key "sct"

  def to_path(origin, destination) do
    @endpoint <> "?" <> params(origin, destination)
  end

  defp params(origin, destination) do
    URI.encode_query(
      %{json: build_query(origin, destination)})
  end

  defp build_query(origin, destination) do
    %{
      usr: @usr, key: @key,
      origen: origin, destinos: [destination],
      opciones: %{casetas: true, alertas: true},
      vehiculo: %{
        tipo: 1, subtipo: 2,
        rendimiento: "3.0", combustible: 4,
        costoltgas: 14.45, excedente: 2
      },
      ruta: 2
    } |> Poison.encode!
  end
end
