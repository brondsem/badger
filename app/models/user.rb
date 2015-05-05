class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :events

  validates :first_name, :last_name, presence: true

  def name
    [first_name, last_name].join(" ")
  end

  def self.alphabetical
    order("last_name asc, first_name asc")
  end

  def name
    [first_name, last_name].join(" ")
  end

  def role
    if admin || super_admin
      "Admin"
    else
      "Standard"
    end
  end
end
