class SessionsController < ApplicationController
  def new
  end

  def create
    if user = User.authenticate_by(session_params)
      redirect_to start_new_session_for(user) || root_path, notice: "Signed in."
    else
      flash.now[:alert] = "Invalid username or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    terminate_session
    redirect_to root_path, notice: "Signed out."
  end

  private

  def session_params
    params.permit(:username, :password)
  end
end
