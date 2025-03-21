
**HR Management In-house Project** 

This project is an HR Management system built to manage employee requests, tickets, reimbursements, and admin functions with a focus on authentication, role-based access, and audit tracking.

**Features**

The following features have been implemented in the project:

 **1. Authentication and Authorization**
 Device-based and Role-based authentication for users.
 Users are authenticated based on their device and role.
 
 **2. Ticket Management**
 Employees can create tickets for technical requests (e.g., equipment such as headphones).
 Tickets created by employees are visible to the employee, admin, HR, and lead.
 Admin, HR, and lead can change the ticket status to "Resolved" or "In Progress".
 
 **3. Reimbursement Request**
 Employees can create expense requests and corresponding reimbursement requests.
 Reimbursement requests are visible to admin, HR, and lead, who can approve or reject the requests.
 Employees can view their own reimbursement requests, tickets, and expenses.
 Admin, HR, and lead can view all tickets and reimbursement requests and download reports for any user.
 
 **4. Audit Trail**
 The system tracks approvals and actions for tickets and reimbursement requests (e.g., tracking who approved a reimbursement request).
 
 **5. Pagination**
 Pagination has been added for index views. If there are more than 10 records, pagination will be applied to manage the views efficiently.
 
 **6. User Profile**
 Users can view and update their own profiles.
 
 **7. Admin and HR Dashboard**
 Admin and HR can access the following metrics:
 Number of reimbursement requests.
 Number of tickets and pending tickets.
 Recent reimbursement requests.
 Recent tickets.
 
**Technologies Used**
Ruby: 3.2.3
Rails: 8.0.1

**Steps to Run the Project**

Clone the Repository (if applicable):

**git clone <repository-url>**
**cd <project-directory>**

**Install Dependencies:**  Run the following command to install the required Ruby gems:

**bundle install**

**Database Setup:**  Run the following commands to set up the database:

Migrate the database:
**rails db:migrate**

Seed the database with initial data:
**rails db:seed**

Start the Server: You can start the server with:
**rails s**

Your app will be available at **http://localhost:3000**.

Console: To access the Rails console, use:

**rails c**
