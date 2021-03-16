R=`tput setaf 1`
G=`tput setaf 2`
Y=`tput setaf 3`
B=`tput setaf 4`
NC=`tput sgr0`

$(eval ENV_APP ?= asprilo)
$(eval APP ?= afw)
$(eval LOGIC ?= tel)
$(eval MODELS ?= 1)
$(eval NAME_INSTANCE = $(basename $(notdir $(INSTANCE))))
$(eval PATH_OUT = ./outputs/$(ENV_APP)/$(APP)/$(LOGIC)/$(CONSTRAINT)/$(NAME_INSTANCE))
$(eval PATH_TELINGO_OUT = outputs/$(ENV_APP)/$(APP)/$(LOGIC)/$(CONSTRAINT)/$(NAME_INSTANCE))
$(eval PATH_TO_TELINGO = benchmarks/telingo)
$(eval PATH_FROM_TELINGO = ../..)
$(eval PATH_INPUT = env/$(ENV_APP)/temporal_constraints/$(LOGIC)/$(CONSTRAINT))
ZSH_RESULT:=$(shell mkdir -p $(PATH_OUT))
$(eval EXTRA = $(PATH_INPUT).extra.lp)

ifeq ("$(wildcard $(EXTRA))","")
    $(eval EXTRA = )
endif

clean:
	rm -rf outputs/*
	(cd benchmarks ; make clean)

translate:

	@ printf "$B Reifying constraint... $(NC)\n"

	gringo formula_to_automaton/$(LOGIC)/theory.lp $(PATH_INPUT).lp $(INSTANCE) $(TRANSLATE_FILES) --output=reify > $(PATH_OUT)/reified.lp 


	@if grep theory_atom $(PATH_OUT)/reified.lp -q; then\
		printf "$(G) Reification successfull $(NC)\n";\
	else \
		printf "$(R) Reification failed, theory was not reified\n";\
		exit 1;\
    fi;

	@ printf "$(B) Translating.... $(NC)\n"
	clingo $(PATH_OUT)/reified.lp ./formula_to_automaton/automata_$(LOGIC).lp -n 0 --outf=0 -V0 --out-atomf=%s. --warn=none | head -n1 | tr ". " ".\n"  > $(PATH_OUT)/automaton.lp

	@if [ -s $(PATH_OUT)/automaton.lp ]; then\
		printf "$(G) Translation successfull $(NC)\n";\
	else \
		printf "$(R) Translation failed\n";\
		exit 1;\
    fi;

run:

	@ printf " $BFinding filtered plans... $(NC)\n"
	rm -f $(PATH_OUT)/plan_h-$(HORIZON)_n-$(MODELS).txt
	# -clingo $(PATH_OUT)/automaton.lp automata_run/run.lp env/$(ENV_APP)/glue.lp $(INSTANCE) $(EXTRA) $(RUN_FILES) -c horizon=$(HORIZON) -n $(MODELS) --stats
	clingo $(PATH_OUT)/automaton.lp automata_run/run.lp env/$(ENV_APP)/glue.lp $(INSTANCE) $(EXTRA) $(RUN_FILES) -c horizon=$(HORIZON) -n $(MODELS) --stats | tee $(PATH_OUT)/plan_h-$(HORIZON)_n-$(MODELS).txt

generate-traces:

	@ printf " $BGenerating traces for automaton... $(NC)\n"

	clingo $(PATH_OUT)/automaton.lp automata_run/run.lp  automata_run/trace_generator.lp -c horizon=$(HORIZON)


translate-run:

	@ make translate CONSTRAINT=$(CONSTRAINT) LOGIC=$(LOGIC) INSTANCE=$(INSTANCE) ENV_APP=$(ENV_APP)TRANSLATE_FILES=$(TRANSLATE_FILES)
	
	@ make run CONSTRAINT=$(CONSTRAINT) LOGIC=$(LOGIC) INSTANCE=$(INSTANCE) ENV_APP=$(ENV_APP)RUN_FILES=$(RUN_FILES) MODELS=$(MODELS)


viz-automaton:
	@printf "$B Computing visualization for automaton in $(PATH_OUT)/automaton.lp ... $(NC)"

	@python scripts/viz.py $(LOGIC) $(PATH_OUT)/automaton.lp

tests:
	@ printf "$(B)Running 'del' tests...$(NC)"
	@ python -m unittest tests.del_test
	@ printf "$(B)Running 'tel' tests...$(NC)"
	@ python -m unittest tests.tel_test


stats:
	tail -32 $(PATH_OUT)/plan_h-$(HORIZON)_n-$(MODELS).txt

######################  TELINGO ########################

translate-telingo:


	rm -f ./$(PATH_TELINGO_OUT)/plan_h-$(HORIZON)_n-$(MODELS).txt
	(cd benchmarks/telingo ; python telingo/program_observer.py $(HORIZON) $(PATH_FROM_TELINGO)/$(PATH_TELINGO_OUT)_translation.lp $(PATH_FROM_TELINGO)/env/$(ENV_APP)/telingo_choices.lp  $(PATH_FROM_TELINGO)/$(PATH_INPUT).lp)

translate-run-telingo:
	@ make translate-telingo CONSTRAINT=$(CONSTRAINT) LOGIC=$(LOGIC) INSTANCE=$(INSTANCE) ENV_APP=$(ENV_APP)
	clingo ./$(PATH_TELINGO_OUT)_translation.lp  $(INSTANCE) $(RUN_FILES) -n $(MODELS) -c horizon=$(HORIZON) --stats | tee $(PATH_OUT)/telingo_plan_h-$(HORIZON)_n-$(MODELS).txt

######################  ASPRILO ########################

run-asprilo:

	@ make run CONSTRAINT=$(CONSTRAINT) LOGIC=$(LOGIC) INSTANCE=$(INSTANCE) ENV_APP=asprilo RUN_FILES="env/asprilo/asprilo-abstraction-encodings/encodings/torsten/md/action-MD.lp env/asprilo/asprilo-abstraction-encodings/encodings/torsten/md/goal-MD.lp env/asprilo/asprilo-abstraction-encodings/encodings/torsten/md/output-M.lp env/asprilo/asprilo-abstraction-encodings/asprilo/misc/augment-md-to-m.lp $(RUN_FILES)" MODELS=$(MODELS)

translate-asprilo:

	@ make translate CONSTRAINT=$(CONSTRAINT) LOGIC=$(LOGIC) INSTANCE=$(INSTANCE) ENV_APP=asprilo  TRANSLATE_FILES="env/asprilo/asprilo-abstraction-encodings/asprilo-encodings/input.lp"

translate-run-asprilo:

	@ make translate-asprilo CONSTRAINT=$(CONSTRAINT) LOGIC=$(LOGIC) INSTANCE=$(INSTANCE) ENV_APP=$(ENV_APP)
	
	@ make run-asprilo CONSTRAINT=$(CONSTRAINT) LOGIC=$(LOGIC) INSTANCE=$(INSTANCE) ENV_APP=$(ENV_APP) MODELS=$(MODELS)

viz-asprilo:
	sed -n "4,5p" $(PATH_OUT)/plan_h-$(HORIZON)_n-$(MODELS).txt | viz


######################  ELEVATOR ########################

run-elevator:

	@ make run CONSTRAINT=$(CONSTRAINT) LOGIC=$(LOGIC) INSTANCE=$(INSTANCE) ENV_APP=elevator RUN_FILES="env/elevator/encoding.lp $(RUN_FILES)" MODELS=$(MODELS) 

translate-elevator:

	@ make translate CONSTRAINT=$(CONSTRAINT) LOGIC=$(LOGIC) INSTANCE=$(INSTANCE) ENV_APP=elevator

translate-run-elevator:

	@ make translate-elevator CONSTRAINT=$(CONSTRAINT) LOGIC=$(LOGIC) INSTANCE=$(INSTANCE) ENV_APP=elevator
	
	@ make run-elevator CONSTRAINT=$(CONSTRAINT) LOGIC=$(LOGIC) INSTANCE=$(INSTANCE) ENV_APP=elevator MODELS=$(MODELS)

viz-elevator:
	sed -n "4,5p" $(PATH_OUT)/plan_h-$(HORIZON)_n-$(MODELS).txt | viz