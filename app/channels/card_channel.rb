class CardChannel < ApplicationCable::Channel
  def subscribed
    stream_from "card_channel_#{params[:id]}"
  end

  def unsubscribed
    stop_stream_from "card_channel_#{params[:id]}"
  end
end
