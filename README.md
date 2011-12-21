# Carmen- A repository of geographic regions for Ruby

## A Little History

Carmen began its life as a replacement for Rails' country_select and
state_select helpers. The API of the library was designed to facilitate
a few view helpers and model validations, and that was about it.

## Today

It's been a few years since Carmen was released, and it has been used by a lot of projects. Many fine individuals have contributed code and
data- I'm really happy with the way the [community](https://github.com/jim/carmen/contributors) has improved the library. But this growth has brought to light many of the weaknesses in the current library and implementation.

I have decided that it is time to go back and rethink Carmen's
data model and API, and in the process address some long standing
issues. Carmen 1.0 will feature the following:

* A new, cleaner API
* Support for the old API via an optional require
* More complete data via the iso-codes Debian package (idea borrowed from [here](https://github.com/pluginaweek/has_addresses))
* A sane approach to internationalization, utilizing an existing i18n
  library.

## The TODO

* Switch to a more complete data source (done)
* Add the ability to overlay custom data on the dataset
* Rewrite spike-level V2 API implementation
* Provide a legacy api so existing users have an upgrade path ('carmen/legacy')
* Separate Rails view methods out into a carmen-rails gem
* i18n integration

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

Subregions support a limited set of attributes than countries:

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