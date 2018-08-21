class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :read, :update, :destroy, to: :crud
    if user.present?
      if user.fan?
        can :read, Artist
        can [:my_events, :followed_artist, :add_event, :remove_event, :follow_artist, :unfollow_artist], Fan, user_id: user.id
        can [:show], Event
        can [:show], Product
        can [:create, :fan_purchases], Order, fan_id: user.profile_id
      end
      if user.artist?
        can :show, Fan
        can :crud, Event, artist_id: user.profile_id
        can :crud, Product, artist_id: user.profile_id
        can :artist_sales, Order, artist_id: user.profile_id
      end
    end
  end


end
