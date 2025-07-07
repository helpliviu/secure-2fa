# frozen_string_literal: true

class Clients::WelcomeController < ApplicationController
  before_action :authenticate_client!

  def index ; end
end
