# IMDB API / Scraper

This is a Rails API that acts as an endpoint that provides data from IMDB for Actors that are born on a day. The data is scraped and then returned in JSON format

### In order to retrieve data you must provide the following parameters:
- *month*: Provide number between 1-12
- *day*: Provide number between 1-31

**Note: If you provide a day/month combination that doesn't exist, a 400 request will be returned, ex: 4/31 or 13/1**

### The following parameters are optional:
- *amount*: Provide a number of actors you would like to be retrieved per page. Each page has a max of 50 actors. **If no amount parameter is provided, it will default to 50 and obtain every actor on the IMDB page**
- *all*: Provide **true** If you would like to retrieve **ALL** actors available on IMDB for the month/day provided

## Example API Call
*The following api call will retrieve the first 10 actors of every page available for the birthday combination of 02/02*

```localhost:3000/actors?month=2&day=2&amount=10&all=true```

###**Note: 😵 If you request every page available (*all=true*) and have a big amount provided or set by default (amount=50), the API request may take up to 24 minutes to scrape everything 😵**
