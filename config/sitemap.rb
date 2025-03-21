# config/sitemap.rb

# Ensure the correct helper methods are loaded
Rails.application.routes.default_url_options[:host] = 'localhost:3000'

SitemapGenerator::Sitemap.default_host = 'http://localhost:3000'

SitemapGenerator::Sitemap.create do
  Ticket.find_each do |ticket|
    add(ticket_path(ticket), lastmod: ticket.updated_at, changefreq: 'weekly', priority: 0.7)
  end

  Expense.find_each do |expense|
    add(expense_path(expense), lastmod: expense.updated_at, changefreq: 'weekly', priority: 0.6)
  end
end
