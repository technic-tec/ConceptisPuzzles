require 'nokogiri'

class PuzzlesController < ApplicationController
  before_action :set_puzzle, only: [:show, :save, :load, :edit, :update, :destroy]
  before_action :set_puzzle_config, only: [:show, :index, :configure]

  # GET /puzzles
  # GET /puzzles.json
  def index
    query = params.permit(:family, :variant, :model, :difficulty, :page)
    if query[:difficulty]
      @puzzles = Puzzle.joins("LEFT JOIN properties ON puzzles.id = properties.puzzle_id AND properties.name = 'difficulty'").all
    else
      @puzzles = Puzzle.all
    end
    if query[:family]
      @puzzles = @puzzles.where(:codeFamily => query[:family])
    end
    if query[:variant]
      @puzzles = @puzzles.where(:codeVariant => query[:variant])
    end
    if query[:model]
      @puzzles = @puzzles.where(:codeModel => query[:model])
    end
    if query[:difficulty]
      @puzzles = @puzzles.where("properties.value = ?", query[:difficulty])
    end
    @page = (query[:page] || 1).to_i
    @page = 1 if @page < 1
    @perPage = (params[:per_page] || 12).to_i
    @total = @puzzles.count;
    @puzzles = @puzzles.limit(@perPage).offset(@perPage*(@page-1)).map { |puzzle| set_puzzle_save(puzzle) }
  end

  # GET /puzzles/1
  # GET /puzzles/1.json
  def show
    set_puzzle_save(@puzzle)
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
    if PuzzleSave.create saveParam
      render text: "OK"
    else
      render text: "FAILURE", :status => 422
    end
  end

  # POST /puzzles/1/save/1
  # POST /puzzles/1/save/1.json
  def load
    @puzzle_save = PuzzleSave.find_or_initialize_by(:id => params[:save_id]) { |save|
      save.assign_attributes(:puzzle_id => @puzzle.id,
        :user_id => @current_user.id,
        :first_save => "",
        :last_save => "",
        :total => 0,
        :solved => false,
        :family_ref => @puzzle.codeFamily,
        :variant_ref => @puzzle.codeVariant,
        :member_ref => @current_user.uid,
        :serial => @puzzle.serialNumber,
        :data => "")
    }
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
    def set_puzzle_save(puzzle)
      if @current_user
        save_id = PuzzleSave.where(:puzzle_id => puzzle.id, :member_ref => @current_user.uid).order(:updated_at => :desc).first_or_initialize(:id => 0).id
        puzzle.save_url = save_puzzle_path puzzle
        puzzle.load_url = "#{puzzle.save_url}/#{save_id}"
      else
        puzzle.save_url = puzzle.load_url = 'cookie'
      end
      puzzle
    end

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
