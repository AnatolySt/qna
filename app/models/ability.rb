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
    can :best, Answer, question: { user_id: user.id }
  end

end
