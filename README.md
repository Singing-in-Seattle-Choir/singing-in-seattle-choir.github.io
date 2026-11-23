# Singing in Seattle Choir — website

Home page for Singing in Seattle Choir, a nonprofit community choir in Bellevue and the Eastside.

Built with [Jekyll](https://jekyllrb.com/) and published to GitHub Pages by
`.github/workflows/pages.yml` on every push to `main`.

Events become "past" the day after their date. The workflow also runs every
night and redeploys the site only when the list of upcoming events has changed.

## Building locally

With Ruby and Bundler installed:

    bundle install
    bundle exec jekyll serve

Or without installing Ruby, using a container:

    podman run --rm -it -p 4000:4000 -v "$PWD":/site:Z -w /site \
      -e BUNDLE_PATH=/site/vendor/bundle docker.io/library/ruby:3.4 \
      sh -c 'bundle install && bundle exec jekyll serve --host 0.0.0.0'

Then open http://localhost:4000/.
