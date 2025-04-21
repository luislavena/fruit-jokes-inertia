module FruitJokes
  # Common pagination data structure for repository results
  struct PaginationData
    getter total : Int64
    getter page : Int32
    getter per_page : Int32
    getter total_pages : Int32

    def initialize(@total, @page, @per_page)
      @total_pages = (@total.to_f / @per_page).ceil.to_i
      @total_pages = 1 if @total_pages == 0
    end

    def has_previous? : Bool
      @page > 1
    end

    def has_next? : Bool
      @page < @total_pages
    end
  end
end
