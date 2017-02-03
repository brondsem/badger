class RectangleBadgePdf < Prawn::Document
  attr_reader :attendees, :event, :roles
  WIDTH = 220
  HEIGHT = 347
  BORDER_WIDTH = 10

  def initialize(attendees, event = nil)
    super()

    font_families.update("Helvetica" => {
      normal: Rails.root.join("vendor/fonts/Helvetica/Helvetica.ttf"),
      bold:   Rails.root.join("vendor/fonts/Helvetica/Helvetica-Bold.ttf")
    })
    font "Helvetica"

    if attendees
      @attendees = attendees
      @event = event || attendees.first.event

      generate_pdf
    else
      @event = event
      @roles = @event.roles.uniq

      generate_blanks
    end
  end

  private

  def generate_blanks
    roles.each_with_index do |role, page|
      start_new_page unless page == 0
      (1..4).each_with_index do |_, i|
        blank_badge(role, i)
      end

      draw_print_lines
    end
  end

  def blank_badge(role, ord)
    badge_bounds = {
      1 => [bounds.left + 45, bounds.top - 8],
      2 => [bounds.right - WIDTH - 45, bounds.top - 8],
      3 => [bounds.left + 45, bounds.bottom + HEIGHT + 8],
      4 => [bounds.right - WIDTH - 45, bounds.bottom + HEIGHT + 8]
    }

    bounding_box(badge_bounds[ord + 1], :width => WIDTH, :height => HEIGHT) do
      move_down BORDER_WIDTH * 1.5

      draw_logo

      bounding_box([bounds.left + BORDER_WIDTH, bounds.bottom + 40], width: WIDTH - (BORDER_WIDTH * 2), height: 30) do
        text @event.name.upcase, size: 12, align: :left, valign: :bottom
        draw_role(role)
      end

      stroke_color role.border_color
      line_width BORDER_WIDTH
      stroke_bounds
    end
  end

  def generate_pdf
    roles = attendees.alphabetical.group_by(&:role)
    roles.each do |role, role_attendees|
      role_attendees.each_slice(4).with_index do |page, num|
        # Don't start with a blank page
        start_new_page unless num == 0 && roles.keys.first.name == role.name

        page.each_with_index do |attendee, i|
          create_badge(attendee, i) if attendee
        end

        draw_print_lines

        start_new_page

        page.in_groups_of(2).each_with_index do |reverse_page, i|
          reverse_page.reverse.each_with_index do |attendee, j|
            # This calculates the correct order for badges 3 & 4
            if (i % 3 == 1)
              j += 2
            end

            create_badge(attendee, j) if attendee
          end
        end

        draw_print_lines
      end
    end
  end

  def draw_print_lines
    # line [x, y], [x, y]
    # Top
    line [bounds.left + 40, bounds.top + 25], [bounds.left + 40, bounds.top - 4] # Left
    line [bounds.width / 2, bounds.top + 25], [bounds.width / 2, bounds.top - 4] # Middle
    line [bounds.right - 40, bounds.top + 25], [bounds.right - 40, bounds.top - 4] # Right

    # Bottom
    line [bounds.left + 40, bounds.bottom + 4], [bounds.left + 40, bounds.bottom - 25] # Left
    line [bounds.width / 2, bounds.bottom + 4], [bounds.width / 2, bounds.bottom - 25] # Middle
    line [bounds.right - 40, bounds.bottom + 4], [bounds.right - 40, bounds.bottom - 25] # Right

    # Left
    line [bounds.left - 25, bounds.top - 4], [bounds.left + 40, bounds.top - 4] # Top
    line [bounds.left - 25, bounds.height / 2], [bounds.left + 40, bounds.height / 2] # Middle
    line [bounds.left - 25, bounds.bottom + 4], [bounds.left + 40, bounds.bottom + 4] # Bottom

    # Right
    line [bounds.right + 25, bounds.top - 4], [bounds.right - 40, bounds.top - 4] # Top
    line [bounds.right + 25, bounds.height / 2], [bounds.right - 40, bounds.height / 2] # Middle
    line [bounds.right + 25, bounds.bottom + 4], [bounds.right - 40, bounds.bottom + 4] # Top

    # Draw Lines
    stroke_color '7E7E7E'
    dash [2, 3]
    line_width 1
    stroke # This actually draws the line
    undash
  end


  def create_badge(attendee, ord)
    badge_bounds = {
      1 => [bounds.left + 45, bounds.top - 8],
      2 => [bounds.right - WIDTH - 45, bounds.top - 8],
      3 => [bounds.left + 45, bounds.bottom + HEIGHT + 8],
      4 => [bounds.right - WIDTH - 45, bounds.bottom + HEIGHT + 8]
    }

    bounding_box(badge_bounds[ord + 1], :width => WIDTH, :height => HEIGHT) do
      move_down BORDER_WIDTH * 1.5

      draw_logo

      # This is here instead of higher in the chain for blank tag generation
      move_down 15

      draw_name(attendee)

      move_down 10
      bounding_box([bounds.left + 5, bounds.height / 2 - 20], width: WIDTH - 10, height: 50) do
        text attendee.company, size: 14, align: :center
        text attendee.twitter, size: 16, align: :center
      end

      move_down 15

      bounding_box([bounds.left + BORDER_WIDTH, bounds.bottom + 40], width: WIDTH - (BORDER_WIDTH * 2), height: 30) do
        text attendee.event.name.upcase, size: 12, align: :left, valign: :bottom
        draw_role(attendee.role)
      end

      stroke_color attendee.role.border_color
      line_width BORDER_WIDTH
      stroke_bounds
    end
  end

  def draw_logo
    image event.logo.file.file, position: :center, width: WIDTH - (BORDER_WIDTH * 2)

    # move_down 60
    move_down 20
  end

  def draw_name(attendee)
    text attendee.first_name, align: :center, size: 30, style: :bold
    move_down 5
    text attendee.last_name, align: :center, size: 30, style: :bold
  end

  def draw_role(role)
    role_width = width_of(role.name.upcase, size: 12)
    stroke do
      line_width 0
      stroke_color role.border_color
      fill_color role.border_color
      fill_and_stroke_rectangle [bounds.right - BORDER_WIDTH - role_width, bounds.bottom + 20], role_width + BORDER_WIDTH * 2, 30
    end
    fill_color 'FFFFFF'
    text role.name.upcase, size: 12, align: :right, valign: :bottom
    fill_color '000000'
  end
end
