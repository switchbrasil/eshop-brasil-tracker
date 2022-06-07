module RawItems
  class Process < Actor
    def call
      RawItem.pending.find_each(batch_size: 200) do |raw_item|
        data = NintendoItemDataAdapter.new(raw_item.data).adapt
        item = raw_item.item || Item.new
        item.assign_attributes(data)
        item.save!
      rescue => e
        raise e if Rails.env.development?
        Sentry.capture_exception(e, level: :fatal, extra: { item: item })
      else
        raw_item.update(item_id: item.id, imported: true)
      end
    end
  end
end
