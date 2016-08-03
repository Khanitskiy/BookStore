class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      user.admin ? admin_abilities : user_abilities(user)
    else
      guest_abilities
    end
  end

  def admin_abilities
    can :access, :rails_admin
    can :dashboard
    can :manage, [Author, User, Book, Cupon, Category, Rating, Order]
    cannot :create, Rating
  end

  def user_abilities(user)
    guest_abilities
    can :read, [Book, Category, Rating, Author]
    can :manage, Address, billing_address_for_id: user.id
    can :manage, Address, shipping_address_for_id: user.id
    can :manage, CreditCard, user_id: user.id
    can :manage, Order, user_id: user.id
    can :manage, OrderItem, order: { 
      user_id: user.id, state: 'in_progress' } 
    can [:read, :update], Cupon
    can [:manage], User, id: user.id
    can :create, Rating, user_id: user.id
  end

  def guest_abilities
    can :read, [Book, Category, Author, Rating]
    can [:read, :create, :clear_cookies_shopcart, :check_cupon_ajax], Order
  end
end