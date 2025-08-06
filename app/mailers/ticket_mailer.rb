class TicketMailer < ApplicationMailer
  def notify_employee_and_tl(ticket)
    @ticket = ticket

    @employee = @ticket.user
    if @employee.tl_id.present?
      @team_lead = User.find_by(id: @employee.tl_id)

      mail(
        to: @employee&.email,
        cc: @team_lead&.email,
        subject: "New Ticket Created by #{@employee.full_name}"
      )
    end
  end

  def notify_employee_on_rejection(ticket)
    @ticket = ticket

    @employee = @ticket.user
    if @employee.tl_id.present?
      @team_lead = User.find_by(id: @employee.tl_id) 

      mail(
        to: @employee&.email, 
        cc: @team_lead&.email,
        subject: "Your Ticket Was Rejected"
      )
    end
  end

  def notify_employee_on_approval(ticket)
    @ticket = ticket
    
    @employee = @ticket.user
    if @employee.tl_id.present?
      @team_lead = User.find_by(id: @employee.tl_id) 
      recipient_emails = []

      recipient_emails << @team_lead&.email
      recipient_emails += User.where(role: %w[admin hr operation_head]).pluck(:email)
      recipient_emails.uniq!

      mail(
        to: @employee&.email, 
        cc: recipient_emails,
        subject: "Ticket Approved"
      )
    end
  end

  def notify_ticket_status(ticket, employee, current_user)
    @ticket = ticket
    @employee = employee
    if @employee.tl_id.present?
      @team_lead = User.find_by(id: @employee.tl_id) 
      recipient_emails = []

      recipient_emails << @team_lead&.email
      recipient_emails += User.where(role: %w[admin hr operation_head]).pluck(:email)
      recipient_emails.uniq!

      mail(
        to: @employee&.email, 
        cc: recipient_emails,
        subject: "Ticket Status."
      )
    end
  end
end
