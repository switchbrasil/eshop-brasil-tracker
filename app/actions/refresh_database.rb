class RefreshDatabase < Actor
  def call
    Task.start 'Import Raw Items' do
      RawItems::Import.call
    end

    Task.start 'Import Prices' do
      Prices::Import.call
    end

    Task.start 'Dispatch notifications' do
      DiscordNotifications::Send.call
    end
  end
end
