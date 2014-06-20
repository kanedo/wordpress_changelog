# WordpressChangelog

Small tool to gather changes between multiple wordpress versions

## Installation

Add this line to your application's Gemfile:

    gem 'wordpress_changelog'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wordpress_changelog

## Dependencies

	nokogiri http://nokogiri.org/

## Usage

	Usage: wordpress_changelog [options]
	    -s, --show                       show all available version changelogs
	    -m, --min-version VERSION        Lower Bound of Versions
	    -n, --max-version VERSION        Upper Bound of Versions
	    -o, --output-file PATH           path to output file

## Output

HTML File with all changelogs of versions merged. Sample output provided in `output.html`

![screenshot](https://raw.githubusercontent.com/kanedo/wordpress_changelog/master/Screenshot.png)

## TODO

make it pretty. At the moment I don't check if anything is real. I'm assuming this app runs in a perfect little world.
I don't check if there is any network or even if the codex is available.

## Contributing

1. Fork it ( https://github.com/kanedo/wordpress_changelog/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
