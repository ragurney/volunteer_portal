class User < ApplicationRecord
  has_soft_deletion default_scope: true

  has_many :signups, dependent: :destroy
  has_many :events, through: :signups
  has_many :individual_events, dependent: :destroy

  belongs_to :role
  belongs_to :office

  attr_accessor :google_token
  attr_encrypted :google_token, key: ENV.fetch('ATTR_ENCRYPTION_KEY')

  before_validation :set_defaults, on: :create

  validates :email, presence: true, uniqueness: true

  validates :office, presence: true

  def full_name
    [first_name, last_name].join(' ').strip
  end

  private

  def set_defaults
    self.role ||= User.count.zero? ? Role.admin : Role.volunteer
    self.office ||= Office.default
  end
end
