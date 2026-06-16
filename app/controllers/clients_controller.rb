class ClientsController < ApplicationController
  before_action :authenticate_client!
  before_action :require_admin!

  def index
    @clients = Client.unscoped.order(id: :asc).page(params[:page])
  end

  def show
    @client = Client.find(params[:id])
  end

  def update
    @client = Client.find(params[:id])

    if @client.update(client_params)
      redirect_to @client, notice: "Client updated successfully."
    else
      redirect_to @client, alert: "Failed to update client: #{@client.errors.full_messages.to_sentence}"
    end
  end

  private

  def client_params
    params.require(:client).permit(:admin)
  end

  def require_admin!
    redirect_to root_path, alert: "You are not authorized to access this area." unless current_client.admin?
  end
end
