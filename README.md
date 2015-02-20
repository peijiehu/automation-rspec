# automation-rspec

Prototype for building test automation framework with RSpec, Capybara, Selenium and SitePrism.
Other than the primary usage being for selenium tests, this framework can be embedded into an
ruby web app, and testing against the locally running web app without browser.

## Setup
    Clone this project
    bundle

## Run Specs
    rspec                            # to run all specs, with default driver and env
    rspec -t my_tag:my_value         # to run specs filtered by {:my_tag=>my_value}
    rspec -t ~slow                   # to run specs without tag {:slow=>true}
    r_env=stg rspec                  # to run all specs, on stg server
    r_driver=chrome rspec            # to run all specs, with chrome
    r_driver=saucelabs rspec
    r_driver=saucelabs:sauce_username:platform_and_browser rspec
To run specs in parallel, with serialized stdout printing out after all specs are done
(note that when running specs through 'parallel_rspec', options in .rspec_parallel will be used, instead of .rspec)
```
parallel_rspec --serialize-stdout -n 15 spec/
```
Note that when running specs through 'parallel_rspec', options in .rspec_parallel will be used, instead of .rspec
As you can see in .rspec_parallel, results will also be recorded in JUnit format under reports/, so CI like Jenkins can read and publish.

To run with rake without options for parallel_rspec
```
rake
```
Of course you can
```
r_driver=saucelabs rake
```

## What should be in the hidden config/
    config/
        driver/
            saucelabs.yml    # remote driver saucelabs and its users' accounts and capabilities configuration
        accounts.yml         # user accounts credentials to be used for specs
        env.yml              # remote app name and url to be tested on

## TODO
* inspect why there's an additional browser open at the end of a spec;
* saucelabs integration;
    - further integrate: send test name, status, etc to saucelabs jobs
* tagger utility to add tag(s) to spec/example

## My Preference

I'm not a big fan of keyword driven framework such as Cucumber, it requires work by more people
from different departments, an engineer can get bored quickly and it can become hard to maintain;
SitePrism makes feature tests well organized, and strikes a nice balance between readability and conciseness.
