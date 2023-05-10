# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    # Guest users can only read tournaments and messages
    can :show, Devise::ConfirmationsController
    can :access, :root
    can :read, [Tournament, Message, Match]
    can %i[create new destroy], [User]

    # Logged in users can create messages and register for tournaments
    if user.member?
      can :create, Message
      can :register, Tournament
      can %i[playmatch index show], Match
      can :manage, UsersMatch, user_id: user.id
      can :create, Selection, match: { users: { id: user.id } }

      cannot %i[edit update destroy], Selection

    # Admin users can create tournaments, generate matches, and manage users
    elsif user.admin?
      can %i[new create index edit], Tournament
      can :create_matches, Tournament
      cannot %i[edit update destroy], Selection

    # Super admins can do everything an admin can do, and also manage admin rights
    elsif user.super_admin?
      can :manage, :all
      can :manage_admin_rights, User
      cannot %i[edit update destroy], Selection
    end
    # every one can access users signup page
  end
end
