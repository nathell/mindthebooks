require 'spec_helper'
require 'rails_helper'
require 'fakeweb'
require 'fetcher/updater'

def mock_web(url, file)
  FakeWeb.register_uri(:any, url, body: IO.read("spec/fetcher/pages/#{file}"), content_type: "text/html")
end

def pretend_to_obtain_books(file) 
  mock_web SOUTHWARK_LOGINFORM_URL, file
  synchronize_card_data @client, @card
end

describe "Updater" do
  let(:user) { FactoryGirl.create(:user) }

  before do
    @client = Mechanize.new
    @card = user.cards.build(number: "01234567")
    FakeWeb.allow_net_connect = false
    mock_web SOUTHWARK_LIBRARY_URL, "login.html"
  end

  subject(:books) { @card.card_info.books }
  
  it "should pick up a borrowed book" do
    pretend_to_obtain_books "books-list.html"
    expect(books.length).to eq 1
    expect(books.first.attributes).to include ({
      "author" => "Jones, Tom",
      "title" => "Tired of London, tired of life : one thing a day to do in London",
      "due_date" => "2014-09-28".to_date
    })
  end

  it "should pick up more books" do 
    pretend_to_obtain_books "books-list.html"
    pretend_to_obtain_books "books-list-2.html"
    expect(books.length).to eq 2
    expect(books.second.attributes).to include ({
      "author" => "Marchant, Ian",
      "title" => "Something of the night",
      "due_date" => "2014-10-05".to_date
    })
  end

  it "should be able to update book due date properly" do
    pretend_to_obtain_books "books-list.html"
    pretend_to_obtain_books "books-list-2.html"
    pretend_to_obtain_books "books-list-3.html"
    expect(books.length).to eq 3
    expect(books.third.attributes).to include ({
      "author" => "McCarthy, John, 1956-",
      "title" => "You can't hide the sun: a journey through Palestine",
      "due_date" => "2014-10-10".to_date
    })
    expect(books.first.due_date).to eq "2014-10-10".to_date # it should have changed
  end

  it "should remove books returned to the library" do
    pretend_to_obtain_books "books-list.html"
    pretend_to_obtain_books "books-list-2.html"
    pretend_to_obtain_books "books-list-3.html"
    old_book_list = books.to_a
    pretend_to_obtain_books "books-list-4.html" # we return "Tired of London..."
    expect(books).to eq old_book_list[1..2]
  end

  it "should not fail when there are no books" do
    pretend_to_obtain_books "books-list-empty.html"
    expect(books).to be_empty
  end
end
