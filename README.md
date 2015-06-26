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
Additionally, --pattern or -p could be useful when you need to only run specs that match certain pattern
For example, command below will run all examples from search_engine_spec since this is the only spec has 'search' in filename:
```
parallel_rspec -p search --serialize-stdout -n 15 spec/
```
Or, similarly, pass rspec options to parallel_rspec with option -t '[OPTIONS]' or --test-options '[OPTIONS]' so you can
filter out some examples, not limited to specs the one above.

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
* example level parallelization instead of spec level
* run a specific example by example name: override -e or add a new option
* saucelabs integration;
    - further integrate: send test name, status, etc to saucelabs jobs
* continue as a standalone framework VS convert to a gem(will enable it to be embedded into a ruby web app and testing
  a locally running app without browser)
* wrapper for page object instantiation, more convenient methods in base or wherever

## My Preference

I'm not a big fan of keyword driven framework such as Cucumber, it requires work by more people
from different departments, an engineer can get bored quickly and it can become hard to maintain;
SitePrism makes feature tests well organized, and strikes a nice balance between readability and conciseness.

#### Advantages over Minitest
* parallel: highly configurable parallel-tests gem, works out of the box(eg. integrates with saucelabs without any effort)
* headless:
    - capybara-webkit is easy to install(just a gem) and to work with, compared to phantomjs
    ghost for minitest is a pain to work with(issues during test run and installation of phantomjs differs from OS to OS)
    - capybara-webkit doesn't require you to explicitly run anything on the background and it allows multiple headless tests
    running at the same time on one machine, while phantomjs requires you to start ghost driver process at a port of localhost
    and it only allows one test to connect to one port which makes parallelization for headless testing really tough.
    drawbacks: has dependency on Qt, requires xvfb on linux
* built-in tagging: predefined tags and custom tags
* skip: doesn't run before hooks for skipped specs which makes sense while minitest runs before hooks if you mark a test as skip
* Bonus point if you use rspec for unit testing: consistency(not that important though)
