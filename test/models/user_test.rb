require "test_helper"

describe User do
  let(:new_user) {
    users(:human)
  }

  it "can be instantiated" do 
    # Assert 
    expect(new_user.valid?).must_equal true
  end

  it "will have the required fields" do 
    # Arrange
    new_user.save 
    user = User.first 

    # Assert
    expect(user).must_respond_to :name
  end

  describe "relationships" do 
    it "can have many votes" do 
      # Arrange 
      new_user.save 
      movie_work = works(:parasite)
      album_work = works(:hurt)
      
      Vote.create(work_id: movie_work.id, user_id: new_user.id)
      Vote.create(work_id: album_work.id, user_id: new_user.id)

      expect(new_user.votes.count).must_equal 2

      new_user.votes.each do |vote|
        expect(vote).must_be_instance_of Vote
      end
    end
  end

  describe "validations" do 
    it "must have a name" do 
      # Arrange
      new_user.name = nil

      # Assert 
      expect(new_user.valid?).must_equal false
      expect(new_user.errors.messages).must_include :name 

      expect(new_user.errors.messages[:name]).must_include "can't be blank"
    end

    it "returns true if it has a name" do 
      # Arrange
      new_user.name = "Ellen"

      # Assert 
      expect(new_user.valid?).must_equal true
    end
  end
end
