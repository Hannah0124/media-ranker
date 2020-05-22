MOVIE = "movie"
ALBUM = "album"
BOOK = "book"

class Work < ApplicationRecord
  has_many :votes

  validates :title, presence: true


  def self.sort_by_vote
    all_works = Work.all
    return all_works.sort_by { |work| work.votes.length }.reverse
  end 


  def self.spotlight 
    sorted_works = Work.sort_by_vote

    return sorted_works.first
  end


  def self.sort_by_category(category)
    sorted_works = self.sort_by_vote

    return sorted_works.select { |work| work.category == category }
  end


  def self.top_ten(category)
    works_by_category = self.sort_by_category(category) 

    return works_by_category.slice(0, 10)
  end
  
  # # TODO
  # def self.sort_by_date
  #   return Work.order(publication_year: :desc).all 
  # end 
end
