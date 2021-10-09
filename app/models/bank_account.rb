class BankAccount < ApplicationRecord
  belongs_to :user
  has_many :account_transactions
  validates_presence_of :user, :account_number, :balance
  validates_uniqueness_of :account_number
  validates :balance, numericality: true

  before_validation :load_defaults

  def load_defaults
    self.balance = 0.00 if new_record?
  end

  def to_s
    account_number
  end
end
