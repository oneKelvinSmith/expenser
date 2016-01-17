class Expense < ActiveRecord::Base
  validates :description, :amount, :user, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0.01 }

  belongs_to :user
  before_validation :default_datetime

  attr_writer :clock

  private

  def default_datetime
    self.datetime = clock.now if datetime.nil?
  end

  def clock
    @clock || DateTime
  end
end
