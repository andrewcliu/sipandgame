class User < ApplicationRecord
  include Clearance::User
  validate :singleton_user, on: :create

  private

  def singleton_user
    if User.exists?
      errors.add(:base, "Only one user is allowed in this system.")
    end
  end
end
