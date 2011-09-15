class DonationsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: :create

  def new
  end

  def show
  end

  def create
    Amazon::InstantPaymentNotification.create(params)
    head :ok
  end
end
