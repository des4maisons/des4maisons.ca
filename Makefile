all:
	@echo "Choose a valid help target"
	@exit 1

clean:
	rm -rf _site

serve: clean
	jekyll serve \
		--host 0.0.0.0 \
		--port 4000 \
		--future \
		--drafts \
		--source website
