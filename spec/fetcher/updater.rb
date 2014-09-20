require 'spec_helper'
require 'rails_helper'
require 'fakeweb'
require 'fetcher/updater'

def mock_web(url, file)
  FakeWeb.register_uri(:any, url, body: IO.read("spec/fetcher/pages/#{file}"), content_type: "text/html")
end

describe "Updater" do
  let(:user) { FactoryGirl.create(:user) }
  before do
    @client = Mechanize.new
    @card = user.cards.build(number: "01234567")
    FakeWeb.allow_net_connect = false
    mock_web SOUTHWARK_LIBRARY_URL, "login.html"
  end
  
  it "should pick up borrowed books" do
    mock_web SOUTHWARK_LOGINFORM_URL, "books-list.html"
    synchronize_card_data @client, @card
    puts @card.card_info.books.inspect
  end
end
