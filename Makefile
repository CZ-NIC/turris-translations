MAKEFLAGS += --no-builtin-rules

.PHONY: all
all:
	@

.PHONY: clean
clean:
	@

.PHONY: install
install:
	@

.PHONY: update
update:
	@

.PHONY: help
help:
	@echo "Top level targets:"
	@echo "  all: generate *.mo files"
	@echo "  clean: remove generated *.mo files"
	@echo "  install: copy *.mo files to $(DESTDIR)/usr/share/locale/"
	@echo "  update: merge changes from *.pot files to *.po"


define CASEDEF_LANG

# The touch in this rule is because msgmerge won't update file if there are no
# changes and thus won't settle build fully.
$(2)/$(1).po: $(1).pot
	msgmerge --backup off --force-po --update "$$@" "$$<"
	touch "$$@"

.PHONY: update-$(1)-$(2)
update: update-$(1)
update-$(1): update-$(1)-$(2)
update-$(1)-$(2): $(2)/$(1).po
	msgmerge --backup off --force-po --update "$(2)/$(1).po" "$$<"

.PHONY: install-$(1)-$(2)
install: install-$(1)
install-$(1): install-$(1)-$(2)
install-$(1)-$(2): $(2)/$(1).mo
	install -D $$< $$(DESTDIR)/usr/share/locale/$$(patsubst %/$(1).mo,%/LC_MESSAGES/$(1).mo,$$<)

endef

define CASEDEF

$(1)_LANGS:=$$(shell find -name $(1).po | cut -d '/' -f 2)
$(1)_MO:=$$(patsubst %.po,%.mo,$$(shell find -name $(1).po))

.PHONY: $(1) install-$(1) update-$(1)

all: $(1)
$(1): $$($(1)_MO)
$$($(1)_MO): %.mo: %.po
	msgfmt --output-file=$$@ $$<

clean: clean-$(1)
clean-$(1):
	rm -f $$($(1)_MO)

$$(foreach LANG, $$($(1)_LANGS), $$(eval $$(call CASEDEF_LANG,$(1),$$(LANG))))

endef

$(eval $(call CASEDEF,pkglists))
$(eval $(call CASEDEF,user-notify))
