class ScrapeController < ApplicationController

  # GET /actors
  def index
    month = params['month']
    day = params['day']
    amount = params['amount'].to_i <= 0 ? 50 : params['amount'].to_i # If the amount parameter is missing or below 0, 50 is assigned
    all = params['all'] == 'true' ? true : false

    scrape_results = ImdbScrape.new.begin(month, day, amount, all) # Scrape service in app/services

    render json: scrape_results[0], status: scrape_results[1]
  end

end
