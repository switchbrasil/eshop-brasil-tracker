module RawItems
  class Import < Actor
    play Fetch, Create, Process
  end
end
