require "test_helper"

describe Work do
  let (:new_work) {
    works(:parasite)
  }

  it "can be instantiated" do 
    # Assert 
    expect(new_work.valid?).must_equal true
  end

  it "will have the required fields" do 
    # Arrange 
    new_work.save 
    work = Work.first
    
    expect(work).must_respond_to :title
  end
  

  describe "relationships" do 
    it "can have many votes" do 
      # Arrange 
      new_work.save 

      expect(new_work.votes.count).must_equal 4

      new_work.votes.each do |vote|
        expect(vote).must_be_instance_of Vote
      end
    end

    describe "validations" do 
      it "must have a title" do 
        # Arrange 
        new_work.title = nil 

        # Assert
        expect(new_work.valid?).must_equal false
        expect(new_work.errors.messages).must_include :title
        expect(new_work.errors.messages[:title]).must_include "can't be blank"
      end
    end

    describe "custom methods" do 

      describe "self.sort_by_vote_counts" do 
        it "will successfully return sorted works by vote counts (descenidng order)" do 
          # Arrange
          sorted_works = Work.sort_by_vote_counts

          movie_work = works(:parasite)
          album_work = works(:hurt)
          book_work = works(:kindred)

          # Assert
          expect(sorted_works[0].votes.count).must_equal 4
          expect(sorted_works[1].votes.count).must_equal 2
          expect(sorted_works[2].votes.count).must_equal 1

          expect(sorted_works[0].id).must_equal movie_work.id
          expect(sorted_works[1].id).must_equal album_work.id
          expect(sorted_works[2].id).must_equal book_work.id
        end
      end

      describe "self.spotlight" do
        it "will return spotlight with the highest vote counts" do 
          # Arrange
          spotlight = Work.spotlight
          movie_work = works(:parasite)

          # Assert
          expect(spotlight).must_be_instance_of Work
          expect(spotlight.votes.count).must_equal 4
          expect(spotlight.id).must_equal movie_work.id
        end 
      end

      describe "self.sort_by_category(category)" do 
        it "will return sorted list per category" do 
          # Arrange 
          movies = Work.sort_by_category("movie")
          albums = Work.sort_by_category("album")
          books = Work.sort_by_category("book")

          # Assert
          expect(movies.length).must_equal 12
          expect(albums.length).must_equal 3
          expect(books.length).must_equal 2

          movies.each do |movie| 
            expect(movie.category).must_equal "movie"
          end

          albums.each do |album| 
            expect(album.category).must_equal "album"
          end

          books.each do |book| 
            expect(book.category).must_equal "book"
          end

        end
      end

      describe "self.top_ten(category)" do
        it "will return top ten list per category" do 
          # Arrange
          top_ten_movies = Work.top_ten("movie")
          movie_work = works(:parasite)

          # Assert
          expect(top_ten_movies.length).must_equal 10

          top_ten_movies.each do |movie| 
            expect(movie).must_be_instance_of Work
            expect(movie.category).must_equal "movie"
          end

          expect(top_ten_movies.first).must_equal movie_work

        end 
      end
    end

  end
end
