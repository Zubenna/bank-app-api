Rails.application.routes.draw do

  namespace 'api' do
    namespace 'v1' do 
      resources :registrations
    end
  end

  namespace 'api' do
    namespace 'v1' do
      post "bank_accounts/new_transaction", to: "bank_account#new_transaction"
    end
  end

  get "api/v1/logged_in", to: "api/v1/sessions#logged_in?"
  delete "api/v1/logout", to: "api/v1/sessions#destroy"
  post "api/v1/login", to: "api/v1/sessions#create"
end