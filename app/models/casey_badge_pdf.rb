class CaseyBadgePdf < Prawn::Document
  attr_reader :attendees, :event, :roles
  WIDTH = 230
  HEIGHT = 347
  BORDER_WIDTH = 10

  def initialize(attendees, event = nil)
    super()

    if attendees
      @attendees = attendees
      @event = attendees.first.event

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
      1 => [bounds.left + 35, bounds.top - 8],
      2 => [bounds.right - WIDTH - 35, bounds.top - 8],
      3 => [bounds.left + 35, bounds.bottom + HEIGHT + 8],
      4 => [bounds.right - WIDTH - 35, bounds.bottom + HEIGHT + 8]
    }

    bounding_box(badge_bounds[ord + 1], :width => WIDTH, :height => HEIGHT) do
      # Move down top BORDER_WIDTH
      move_down BORDER_WIDTH

      draw_logo

      text role.name, align: :center, size: 25, valign: :bottom

      stroke_color role.border_color
      line_width BORDER_WIDTH
      stroke_bounds
    end
  end

  def generate_pdf
    attendees.group_by(&:role).each do |role, role_attendees|
      role_attendees.each_slice(4).with_index do |page, num|
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

        start_new_page
      end
    end
  end

  def draw_print_lines
    # line [x, y], [x, y]
    # Top
    line [bounds.left + 30, bounds.top + 25], [bounds.left + 30, bounds.top - 4] # Left
    line [bounds.width / 2, bounds.top + 25], [bounds.width / 2, bounds.top - 4] # Middle
    line [bounds.right - 30, bounds.top + 25], [bounds.right - 30, bounds.top - 4] # Right

    # Bottom
    line [bounds.left + 30, bounds.bottom + 4], [bounds.left + 30, bounds.bottom - 25] # Left
    line [bounds.width / 2, bounds.bottom + 4], [bounds.width / 2, bounds.bottom - 25] # Middle
    line [bounds.right - 30, bounds.bottom + 4], [bounds.right - 30, bounds.bottom - 25] # Right

    # Left
    line [bounds.left - 25, bounds.top - 4], [bounds.left + 30, bounds.top - 4] # Top
    line [bounds.left - 25, bounds.height / 2], [bounds.left + 30, bounds.height / 2] # Middle
    line [bounds.left - 25, bounds.bottom + 4], [bounds.left + 30, bounds.bottom + 4] # Bottom

    # Right
    line [bounds.right + 25, bounds.top - 4], [bounds.right - 30, bounds.top - 4] # Top
    line [bounds.right + 25, bounds.height / 2], [bounds.right - 30, bounds.height / 2] # Middle
    line [bounds.right + 25, bounds.bottom + 4], [bounds.right - 30, bounds.bottom + 4] # Top

    # Draw Lines
    stroke_color '7E7E7E'
    dash [2, 3, 0]
    line_width 1
    stroke # This actually draws the line
    undash
  end


  def create_badge(attendee, ord)
    badge_bounds = {
      1 => [bounds.left + 35, bounds.top - 8],
      2 => [bounds.right - WIDTH - 35, bounds.top - 8],
      3 => [bounds.left + 35, bounds.bottom + HEIGHT + 8],
      4 => [bounds.right - WIDTH - 35, bounds.bottom + HEIGHT + 8]
    }

    bounding_box(badge_bounds[ord + 1], :width => WIDTH, :height => HEIGHT) do
      # Move down top BORDER_WIDTH
      move_down BORDER_WIDTH

      draw_logo

      # This is here instead of higher in the chain for blank tag generation
      draw_name(attendee)
      text attendee.company, size: 15, align: :center
      draw_role(attendee)

      stroke_color attendee.role.border_color
      line_width BORDER_WIDTH
      stroke_bounds
    end
  end

  def draw_logo
    image event.logo.file.file, position: :center, width: WIDTH - (BORDER_WIDTH * 2)

    move_down 60
  end

  def draw_name(attendee)
    text attendee.first_name, align: :center, size: 34, style: :bold
    move_down 5
    text attendee.last_name, align: :center, size: 30, style: :bold
    move_down 15
  end

  def draw_role(attendee)
    text attendee.role.name, align: :center, size: 25, valign: :bottom
  end
end
