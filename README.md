# automation-rspec

Prototype for building test automation framework with RSpec, Capybara, Selenium and SitePrism.
Other than the primary usage being for selenium tests, this framework can be embedded into an
ruby web app, and testing against the locally running web app without browser.

## Setup
    Clone this project
    bundle

## Run Specs
    rspec                            # to run all specs, with default driver and env
    r_driver=chrome r_env=stg rspec  # to run all specs, with chrome and on stg

## What should be in the hidden config/
    config/
        driver/
            saucelabs.yml    # remote driver saucelabs and its users' accounts and capabilities configuration
        accounts.yml         # user accounts credentials to be used for specs
        env.yml              # remote app name and url to be tested on

## TODO
    saucelabs integration;
    parallelization

## My Preference

I'm not a big fan of keyword driven framework such as Cucumber, it requires work by more people
from different departments, an engineer can get bored quickly and it can become hard to maintain;
SitePrism makes feature tests well organized, and strikes a nice balance between readability and conciseness.
