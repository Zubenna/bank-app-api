module BankAccounts
  class PerformTransaction
    def initialize(amount:, transaction_type:, bank_account_id:)
      @amount = amount
      @transaction_type = transaction_type
      @bank_account_id = bank_account_id
      @bank_account = BankAccount.where(id: @bank_account_id).first
    end

    def execute!
      AccountTransaction.create!(
        bank_account: @bank_account,
        amount: @amount,
        transaction_type: @transaction_type
      )
      case @transaction_type
      when 'withdraw'
        @bank_account.update!(balance: @bank_account.balance - @amount)
      when 'deposit'
        @bank_account.update!(balance: @bank_account.balance + @amount)
      when 'balance'
        @bank_account.update!(balance: @bank_account.balance)
      end

      @bank_account
    end
  end
end
