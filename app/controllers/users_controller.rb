class UsersController < ApplicationController
  expose(:users)
  expose(:user, attributes: :user_params)

  respond_to :html, :json

  def index
    users = UserSearch.new(sort: sort_options,
                           search: search_options,
                           pagination: pagination_options).call
    result = { items: users, meta: { total: User.count } }
    respond_with(result)
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

  def sort_options
    JSON.parse(params["sort"]).symbolize_keys if params["sort"]
  end

  def pagination_options
    JSON.parse(params["pagination"]).symbolize_keys if params["pagination"]
  end

  def search_options
    if params["search"]
      search_params = JSON.parse(params["search"])
      if search_params["predicateObject"]
        search_params["predicateObject"].symbolize_keys
      end
    end
  end
end
