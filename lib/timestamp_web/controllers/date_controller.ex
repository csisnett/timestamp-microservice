defmodule TimestampWeb.DateController do
    use TimestampWeb, :controller

    alias Timestamp.Implementation
    def show(conn, %{"date" => date}) do
        timestamp = Implementation.unix_or_date(date)
        render(conn, "show.json", timestamp: timestamp)
    end
end