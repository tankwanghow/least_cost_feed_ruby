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
    draw_premix
    #draw_formula
    self
  end

  def draw_formula
    @py = @py - 10.mm
    formula_start_at = @py + 6.mm
    stroke_horizontal_line 10.mm, 200.mm, at: @py + 13.mm
    @py = @py + 8.mm
    draw_text "Ingredient", size: 12, style: :bold_italic, at: [10.mm, @py]
    draw_text "Cost", size: 12, style: :bold_italic, at: [70.mm, @py]
    draw_text "%", size: 12, style: :bold_italic, at: [93.mm, @py]
    draw_text "#{User.current.weight_unit}", size: 12, style: :bold_italic, at: [113.mm, @py]
    draw_text "Nutrient", size: 12, style: :bold_italic, at: [130.mm, @py]
    draw_text "Actual", size: 12, style: :bold_italic, at: [187.mm, @py]
    @py = @py - 2.mm
    @formula.formula_ingredients.select { |t| t.actual > 0 }.each do |i|
      bounding_box [10.mm, @py], height: @detail_height, width: 53.mm do
        font("#{Prawn::DATADIR}/fonts/DroidSansFallbackFull.ttf") do
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
      @py = @py - @detail_height
    end

    @py = formula_start_at

    @formula.formula_nutrients.select { |t| t.actual > 0 }.each do |i|
      bounding_box [130.mm, @py], height: @detail_height, width: 50.mm do
        font("#{Prawn::DATADIR}/fonts/DroidSansFallbackFull.ttf") do
          text i.nutrient_name_unit, size: 12, overflow: :shrink_to_fit, valign: :center
        end
      end
      bounding_box [180.mm, @py], height: @detail_height, width: 20.mm do
        text @view.number_with_precision(i.actual, precision: 4), size: 12, overflow: :shrink_to_fit, valign: :center, align: :right
      end
      @py = @py - @detail_height
    end
  end

  def draw_premix
    draw_text "Optimize by - Least Cost Feed (leastcostfeed.com)", size: 14, style: :bold, at: [10.mm, 287.mm]
    draw_text "Produce by - #{User.current.name} at #{@premix.updated_at.in_time_zone(User.current.time_zone).to_s(:long)}", size: 12, at: [10.mm, 281.mm]

    draw_text "Formula:", size: 12, at: [10.mm, 275.mm], style: :bold
    draw_text "#{@premix.name}", size: 12, at: [37.mm, 275.mm], style: :italic

    draw_text "Batch Size:", size: 12, at: [105.mm, 275.mm], style: :bold
    draw_text "#{@premix.batch_size} #{User.current.weight_unit}", size: 12, at: [139.mm, 275.mm], style: :italic

    draw_text "Ingredient", size: 12, style: :bold, at: [10.mm, 269.mm], style: :bold_italic
    draw_text "%", size: 12, style: :bold, at: [93.mm, 269.mm], style: :bold_italic
    draw_text "#{User.current.weight_unit}", size: 12, style: :bold, at: [113.mm, 269.mm], style: :bold_italic

    @premix.premix_ingredients.select { |t| t.actual_usage - t.premix_usage > 0 }.sort_by { |t| -(t.actual_usage - t.premix_usage) }.each do |i|
      bounding_box [10.mm, @py], height: @detail_height, width: 65.mm do
        font("#{Prawn::DATADIR}/fonts/DroidSansFallbackFull.ttf") do
          text i.ingredient_name, size: 12, overflow: :shrink_to_fit, valign: :center
        end
      end
      bounding_box [80.mm, @py], height: @detail_height, width: 20.mm do
        text @view.number_with_precision((i.actual_usage - i.premix_usage)/@premix.batch_size * 100, precision: 2), size: 12, overflow: :shrink_to_fit, valign: :center, align: :right
      end
      bounding_box [100.mm, @py], height: @detail_height, width: 20.mm do
        text @view.number_with_precision(i.actual_usage - i.premix_usage, precision: 2), size: 12, overflow: :shrink_to_fit, valign: :center, align: :right
      end
      @py = @py - @detail_height
    end

    bounding_box [10.mm, @py], height: @detail_height, width: 60.mm do
      text "#{@premix.name} Premix", size: 12, overflow: :shrink_to_fit, valign: :center
    end
    bounding_box [80.mm, @py], height: @detail_height, width: 20.mm do
      text @view.number_with_precision(@premix.premix_weight/@premix.batch_size * 100, precision: 2), size: 12, overflow: :shrink_to_fit, valign: :center, align: :right
    end
    bounding_box [100.mm, @py], height: @detail_height, width: 20.mm do
      text @view.number_with_precision(@premix.premix_weight, precision: 2), size: 12, overflow: :shrink_to_fit, valign: :center, align: :right
    end

    @py = @py - (@detail_height * 2)

    draw_text "Premix:", size: 12, at: [10.mm, @py], style: :bold
    draw_text "#{@premix.name} Premix", size: 12, at: [37.mm, @py], style: :italic

    draw_text "Batch Size:", size: 12, at: [105.mm, @py], style: :bold
    draw_text "#{@premix.total_premix_weight}  #{User.current.weight_unit}", size: 12, at: [139.mm, @py], style: :italic

    @py = @py - @detail_height

    draw_text "Bag Weight:", size: 12, at: [10.mm, @py], style: :bold
    draw_text "#{@premix.premix_weight} #{User.current.weight_unit}", size: 12, at: [37.mm, @py], style: :italic

    draw_text "Total Bags:", size: 12, at: [105.mm, @py], style: :bold
    draw_text "#{@premix.bags_of_premix}", size: 12, at: [139.mm, @py], style: :italic

    @py = @py - @detail_height - 1.mm

    draw_text "Ingredient", size: 12, style: :bold_italic, at: [10.mm, @py]
    draw_text "%", size: 12, style: :bold_italic, at: [93.mm, @py]
    draw_text "#{User.current.weight_unit}", size: 12, style: :bold_italic, at: [113.mm, @py]
    draw_text "Bags", size: 12, style: :bold_italic, at: [135.mm, @py]
    draw_text "Left (Kg)", size: 12, style: :bold_italic, at: [160.mm, @py]

    @py = @py - 2.mm
    premix_bag_cost = 0
    @premix.premix_ingredients.select { |t| t.premix_usage > 0 }.sort_by { |t| -t.premix_usage }.each do |i|
      perc = i.premix_usage/@premix.premix_weight * 100
      weight = perc / 100 * @premix.total_premix_weight
      bags = (weight/i.ingredient.package_weight).round(2).to_i
      premix_bag_cost = premix_bag_cost + (i.ingredient.cost * i.premix_usage)
      bounding_box [10.mm, @py], height: @detail_height, width: 65.mm do
        font("#{Prawn::DATADIR}/fonts/DroidSansFallbackFull.ttf") do
          text "#{i.ingredient_name} (#{i.ingredient.package_weight} #{User.current.weight_unit})", size: 12, overflow: :shrink_to_fit, valign: :center
        end
      end
      bounding_box [80.mm, @py], height: @detail_height, width: 20.mm do
        text @view.number_with_precision(perc, precision: 2), size: 12, overflow: :shrink_to_fit, valign: :center, align: :right
      end
      bounding_box [100.mm, @py], height: @detail_height, width: 20.mm do
        text @view.number_with_precision(weight, precision: 2), size: 12, overflow: :shrink_to_fit, valign: :center, align: :right
      end
      bounding_box [126.mm, @py], height: @detail_height, width: 20.mm do
        text @view.number_with_precision(bags, precision: 2), size: 12, overflow: :shrink_to_fit, valign: :center, align: :right
      end
      bounding_box [155.mm, @py], height: @detail_height, width: 20.mm do
        text @view.number_with_precision(weight - bags * i.ingredient.package_weight, precision: 2), size: 12, overflow: :shrink_to_fit, valign: :center, align: :right
      end
      @py = @py - @detail_height
    end
    # draw_text "Cost per #{User.current.weight_unit}:", size: 12, at: [10.mm, @py - 5.mm], style: :bold
    # draw_text "#{(premix_bag_cost/@premix.premix_weight).round(4)}", size: 12, at: [37.mm, @py - 5.mm], style: :italic
    # draw_text "Cost per bag:", size: 12, at: [60.mm,   @py - 5.mm], style: :bold
    # draw_text "#{premix_bag_cost.round(4)}", size: 12, at: [89.mm, @py - 5.mm], style: :italic
    @py = @py - (@detail_height * 2)
  end

  def new_page(options={})
    @total_pages = @total_pages + 1
    start_new_page
  end
end
