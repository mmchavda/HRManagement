require "test_helper"

class TicketTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  RSpec.describe Ticket, type: :model do

    it "is valid with valid attributes" do
      user = User.create(email: 'test@example.com', password: 'password')
      ticket = Ticket.new(title: 'Sample Ticket', description: 'This is a sample ticket', user: user, status: :new, priority: :low)
      expect(ticket).to be_valid
    end

    it "is not valid without a title" do
      ticket = Ticket.new(title: nil)
      expect(ticket).to_not be_valid
    end

    it "is not valid without a user" do
      ticket = Ticket.new(user: nil)
      expect(ticket).to_not be_valid
    end

    it "has a default status of new" do
      ticket = Ticket.new
      expect(ticket.status).to eq('new')
    end

    it "has a default priority of low" do
      ticket = Ticket.new
      expect(ticket.priority).to eq('low')
    end

    it "can change status" do
      ticket = Ticket.new(status: :new)
      ticket.status = :in_progress
      expect(ticket.status).to eq('in_progress')
    end

    it "can change priority" do
      ticket = Ticket.new(priority: :low)
      ticket.priority = :high
      expect(ticket.priority).to eq('high')
    end
  end   
end
