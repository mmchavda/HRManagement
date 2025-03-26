Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:index, :edit, :update, :destroy, :show]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "dashboard#index"

  resources :dashboard
  resources :tickets do
    collection do
      get :export_csv  # Add a route for the export action
    end
  end

  resources :reimbursement_requests do
    collection do
      get :export_csv  # Add a route for the export action
    end
  end   
  resources :expenses do
    collection do
      get :export_csv  # Add a route for the export action
    end 
  end

  get 'reimbursement_requests/:id/approve_request', to: 'reimbursement_requests#approve_request', as: 'approve_reimbursement_request'
  get 'reimbursement_requests/:id/reject_request', to: 'reimbursement_requests#reject_request', as: 'reject_reimbursement_request'
  patch 'tickets/:id/assign_ticket', to: 'tickets#assign_ticket', as: 'assign_ticket'
  get 'tickets/:id/close_ticket', to: 'tickets#close_ticket', as: 'close_ticket'
  get 'tickets/:id/reopen_ticket', to: 'tickets#reopen_ticket', as: 'reopen_ticket'
  post 'tickets/:id/resolve_ticket', to: 'tickets#resolve_ticket', as: 'resolve_ticket'
  get 'tickets/:id/unassign_ticket', to: 'tickets#unassign_ticket', as: 'unassign_ticket'
  get 'reports', to: 'dashboard#reports', as: 'reports'

end
