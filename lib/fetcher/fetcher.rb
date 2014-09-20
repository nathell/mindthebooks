require 'mechanize'

SOUTHWARK_LIBRARY_URL = 'https://capitadiscovery.co.uk/southwark/login'
SOUTHWARK_LOGINFORM_URL = 'https://capitadiscovery.co.uk/southwark/sessions' # for tests only

def extract_card_info(books_page)
  doc = books_page.parser
  summary = doc.at_css(".accountSummary").inner_text.strip
  info = /Hello (.*)!.*You have (.*) in charges/m.match(summary)
  books = doc.css('table#loans tbody tr').map do |tr| 
    due_date = tr.css(".accDue").inner_text.strip.to_date
    if due_date < Date.today
      due_date += 1.year
    end
    { author: tr.css("span.author").inner_text,
      title: tr.css("th a").inner_text.strip,
      library_id: tr.at_css("th a").attr("href").sub("items/", "").to_i,
      due_date: due_date,
      fine: tr.css(".accFines").inner_text.strip,
      renew_count: tr.css(".accRenews").inner_text.strip.to_i }
  end
  {cardholder: info[1], charges: info[2], books: books}
end

def download_books_page(client, card_number)
  page = client.get SOUTHWARK_LIBRARY_URL
  form = page.form_with id: "borrowerServices"
  form.field_with(name: "barcode").value = card_number
  client.submit form
end
