require 'nokogiri'

class PuzzlesController < ApplicationController
  before_action :set_puzzle, only: [:show, :save, :load, :edit, :update, :destroy]
  before_action :set_puzzle_config, only: [:show, :index, :configure]

  # GET /puzzles
  # GET /puzzles.json
  def index
    @page = (params[:page] || 1).to_i
    @page = 1 if @page < 1
    @perPage = (params[:per_page] || 12).to_i
    @total = Puzzle.count;
    @puzzles = Puzzle.limit(@perPage).offset(@perPage*(@page-1))
  end

  # GET /puzzles/1
  # GET /puzzles/1.json
  def show
  end

  # POST /puzzles/1/save
  # POST /puzzles/1/save.json
  def save
    post_data = request.raw_post
    begin
      doc = Nokogiri.XML(post_data)
      root = doc.root
      header = (root>"header").first
      time = (header>"time").first
      flags = (header>"flags").first
      code = (header>"code").first
      data = (root>"data").first
      uid = "0"
      uid = @current_user.id if @current_user
      saveParam = {
        :puzzle_id => params[:id],
        :user_id => uid,
        :first_save => time['firstSave'],
        :last_save => time['lastSave'],
        :total => time['total'],
        :solved => flags['solved'],
        :family_ref => code['familyRef'],
        :variant_ref => code['variantRef'],
        :member_ref => code['memberRef'],
        :serial => code['serial'],
        :data => data.children.to_xml
      }
    rescue => e
      logger.error e
      render text: "Invalid save! #{e} \n #{post_data}", :status => 422
      return
    end
    if saveParam[:member_ref].to_s == "0" and @current_user
      saveParam[:member_ref] = @current_user.uid
    end
    if PuzzleSafe.create saveParam
      render text: "OK"
    else
      render text: "FAILURE", :status => 422
    end
  end

  # POST /puzzles/1/save/1
  # POST /puzzles/1/save/1.json
  def load
    @puzzle_save = PuzzleSave.find(params[:save_id])
  end

  # GET /puzzles/config.xml
  def configure
    respond_to do |format|
        format.xml
    end
  end

  # GET /puzzles/new
  def new
    @puzzle = Puzzle.new
  end

  # GET /puzzles/1/edit
  def edit
  end

  # POST /puzzles
  # POST /puzzles.json
  def create
    @puzzle = Puzzle.new(puzzle_params)

    respond_to do |format|
      if @puzzle.save
        format.html { redirect_to @puzzle, notice: 'Puzzle was successfully created.' }
        format.json { render :show, status: :created, location: @puzzle }
      else
        format.html { render :new }
        format.json { render json: @puzzle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /puzzles/1
  # PATCH/PUT /puzzles/1.json
  def update
    respond_to do |format|
      if @puzzle.update(puzzle_params)
        format.html { redirect_to @puzzle, notice: 'Puzzle was successfully updated.' }
        format.json { render :show, status: :ok, location: @puzzle }
      else
        format.html { render :edit }
        format.json { render json: @puzzle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /puzzles/1
  # DELETE /puzzles/1.json
  def destroy
    @puzzle.destroy
    respond_to do |format|
      format.html { redirect_to puzzles_url, notice: 'Puzzle was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_puzzle
      @puzzle = Puzzle.find(params[:id])
    end

    def set_puzzle_config
      @puzzle_config = Rails.application.config.x.PUZZLE_CONFIG
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def puzzle_params
      params.require(:puzzle).permit(:guid, :codeFamily, :codeVariant, :codeModel, :serialNumber, :versionMajor, :versionMinor, :builderVersion, :creationDate, :releaseDate, :data)
    end
end
