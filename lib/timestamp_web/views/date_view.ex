defmodule TimestampWeb.DateView do
    use TimestampWeb, :view

    def render("show.json", %{timestamp: timestamp}) do
        timestamp
    end
end