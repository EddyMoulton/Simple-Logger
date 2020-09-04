class RecordsController < ApplicationController
  include Secured

  def initialize
    allowed_scopes = {
      'GET' => ['reader'],
      'PUT' => ['updater'],
      'POST' => ['logger'],
      'DELETE' => ['deleter']
    }

    set_allowed_scopes allowed_scopes
  end

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
        json_response({ message: e.message }, :internal_server_error)
      else
        json_response({}, :no_content)
      end
    else
      json_response(@records)
    end
  end

  def show
    json_response(@record)
  end

  def create
    if params['creator'] && params['logs'] && params['logs'].is_a?(Array)
      ActiveRecord::Base.transaction do
        params['logs'].each do |log|
          if log['category'] && log['key'] && log['value']
            creator = Creator.find_or_create_by(name: params['creator'])
            category = Category.find_or_create_by(name: log['category'])

            timestamp = if log['timestamp'].nil?
                          Time.now.utc
                        else
                          DateTime.parse(log['timestamp'])
                        end

            Record.create!(creator_id: creator.id, category_id: category.id, key: log['key'], value: log['value'], timestamp: timestamp)
          else
            ActiveRecord::Rollback
            return head :unprocessable_entity
          end
        end
      end

      head :no_content
    else
      head :unprocessable_entity
    end
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
