# Singing in Seattle Choir — website

Home page for Singing in Seattle Choir, a nonprofit community choir in Bellevue and the Eastside.

Built with [Jekyll](https://jekyllrb.com/) and published to GitHub Pages by
`.github/workflows/pages.yml` on every push to `main`.

Events become "past" the day after their date. The workflow also runs every
night and redeploys the site only when the list of upcoming events has changed.

## Events

Each event is one file in `_events/`, named `YYYY-MM-DD-short-name.md`; the
date comes from the file name. It gets its own page at
`/events/YYYY-MM-DD-short-name/`, and the Events page and the home page list
events from these files. The address never changes, even after the event is
over.

```yaml
---
title: “Magic in the air” winter concert
time: 5:00 – 10:00 PM
venue: Highland Community Center, 14224 NE Bel-Red Rd, Bellevue
poster: assets/events/magic-poster.webp
summary: One or two sentences for the event cards and the home page.
tickets: https://www.zeffy.com/...        # shown only while upcoming
tickets_label: Get garden tickets         # optional, default "Get tickets"
facebook: https://www.facebook.com/events/...   # optional
# Optional:
# poster_position: center 30%   # crop of the poster on event cards
# poster_alt: ...               # default "Poster for <title>"
# map: https://maps.app.goo.gl/...   # default: Google Maps search for venue
# photo: assets/events/...webp  # thumbnail in "Past events"; default: poster
# playlists: [PLAYLIST_ID, ...] # YouTube playlists: embedded + a button
# youtube: [VIDEO_ID, ...]      # single YouTube videos, embedded
# photos: [assets/events/....webp, ...]   # gallery on the event page
# albums:                       # links to shared photo albums
#   - url: https://photos.app.goo.gl/...
#     title: Photo album        # optional, default "Photo album"
---
Optional longer text for the event page (Markdown). Without it, the page
shows the summary.
```

## Building locally

With Ruby and Bundler installed:

    bundle install
    bundle exec jekyll serve

Or without installing Ruby, using a container:

    podman run --rm -it -p 4000:4000 -v "$PWD":/site:Z -w /site \
      -e BUNDLE_PATH=/site/vendor/bundle docker.io/library/ruby:3.4 \
      sh -c 'bundle install && bundle exec jekyll serve --host 0.0.0.0'

Then open http://localhost:4000/.
