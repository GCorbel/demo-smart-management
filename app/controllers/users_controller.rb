class UsersController < ApplicationController
  expose(:users)
  expose(:user, attributes: :user_params)

  respond_to :html, :json

  def index
    users = User.all
    users = SmartManagement::Searcher.new(users, search_options).call
    total = users.count

    users = SmartManagement::Paginer.new(users, pagination_options).call
    users = SmartManagement::Sorter.new(users, sort_options).call

    result = { items: users, meta: { total: total } }
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
