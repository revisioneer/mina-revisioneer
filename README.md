# MinaRevisioneer

Notify revisioneer of new deployments automatically. Integrates properly with [mina][1].

## Installation

Add this line to your application's Gemfile:

``` ruby
gem 'mina_revisioneer'
```

Next update your deployment file:

``` ruby
# config/deploy.rb
require 'mina-revisioneer'
# ...
set :revisioneer_host, "https://revisioneer.io"
set :revisioneer_api_token, ENV["REVISIONEER_TOKEN"]
# ...
task :deploy => :environment do
  deploy do
    # ...
    invoke :'revisioneer:notify'
  end
end
```

Now deploy away while keeping revisioneer in sync.

## Usage

MinaRevisioneer uses the oneline commit message summaries from git to populate your deployment informations.
Alongside with your current SHA these informations are passed to revisioneer.

Assuming you are on Ruby on Rails you can use [revisioneer-rails][2] to display the deployment informations somewhere in your application.

Note however that interfacing with revisioneer is really simple so you can always RYO.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[1]:https://github.com/nadarei/mina
[2]:https://github.com/nicolai86/revisioneer-rails