require 'rails_helper'

feature "see show page for a submission" do
  before(:each) do
    @greg = FactoryGirl.create(:user)
    @min_submission = FactoryGirl.create(:submission, user: @greg)
    @comment = FactoryGirl.create(:comment, :min, submission: @min_submission, user: @greg)
    @rating = FactoryGirl.create(:rating, user: @greg, submission: @min_submission, comment: @comment)
  end

  scenario "user visit minimum submission" do

    visit submission_path(@min_submission)

    login_as(@greg, :scope => :user)

    expect(page).to have_content(@min_submission.title)
    expect(page).to have_content(@greg.username)
    expect(page).to have_css("img[src*='test_submission_image.jpeg']")
  end

  scenario "user visit full submission" do
    full_submission = FactoryGirl.create(:submission, :full, user: @greg)
    comment = FactoryGirl.create(:comment, submission: full_submission, user: @greg)

    visit submission_path(full_submission)

    login_as(@greg, :scope => :user)

    expect(page).to have_content(full_submission.title)
    expect(page).to have_content(full_submission.comments[0].body)
    expect(page).to have_content(@greg.username)
    expect(page).to have_link("Original Review", href: full_submission.url)
    expect(page).to have_css("img[src*='test_submission_image.jpeg']")
  end

end

feature "user can see comments on page" do
  before(:each) do
    @greg = FactoryGirl.create(:user)
    @min_submission = FactoryGirl.create(:submission, user: @greg)
    @comment = FactoryGirl.create(:comment, :min, submission: @min_submission, user: @greg)
    @rating = FactoryGirl.create(:rating, user: @greg, submission: @min_submission, comment: @comment)
  end

  scenario "user goes to show page for a submission for comments" do
    steven = FactoryGirl.create(:user)

    first_comment = FactoryGirl.create(:comment, submission: @min_submission, user: steven)
    first_rating = FactoryGirl.create(:rating, user: steven, submission: @min_submission, comment: first_comment)

    login_as(steven, :scope => :user)
    visit submission_path(@min_submission)

    expect(page).to have_content(first_comment.body)
    expect(page).to have_content(steven.username)
  end
end


feature "user can see ratings on show page" do
  before(:each) do
    @greg = FactoryGirl.create(:user)
    @min_submission = FactoryGirl.create(:submission, user: @greg)
    @comment = FactoryGirl.create(:comment, :min, submission: @min_submission, user: @greg)
  end

  scenario "user goes to show page for a submission" do

    first_comment = FactoryGirl.create(:comment, user: @greg, submission_id: @min_submission.id)
    first_rating = FactoryGirl.create(:rating, user: @greg, submission_id: @min_submission.id, comment_id: first_comment.id)

    visit submission_path(@min_submission)
    expect(page).to have_content("Overall Troll: 1")
    expect(page).to have_content("Overall Funny: 3")
    expect(page).to have_content("Overall Story: 5")
    expect(page).to have_content("Overall Helpful: 1")
    expect(page).to have_content(first_rating.troll)
    expect(page).to have_content(first_rating.funny)
    expect(page).to have_content(first_rating.story)
    expect(page).to have_content(first_rating.helpful)
  end
end

feature "user sees edit submisison link" do
  before(:each) do
    @greg = FactoryGirl.create(:user)
    @min_submission = FactoryGirl.create(:submission, user: @greg)
    @comment = FactoryGirl.create(:comment, :min, submission: @min_submission, user: @greg)
  end

  scenario "user sees link if owner" do
    login_as(@greg, :scope => :user)

    visit submission_path(@min_submission)

    expect(page).to have_content(@min_submission.title)
    expect(page).to have_content(@greg.username)
    expect(page).to have_css("img[src*='test_submission_image.jpeg']")
    expect(page).to have_link("Edit this Jawn")
  end

  scenario "user doesn't see link if not owner" do
    not_greg = FactoryGirl.create(:user)

    visit submission_path(@min_submission)

    expect(page).to have_content(@min_submission.title)
    expect(page).to have_content(@greg.username)
    expect(page).to have_css("img[src*='test_submission_image.jpeg']")
    expect(page).to_not have_link("Edit this Jawn")
  end
end
