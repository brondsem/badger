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
      # attendee = context.event.attendees.find_or_create_by(confirmation: row['confirmation'])
      attendee = context.event.attendees.find_or_create_by(
        email: row['email'],
        first_name: row['first_name'],
        last_name: row['last_name']
      )

      unless attendee.exported
        attendee.update_attributes(
          first_name: row['first-name'],
          last_name: row['last-name'],
          email: row['email'],
          preferences: {
            # Any new fields that need to be added can just be added in here;
            # doesn't matter if they end up being nil.
            twitter: row["twitter"],
            company: row["company"],
            linked_in: row["linked_in"],
            nonprofit: row["nonprofit"],
            shirt_size: row["shirt-size"],
            dietary_restrictions: row["dietary"],
            notes: row["notes"]
          },
          role: context.event.roles.where("reference_key ILIKE ?", "%#{row['role']}%").first || context.event.roles.first,
          exported: false
        )
      end
    end
  end
end
