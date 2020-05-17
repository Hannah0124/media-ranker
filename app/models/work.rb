class Work < ApplicationRecord
  has_many :votes

  def self.sort_by_vote_counts
    all_works = Work.all

    return all_works.sort_by { |work| work.votes.length }.reverse
  end 

  def self.spotlight 

    @works = Work.all

    max = 0 
    vote_id = 0
    @works.each do |work|
      if work.votes.length > max 
        max = work.votes.length
        vote_id = work.id
      end
    end

    return vote_id
  end

  def self.top_ten(category)
    works_by_category = Work.where(category: category) 

    result = works_by_category.sort_by { |work| work.votes.length }.reverse

    return result.slice(0, 10)
  end

  # def self.sort_by_date(category)
  #   all_works = Work.order(publication_year: :desc).all 

  #   return all_works.select { |work| work.category == category }
  # end 
  
  def self.sort_by_category(category)
    works_by_vote = self.sort_by_vote_counts

    return works_by_vote.select { |work| work.category == category }
  end
end
