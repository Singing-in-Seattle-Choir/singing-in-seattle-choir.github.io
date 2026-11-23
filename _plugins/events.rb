# Marks each event as upcoming or past, once per build.
#
# An event is upcoming through its date (in the site timezone) and becomes
# past the next day. Templates use `event.upcoming`, so the Events page, the
# home page, event pages and build-state.txt always agree.
module ChoirEvents
  class Upcoming < Jekyll::Generator
    priority :highest

    def generate(site)
      today = site.time.to_date
      site.collections["events"].docs.each do |doc|
        doc.data["upcoming"] = doc.date.to_date >= today
      end
    end
  end
end
