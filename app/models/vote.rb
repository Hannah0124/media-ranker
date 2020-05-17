class Vote < ApplicationRecord
  belongs_to :work 
  belongs_to :user

  validates :work_id, presence: true
  validates :user_id, presence: true, uniqueness: { scope: :work_id }

  def self.upvoted?(work_id, user_id)
    Vote.find_by(work_id: work_id, user_id: user_id) ? true : false
  end

end


# vlidate reference: https://guides.rubyonrails.org/active_record_validations.html#uniqueness