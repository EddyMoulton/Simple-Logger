class CategoriesController < ApplicationController
  include Secured

  def initialize
    allowed_scopes = {
      'GET' => ['reader'],
      'PUT' => ['updater'],
      'DELETE' => ['deleter']
    }

    set_allowed_scopes allowed_scopes
  end

  before_action :set_category, only: %i[show update destroy]

  def index
    @categories = Category.all
    json_response(@categories)
  end

  def show
    json_response(@category)
  end

  def update
    @category.update(category_params)
    head :no_content
  end

  def destroy
    @category.destroy
    head :no_content
  end

  private

  def category_params
    params.permit(:name)
  end

  def set_category
    @category = Category.find(params[:id])
  end
end
