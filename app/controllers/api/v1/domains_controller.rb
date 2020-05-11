class Api::V1::DomainsController < ApplicationController
  def status
    domains = Domain.select('id, name, status')
    render json: { domains: domains }, status: 200
  end

  def domain
    
  end
end
