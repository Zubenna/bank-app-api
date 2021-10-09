class AccountTransaction < ApplicationRecord
  belongs_to :bank_account

  TRANSACTION_TYPES = %w[withdraw deposit balance].freeze
  validates_presence_of :bank_account, :amount, :transaction_number, :transaction_type
  validates :transaction_type, inclusion: { in: TRANSACTION_TYPES }
  validates :amount, numericality: true
  validates :transaction_number, uniqueness: true

  before_validation :load_defaults

  def load_defaults
    self.transaction_number = SecureRandom.uuid if new_record?
  end
end
