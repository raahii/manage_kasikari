class SubscriptionsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    session[:subscription] = params.fetch(:subscription, {})
    head :ok
  end

  def destroy
    session[:subscription] = nil
    head :ok
  end

  def push
    Webpush.payload_send(webpush_params)
    head :ok
  end

  private

  def webpush_params
    subscription_params = fetch_subscription

    message  = "Hello world, the time is #{Time.zone.now}"
    endpoint = subscription_params["endpoint"]
    p256dh   = subscription_params.dig("keys", "p256dh")
    auth     = subscription_params.dig("keys", "auth")
    vapid = {
      subject:     "piyo56.net@gmail.com",
      public_key:  "BK6_74HsZx1k6i8mquyKG-dKOtgV006ULQdXuz6RYeNcURS9o7EVh8wWgQI3212qAldps3tqQYOZhpCUzFj9z5k=",
      private_key: "3kxDPfB1QQ8gq5XKrr6SmFQcYY8hkzs4ONYvuqNPbq0=",
    }

    {
      message: message,
      endpoint: endpoint,
      p256dh: p256dh,
      auth: auth,
      vapid: vapid,
    }
  end

  def fetch_subscription
    subscription = session.fetch(:subscription) do
      raise "Cannot create notification: no :subscription in params or session"
    end
  end
end
