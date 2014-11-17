require 'spec_helper'

feature "User browses the list of links" do

  before(:each) {
    Link.create(:url => "http://www.makersacademy.com",
               :title => "Makers Academy")
  }

  scenario "when opening the home page" do
    visit '/'
    expect(page).to have_content("Makers Academy")
  end
end

# So, this test creates one link, goes to the homepage and expects to see it there (well, not exactly, it just looks for "Makers Academy" words somewhere on the page). If you run the test, it should fail.