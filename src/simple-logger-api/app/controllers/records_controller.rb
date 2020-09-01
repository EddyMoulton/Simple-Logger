class RecordsController < ApplicationController
  before_action :set_record, only: %i[show update destroy]

  def index
    current_uri = request.env['PATH_INFO']

    if current_uri.include?('creators') && current_uri.include?('categories')
      if params.has_key?(:creator_id) && params.has_key?(:category_id)
        @records = Record.where(creator_id: params[:creator_id], category_id: params[:category_id])
      end
    elsif current_uri.include?('categories')
      @records = Record.where(category_id: params[:category_id]) if params.has_key?(:category_id)
    elsif current_uri.include?('creators')
      @records = Record.where(creator_id: params[:creator_id]) if params.has_key?(:creator_id)
    else
      @records = Record.all
    end

    if @records.nil? || @records.empty?
      if defined?(e)
        json_response({ message: e.message }, :not_found)
      else
        json_response({}, :not_found)
      end
    else
      json_response(@records)
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
