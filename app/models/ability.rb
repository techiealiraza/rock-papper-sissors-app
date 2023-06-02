# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can :read, [Tournament, Message, Match]
    can %i[create new], [User]
    if user.member?
      can %i[create new index], Message
      can :register, Tournament
      can %i[playmatch index show result all], Match
      can :create, Selection, match: { user_id: user.id }
      can :authenticate_2fa, User
    elsif user.admin?
      can %i[create new index], Message
      can %i[new create create_matches index edit], Tournament
      can %i[playmatch result index show new create all], Match
      can :authenticate_2fa, User
    end
  end
end
