#slideshow -t s5blank -o output derek
EXTENSION := .md
CONFIG := .slideshow 
THEME := goozbach
OUTPUTDIR := output
SLIDESHOW := https://github.com/goozbach-presentation/slideshow-goozbach.git

NAMES := $(patsubst %.md,%,$(wildcard *.md))
IMAGES := $(wildcard *.jpg) $(wildcard *.png) $(wildcard *.gif)

$(CONFIG):
	git submodule add $(SLIDESHOW) $(CONFIG)

$(OUTPUTDIR)/%.html: $(CONFIG) %.md $(IMAGES)
	slideshow -c $(CONFIG) b -t $(THEME) -o $(OUTPUTDIR) $(shell echo $@ | sed -e 's/$(OUTPUTDIR)\/\(.*\)\.html/\1/')
	cd $(OUTPUTDIR) && ln -sf $(shell echo $@ | sed -e 's/$(OUTPUTDIR)\/\(.*\.html\)/\1/') index.html && cd -
	if ls *.png &>/dev/null; then cp -v *.png $(OUTPUTDIR); fi
	if ls *.jpg &>/dev/null; then cp -v *.jpg $(OUTPUTDIR); fi
	if ls *.gif &>/dev/null; then cp -v *.gif $(OUTPUTDIR); fi

.SECONDEXPANSION:
$(NAMES): $$(patsubst %,output/%.html,$$@)

.PHONY: all $(NAMES) clean update

update:
	git submodule init
	git submodule update

clean:
	rm -rf $(OUTPUTDIR)

all: $(NAMES)
