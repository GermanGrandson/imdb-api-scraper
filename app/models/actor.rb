class Actor
  @@instances = [] # instances array to save Actor instances
  attr_reader :name, :photo_url, :profile_url, :movie_title, :movie_url

  def initialize(name, photo_url, profile_url, movie_title, movie_url)
    @@instances << self

    @name = name
    @photo_url = photo_url
    @profile_url = profile_url
    @movie_title = movie_title
    @movie_url = movie_url
  end

  def self.instances
    @@instances
  end

end
