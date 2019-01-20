class Ability

  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def set_aliases
    alias_action :update, :destroy, :to => :modify
    alias_action :vote_up, :vote_down, :to => :modify
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can [:update, :destroy], [Question, Answer], user_id: user.id
    can [:vote_up, :vote_down], [Question, Answer]
    cannot [:vote_up, :vote_down],[Question, Answer], user_id: user.id
    can :mark_best, Answer, question: { user_id: user.id }
  end

end
