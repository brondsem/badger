class ExportAttendees
  include Interactor

  def call
    if context.attendees.present?
      context.pdf = export(context.attendees.where(exported: false), context.event)

      # context.attendees.update_all(exported: true)
    elsif context.blanks && context.event.present?
      context.pdf = export_blanks(context.event)
    else
      context.fail!(message: "No attendees to export.")
    end
  end

  private

  def export(attendees, event)
    RectangleBadgePdf.new(attendees, event)
  end

  def export_blanks(event)
    RectangleBadgePdf.new(nil, event)
  end
end
