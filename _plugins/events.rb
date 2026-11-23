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

  # Every event also gets a Russian page at /ru/events/<name>/, built from the
  # same file. Translated fields are named <field>_ru (see the `loc` filter).
  class RussianPages < Jekyll::Generator
    priority :high

    def generate(site)
      site.collections["events"].docs.each do |doc|
        page = Jekyll::PageWithoutAFile.new(site, site.source, "ru#{doc.url}", "index.html")
        page.data.merge!(doc.data)
        page.data.merge!("layout" => "event", "nav" => "events", "lang" => "ru")
        page.content = ""
        site.pages << page
      end
    end
  end
end

module ChoirI18n
  RU_MONTHS = %w[января февраля марта апреля мая июня июля августа сентября октября ноября декабря].freeze
  RU_MONTHS_SHORT = %w[янв фев мар апр мая июн июл авг сен окт ноя дек].freeze
  RU_DAYS = %w[воскресенье понедельник вторник среда четверг пятница суббота].freeze

  # {{ event | loc: "summary", page.lang }} gives summary_ru on Russian pages
  # when it is set, and summary otherwise.
  def loc(obj, field, lang)
    return nil if obj.nil?
    value = obj["#{field}_#{lang}"] if lang && lang != "en"
    return value unless value.nil? || value.to_s.strip.empty?
    value = obj[field]
    value = ChoirI18n.to_24h(value) if field == "time" && lang == "ru"
    value
  end

  # "5:00 – 9:30 PM" => "17:00 – 21:30". A trailing AM/PM applies to every
  # time before it that has none.
  def self.to_24h(text)
    return text unless text.is_a?(String) && text =~ /\b(AM|PM)\b/i
    times = text.scan(/(\d{1,2})(?::(\d{2}))?(?:\s*(AM|PM))?/i)
    suffix = nil
    marks = times.reverse.map { |_, _, ap| suffix = ap if ap; suffix }.reverse
    i = -1
    text.gsub(/(\d{1,2})(?::(\d{2}))?(?:\s*(AM|PM))?/i) do
      i += 1
      h, m, ap = $1.to_i, ($2 || "00"), marks[i]
      h = h % 12 + (ap.to_s.upcase == "PM" ? 12 : 0) if ap
      format("%d:%s", h, m)
    end
  end

  # Like `date`, but with Russian month and day names on Russian pages
  # (capitalized at the start, as English day names are).
  def ldate(input, format, lang)
    time = Jekyll::Utils.parse_date(input.to_s) rescue input
    time = input if input.respond_to?(:strftime)
    if lang == "ru"
      format = format.gsub("%B", RU_MONTHS[time.month - 1])
                     .gsub("%b", RU_MONTHS_SHORT[time.month - 1])
                     .gsub("%A", RU_DAYS[time.wday])
    end
    result = time.strftime(format)
    result = result[0].upcase + result[1..] if lang == "ru" && !result.empty?
    result
  end
end

Liquid::Template.register_filter(ChoirI18n)
