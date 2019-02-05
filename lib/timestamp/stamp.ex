defmodule Timestamp.Stamp do
   @derive {Jason.Encoder, only: [:unix, :utc]}
    defstruct [:unix, :utc]
end