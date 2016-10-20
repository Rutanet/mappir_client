defmodule Mappirclient do
  use HTTPoison.Base

  def process_url(url) do
    "http://ttr.sct.gob.mx/TTR/rest/GeoRouteSvt?json=#{json_request}" <> url
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
  end

  def json_request do
    File.read!("requestdata.json")
    |> Poison.decode!
    |> Poison.encode!
    |> URI.encode
  end
end
