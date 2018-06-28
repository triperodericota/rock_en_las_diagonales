class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?
      if user.fan?
        can :read, Artist
        can [:show, :update], Fan, user_id: user.id
      end
      if user.artist?
        can [:show, :update], Artist, user_id: user.id
      end
    end
  end


end
