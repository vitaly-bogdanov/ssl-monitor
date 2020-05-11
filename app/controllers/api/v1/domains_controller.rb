class Api::V1::DomainsController < ApplicationController
  def status
    domains = Domain.select('id, name, status')
    render json: { domains: domains }, status: 200
  end

  def domain
    domain = Domain.new(name: params)
    if domain.save
      render json: { domain: domain }, status: 201
    else
      render json: {}, status: 422
    end
  end

end