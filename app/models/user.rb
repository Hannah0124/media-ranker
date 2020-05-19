class User < ApplicationRecord
  has_many :votes

  validates :name, presence: true

  # TODO
  # def self.sort_by_id 
  # end
end
