class AccountTransaction < ApplicationRecord
  belongs_to :bank_account
  
  TRANSACTION_TYPES = ["withdraw", "deposit", "balance"]
  validates_presence_of :bank_account, :amount, :transaction_number, :transaction_type
  validates :transaction_type, inclusion: { in: TRANSACTION_TYPES}
  validates :amount, numericality:true
  validates :transaction_number, uniqueness:true

  before_validation :load_defaults

  def load_defaults
    if self.new_record?
    self.transaction_number = SecureRandom.uuid
    end
  end
end
