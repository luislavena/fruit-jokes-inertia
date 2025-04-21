require "./pagination"

module FruitJokes
  struct JokeRepository
    struct JokeRecentRow
      include DB::Serializable

      getter id : Int64
      getter setup : String
      getter punchline : String
      getter created_at : Time
    end

    struct JokeRow
      include DB::Serializable

      getter id : Int64
      getter setup : String
      getter punchline : String
      getter fruit : String
      getter comedian_id : Int64?
      getter comedian_name : String?
      getter created_at : Time
      getter updated_at : Time
    end

    struct JokeDetailRow
      include DB::Serializable

      getter id : Int64
      getter setup : String
      getter punchline : String
      getter fruit : String
      getter comedian_id : Int64?
      getter created_at : Time
      getter updated_at : Time
    end

    def initialize(@db : DB::Database)
    end

    # Get the most recent jokes
    def latest(limit : Int32 = 10) : Array(JokeRecentRow)
      @db.query_all("SELECT id, setup, punchline, created_at FROM jokes ORDER BY created_at DESC LIMIT ?", limit, as: JokeRecentRow)
    end

    # Get the total count of jokes
    def total_count : Int64
      @db.query_one("SELECT COUNT(*) FROM jokes", as: Int64)
    end

    # Get the count of jokes created in the current month
    def count_current_month : Int64
      @db.query_one(
        "SELECT COUNT(*) FROM jokes WHERE strftime('%Y-%m', created_at) = strftime('%Y-%m', 'now')",
        as: Int64
      )
    end

    # Get the count of jokes created in the previous month
    def count_previous_month : Int64
      @db.query_one(
        "SELECT COUNT(*) FROM jokes WHERE strftime('%Y-%m', created_at) = strftime('%Y-%m', 'now', '-1 month')",
        as: Int64
      )
    end

    # Get the delta between current month and previous month
    def month_over_month_delta : Int64
      current = count_current_month
      previous = count_previous_month
      current - previous
    end

    # Get a paginated list of jokes with comedian names
    def list(page : Int32 = 1, per_page : Int32 = 10) : {Array(JokeRow), PaginationData}
      offset = (page - 1) * per_page

      total = total_count
      pagination = PaginationData.new(total, page, per_page)

      jokes = @db.query_all(
        "SELECT j.id, j.setup, j.punchline, j.fruit, j.comedian_id, c.name as comedian_name, j.created_at, j.updated_at
         FROM jokes j
         LEFT JOIN comedians c ON j.comedian_id = c.id
         ORDER BY j.created_at DESC
         LIMIT ? OFFSET ?",
        per_page, offset,
        as: JokeRow
      )

      {jokes, pagination}
    end

    # Find a joke by ID
    def find(id : Int64) : JokeDetailRow?
      @db.query_one?(
        "SELECT id, setup, punchline, fruit, comedian_id, created_at, updated_at
         FROM jokes
         WHERE id = ?",
        id,
        as: JokeDetailRow
      )
    end

    # Create a new joke
    def create(setup : String, punchline : String, fruit : String, comedian_id : Int64) : Int64
      @db.query_one(
        "INSERT INTO jokes (setup, punchline, fruit, comedian_id, created_at, updated_at)
         VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
         RETURNING id",
        setup,
        punchline,
        fruit,
        comedian_id,
        as: Int64
      )
    end

    # Update an existing joke
    def update(id : Int64, setup : String, punchline : String, fruit : String, comedian_id : Int64) : Nil
      @db.exec(
        "UPDATE jokes
         SET setup = ?, punchline = ?, fruit = ?, comedian_id = ?, updated_at = CURRENT_TIMESTAMP
         WHERE id = ?",
        setup,
        punchline,
        fruit,
        comedian_id,
        id
      )
    end

    # Delete a joke
    def delete(id : Int64) : Nil
      @db.exec("DELETE FROM jokes WHERE id = ?", id)
    end

    # Get all unique fruits from jokes
    def unique_fruits : Array(String)
      @db.query_all("SELECT DISTINCT fruit FROM jokes ORDER BY fruit ASC", as: String)
    end
  end
end
