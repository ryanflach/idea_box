class Idea < ApplicationRecord
  enum status: ['swill', 'plausible', 'genius']
end
