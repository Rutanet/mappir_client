defmodule MappirClient.Response do
  @derive[Poison.Encoder]
  defstruct [:code, :status, :results]
end
