module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :authenticated?
  end

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def authenticated?
    current_user.present?
  end

  def require_authentication
    return if authenticated?

    session[:return_to] = request.fullpath if request.get? || request.head?
    redirect_to new_session_path, alert: "Please sign in."
  end

  def start_new_session_for(user)
    # reset_session wipes return_to, so capture it and hand it back to the caller.
    return_to = session[:return_to]
    reset_session
    session[:user_id] = user.id
    return_to
  end

  def terminate_session
    reset_session
  end
end
