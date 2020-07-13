# Twitter Scraper

Very lightweight (in terms of dependencies) scraper that uses the Twitter private API to scrape posts, and attached media files.

It is integrated into [tagem](https://github.com/NotCompsky/tagem), such that posts and media recorded in this scraper are trivially accessible from tagem.

# Dependencies

MySQL client and server
Python 3 and pymysql

NOTE: I don't think this uses any MySQL-specific SQL code, so other SQL servers should be easily supportable.

# Installation

On Ubuntu, PyMySQL does not seem to generally work when installed from the pip package manager.

	sudo apt install python3-pymysql

# Configuration

Open Twitter on your browser, take a note of your cookies etc, and place those values into `scripts/config.template`. Then move scripts/config.template to `scripts/config`.

Then open up your favourite SQL client, and run the commands listed in `sql/init-tables.sql` to create the necessary tables.

# Example Usage

	DL_TWEET_MEDIA=1 ./get-tweet https://twitter.com/BBCNews/status/1282683947139440644
	
	./add-job SkyNews "British~~~News Corporation" FALSE
	
	./scraper

# Contributing

This is extraordinarily bad code. I'm aware. It was a prototype that went so smoothly I never needed to clean it up.

Contributions are welcome; there is no doubt a lot of areas for possible improvements, for instance awful inefficiencies (that the user won't notice due to the rate limit anyway, but are still a waste of CPU cycles).
