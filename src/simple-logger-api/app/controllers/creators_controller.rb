class CreatorsController < ApplicationController
  before_action :set_creator, only: [:show, :update, :destroy]

  def index
    @creators = Creator.all
    json_response(@creators)
  end

  def show
    json_response(@creator)
  end

  def update
    @creator.update(creator_params)
    head :no_content
  end

  def destroy
    @creator.destroy
    head :no_content
  end

  private

  def creator_params
    params.permit(:name)
  end

  def set_creator
    @creator = Creator.find(params[:id])
  end
end
