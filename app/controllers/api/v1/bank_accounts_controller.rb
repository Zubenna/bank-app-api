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
        if errors[0] == 'Account not found'
          render json: { errors: errors }, status: 402
        else
          bank_account = ::BankAccounts::PerformTransaction.new(
            amount: amount,
            transaction_type: transaction_type,
            bank_account_id: bank_account_id
          ).execute!
          render json: { balance: bank_account.balance }
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
        if errors[0] == 'Account not found'
          render json: { errors: errors }, status: 402
        end
        if errors.empty?
        error = ::BankAccounts::ValidateWithdrawal.new(
          amount: amount,
          transaction_type: transaction_type,
          bank_account_id: bank_account_id
        ).execute!
          if error[0] == 'Not enough funds'
            render json: { errors: error }, status: 402
          end
        end
        if errors.empty? && error.empty?
          bank_account = ::BankAccounts::PerformTransaction.new(
            amount: amount,
            transaction_type: transaction_type,
            bank_account_id: bank_account_id
          ).execute!
          render json: { balance: bank_account.balance }
        end
      end

      def check_balance
        amount = params[:amount]
        transaction_type = params[:transaction_type]
        bank_account_id = params[:bank_account_id]
        errors = ::BankAccounts::ValidateNewTransaction.new(
          amount: 0.0,
          transaction_type: transaction_type,
          bank_account_id: bank_account_id
        ).execute!
        if errors[0] == 'Account not found'
          render json: { errors: errors }, status: 402
        else
          bank_account = ::BankAccounts::PerformTransaction.new(
            amount: 0.0,
            transaction_type: transaction_type,
            bank_account_id: bank_account_id
          ).execute!
          render json: { balance: bank_account.balance }
        end
      end

      def list_transactions
        amount = params[:amount]
        transaction_type = params[:transaction_type]
        bank_account_id = params[:bank_account_id]
        errors = ::BankAccounts::ValidateNewTransaction.new(
          amount: 0.0,
          transaction_type: transaction_type,
          bank_account_id: bank_account_id
        ).execute!
        if errors[0] == 'Account not found'
          render json: { errors: errors }, status: 402
        else
          bank_account = ::BankAccounts::PerformTransaction.new(
            amount: 0.0,
            transaction_type: transaction_type,
            bank_account_id: bank_account_id
          ).execute!
          render json: { list: bank_account }
        end
      end

      def index
        @accounts = BankAccount.all
        @users = User.all
        # @test = BankAccount.joins(:user).where(users: { country: "Australia" })

        # @name = User.first_name.where(b)
        render json: { acc: @accounts, user: @users }
       
      end

      def create
        acc_number = BankAccount.create(bank_account_params)
        if  acc_number.save
          render json: { status: 'created', message: 'Saved Bank Account Number', data: acc_number }
        else
          render json: { status: 500, message: 'Account Number not saved', errors: acc_number.errors }
        end
      end

      def total_accounts
        number_accounts = BankAccount.count
        if number_accounts.positive?
          render json: { status: 'SUCCESS', message: 'Accounts exist', data: number_accounts }, status: :ok
        else
          render json: { status: 'SUCCESS', message: 'No account created', data: 0 }, status: :ok
        end
      end

      def total_users
        number_users = User.count
        if number_users.positive?
          render json: { status: 'SUCCESS', message: 'Users exist', data: number_users }, status: :ok
        else
          render json: { status: 'SUCCESS', message: 'No user created', data: 0 }, status: :ok
        end
      end

      private
      
      def bank_account_params
        params.permit(:user_id, :account_number)
      end
    end
  end
end
