# reference: http://www.mattsears.com/articles/2011/12/10/minitest-quick-reference/


require "test_helper"

describe WorksController do
  # it "does a thing" do
  #   value(1+1).must_equal 2
  # end

  describe "index" do 
    it "responds with sucess when there are many works saved" do 
      # Act 
      get works_path

      # Assert
      expect(Work.count).must_be :>, 0
      must_respond_with :success
    end

    it "responds with sucess when there are no works saved" do 
      # Arrange
      Work.all.each do |work|
        work.destroy
      end

      # Act 
      get works_path

      # Assert
      expect(Work.count).must_equal 0
      must_respond_with :success
    end
  end

  describe "show" do 
    it "responds with success when showing an existing valid work_id" do 
      # Arrange
      new_work = works(:kindred)

      # Act 
      valid_id = new_work.id 
      get work_path(valid_id)

      # Assert 
      must_respond_with :success
    end

    it "responds with 404 with an invalid work id" do 
      # Arrange 
      invalid_id = -1

      # Act
      get work_path(invalid_id)

      # Assert 
      must_respond_with :not_found
    end
  end

  describe "new" do 
    it "responds with success" do 
      get new_work_path 

      must_respond_with :success
    end
  end

  describe "create" do 
    it "can create a new work with valid information accurately, and redirect" do 
      # Arrange
      # Set up the form data
      work_hash = {
        work: {
          category: BOOK,
          title: "Grokking algorithms",
          creator: "Aditya Bhargava",
          description: "Grokking Algorithms is a fully illustrated, friendly guide that teaches you how to apply common algorithms to the practical problems you face every day as a programmer.", 
          publication_year: 2016
        }
      }

      # Act & Assert 
      expect {
        post works_path, params: work_hash
      }.must_differ 'Work.count', 1

      # Assert
      # Find the newly created Work, and check that all its attributes match what was given in the form data
      work = Work.last 
      expect(work.category).must_equal work_hash[:work][:category]
      expect(work.title).must_equal work_hash[:work][:title]
      expect(work.creator).must_equal work_hash[:work][:creator]
      expect(work.description).must_equal work_hash[:work][:description]
      expect(work.publication_year).must_equal work_hash[:work][:publication_year]
    end

    it "will not create a work with invalid params" do 
      # Arrange
      work_hash = {
        work: {
          category: BOOK,
          title: nil
        }
      }

      # Act & Assert 
      expect {
        post works_path, params: work_hash
    }.wont_change 'Work.count'
    end
  end

  describe "edit" do 
    it "responds with success when getting the edit page for an existing, valid work" do
      # Arrange 
      album_work = works(:hurt)

      # Act
      get edit_work_path(album_work.id)

      # Assert 
      must_respond_with :success
    end

    it "responds with redirect when getting the edit page for a non-existing work" do 
      # Arrange
      invalid_id = -1

      # Act
      get edit_work_path(invalid_id)

      # Assert
      must_respond_with :not_found
    end
  end

  describe "update" do 
    let(:movie_work) {
      movie_work = works(:hurt)
    }

    it "can update an existing work with valid information accurately, and redirect" do
      # Arrange
      work_id = movie_work.id 

      update_hash = {
        work: {
          title: "happy people",
          description: "happy people!!",
        }
      }

      # Act & Assert 
      expect {
        patch work_path(work_id), params: update_hash
      }.wont_change "Work.count"

      # Use the local variable of an existing work's id to find the work again, and check that its attributes are updated
      updated_work = Work.find_by(id: work_id)

      expect(updated_work.title).must_equal update_hash[:work][:title]
      expect(updated_work.description).must_equal update_hash[:work][:description]
      must_respond_with :redirect

    end

    it "does not update any work if given an invalid id, and responds with a 404" do 
      # Arrange 
      invalid_id = -1

      # Act & Assert
      # Arrange
      update_hash = {
        work: {
          title: "new people",
          description: "new people!!",
        }
      }

      # Act & Assert 
      expect {
        patch work_path(invalid_id), params: update_hash
      }.wont_change "Work.count"

      must_respond_with :not_found
    end

    it "does not update a work if the form data violates Work validations" do 
      # Arrange
      work_id = movie_work.id 

      update_hash = {
        work: {
          title: nil,
          description: "something new"
        }
      }

      # Act & Assert 
      expect {
        patch work_path(work_id), params: update_hash
      }.wont_change 'Work.count'

      must_respond_with :success
    end
  end

  describe "destroy" do 
    it "destroys the work instance in db when work exists, then redirects" do
      # Arrange 
      work = works(:kindred)

      # Act & Assert 
      expect {
        delete work_path(work.id)
      }.must_differ 'Work.count', -1

      must_respond_with :redirect
    end

    it "does not change the db when the work does not exist, and responds with a 404" do
      # Arrange
      invalid_id = -1

      # Act & Assert
      expect {
        delete work_path(invalid_id)
      }.wont_change 'Work.count'

      # Assert
      must_respond_with :not_found
    end
  end
end
