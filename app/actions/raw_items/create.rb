module RawItems
  class Create < Actor
    input :data_items, type: Array

    def call
      data_items_size = data_items.size
      index = 0

      while index < data_items_size
        data = data_items[index]
        create_raw_item(data)
        index += 1
      end
    end

    private

    def create_raw_item(data)
      raw_item = RawItem.find_or_initialize_by(external_id: data['objectID'])
      data_checksum = Digest::MD5.hexdigest(data.to_s)

      return if raw_item.present? && raw_item.checksum == data_checksum

      raw_item.assign_attributes(data: data, checksum: data_checksum, imported: false)
      raw_item.save!
    rescue => e
      Sentry.capture_exception(e, level: :fatal, extra: { raw_item: raw_item })
    end
  end
end
