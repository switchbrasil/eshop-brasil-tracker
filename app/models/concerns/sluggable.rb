module Sluggable
  extend ActiveSupport::Concern

  included do
    include FriendlyId

    friendly_id :title, use: :slugged
  end

  def should_generate_new_friendly_id?
    title_changed?
  end
end
