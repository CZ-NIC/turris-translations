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


define CASEDEF

$(1)_LANGS:=$$(shell find -name $(1).po)
$(1)_MLANGS:=$$(patsubst %.po,%.mo,$$($(1)_LANGS))

.PHONY: $(1) install-$(1)

all: $(1)
$(1): $$($(1)_MLANGS)
$$($(1)_MLANGS): %.mo: %.po
	msgfmt --output-file=$$@ $$<

clean: clean-$(1)
clean-$(1):
	rm -f $$($(1)_MLANGS)

install: install-$(1)
install-$(1): $(1)
	$$(foreach LANG, $$($(1)_MLANGS), \
		install -D $$(LANG) $$(DESTDIR)/usr/share/locale/$$(patsubst %/$(1).mo,%/LC_MESSAGES/$(1).mo,$$(LANG));\
	)

update: update-$(1)
update-$(1):
	$$(foreach LANG, $$($(1)_LANGS), msgmerge --update $$(LANG) $(1).pot; )

endef

$(eval $(call CASEDEF,userlists))
$(eval $(call CASEDEF,user-notify))
