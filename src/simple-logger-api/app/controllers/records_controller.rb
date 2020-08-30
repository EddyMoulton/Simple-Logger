class RecordsController < ApplicationController
  before_action :set_record, only: [:show, :update, :destroy]

  def index
    if (params.has_key?(:creator_id) && params.has_key?(:category_id))
      @records = Record.find_by(creator_id: params[:creator_id], category_id: params[:category_id])
    elsif (params.has_key?(:category_id))
      @records = Record.find_by(category_id: params[:category_id])
    else
      @records = Record.all
    end

    if (@records.any?)
      json_response(@records)
    else
      json_response({ message: e.message }, :not_found)
    end
  end

  def show
    json_response(@record)
  end

  def update
    @record.update(record_params)
    head :no_content
  end

  def destroy
    @record.destroy
    head :no_content
  end

  private

  def record_params
    params.permit(:name)
  end

  def set_record
    @record = Record.find(params[:id])
  end
end
