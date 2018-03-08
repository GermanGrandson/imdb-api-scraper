require 'mechanize'

class ImdbScrape

  def begin(month, day, amount, all)
    actors = []
    @amount = amount
    @all = all
    @mechanize = Mechanize.new # Inialize Mechanize and then get the page requested by user in line below
    page = @mechanize.get("http://www.imdb.com/search/name?birth_monthday=#{month}-#{day}") rescue nil

    if bad_request(page) # If a user submits a bad request, a bad request is returned
      return [{message: 'Error. Please make sure parameters are correct!'}, :bad_request]
    end

    scrape_actor_data(page, actors)
  end

  def scrape_actor_data(page, actors)
      next_page_present = "http://www.imdb.com#{page.root.css('.desc > .lister-page-next').attribute('href').value}" rescue nil # Gets url for next page

      imdb_list = page.root.css('.lister-list > .lister-item').first(@amount) # Gets data for all actors and iterates
      imdb_list.each do |list_item|
        name = list_item.css('.lister-item-content > .lister-item-header > a').text.strip rescue ""
        photo_url = list_item.css('.lister-item-image > a > img').attribute('src').value rescue ""
        profile_url = "http://www.imdb.com#{list_item.css('.lister-item-content > .lister-item-header > a').attribute('href').value}" rescue ""
        movie_title = list_item.css('.lister-item-content > .text-muted > a').text.strip rescue ""
        movie_url = "http://www.imdb.com#{list_item.css('.lister-item-content > .text-muted > a').attribute('href').value}" rescue ""

        Actor.new(name, photo_url, profile_url, movie_title, movie_url) # Creates new Actor object
      end

    Actor.instances.each do |actor| # Iterate through Actor instances and creates person hash which is pushed into actors array
      page = @mechanize.get(actor.movie_url) # Switch to Actor's most known work page url
      person = {}
      rating = page.root.css('.imdbRating > .ratingValue > strong > span').text.strip rescue ""

      # If a movie doesn't not have a director, "" will be assigned
      # If a span with an itemprop of value "director is present, assign director"
      begin
        if page.root.css('.credit_summary_item').first.css('span').attribute('itemprop').value == "director"
          director = page.root.css('.plot_summary > .credit_summary_item').first.css('span > a').first.text
        else
          director = ""
        end
      rescue
        director = ""
      end

      person["name"] = actor.name
      person["photoUrl"] = actor.photo_url
      person["profileUrl"] = actor.profile_url
      person["mostKnownWork"] = {
        title: actor.movie_title,
        url: actor.movie_url,
        rating: rating,
        director: director
      }

      actors << person
    end

    Actor.instances.clear # Clears all Actor instances before moving onto next page

    # If the `all` parameter is true and a `next_page_present` element is present, the scrape_actor_data method is called recursively
    if @all && next_page_present
      page = @mechanize.get(next_page_present)
      scrape_actor_data(page, actors)
    end

    [{"people": actors}, :ok] # Return actors array with all Actor instances
  end

  def bad_request(page) # If the IMDB page doesn't contain certain html elements or an error message, we return true for bad_request
    if page == nil || !page.at_css('.lister-list') # If there's no lister-list class return true
      true
    end
  end

end
