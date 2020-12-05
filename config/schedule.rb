every :hour, at: 1 do
  runner 'RefreshDatabase.call'
end
