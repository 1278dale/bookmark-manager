require 'spec_helper'


feature "user signs up" do

  # Strictly speaking, the tests that check the UI
  # (have_content, etc.) should be separate from the tests
  # that check what we have in the DB. The reason is that
  # you should test one thing at a time, whereas
  # by mixing the two we're testing both
  # the business logic and the views.
  #
  # However, let's not worry about this yet
  # to keep the example simple.

  scenario "when being logged out" do
      expect{ sign_up }.to change(User, :count).by(1)
      expect(page).to have_content("Welcome, alice@example.com")
      expect(User.first.email).to eq("alice@example.com")
    end


  scenario "with a password that doesn't match" do
    expect{ sign_up('a@a.com', 'pass', 'wrong') }.to change(User, :count).by(0)
    expect(current_path).to eq('/users')
    expect(page).to have_content("Sorry, your passwords don't match")
  end
  # This test expects the website to stay at /users, instead of navigating to the home page (note the use of the current_path helper, provided by capybara). The reason is that we are submitting the form to /users and we don't want the redirection to happen if the user is not saved because we will lose the unsaved data.

  def sign_up(email = "alice@example.com", password = "oranges!", password_confirmation = "oranges!")
    visit '/users/new'
    fill_in :email, :with => email
    fill_in :password, :with => password
    fill_in :password_confirmation, :with => password_confirmation
    click_button "Sign up"
  end

  scenario "with an email that is already registered" do
    expect{ sign_up }.to change(User, :count).by(1)
    expect{ sign_up }.to change(User, :count).by(0)
    expect(page).to have_content("This email has already been taken")
  end
end

