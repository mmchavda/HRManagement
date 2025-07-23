# Preview all emails at http://localhost:3000/rails/mailers/ticket_mailer
class TicketMailerPreview < ActionMailer::Preview
  def notify_employee_and_tl
    user = User.find_by(email: "shivani.shilpi@techcronus.com")   # for test 
    ticket = Ticket.first
    TicketMailer.notify_employee_and_tl(ticket)
  end
end
