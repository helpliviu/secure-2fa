class LogsController < ApplicationController
  before_action :authenticate_client!

  # Dashboard — shows all logs for the current client, with optional level filter
  def index
    @logs = current_client.logs

    if params[:levels].present?
      @logs = @logs.filter_by_levels(params[:levels].to_a)
    end

    @logs = @logs.page(params[:page])
  end
end
