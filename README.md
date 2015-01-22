# NOT ACTIVELY MAINTAINED

I haven't time in over a year to properly support this project.

# Carmen- A repository of geographic regions for Ruby

[![Build Status](https://secure.travis-ci.org/jim/carmen.png?branch=master)](http://travis-ci.org/jim/carmen)

Carmen 1.0.0 is now out, after more than a year in beta.  This release is a rewrite of the library, separating out the geographic components from the Rails-specific view helpers. If you are using Carmen with Rails, you should check out the [carmen-rails](http://github.com/jim/carmen-rails) library.

The [0.2.x branch](https://github.com/jim/carmen/tree/0.2.x) contains the previous
version of Carmen should you need it for some reason.

**Carmen now requires Ruby 1.9.3 The [ruby-18 branch](https://github.com/jim/carmen/tree/ruby-18) contains the
last stable version of Carmen that will run on Ruby 1.8.x.

Carmen 1.0 features the following:

* A new, cleaner API
* More complete data via the iso-codes Debian package (idea borrowed from [here](https://github.com/pluginaweek/has_addresses))
* A sane approach to internationalization

# How to Use Carmen

Carmen is designed to make it easy to access Country and region data.
You can query for a country by name or code:

    require 'carmen'
    include Carmen

    us = Country.named('United States')
    => <#Carmen::Country name="United States">

A Country object has some attributes that may be useful:

    us.alpha_2_code
    => 'US'

    us.alpha_3_code
    => 'USA'

    us.code # alias for alpha_2_code
    => 'US'

    us.official_name
    => "United States of America"

A `Country` (and its subregions) can contain subregions. In the US these are states, but other countries have other types of regions:

    us.subregions?
    => true

    us.subregions.first
      => <#Carmen::Region name="Alabama" type="state">

`Country#subregions` returns a `RegionCollection`, which can be queried
similarly to a `Country` to find, for instance, a specific state:

    illinois = us.subregions.coded('IL')
    => <#Carmen::Region "Illinois">

Subregions support a smaller set of attributes than countries:

    illinois.name
      => "Illinois"

    illinois.code
    => "IL"

    illinois.type
    => "state"

Some subregions may contain additional subregions. An example of this is Spain:

    spain = Country.named('Spain')
    andalucia = spain.subregions.first
    => <#Carmen::Region name="Andalucía" type="autonomous community">

    andalucia.subregions?
    => true

    andalucia.subregions.first
    => <#Carmen::Region name="Almería" type="province">

## How Carmen organizes data

In order to facilitate support for I18n, Carmen stores the structure of regions
separately from the strings that represent a region's names. The default data
that ships with Carmen is in the iso_data and locale directories,
respectively.

## Overriding structural data

You might want to tweak the data that Carmen provides for a variety of reasons. Carmen
maintains an array of paths to load data from in: `Carmen.data_paths`. The structure of
files in each of these paths should mirror those in the `iso_data` path Carmen ships with.

To add a new country to the system, you would create a directory (let's use `my_data` as an example),
and create a `world.yml` file inside it. Then add the path to Carman:

    Carmen.append_data_path File.expand_path('../my_data', __FILE__)

Elements within the data files are identified using their `code` values (or, in the case of countries, `alpha_2_code`). Create a new block for the country you wish to add inside `my_data/world.yml`:

    ---
    - alpha_2_code: ZZ
      alpha_3_code: ZZZ
      numeric_code: "999"
      type: country

Now, modify the fields you wish to change, and delete the others. Be sure to specify `alpha_2_code` for countries and `code` for subregions, as those values are used internally by Carmen to match your customized data with the corresponding data in the default dataset.

Now, Carmen will reflect your personal view of the world:

    Carmen::Country.coded('ZZ').type
    => "country"

You will also want to create a localization file with the names for the new
region. See the section 'Customizing an existing locale', below.

### Modifying existing elements

Existing regions can be modified by copying their existing data block into
a new file at the correct overlay path, and modifying the values as desired.

### Disabling elements

It is also possible to remove an element from the dataset by setting its `_enabled` value to [anything YAML considers false](http://yaml.org/type/bool.html), such as 'false' or 'no':

    - alpha_2_code: EU
      _enabled: false

This will cause Carmen to not return that element from any query:

    Carmen::Country.coded('EU')
    => nil

## Localization

Carmen ships with very simple I18n support. You can tell Carmen to use your own
I18n backend:

    Carmen.i18n_backend = YourI18nBackend.new

The object used as a backend must respond to `t` with a single argument (the
key being looked up). This key will look something like `world.us.il.name`.

## Setting the locale

If you use the built in I18n support, you can set the locale:

    Carmen.i18n_backend.locale = :es

Each region is assigned
a localization key based on the formula world.PARENT\_CODE.CODE. The
key used for the United States is `world.us`.

## Customizing an existing locale

The library ships with a set of YAML files that contain localizations of many
country names (and some states). If you want to override any of these values,
create a YAML file that contains a nested hash structure, where each segment of
the key is a hash:

    en:
      world:
        us:
          official_name: These Crazy States

This file can live anywhere, but it is recommended that it be stored in
a structure similar to the one Carmen uses for its locale storage.

To tell Carmen to load this file, add the directory it is contained in to the
set of locale paths used by the backend:

    Carmen.i18n_backend.append_locale_path('/path/to/your/locale/files')

If you are using your own backend, then follow the steps necessary to have it
load your additional files instead.


## Contributing to Carmen

Please read [Contributing Data](https://github.com/jim/carmen/wiki/Contributing-Data) before making any changes to the project's data. It will save you (and me) a bunch of time!

## Extensions

[Jacob Morris](https://github.com/jacobsimeon) has created [a plugin for Carmen that adds support for demonyms](https://github.com/jacobsimeon/carmen-demonyms).

[Cyle Hunter](https://github.com/nozpheratu) has created [a plugin that adds ISO 4217 currency names to Carmen::Country](https://github.com/nozpheratu/carmen-iso-4217).
