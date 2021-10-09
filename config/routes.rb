Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do 
    resources :registrations, :only => [:create, :destroy, :index, :update]
    end
  end

  namespace 'api' do
    namespace 'v1' do
      post "bank_accounts/new_deposit", to: "bank_accounts#new_deposit"
      post "bank_accounts/new_withdraw", to: "bank_accounts#new_withdraw"
      post "bank_accounts/create", to: "bank_accounts#create"
      get "bank_accounts/list_transactions", to: "bank_accounts#list_transactions"
      get "bank_accounts/check_balance", to: "bank_accounts#check_balance"
      get "bank_accounts/total_accounts", to: "bank_accounts#total_accounts"
      get "bank_accounts/total_users", to: "bank_accounts#total_users"
      get "bank_accounts/index", to: "bank_accounts#index"
    end
  end

  get "api/v1/logged_in", to: "api/v1/sessions#logged_in?"
  delete "api/v1/logout", to: "api/v1/sessions#destroy"
  post "api/v1/login", to: "api/v1/sessions#create"
end
