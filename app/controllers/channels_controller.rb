class ChannelsController < ApplicationController
  before_action :authenticate_client!
  before_action :set_channel, only: %i[ show edit update destroy ]

  # GET /channels or /channels.json
  def index
    @channels = current_client.channels.all
  end

  # GET /channels/1 or /channels/1.json
  def show
  end

  # GET /channels/new
  def new
    @channel = current_client.channels.new
  end

  # GET /channels/1/edit
  def edit
  end

  # POST /channels or /channels.json
  def create
    @channel = current_client.channels.new(channel_params)

    respond_to do |format|
      if @channel.save
        format.html { redirect_to @channel, notice: "Channel was successfully created." }
        format.json { render :show, status: :created, location: @channel }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @channel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /channels/1 or /channels/1.json
  def update
    respond_to do |format|
      if @channel.update(channel_params)
        format.html { redirect_to @channel, notice: "Channel was successfully updated." }
        format.json { render :show, status: :ok, location: @channel }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @channel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /channels/1 or /channels/1.json
  def destroy
    @channel.destroy!

    respond_to do |format|
      format.html { redirect_to channels_path, status: :see_other, notice: "Channel was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_channel
      @channel = current_client.channels.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def channel_params
      params.expect(channel: [ :client_id, :title ])
    end
end
