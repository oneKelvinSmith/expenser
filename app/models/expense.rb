class Expense < ActiveRecord::Base
  validates :description, :amount, :user, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0.01 }

  belongs_to :user
  before_validation :default_date_and_time

  attr_writer :clock

  private

  def default_date_and_time
    self.time = clock.now.to_time if time.nil?
    self.date = clock.now.to_date if date.nil?
  end

  def clock
    @clock || DateTime
  end
end
