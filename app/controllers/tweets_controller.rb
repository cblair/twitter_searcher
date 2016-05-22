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
  # POST /tweets/search.json
  def search
    # Set our query to an ignore value
    query = nil
    # Twitter API limits: 15 calls every 15 minutes,
    # and 180 search calls every 15 minutes.
    # Time in seconds to keep the tweets before we hit twitter again.
    cache_time = 60

    # See our API - Search documentation for these requirements
    if params and params[:search] and params[:search][:value] and params[:search][:value] != ""
      if ["healthcare", "nasa", "open source"].include? params[:search][:value]
        query = params[:search][:value]
      end
    end
    puts "query: #{query}"

    # Category of tweet - this will be the query they ask for. Would have to
    # change if we opened them up to all queries.
    category = query

    # Cache.
    if query == nil
      puts "Can't get new tweets because we have no query."
      get_new_tweets = false
    elsif Tweet.where(:category => category).empty?
      puts 'Geting new tweets because we have none...'
      get_new_tweets = true
    else
      expire_time = (Tweet.where(:category => category).order("created_at").first.created_at + cache_time)
      cached_time_expired = expire_time < Time.now.utc
      puts "Cached tweets expired? expire time < now?: #{expire_time.to_s} < #{Time.now.utc.to_s}? - #{cached_time_expired.to_s}"
      get_new_tweets = cached_time_expired
    end

    # Get Tweets!
    # If the query was invalid, don't even bother hitting twitter. We will 
    # either get what we have in the cache, or get an empty data set.
    if !get_new_tweets
      tweets = Tweet.where(:category => category).last(10).map do |tweet|
        [
          tweet.name,
          tweet.body
        ]
      end
    # Else, we need fresh tweets.
    else
      # Get our twitter client for querying.
      twitter_client = get_twitter_client
      
      #Get new tweets and save the in our database cache.
      tweets = twitter_client.search(query, result_type: "recent").take(10).map do |tweet|
        # Save these tweets for our cache.
        tweet_record = Tweet.new(:name => tweet.user.screen_name,
          :body => tweet.text, :category => category)
        tweet_record.save

        # Format for each item in our Tweets list.
        [
          # screen name
          tweet.user.screen_name,
          # body
          tweet.text
        ]
      end
    end

    # Cache Cleanup
    # Delete all but the last 10 to limit size
    if Tweet.where(:category => category).size > 10
      puts 'Cleaning up old tweets...'
      Tweet.where(:category => category).order('id desc').offset(10).destroy_all
    end

    # Tweet Data (see API - Search Data). There are extra things in here too
    # for datatables.
    @tweet_data = {
      # The datatables draw count. Cast to int to prevent cross site scripting.
      draw: params[:draw] ? params[:draw].to_i : 1,
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
