class ImportAttendees
  include Interactor

  def call
    if context.file
      context.failed_imports = []
      context.attendees = import(context.file)
    else
      context.fail!(message: "Unable to import attendees")
    end
  end

  private

  def import(file)
    require "csv"

    CSV.foreach(file.path, headers: true) do |row|
      attendee = context.event.attendees.find_or_create_by(first_name: row['first_name'], last_name: row['last_name'], email: row['email'])

      unless attendee.exported
        attendee.update_attributes(
          first_name: row['first_name'],
          last_name: row['last_name'],
          preferences: {
            # Any new fields that need to be added can just be added in here;
            # doesn't matter if they end up being nil.
            twitter: row['twitter'],
            company: row["company"]
          },
          role: context.event.roles.where("reference_key ILIKE ?", "%#{row['role']}%").first || context.event.roles.first,
          exported: false
        )
      end
    end
  end
end
