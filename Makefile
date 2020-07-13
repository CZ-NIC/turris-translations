MAKEFLAGS += --no-builtin-rules

CASES:=$(shell ls *.pot | sed 's/\.pot//g')

.PHONY: all clean install update
all:
	@

clean:
	@

install:
	@

update:
	@


define CASEDEF_LANG

.PHONY: install-$(1)-$(2) update-$(1)-$(2)

install-$(1): install-$(1)-$(2)
install-$(1)-$(2): $(2)/$(1).mo
	install -D $$< $$(DESTDIR)/usr/share/locale/$$(patsubst %/$(1).mo,%/LC_MESSAGES/$(1).mo,$$<)

update-$(1): update-$(1)-$(2)
update-$(1)-$(2):
	msgmerge --backup off --update $(2)/$(1).po $(1).pot

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

install: install-$(1)
update: update-$(1)
$$(foreach LANG, $$($(1)_LANGS), $$(eval $$(call CASEDEF_LANG,$(1),$$(LANG))))

endef

$(eval $(call CASEDEF,userlists))
$(eval $(call CASEDEF,pkglists))
$(eval $(call CASEDEF,user-notify))
