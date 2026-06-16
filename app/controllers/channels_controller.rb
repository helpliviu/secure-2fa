class ChannelsController < ApplicationController
  before_action :authenticate_client!
  before_action :set_channel, only: %i[show edit update destroy]

  def index
    @channels = current_client.channels.all.page(params[:page])
  end

  def show; end

  def new
    @channel = current_client.channels.new
  end

  def edit; end

  def create
    @channel = current_client.channels.new(channel_params)

    if @channel.save
      redirect_to @channel, notice: "Channel created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @channel.update(channel_params)
      redirect_to @channel, notice: "Channel updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @channel.destroy
      redirect_to channels_path, notice: "Channel deleted."
    else
      redirect_to @channel, alert: @channel.errors.full_messages.to_sentence
    end
  end

  private

  def set_channel
    @channel = current_client.channels.find(params[:id])
  end

  def channel_params
    params.require(:channel).permit(:title, :method, :provider, :credentials)
  end
end
