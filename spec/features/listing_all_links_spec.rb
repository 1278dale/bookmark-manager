require 'spec_helper'

feature "User browses the list of links" do

  before(:each) {
    Link.create(:url => "http://www.makersacademy.com",
               :title => "Makers Academy",
               :tags => [Tag.first_or_create(:text => 'education')])
    Link.create(:url => "http://www.google.com",
                :title => "Google",
                :tags => [Tag.first_or_create(:text => 'search')])
    Link.create(:url => "http://www.bing.com",
                :title => "Bing",
                :tags => [Tag.first_or_create(:text => 'search')])
    Link.create(:url => "http:/www.code.org",
                :title => "Code.org",
                :tags => [Tag.first_or_create(:text => 'education')])
  }

  scenario "when opening the home page" do
    visit '/'
    expect(page).to have_content("Makers Academy")
  end

  scenario "filtered by a tag" do
  visit '/tags/search'
  expect(page).not_to have_content("Makers Academy")
  expect(page).not_to have_content("Code.org")
  expect(page).to have_content("Google")
  expect(page).to have_content("Bing")
end

  # scenario "filtered by a tag" do
  #   visit '/tags/search'
  #   expect(page).not_to have_content("Makers Academy")
  #   expect(page).not_to have_content("Code.org")
  #   expect(page).to have_content("Google")
  #   expect(page).to have_content("Bing")
  # end
end
# So, this test creates one link, goes to the homepage and expects to see it there (well, not exactly, it just looks for "Makers Academy" words somewhere on the page). If you run the test, it should fail.