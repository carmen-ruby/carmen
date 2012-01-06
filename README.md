# WARNING

This branch (master) is home to a rewrite of the Carmen library. If you're currently using Carmen in your application, you probably want to see the [0.2.x branch](https://github.com/jim/carmen/tree/0.2.x), which will be maintained until version 1 is ready.

If you'd like become a maintainer of the project, please let me know.

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
* Add the ability to overlay custom data on the dataset (done)
* Rewrite spike-level V2 API implementation (in progess)
* Provide a legacy api so existing users have an upgrade path ('carmen/legacy')
* Separate Rails view methods out into a carmen-rails gem (in progress)
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

## Overriding data

You might want to tweak the data that Carmen provides for a variety of reasons.
Carmen provides an `overlay_path` which can be set to point to a set of data that will be
overlayed on top of the standard data. The structure of the files in this directory should mirror those in the data path that Carmen ships with.

To override a country's name, you would create a directory (let's use my_data as an example), and create a `world.yml` file inside it. Then set Carmen to use the
new overlay path:

    Carmen.overlay_path = File.expand_path('../my_data', __FILE___)

Elements within the data files are identified using their `code` values (or, in the case of countries, `alpha_2_code`). Then copy the block for the country you wish to modify into the new `my_data/world.yml`:

    ---
    - alpha_2_code: EU
      alpha_3_code: EUR
      numeric_code: "002"
      common_name: Eurasia
	  name: Eurasia
	  official_name: The Superstate of Eurasia
	  type: country

Now, modify the fields you wish to change, and delete the others. Be sure to leave `alpha_2_code` and `code`, as those values are used internally by Carmen to match your customized data with the corresponding data in the default dataset:

    - alpha_2_code: EU
	  official_name: The Wonderous Superstate of Eurasia

Now, Carmen will reflect your personal view of the world:

    Carmen::Country.named('Eurasia').official_name
    => "The Wonderous Superstate of Eurasia"

### Adding new elements

New elements can be added to a set of regions by adding a new block to `my_data/world.yml` that contains all the required attributes.

### Disabling elements

It is also possible to remove an element from the dataset by setting its `_enabled` value to [anything YAML considers false](http://yaml.org/type/bool.html), such as 'false' or 'no':

    - alpha_2_code: EU
	  _enabled: false

This will cause Carmen to not return that element from any query:

    Carmen::Country.named('Eurasia')
    => nil