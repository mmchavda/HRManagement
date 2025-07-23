class TicketMailer < ApplicationMailer
  def notify_employee_and_tl(ticket)
    @ticket = ticket

    @employee = @ticket.user
    @team_lead = User.find_by(id: @employee.tl_id)

    mail(
      to: @employee.email,
      cc: @team_lead.email,
      subject: "New Ticket Created by #{@employee.full_name}"
    )
  end

  def notify_employee_on_rejection(ticket)
    @ticket = ticket

    @employee = @ticket.user
    @team_lead = User.find_by(id: @employee.tl_id)

    mail(
      to: @employee.email, 
      cc: @team_lead.email,
      subject: "Your Ticket Was Rejected"
    )
  end

  def notify_employee_on_approval(ticket)
    @ticket = ticket
    
    @employee = @ticket.user
    @team_lead = User.find_by(id: @employee.tl_id)
    recipient_emails = []

    recipient_emails << @team_lead.email if @team_lead.present?
    recipient_emails += User.where(role: %w[admin hr operation_head]).pluck(:email)
    recipient_emails.uniq!

    mail(
      to: @employee.email, 
      cc: recipient_emails,
      subject: "Ticket Approved"
    )
  end
end
