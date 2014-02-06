# camt: A ruby gem for parsing CAMT.053 files

This gem is based on the Python implementation by Therp (https://code.launchpad.net/~therp-nl/banking-addons) (camt.py). It is still far from supporting the full CAMT.053 specification, but it does provide the most important transaction information.

## Installation

Add to your Gemfile: gem 'camt', github: 'moiristo/camt'

## Usage

* Parse a CAMT file:
  * camt = Camt::File.parse 'camt.xml'
* Get information:
  * puts camt.messages.inspect
  * puts camt.statements.inspect
  * puts camt.transactions.inspect

## TODO

* More testing
* Release on RubyGems.org
* Extend Camt::Parser to support the full CAMT.053 specification

## Note on Patches/Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Send me a pull request

## Copyright

Copyright (c) 2014 Reinier de Lange. See LICENSE for details.
