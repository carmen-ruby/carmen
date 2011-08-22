require 'forwardable'

require 'carmen/world'
require 'carmen/querying'

module Carmen
  module Country
    extend Querying
    extend SingleForwardable

    def_delegator 'Carmen::World', :subregions
  end
end
