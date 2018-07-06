class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?
      if user.fan?
        can :read, Artist
        can [:show, :update], Fan, user_id: user.id
        can [:show], Event
      end
      if user.artist?
        can [:show, :update], Artist, user_id: user.id
        can :manage, Event, artist_id: user.profile_id
      end
    end
  end


end
