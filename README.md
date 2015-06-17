# automation-rspec

Prototype for building test automation framework for both headless and browser testing with RSpec, Capybara, Selenium and SitePrism.

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
If your test doesn't care browser compatibility, but you still want javascript support, then go with headless webkit,
run:
```
r_driver=webkit rspec
```
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
* saucelabs integration;
    - further integrate: send test name, status, etc to saucelabs jobs
* capybara-webkit is the best way to go?
* run a specific example by example name: override -e or add a new option
* continue as a standalone framework VS convert to a gem(will enable it to be embedded into a ruby web app and testing
  a locally running app without browser)

## My Preference

I'm not a big fan of keyword driven framework such as Cucumber, it requires work by more people
from different departments, an engineer can get bored quickly and it can become hard to maintain;
SitePrism makes feature tests well organized, and strikes a nice balance between readability and conciseness.

#### Advantages over Minitest
* parallel: highly configurable parallel-tests gem, works out of the box(eg. integrates with saucelabs without any effort)
* headless: capybara-webkit is easy to install(just a gem) and to work with, compared to phantomjs ghost for minitest
          which seems similar but is actually a pain to work with(issues during test run and it requires
          installation of phantomjs which differs from OS to OS)
* built-in tagging: predefined tags and custom tags
* skip: doesn't run before hooks for skipped specs which makes sense while minitest runs before hooks if you mark a test as skip
* Bonus point if you use rspec for unit testing: consistency(not that important though)
