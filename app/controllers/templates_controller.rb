class TemplatesController < ApplicationController
  before_action :authenticate_client!
  before_action :set_template, only: %i[ show edit update destroy ]

  # GET /templates or /templates.json
  def index
    @templates = current_client.templates.all
  end

  # GET /templates/1 or /templates/1.json
  def show
  end

  # GET /templates/new
  def new
    @template = current_client.templates.new
  end

  # GET /templates/1/edit
  def edit
  end

  # POST /templates or /templates.json
  def create
    @template = current_client.templates.new(template_params)

    respond_to do |format|
      if @current_client.templates.save
        format.html { redirect_to @template, notice: "Template was successfully created." }
        format.json { render :show, status: :created, location: @template }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @current_client.templates.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /templates/1 or /templates/1.json
  def update
    respond_to do |format|
      if @current_client.templates.update(template_params)
        format.html { redirect_to @template, notice: "Template was successfully updated." }
        format.json { render :show, status: :ok, location: @template }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @current_client.templates.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /templates/1 or /templates/1.json
  def destroy
    @current_client.templates.destroy!

    respond_to do |format|
      format.html { redirect_to templates_path, status: :see_other, notice: "Template was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_template
      @template = current_client.templates.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def template_params
      params.expect(template: [ :client_id, :title ])
    end
end
