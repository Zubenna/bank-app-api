module Api 
    module V1 
      class BankAccountsController < ApplicationController 
        def new_deposit
          amount = params[:amount]
          transaction_type = params[:transaction_type]
          bank_account_id = params[:bank_account_id]
        errors = ::BankAccounts::ValidateNewTransaction.new(
                 amount: amount,
                 transaction_type: transaction_type,
                 bank_account_id: bank_account_id
                ).execute! 
        if (errors[0] == "Account not found")
          render json: { errors: errors }, status: 402
        else
          bank_account = ::BankAccounts::PerformTransaction.new(
            amount: amount,
            transaction_type: transaction_type,
            bank_account_id: bank_account_id
          ).execute!
         render json: { balance: bank_account.balance}
        end
      end

      def new_withdraw
        amount = params[:amount]
        transaction_type = params[:transaction_type]
        bank_account_id = params[:bank_account_id]
      errors = ::BankAccounts::ValidateNewTransaction.new(
               amount: amount,
               transaction_type: transaction_type,
               bank_account_id: bank_account_id
              ).execute! 
      error = ::BankAccounts::ValidateWithdrawal.new(
               amount: amount,
               transaction_type: transaction_type,
               bank_account_id: bank_account_id
              ).execute! 
      if (error[0] == "Not enough funds")
        render json: { errors: error }, status: 402
      elsif (errors[0] == "Account not found")
        render json: { errors: errors }, status: 402
      else
        bank_account = ::BankAccounts::PerformTransaction.new(
          amount: amount,
          transaction_type: transaction_type,
          bank_account_id: bank_account_id
        ).execute!
       render json: { balance: bank_account.balance}
      end
    end

    def check_balance
      amount = params[:amount]
      transaction_type = params[:transaction_type]
      bank_account_id = params[:bank_account_id]
    errors = ::BankAccounts::ValidateNewTransaction.new(
             amount: amount,
             transaction_type: transaction_type,
             bank_account_id: bank_account_id
            ).execute! 
    if (errors[0] == "Account not found")
      render json: { errors: errors }, status: 402
    else
      bank_account = ::BankAccounts::PerformTransaction.new(
        amount: amount,
        transaction_type: transaction_type,
        bank_account_id: bank_account_id
      ).execute!
     render json: { balance: bank_account.balance}
    end
  end

          def index 
              @accounts = BankAccount.all
              @users = User.all
              render json: { acc: accounts, user: users }
          end

          def total_accounts
            number_accounts = BankAccount.count
            if number_accounts > 0
              render json: { status: 'SUCCESS', message: 'Accounts exist', data: number_accounts }, status: :ok
            else
              render json: { status: 'SUCCESS', message: 'No account created', data: 0 }, status: :ok 
            end
          end

          def total_users
            number_users = User.count
            if number_users > 0
              render json: { status: 'SUCCESS', message: 'Users exist', data: number_users }, status: :ok
            else
              render json: { status: 'SUCCESS', message: 'No user created', data: 0 }, status: :ok 
            end
          end
      end
    end
  end
  