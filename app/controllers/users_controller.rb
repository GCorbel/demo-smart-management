class UsersController < ApplicationController
  expose(:users)
  expose(:user, attributes: :user_params)

  respond_to :html, :json

  def index
    respond_with(users)
  end

  def show
    respond_with(user)
  end

  def create
    user.save
    respond_with(user)
  end

  def update
    if user.save
      render json: user, status: :ok
    else
      render json: { errors: resource.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    user.destroy
    respond_with(user)
  end

  private

  def user_params
    params.require(:user).permit(:name, :age)
  end
end
