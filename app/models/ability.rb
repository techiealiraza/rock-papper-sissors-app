# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    # Guest users can only read tournaments and messages
    can :read, [Tournament, Message, Match]
    can %i[create new], [User]

    # Logged in users can create messages and register for tournaments
    if user.member?
      can :create, Message
      can :registration, Tournament
      can %i[playmatch index show], Match

    # Admin users can create tournaments, generate matches, and manage users
    elsif user.admin?
      can %i[new create index edit], Tournament
      can :create_matches, Tournament

    # Super admins can do everything an admin can do, and also manage admin rights
    elsif user.super_admin?

      can :manage, :all
      can :manage_admin_rights, User
    end
    # every one can access users signup page
  end
end
