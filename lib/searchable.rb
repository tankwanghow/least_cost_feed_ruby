require "active_support/concern"
require "active_support/core_ext/class/attribute"

module Searchable
  extend ActiveSupport::Concern

  module ClassMethods
    def searchable options={}
      class_attribute :searchable_options
      self.searchable_options = options
    end
  end

  included do
    has_one :pg_search_document, as: :searchable, dependent: :delete

    after_save :update_pg_search_document
  end

  def update_pg_search_document
    if !self.pg_search_document 
      create_pg_search_document if self.respond_to?(:searchable_options)
    else
      self.pg_search_document.save
    end
  end
end