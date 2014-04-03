require 'prawn'
require 'prawn/measurement_extensions'

ActionView::Template.register_template_handler(:prawn, lambda { |template| "#{template.source.strip}.render" })