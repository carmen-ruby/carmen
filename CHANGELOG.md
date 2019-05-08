### master (unreleased)

##### Geographic Modifications
* [#274](https://github.com/carmen-ruby/carmen/pull/274) Run update_data script
  to sync with the ISO repository. Includes changes for CN, IN, GM, MK,
  MZ, and ZA ([@swcraig](https://github.com/swcraig))

### 1.1.2 (May 2, 2019)

##### Geographic Modifications
* [#270](https://github.com/carmen-ruby/carmen/pull/270) Update name of FYR of Macedonia to North Macedonia ([@szajbus](https://github.com/szajbus))
* [#267](https://github.com/carmen-ruby/carmen/pull/267) Update Moroccan regions and subregions to match the new standard (after 2015), because of the absence of the new iso codes, I used the last two digit of the non-official [HASC](http://www.statoids.com/ihasc.html) codes.
([@kainio](https://github.com/kainio))
* [#268](https://github.com/carmen-ruby/carmen/pull/268) Remove UK overlays for Middlesex and Wiltshire ([@manewitz](https://github.com/manewitz))

### 1.1.1 (May 7, 2018)
* [#250](https://github.com/carmen-ruby/carmen/pull/250) Add better fuzzy
  searching when using `Querying#named`. Calling this method with `fuzzy:
  true` does better with dashes, apostrophes, and spaces ([@raj](https://github.com/raj))

##### Geographic Modifications
* [#256](https://github.com/carmen-ruby/carmen/pull/256) Fix Brazilian regions - remove `Fernando de Noronha` ([@guicruzzs](https://github.com/guicruzzs))
* [#252](https://github.com/carmen-ruby/carmen/pull/252) Update Kenya
  subregions to match ISO standard ([@gyarra](https://github.com/gyarra))
* [#249](https://github.com/carmen-ruby/carmen/pull/249) Rename Mexico's
  Distrito Federal and make it a state
  ([@jtapia](https://github.com/jtapia))
* [#247](https://github.com/carmen-ruby/carmen/pull/247) Fix New Zealand regions
  to match 2015-11-27 ISO correction ([@louim](https://github.com/louim))

### 1.1.0 (November 7, 2017)
* [#231](https://github.com/carmen-ruby/carmen/pull/231) Base ISO data has been updated for the first time since October 25, 2014
* [#233](https://github.com/carmen-ruby/carmen/pull/233) Revert removing Puerto Rico as a country code
* [#217](https://github.com/carmen-ruby/carmen/pull/217) Add serializer friendly `to_hash` for `Country` and `Region` ([@zarelit](https://github.com/zarelit))
* [#137](https://github.com/carmen-ruby/carmen/pull/137) Add country search by numeric code ([@Envek](https://github.com/Envek))
* [#200](https://github.com/carmen-ruby/carmen/pull/200) Add municipalities of Mexico ([@jdsampayo](https://github.com/jdsampayo))
* [#193](https://github.com/carmen-ruby/carmen/pull/193) Allow filtering subregions by type ([@aldesantis](https://github.com/aldesantis))
* [#180](https://github.com/carmen-ruby/carmen/pull/180) `Region#subregions` returns freezed array ([@j15e](https://github.com/j15e))
* [#177](https://github.com/carmen-ruby/carmen/pull/177) Always return a `RegionCollection` from `Region#load_subregions` ([@codeodor](https://github.com/codeodor))
* Various geographic data updates by [Carmen contributors](https://github.com/carmen-ruby/carmen/graphs/contributors). Thank you!

### 1.0.2 (March 13, 2015)
* Replace use of UnicodeUtils with ActiveSupport (eikes)
* Update data from upstream sources.
* Fix spelling errors for French subregions (hugolantaume)
* Fix spelling errors for Spanish subregions (nudzg)
* Added missing nl translations for bq, cw, ss and sx (brtdv)
* Moved translations into locale/overlay from locale/base. Base is only for data from iso_codes.
* Changed the official name of Taiwan to Republic of China.
* Fixed the name of Vietnam.
* Add local files for Bangla language (tauhidul35)

### 1.0.1 (March 06, 2014)
* Avoid raising an exception when calling Querying#coded with a nil code
* Fix a bug where adding additional data paths caused an error when looking up localized names in the base locale data (seangaffney)
* Add Country#numeric_code (stevenharman)
* Fix the name of Lima (goddamnhippie)
* Add south Sudan Swedish translation (barsoom)
* Add Russian translations of Russian Federation (Envek)
* Fix a regression in the localization of Taiwan from the 1.0 rewrite.
* Fix a bug where empty locale files would prevent access to the base data.
* Add a way to ship overlayed data sets with Carmen to allow for differences from the upstream data source.
* Remove Puerto Rico from the list of countries as it is a subregion.
* Restore the naming of Taiwan after a regression to an outdated name.
* Added La Rioja to the list of subregions of Argentina (njacobs1)
* Added APO states to US subregions.

### 1.0.0 (April 20, 2013)
* Updated version numbering and pushed 1.0.0pre to v1.0.0.
* Merged in updates to German locations, via a patch from @leifg

### 1.0.0pre
* Complete rewrite. New data source and API. Extracting Rails view
  helpers into seperate gem.

### 0.2.12
* Republish the gem with Ruby 1.8.7.

### 0.2.11
* Remove Jeweler and release new version.

### 0.2.10
* Generate the gem with Ruby 1.8.7 to try to fix YAML library
  incompatibilities.

### 0.2.9
* Preserve order of priority_countries in country_select (castiglione)
* Add Finnish localization (marjakapyaho)
* Update a few contru names to match ISO naming (belt)
* Fall back to default locale if selected locale is missing (twinge)
* Added Russian country translations (grlm)
* Added South Sudan as a country (edshadi)
* Renamed Libyan Arab Jamahiriya to Libya (mdimas)
* Fixed an issue where trying find a country for a blank string would
  match everything (smathieu)
* Added Italian country names (Arkham)
* Add Polish, slovak and czech translations (Pajk)
* Various corrections to country names (wolframarnold)
* Add Chinese counties (liwh)
* Add Dutch province names (ariejan)
* Add Saint Barthelemy (BL) and Saint Martin (French Part) (MF) (nengxu)
* Add Japanese countries localization (bonsaiben)
* Prevent Carmen::state_name('NO','NO') from crashing (mhourahine)
* Change "Taiwan, Province of China" to "Taiwan" (camilleroux)
* Add spanish translation for countries (federomero)

### 0.2.8
* Use a shorter name for US Armed Forces States (cgs)
* Added Gujarat to the list of states in India (swaroopch)
* Added American Samoa to the list of US States
* Added Dutch country translations (Arie)
* Added Kosovo to German Translation (Christopher Thorpe)
* Added the ability to list countries at the top of the list (jjthrash)
* Added country names in Hindi (sukeerthiadiga)

### 0.2.7
* Fix a gemspec disaster.

### 0.2.6 (pulled)
* Suppress a deprecation warning in Rails 3 (anupamc)
* Remove init.rb altogether and use requires under Rails
* Added Indian states and union territories (orthodoc)

### 0.2.5
* Data corrections (mikepinde)

### 0.2.4
* Fixed autoloading under Rails 3

### 0.2.2
* Added state and country exclusion (kalafut)

### 0.2.1
* Added regions for New Zealand (yehezkielbs)

### 0.2.0
* Merge in Maximilian Schulz's locale fork, refactor internals to better support locales, and update documentation.
* Remove Carmen::STATES and Carmen::COUNTRIES constants in favor of module instance variables and proper accessors.
* Add a test_helper and remove dependency on RubyGems.

### 0.1.3
* DEPRECATE Carmen::COUNTRIES in favor of Carmen.countries
