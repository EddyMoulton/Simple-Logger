module Secured
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request!
  end

  def initialize
    @allowed_scopes = {
      'GET' => [],
      'PUT' => [],
      'POST' => [],
      'DELETE' => []
    }
  end

  def set_allowed_scopes(scopes)
    @allowed_scopes = scopes
  end

  private

  def authenticate_request!
    @auth_payload, @auth_header = auth_token

    render json: { errors: ['Insufficient scope'] }, status: :unauthorized unless scope_included
  rescue JWT::VerificationError, JWT::DecodeError
    render json: { errors: ['Not Authenticated'] }, status: :unauthorized
  end

  def http_token
    request.headers['Authorization'].split(' ').last if request.headers['Authorization'].present?
  end

  def auth_token
    JsonWebToken.verify(http_token)
  end

  def scope_included
    if @allowed_scopes[request.method].nil? | !defined?(@allowed_scopes)
      true
    else
      # The intersection of the scopes included in the given JWT and the ones in the SCOPES hash needed to access
      # the PATH_INFO, should contain at least one element
      (String(@auth_payload['scope']).split(' ') & @allowed_scopes[request.method]).any?
    end
  end
end
