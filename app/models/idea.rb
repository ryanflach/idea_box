class Idea < ApplicationRecord
  validates_presence_of :title
  enum quality: ['swill', 'plausible', 'genius']

  def self.all_by_newest
    order('created_at DESC')
  end
end
