class DonationsController < ApplicationController
  def new
  end

  def show
  end

  def create
    Amazon::InstantPaymentNotification.create(params)
    head :ok
  end
end
