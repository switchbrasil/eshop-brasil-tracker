every :hour, at: 1 do
  runner 'RefreshDatabase.call'
end

every :day, at: '4:30am' do
  rake 'log:clear'
end
