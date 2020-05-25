describe UsersController do

  describe "index" do 
    it "responds with sucess when there are many users saved" do 
      # Act 
      get users_path

      # Assert
      expect(User.count).must_be :>, 0
      must_respond_with :success
    end

    it "responds with sucess when there are no users saved" do 
      # Arrange
      User.all.each do |user|
        user.destroy
      end

      # Act 
      get users_path

      # Assert
      expect(User.count).must_equal 0
      must_respond_with :success
    end
  end

  describe "show" do 
    it "responds with success when showing an existing valid user_id" do 
      # Arrange
      new_user = users(:dog)

      # Act 
      valid_id = new_user.id 
      get user_path(valid_id)

      # Assert 
      must_respond_with :success
    end

    it "responds with 404 with an invalid user id" do 
      # Arrange 
      invalid_id = -1

      # Act
      get user_path(invalid_id)

      # Assert 
      must_respond_with :not_found
    end
  end

  describe "login_form" do 
    it "responds with success" do 
      get login_path 

      must_respond_with :success
    end
  end

  describe "login" do 
    it "can login a new user" do 
      user = nil # because of the scope issue, create a variable here first. 

      expect {
        user = login()
      }.must_differ "User.count", 1

      must_respond_with :redirect 

      expect(user).wont_be_nil 
      expect(session[:user_id]).must_equal user.id 
      expect(user.name).must_equal "Grace Hopper"
    end


    it "can login an existing user" do 
      user = users(:bubblegum)

      expect {
        login(user.name)
      }.wont_change "User.count"

      expect(session[:user_id]).must_equal user.id 
    end
  end

  describe 'logout' do
    it 'can logout a logged in user' do
      # Arrange
      login()
      expect(session[:user_id]).wont_be_nil

      #Act
      post logout_path

      expect(session[:user_id]).must_be_nil
    end
  end
end
