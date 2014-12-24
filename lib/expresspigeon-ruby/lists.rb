module ExpressPigeon
  class Lists
    include API

    def initialize
      @endpoint = 'lists'
    end

    def create(list_name, from_name, reply_to)
      post @endpoint, name: list_name, from_name: from_name, reply_to: reply_to
    end

    # Query all lists.
    # returns: array of hashes each representing a list for this user
    def all
      get @endpoint
    end

    # Updates existing list
    #
    #:param list_id: Id of list to be updated
    #:type list_id: int
    #
    #:param params: JSON object represents a list to be updated

    #
    #:returns: EpResponse with status, code, message, and updated list
    #:rtype: EpResponse
    # TODO: resolve API on Python side, then implement this
    # def update(list_id, params = {})
    #    params['id'] = list_id
    #    return self.ep.put(self.endpoint, params=params)
    # end

    # Removes a list with a given id. A list must be enabled and has no dependent subscriptions and/or scheduled campaigns.
    #
    #  param list_id: Id of list to be removed.
    #  returns response hash with status, code, and message
    def delete(list_id)
      del "#{@endpoint}/#{list_id}"
    end

    def csv(list_id, &block)
      get "#{@endpoint}/#{list_id}/csv", &block
    end
  end
end
