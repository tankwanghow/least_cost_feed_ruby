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
    @py = 261.mm
  end

  def draw
    @total_pages = 0
    new_page
    repeat(:all) do
      draw_text "Optimize by - Least Cost Feed", size: 14, style: :bold, at: [5.mm, 287.mm]
      draw_text "Produce by - #{User.current.name} at #{@formula.updated_at.in_time_zone(User.current.time_zone).to_s(:long)}", size: 14, at: [5.mm, 281.mm]
      draw_text "Formula:", size: 14, at: [5.mm, 275.mm], style: :bold
      draw_text "#{@formula.name}", size: 14, at: [32.mm, 275.mm], style: :italic

      draw_text "Cost:", size: 14, at: [5.mm, 269.mm], style: :bold
      draw_text "#{@formula.cost} per #{User.current.weight_unit}", size: 14, at: [32.mm, 269.mm], style: :italic
      
      draw_text "Batch Size:", size: 14, at: [100.mm, 269.mm], style: :bold
      draw_text "#{@formula.batch_size} #{User.current.weight_unit}", size: 14, at: [134.mm, 269.mm], style: :italic
      
      draw_text "Ingredient", size: 12, style: :bold_italic, at: [5.mm, 262.mm]
      draw_text "Cost", size: 12, style: :bold_italic, at: [65.mm, 262.mm]
      draw_text "%", size: 12, style: :bold_italic, at: [88.mm, 262.mm]
      draw_text "#{User.current.weight_unit}", size: 12, style: :bold_italic, at: [108.mm, 262.mm]
      @formula.formula_ingredients.select { |t| t.actual > 0 }.each do |i|
        bounding_box [5.mm, @py], height: @detail_height, width: 55.mm do
          font("#{Prawn::DATADIR}/fonts/DroidSansFallbackFull.ttf") do
            text i.ingredient_name, size: 12, overflow: :shrink_to_fit, valign: :center
          end
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
      draw_text "Nutrient", size: 12, style: :bold_italic, at: [125.mm, 262.mm]
      draw_text "Actual", size: 12, style: :bold_italic, at: [182.mm, 262.mm]
      @formula.formula_nutrients.select { |t| t.actual > 0 }.each do |i|
        bounding_box [125.mm, @py], height: @detail_height, width: 50.mm do
          font("#{Prawn::DATADIR}/fonts/DroidSansFallbackFull.ttf") do
            text i.nutrient_name_unit, size: 12, overflow: :shrink_to_fit, valign: :center
          end
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
