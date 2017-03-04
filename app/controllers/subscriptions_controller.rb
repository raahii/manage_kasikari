class SubscriptionsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    session[:subscription] = params.fetch(:subscription, {})
    head :ok
  end

  def destroy
  end

  def push
    Webpush.payload_send(webpush_params)
    head :ok
  end

  private

  def webpush_params
    subscription_params = fetch_subscription

    message = "Hello world, the time is #{Time.zone.now}"
    endpoint = subscription_params["endpoint"]
    p256dh = subscription_params.dig("keys", "p256dh")
    auth = subscription_params.dig("keys", "auth")
    api_key = "AIzaSyBBV9g94Btu5D7xLJkukcVWroz8sEYfiXo" if endpoint =~ /\.google.com\//

    { message: message, endpoint: endpoint, p256dh: p256dh, auth: auth, api_key: api_key }
  end

  def fetch_subscription
    subscription = session.fetch(:subscription) do
      raise "Cannot create notification: no :subscription in params or session"
    end
  end
end
