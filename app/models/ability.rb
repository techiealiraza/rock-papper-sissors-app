# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    #   user ||= User.new # guest user (not logged in)

    #   # Guest users can only read tournaments and messages
    #   can :read, [Tournament, Message]
    #   can :create, User

    #   # Logged in users can create messages and register for tournaments
    #   if user.persisted?
    #     can :create, Message
    #     can :register, Tournament
    #   end

    #   # Admin users can create tournaments, generate matches, and manage users
    #   if user.admin?
    #     can :create, Tournament
    #     can :generate_matches, Tournament
    #     can :manage, User
    #   end

    #   # Super admins can do everything an admin can do, and also manage admin rights
    #   return unless user.super_admin?

    #   can :manage, :all
    #   can :manage_admin_rights, User

    #   # every one can access users signup page
  end
end
