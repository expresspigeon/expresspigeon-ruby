module ExpressPigeon
  class Contacts
    include ExpressPigeon::API

    def initialize
      @endpoint = 'contacts'
    end

    def find_by_email(email)
      get "#{@endpoint}?email=#{CGI.escape(email)}"
    end



    # JSON list represents contacts to be created or updated.
    # The email field is required.
    # When updating a contact, list_id is optional,
    # since the contact is uniquely identified by email across all lists.
    #
    # :param list_id: Contact list ID (Fixnum) the contact will be added to
    #
    # :param contact: Hash describes new contact. The "email" field is required.
    #
    # :returns: :status, :code, :messages, :contacts and :failed_contact_num if contact failed to create
    #
    def upsert(list_id, contacts)
      post @endpoint, params = { list_id: list_id, contacts: [contacts].flatten }
    end

    # Delete single contact. If list_id is not provided, contact will be deleted from system.
    # :param email: contact email to be deleted.
    # :param list_id: list id to remove contact from, if not provided, contact will be deleted from system.
    def delete(email, list_id = nil)
      query = "email=#{CGI.escape(email)}"
      query += "&list_id=#{list_id}" if list_id

      del "#{@endpoint}?#{query}", nil
    end


  end
end
