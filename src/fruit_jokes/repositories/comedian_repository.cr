require "./pagination"

module FruitJokes
  struct ComedianRepository
    struct ComedianRow
      include DB::Serializable

      getter id : Int64
      getter name : String
      getter specialty : String
      getter joke_count : Int64
      getter created_at : Time
      getter updated_at : Time
    end

    struct SingleComedianRow
      include DB::Serializable

      getter id : Int64
      getter name : String
      getter specialty : String
      getter created_at : Time
      getter updated_at : Time
    end

    def initialize(@db : DB::Database)
    end

    # Get the most recent comedians with their joke counts
    def latest(limit : Int32 = 10) : Array(ComedianRow)
      @db.query_all(
        "SELECT c.id, c.name, c.specialty, COUNT(j.id) as joke_count, c.created_at, c.updated_at
         FROM comedians c
         LEFT JOIN jokes j ON c.id = j.comedian_id
         GROUP BY c.id
         ORDER BY c.created_at DESC
         LIMIT ?",
        limit,
        as: ComedianRow
      )
    end

    # Get a paginated list of comedians
    def list(page : Int32 = 1, per_page : Int32 = 10) : {Array(ComedianRow), PaginationData}
      offset = (page - 1) * per_page

      total = total_count
      pagination = PaginationData.new(total, page, per_page)

      comedians = @db.query_all(
        "SELECT c.id, c.name, c.specialty, COUNT(j.id) as joke_count, c.created_at, c.updated_at
         FROM comedians c
         LEFT JOIN jokes j ON c.id = j.comedian_id
         GROUP BY c.id
         ORDER BY c.created_at DESC
         LIMIT ? OFFSET ?",
        per_page, offset,
        as: ComedianRow
      )

      {comedians, pagination}
    end

    # Get a paginated list of comedians filtered by specialty
    def list_by_specialty(specialty : String, page : Int32 = 1, per_page : Int32 = 10) : {Array(ComedianRow), PaginationData}
      offset = (page - 1) * per_page

      total = total_count_by_specialty(specialty)
      pagination = PaginationData.new(total, page, per_page)

      comedians = @db.query_all(
        "SELECT c.id, c.name, c.specialty, COUNT(j.id) as joke_count, c.created_at, c.updated_at
         FROM comedians c
         LEFT JOIN jokes j ON c.id = j.comedian_id
         WHERE c.specialty = ?
         GROUP BY c.id
         ORDER BY c.created_at DESC
         LIMIT ? OFFSET ?",
        specialty, per_page, offset,
        as: ComedianRow
      )

      {comedians, pagination}
    end

    # Get the total count of comedians
    def total_count : Int64
      @db.query_one("SELECT COUNT(*) FROM comedians", as: Int64)
    end

    # Get the total count of comedians filtered by specialty
    def total_count_by_specialty(specialty : String) : Int64
      @db.query_one("SELECT COUNT(*) FROM comedians WHERE specialty = ?", specialty, as: Int64)
    end

    # Get all unique specialties from comedians
    def unique_specialties : Array(String)
      @db.query_all("SELECT DISTINCT specialty FROM comedians ORDER BY specialty ASC", as: String)
    end

    # Get the count of comedians created in the current month
    def count_current_month : Int64
      @db.query_one(
        "SELECT COUNT(*) FROM comedians WHERE strftime('%Y-%m', created_at) = strftime('%Y-%m', 'now')",
        as: Int64
      )
    end

    # Get the count of comedians created in the previous month
    def count_previous_month : Int64
      @db.query_one(
        "SELECT COUNT(*) FROM comedians WHERE strftime('%Y-%m', created_at) = strftime('%Y-%m', 'now', '-1 month')",
        as: Int64
      )
    end

    # Get the delta between current month and previous month
    def month_over_month_delta : Int64
      current = count_current_month
      previous = count_previous_month
      current - previous
    end

    # Create a new comedian
    def create(name : String, specialty : String) : Int64
      @db.query_one(
        "INSERT INTO comedians (name, specialty, created_at, updated_at) VALUES (?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) RETURNING id",
        name,
        specialty,
        as: Int64
      )
    end

    # Find a comedian by ID
    def find(id : Int64) : SingleComedianRow?
      @db.query_one?(
        "SELECT id, name, specialty, created_at, updated_at
         FROM comedians
         WHERE id = ?",
        id,
        as: SingleComedianRow
      )
    end

    # Update an existing comedian
    def update(id : Int64, name : String, specialty : String) : Nil
      @db.exec(
        "UPDATE comedians SET name = ?, specialty = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?",
        name,
        specialty,
        id
      )
    end

    # Delete a comedian
    def delete(id : Int64) : Nil
      @db.exec("DELETE FROM comedians WHERE id = ?", id)
    end
  end
end
