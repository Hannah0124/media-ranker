require "test_helper"

describe VotesController do
  describe "logged in user" do 
    it "can upvote" do 
      login

      fun_work = Work.create(title: "fun work")

      expect {
        post work_upvote_path(fun_work.id).must_change "Vote.count", 1
      }

      # TODO
      # expect(flash[:success]).must_equal "Successfully upvoted!"
      must_respond_with :redirect
    end

    it "cannot upvote the same work more than once" do 
      user = login

      test_work = Work.create(title: "test work")
      Vote.create(work_id: test_work.id, user_id: user.id)

      expect {
        post work_upvote_path(test_work.id).wont_change "Vote.count"
        expect(flash[:warning]).must_equal "A problem occurred: Could not upvote, user: has already voted for this work"
      }

      must_respond_with :redirect
    end
  end

  describe "not logged in user" do 
    it "cannot upvote without logging in" do 
      new_work = Work.create(title: "new work")

      expect {
        post work_upvote_path(new_work.id).wont_change "Vote.count"
      }

      # TODO
      # expect(flash[:warning]).must_include "A problem occured: You must log in to do that :("
      # must_respond_with :redirect
    end
  end

end
