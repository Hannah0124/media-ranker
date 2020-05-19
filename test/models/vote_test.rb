require "test_helper"

describe Vote do

  let (:new_work) {
    works(:avengers)
  }

  let (:new_user) {
    users(:dog)
  }

  let (:new_vote) {
    Vote.new(work_id: new_work.id, user_id: new_user.id)
  }

  it "can be instantiated" do
    expect(new_vote.valid?).must_equal true
  end

  it "will have the required fields" do 
    new_vote.save 

    vote = Vote.first 

    # Assert
    [:work_id, :user_id].each do |field| 
      expect(vote).must_respond_to field
    end
  end

  describe "relationships" do 
    it "belongs to a work and user" do 
      expect(new_vote.work).must_be_instance_of Work
      expect(new_vote.user).must_be_instance_of User
    end
  end

  describe "validations" do 
    it "must have work_id" do
      # Ararnge 
      new_vote.work_id = nil 

      # Assert
      expect(new_vote.valid?).must_equal false 
      expect(new_vote.errors.messages).must_include :work_id
      expect(new_vote.errors.messages[:work_id]).must_include "can't be blank"
    end

    it "must have user_id" do 
      # Ararnge 
      new_vote.user_id = nil 

      # Assert
      expect(new_vote.valid?).must_equal false 
      expect(new_vote.errors.messages).must_include :user_id
      expect(new_vote.errors.messages[:user_id]).must_include "can't be blank"
    end
  end

  describe "custom methods" do 
    describe "self.upvoted?(work_id, user_id)" do

      it "will return true if a work was upvoted by the same user" do 
        new_vote.save
        expect(Vote.upvoted?(new_work.id, new_user.id)).must_equal true
      end

      it "will return false if a work was not upvoted previously" do 
        new_vote.save

        finn = users(:human)
        expect(Vote.upvoted?(new_work.id, finn.id)).must_equal false
      end
    end
  end
end
