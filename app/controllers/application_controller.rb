class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def guest_or_current_user_id
    user_signed_in? ? current_user.id : get_session_id
  end

  def get_session_id
    session['session_id'][0..9].gsub(/\D/, '').to_i
  end

  protected
    def after_sign_in_path_for(user)
      User.update_cart(get_session_id, user)
      user.carted_products.empty? ? root_path : '/carted_products'
    end
end
