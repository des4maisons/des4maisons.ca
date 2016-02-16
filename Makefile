all:
	@echo "Choose a valid help target"
	@exit 1

clean:
	rm -rf _site

build: clean
	bundle exec jekyll build --source website

proofer: build
	bundle exec htmlproof \
		--disable-external \
		--allow-hash-href \
		./_site

test: proofer
	@echo "Everything looks good!"

serve: clean
	bundle exec jekyll serve \
		--host 0.0.0.0 \
		--port 4000 \
		--future \
		--drafts \
		--source website
