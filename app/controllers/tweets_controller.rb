class TweetsController < ApplicationController
  include TweetsHelper

  before_action :set_tweet, only: [:show, :edit, :update, :destroy]

  # GET /tweets
  # GET /tweets.json
  def index
    @tweets = Tweet.all
  end

  # GET /tweets/1
  # GET /tweets/1.json
  def show
  end

  # GET /tweets/new
  def new
    @tweet = Tweet.new
  end

  # GET /tweets/1/edit
  def edit
  end

  # POST /tweets
  # POST /tweets.json
  def create
    @tweet = Tweet.new(tweet_params)

    respond_to do |format|
      if @tweet.save
        format.html { redirect_to @tweet, notice: 'Tweet was successfully created.' }
        format.json { render :show, status: :created, location: @tweet }
      else
        format.html { render :new }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tweets/1
  # PATCH/PUT /tweets/1.json
  def update
    respond_to do |format|
      if @tweet.update(tweet_params)
        format.html { redirect_to @tweet, notice: 'Tweet was successfully updated.' }
        format.json { render :show, status: :ok, location: @tweet }
      else
        format.html { render :edit }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tweets/1
  # DELETE /tweets/1.json
  def destroy
    @tweet.destroy
    respond_to do |format|
      format.html { redirect_to tweets_url, notice: 'Tweet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /tweets/search
  # GET /tweets/search.json
  def search
    default_query = "healthcare"
    query = default_query

    # TODO - document
    if params and params[:search] and params[:search][:value] and params[:search][:value] != ""
      query = params[:search][:value]
    end
    puts "query: #{query}"

    # Get out twitter client for querying.
    twitter_client = get_twitter_client
    
    # TODO - cache, twitter API limits: 15 calls every 15 minutes,
    # and 180 calls every 15 minutes.
    #@tweets = twitter_client.search(query, result_type: "recent").take(10)
    tweets = twitter_client.search(query, result_type: "recent").take(10).map do |tweet|
      [
        # screen name
        tweet.user.screen_name,
        # body
        tweet.text
      ]
    end

    # The datatables draw count. Cast to int to prevent cross site scripting.
    draw = params[:draw] ? params[:draw].to_i : 1

    @tweet_data = {
      draw: draw,
      recordsTotal: 10,
      recordsFiltered: 10,
      data: tweets
    }

    respond_to do |format|
      format.html { render :search }
      format.json { render json: @tweet_data }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tweet_params
      params.require(:tweet).permit(:body, :query)
    end
end
