defmodule Timestamp.Implementation do

    alias Timestamp.Stamp

    def unix_or_date(s) do
        case Integer.parse(s) do
            {n, ""} -> get_timestamp(n)
            _ -> get_timestamp(s)
        end
    end

    # -> Stamp Struct
    # Produces the current timestamp in a string format
    def get_timestamp do
        DateTime.utc_now
        |> DateTime.to_unix(:millisecond)
        |> get_timestamp
    end
    
    # unix Integer -> Stamp Struct
    # Produce the formatted timestamp from the unix date-time
    def get_timestamp(int) when is_number(int) do
        int
        |> produce_date_time
        |> create_stamp
        |> format_date_time
    end

    # String -> Stamp Struct
    # Receives a date in a string and returns the formatted timestamp
    def get_timestamp(date) when is_binary(date) do
        date
        |> valid_date?
        |> produce_date_time
        |> create_stamp
        |> format_date_time
    end

    
    # String -> Date/Error
    # produce true if date is iso8601 compliant, otherwise false
    def valid_date?(date) do
        case Date.from_iso8601(date) do
            {:ok, d} -> d
            {:error, y} -> %{error: "Invalid Date"}
        end
    end

    # Map -> Map
    # Reproduce the error it received
    def format_date_time(%{error: message} = error), do: error

    # Stamp struct -> Stamp struct
    # Changes the utc value from a tuple to the formatted string
    # %Stamp{unix: 21212, {~D, ~T} } -> %Stamp{unix: 21212, "Mon, 15 January 2019, 00:00:00 GMT" }
    def format_date_time(%Stamp{unix: unix, utc: utc}) do
        {date, time} = utc
        %Stamp{unix: unix,
        utc: "#{produce_week_day(date)}, #{date.day} #{produce_month(date.month)} #{date.year} #{Time.to_string(time)} GMT"}
    end

    # Map -> Map
    # Reproduce the error it received
    def format_date_time(%{error: message} = error), do: error

    # Date -> String
    # Produce the day of the week abbv on that date, otherwise :error
    def produce_week_day(date) do
        case Date.day_of_week(date) do
            1 -> "Mon"
            2 -> "Tue"
            3 -> "Wed"
            4 -> "Thu"
            5 -> "Fri"
            6 -> "Sat"
            7 -> "Sun"
        end
    end

    # Integer -> String
    # Produce the month abbreviation the integer corresponds to

    def produce_month(int) do
        case int do
            1 -> "Jan"
            2 -> "Feb"
            3 -> "Mar"
            4 -> "Apr"
            5 -> "May"
            6 -> "June"
            7 -> "July"
            8 -> "Aug"
            9 -> "Sep"
            10 -> "Oct"
            11 -> "Nov"
            12 -> "Dec"
        end
    end
    # Map -> Map
    # Reproduce the error it received
    def produce_date_time(%{error: message} = error) do
        error
    end

    # Integer -> {Integer, {Date, Time}}
    #Produce a tuple with the date and time from the unix integer
    def produce_date_time(int) when is_number(int) do
        {:ok, dt} = DateTime.from_unix(int, unit=:millisecond)
        {int, {DateTime.to_date(dt), Time.truncate(DateTime.to_time(dt), :second)}}
    end

    # Date -> {Integer, {Date, Time}}
    #Produce a tuple with the date and time from a date
    def produce_date_time(date) do
        {:ok, time} = Time.new(0,0,0,0)
        {:ok, ndt} = NaiveDateTime.new(date, time) 
        {:ok, dt}  = ndt |> DateTime.from_naive("Etc/UTC")
        unix = DateTime.to_unix(dt, :millisecond)
        {unix, {DateTime.to_date(dt), Time.truncate(DateTime.to_time(dt), :second)} }
    end

    # {Integer, {Date, Time}} -> Stamp Struct
    # Produce a stamp structure from tuple

    def create_stamp({unix, {date, time} = t}) do
        %Stamp{unix: unix, utc: t}
    end

    # Map -> Map
    # Reproduce the error it received
    def create_stamp(%{error: message} = error), do: error

end