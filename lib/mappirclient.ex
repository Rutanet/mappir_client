defmodule MappirClient do
  use HTTPoison.Base
  alias MappirClient.{LocationSearch, Route, Response}

  def process_url(path) do
    "http://ttr.sct.gob.mx/TTR/rest/" <> path
  end

  def process_response_body(body) do
    case Poison.decode(body, as: %Response{}) do
      {:ok, %Response{code: 100, status: "OK", results: res}} -> res
      _ -> []
    end
  end

  def search_location(term) do
    term
    |> LocationSearch.to_path
    |> get
    |> LocationSearch.process_response
  end

  def pick_location(locations, index) do
    case Enum.fetch(locations, index) do
      {:ok, location} -> {:ok, location[:item]}
      :error -> :error
    end
  end

  def find_route(origin, destination) do
    Route.to_path(origin, destination)
    |> get
  end

  def quick_path(origin_term, destination_term) do
    with {:ok, o} <- origin_term |> search_location |> pick_location(0),
         {:ok, d} <- destination_term |> search_location |> pick_location(0),
         {:ok, route_response} <- find_route(o, d),
         {:ok, route} <- route_response.body do
      route
    end
  end
end
