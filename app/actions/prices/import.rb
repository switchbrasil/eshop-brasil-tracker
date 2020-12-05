module Prices
  class Import < Actor
    play Fetch, Create
  end
end
