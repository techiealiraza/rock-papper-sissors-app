# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    # Guest users can only read tournaments and messages
    can :show, Devise::ConfirmationsController
    can %i[create new], Devise::SessionsController
    can :read, [Tournament, Message, Match]
    can :access, :root
    can %i[create new destroy], [User]

    # Logged in users can create messages and register for tournaments
    if user.member?
      can %i[create new index], Message
      can :register, Tournament
      can %i[playmatch index show result all], Match
      can :manage, UsersMatch, user_id: user.id
      can :create, Selection, match: { user_id: user.id }

      cannot %i[edit update destroy], Selection
      can :authenticate_2fa, User

    # Admin users can create tournaments, generate matches, and manage users
    elsif user.admin?
      can %i[create new index], Message
      can %i[new create create_matches index edit], Tournament
      can %i[playmatch result index show new create all], Match
      cannot %i[edit update destroy], Selection
      can :authenticate_2fa, User

    # Super admins can do everything an admin can do, and also manage admin rights
    elsif user.super_admin?
      can :manage, :all
      can :manage_admin_rights, User
      cannot %i[edit update destroy], Selection
    end
    # every one can access users signup page
  end
end
