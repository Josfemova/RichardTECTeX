# Magia
.PRECIOUS: build/%/main.pdf
.SECONDEXPANSION:

SYMLINKS := $(patsubst %.tex,%.pdf,$(shell find -name main.tex -and ! -path './build/*' -and ! -empty))

all: $(SYMLINKS)

clean:
	@rm -rf $(SYMLINKS) build

%/main.pdf: build/%/main.pdf
	@ln -srf $< $@

build/%/main.pdf: %/main.tex $$(shell find % -type f -and -not -name main.pdf)
	@mkdir -p $(dir $@)
	@ln -srf $(filter-out $(dir $<)/main.pdf,$(wildcard $(dir $<)/*)) $(dir $@)
	cd $(dir $@) && latexmk -pdf main.tex && touch main.pdf
