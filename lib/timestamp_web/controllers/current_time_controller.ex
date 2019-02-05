defmodule TimestampWeb.CurrentTimeController do
    use TimestampWeb, :controller

    alias Timestamp.Implementation

    def show(conn, _params) do
        timestamp = Implementation.get_timestamp
        render(conn, "show.json", timestamp: timestamp)
    end
end