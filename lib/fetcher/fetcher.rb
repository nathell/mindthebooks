# -*- coding: utf-8 -*-

require 'mechanize'

class Fetcher
  SOUTHWARK_LIBRARY_URL = 'https://capitadiscovery.co.uk/southwark/login'
  SOUTHWARK_LOGINFORM_URL = 'https://capitadiscovery.co.uk/southwark/sessions'
  SOUTHWARK_RENEW_URL = 'https://capitadiscovery.co.uk/southwark/account/loans'

  def initialize
    @state = :not_logged_in
    @client = Mechanize.new
    @page = nil
    @card_number = nil
  end

  def login(card_number)
    if @state != :not_logged_in and @card_number != card_number
      logout
    end
    @page = @client.get SOUTHWARK_LIBRARY_URL
    form = @page.form_with id: "borrowerServices"
    form.field_with(name: "barcode").value = card_number
    @page = @client.submit form
    @state = :books_list
    @card_number = card_number
  end

  def logout
    if @state != :not_logged_in
      logout_form = @page.form_with id: "logout"
      @page = @client.submit logout_form
      @state = :not_logged_in
    end
  end

  def renew(loan_ids)
    form = @page.form_with class: "renewForm renewall posRight posRel"
    form.field_with(name: "loan_ids[]").value = loan_ids.join " "
    @page = @client.submit form
  end

  def page
    @page
  end

  def state
    @state
  end
end

def extract_card_info(books_page)
  doc = books_page.parser
  summary = doc.at_css(".accountSummary").inner_text.strip
  name_info = /Hello (.*)!/m.match(summary)
  charges_info = /You have (.*) in charges/m.match(summary) || [nil, "£0"]
  books = doc.css('table#loans tbody tr').map do |tr| 
    due_date = tr.css(".accDue").inner_text.strip.to_date
    if due_date < Date.today
      due_date += 1.year
    end
    { author: tr.css("span.author").inner_text,
      title: tr.css("th a").inner_text.strip,
      library_id: tr.at_css("th a").attr("href").sub("items/", "").to_i,
      library_loan_id: tr.attr("id").sub("row_", "").to_i,
      due_date: due_date,
      fine: tr.css(".accFines").inner_text.strip,
      renew_count: tr.css(".accRenews").inner_text.strip.to_i }
  end
  {cardholder: name_info[1], charges: charges_info[1], books: books}
end
