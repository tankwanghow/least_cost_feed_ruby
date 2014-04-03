class FormulaPdf < Prawn::Document

  def initialize(formula, view)
    super(page_size: [210.mm, 297.mm], margin: [0.mm, 0.mm, 0.mm, 0.mm], skip_page_creation: true)
    @view = view
    @formula = formula
    reset_page_properties
    draw
  end

  def reset_page_properties
    @detail_height = 5.mm
    @py = 253.mm
  end

  def draw
    @total_pages = 0
    new_page
    repeat(:all) do
      draw_text "Optimize by - Least Cost Feed", size: 20, style: :bold, at: [5.mm, 287.mm]
      draw_text "Produce by - #{User.current.name} at #{@formula.updated_at.in_time_zone(User.current.time_zone).to_s(:long)}", size: 18, at: [5.mm, 278.mm]
      draw_text "Formula:", size: 16, at: [5.mm, 270.mm], style: :bold
      draw_text "#{@formula.name}", size: 16, at: [32.mm, 270.mm]

      draw_text "Cost:", size: 16, at: [5.mm, 263.mm], style: :bold
      draw_text "#{@formula.cost} per #{User.current.weight_unit}", size: 16, at: [32.mm, 263.mm]
      
      draw_text "Batch Size:", size: 16, at: [100.mm, 263.mm], style: :bold
      draw_text "#{@formula.batch_size} #{User.current.weight_unit}", size: 16, at: [134.mm, 263.mm]
      
      draw_text "Ingredient", size: 12, style: :bold, at: [5.mm, 255.mm]
      draw_text "Cost", size: 12, style: :bold, at: [65.mm, 255.mm]
      draw_text "%", size: 12, style: :bold, at: [88.mm, 255.mm]
      draw_text "#{User.current.weight_unit}", size: 12, style: :bold, at: [108.mm, 255.mm]
      @formula.formula_ingredients.select { |t| t.actual > 0 }.each do |i|
        bounding_box [5.mm, @py], height: @detail_height, width: 50.mm do
          text i.ingredient_name, size: 12, overflow: :shrink_to_fit, valign: :center
        end
        bounding_box [55.mm, @py], height: @detail_height, width: 20.mm do
          text @view.number_with_precision(i.ingredient_cost, precision: 4), size: 12, overflow: :shrink_to_fit, valign: :center, align: :right
        end
        bounding_box [75.mm, @py], height: @detail_height, width: 20.mm do
          text @view.number_with_precision(i.actual_perc, precision: 4), size: 12, overflow: :shrink_to_fit, valign: :center, align: :right
        end
        bounding_box [95.mm, @py], height: @detail_height, width: 20.mm do
          text @view.number_with_precision(i.weight, precision: 2), size: 12, overflow: :shrink_to_fit, valign: :center, align: :right
        end
        @py = @py - @detail_height
      end
      reset_page_properties
      draw_text "Nutrient", size: 12, style: :bold, at: [125.mm, 255.mm]
      draw_text "Actual", size: 12, style: :bold, at: [182.mm, 255.mm]
      @formula.formula_nutrients.select { |t| t.actual > 0 }.each do |i|
        bounding_box [125.mm, @py], height: @detail_height, width: 50.mm do
          text i.nutrient_name_unit, size: 12, overflow: :shrink_to_fit, valign: :center
        end
        bounding_box [175.mm, @py], height: @detail_height, width: 20.mm do
          text @view.number_with_precision(i.actual, precision: 4), size: 12, overflow: :shrink_to_fit, valign: :center, align: :right
        end
        @py = @py - @detail_height
      end
    end
    self
  end

  def new_page(options={})
    @total_pages = @total_pages + 1
    start_new_page
  end
end
