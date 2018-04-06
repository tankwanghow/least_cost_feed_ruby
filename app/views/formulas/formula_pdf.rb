class FormulaPdf < Prawn::Document

  def initialize(formula, view)
    super(page_size: [210.mm, 297.mm], margin: [0.mm, 0.mm, 0.mm, 0.mm], skip_page_creation: true)
    @view = view
    @formula = formula
    @premix = Premix.find formula.id
    reset_page_properties
    draw
  end

  def reset_page_properties
    @detail_height = 5.mm
    @py = 268.mm
  end

  def draw
    @total_pages = 0
    new_page
    draw_formula
    self
  end

  def draw_formula
    @py = @py - 10.mm
    formula_start_at = @py + 6.mm
    stroke_horizontal_line 10.mm, 200.mm, at: @py + 13.mm
    @py = @py + 8.mm

    draw_text "Optimize by - Least Cost Feed (leastcostfeed.com)", size: 14, style: :bold, at: [10.mm, 287.mm]
    draw_text "Produce by - #{User.current.name} at #{@premix.updated_at.in_time_zone(User.current.time_zone).to_s(:long)}", size: 12, at: [10.mm, 281.mm]

    draw_text "Formula:", size: 12, at: [10.mm, 275.mm], style: :bold
    draw_text "#{@premix.name}", size: 12, at: [30.mm, 275.mm], style: :italic

    draw_text "Cost:", size: 12, at: [90.mm, 275.mm], style: :bold
    draw_text @view.number_with_precision("#{@premix.cost*1000}/1000#{User.current.weight_unit}", precision: 2), size: 12, at: [105.mm, 275.mm], style: :italic

    draw_text "Batch Size:", size: 12, at: [140.mm, 275.mm], style: :bold
    draw_text "#{@premix.batch_size} #{User.current.weight_unit}", size: 12, at: [170.mm, 275.mm], style: :italic

    draw_text "Ingredient", size: 12, style: :bold_italic, at: [10.mm, @py]
    draw_text "Cost", size: 12, style: :bold_italic, at: [70.mm, @py]
    draw_text "%", size: 12, style: :bold_italic, at: [93.mm, @py]
    draw_text "#{User.current.weight_unit}", size: 12, style: :bold_italic, at: [113.mm, @py]
    draw_text "Amount", size: 12, style: :bold_italic, at: [124.mm, @py]
    draw_text "Amt/1000#{User.current.weight_unit}", size: 12, style: :bold_italic, at: [144.mm, @py]
    draw_text "Cost %", size: 12, style: :bold_italic, at: [173.mm, @py]

    @py = @py - 2.mm
    @formula.formula_ingredients.select { |t| t.actual > 0 }.each do |i|
      bounding_box [10.mm, @py], height: @detail_height, width: 53.mm do
        font("#{Rails.root}/vendor/assets/fonts/DroidSansFallbackFull.ttf") do
          text i.ingredient_name, size: 12, overflow: :shrink_to_fit, valign: :center
        end
      end
      bounding_box [60.mm, @py], height: @detail_height, width: 20.mm do
        text @view.number_with_precision(i.ingredient_cost, precision: 4), size: 12, overflow: :shrink_to_fit, valign: :center, align: :right
      end
      bounding_box [80.mm, @py], height: @detail_height, width: 20.mm do
        text @view.number_with_precision(i.actual_perc, precision: 4), size: 12, overflow: :shrink_to_fit, valign: :center, align: :right
      end
      bounding_box [100.mm, @py], height: @detail_height, width: 20.mm do
        text @view.number_with_precision(i.weight, precision: 2), size: 12, overflow: :shrink_to_fit, valign: :center, align: :right
      end
      bounding_box [120.mm, @py], height: @detail_height, width: 20.mm do
        text @view.number_with_precision(i.weight * i.ingredient_cost, precision: 2), size: 12, overflow: :shrink_to_fit, valign: :center, align: :right
      end
      bounding_box [145.mm, @py], height: @detail_height, width: 20.mm do
        text @view.number_with_precision(i.weight/@premix.batch_size * 1000 * i.ingredient_cost, precision: 2), size: 12, overflow: :shrink_to_fit, valign: :center, align: :right
      end
      bounding_box [165.mm, @py], height: @detail_height, width: 20.mm do
        text @view.number_with_precision((i.weight * i.ingredient_cost)/(@premix.cost * @premix.batch_size) * 100, precision: 2), size: 12, overflow: :shrink_to_fit, valign: :center, align: :right
      end

      @py = @py - @detail_height
    end

    @py = @py - 10.mm

    stroke_horizontal_line 10.mm, 200.mm, at: @py + 8.mm

    draw_text "Nutrient", size: 12, style: :bold_italic, at: [10.mm, @py + 2.mm]
    draw_text "Actual", size: 12, style: :bold_italic, at: [67.mm, @py + 2.mm]

    @formula.formula_nutrients.select { |t| t.actual > 0 }.each do |i|
      bounding_box [10.mm, @py], height: @detail_height, width: 50.mm do
        font("#{Rails.root}/vendor/assets/fonts/DroidSansFallbackFull.ttf") do
          text i.nutrient_name_unit, size: 12, overflow: :shrink_to_fit, valign: :center
        end
      end
      bounding_box [60.mm, @py], height: @detail_height, width: 20.mm do
        text @view.number_with_precision(i.actual, precision: 4), size: 12, overflow: :shrink_to_fit, valign: :center, align: :right
      end
      @py = @py - @detail_height
    end
  end

  def new_page(options={})
    @total_pages = @total_pages + 1
    start_new_page
  end
end
