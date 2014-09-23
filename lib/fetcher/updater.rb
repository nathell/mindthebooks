require_relative 'fetcher'
require 'active_record'
require 'sqlite3'
require 'rails/all'
require 'active_record/railtie'
require_relative '../../app/models/user'
require_relative '../../app/models/card'
require_relative '../../app/models/card_info'
require_relative '../../app/models/book'

# This program is not part of the Rails Mind the Books app proper;
# rather, it runs as a separate process, typically invoked from cron.
# However, it needs access to the MTB ActiveRecord models, and we want
# to keep ourselves DRY. So we need to instantiate Rails config manually
# (we can't just access Rails.application.config, since Rails.application
# will be nil), which the hackery below does.

# Note that respecting Rails.env enables us to test it properly. See
# spec/fetcher/.

Rails.logger = Rails.logger or Logger.new STDERR
Rails.logger.debug "Setting up database: #{Rails.env.intern}" 
config = Rails::Application::Configuration.new ""
ActiveRecord::Base.configurations = config.database_configuration
ActiveRecord::Base.establish_connection 

def synchronize_card_data(fetcher, card)
  Rails.logger.info "Synchronizing data for card: #{card.number}"
  fetcher.login card.number
  new_card_info = extract_card_info(fetcher.page)
  if card.card_info
    card.card_info.cardholder = new_card_info[:cardholder]
    card.card_info.charges = new_card_info[:charges]
    old_books = card.card_info.books.map { |x| x.library_id }
    to_delete = (old_books.to_set - new_card_info[:books].map { |x| x[:library_id] }.to_set).to_a
    for book in new_card_info[:books]
      library_id = book[:library_id]
      if old_books.include? library_id
        card.card_info.books.find { |x| x.library_id == library_id }.update book
      else
        card.card_info.books.create! book
      end
    end
    card.card_info.books.delete(card.card_info.books.where({library_id: to_delete}))
  else
    books = new_card_info.delete(:books)
    card.card_info = CardInfo.new(new_card_info)
    card.card_info.books = books.map { |x| Book.new x }
    card.card_info.save
  end
end

def renew_on_demand(client, card)
end

def run
  fetcher = Fetcher.new
  for user in User.all
    for card in user.cards
      synchronize_card_data fetcher, card
    end
  end
end

if __FILE__ == $0
  run
end
