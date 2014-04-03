require 'prawn'
require 'prawn/measurement_extensions'

ActionView::Base.send(:include, Prawn::Helper)
ActionView::Template.register_template_handler(:prawn, lambda { |template| "#{template.source.strip}.render" })