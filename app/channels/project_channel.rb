class ProjectChannel < ApplicationCable::Channel
  def subscribed
    # stream_from 'project_channel'
    stream_from "project_channel_#{params[:id]}"
    # stream_from "project_#{params[:room]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    # stop_stream_from "project_#{params[:room]}"
    stop_stream_from "project_channel_#{params[:id]}"
  end
end
