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
$(eval PATH_TO_TELINGO = benchmarks/telingo)
$(eval PATH_FROM_TELINGO = ../..)
$(eval PATH_INPUT = env/$(ENV_APP)/temporal_constraints/$(LOGIC)/$(CONSTRAINT))
ZSH_RESULT:=$(shell mkdir -p $(PATH_OUT))
$(eval EXTRA = $(PATH_INPUT).extra.lp)

$(eval RUN_ENV_FILES_asprilo = env/asprilo/asprilo-abstraction-encodings/encodings/torsten/md/action-MD.lp env/asprilo/asprilo-abstraction-encodings/encodings/torsten/md/goal-MD.lp env/asprilo/asprilo-abstraction-encodings/encodings/torsten/md/output-M.lp env/asprilo/asprilo-abstraction-encodings/asprilo/misc/augment-md-to-m.lp $(RUN_FILES))
$(eval RUN_ENV_FILES_elevator = env/elevator/encoding.lp $(RUN_FILES))
$(eval RUN_ENV_FILES_test = $(RUN_FILES))

$(eval TRANSLATE_FILES_asprilo = env/asprilo/asprilo-abstraction-encodings/asprilo-encodings/input.lp $(TRANSLATE_FILES))
$(eval TRANSLATE_FILES_elevator = $(TRANSLATE_FILES))
$(eval TRANSLATE_FILES_test = $(TRANSLATE_FILES))

ifeq ("$(wildcard $(EXTRA))","")
    $(eval EXTRA = )
endif

clean:
	rm -rf outputs/*
	(cd benchmarks ; make clean)



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


######################  AFW ########################

translate:

	@if [ "$(APP)" = "afw" ]; then echo ""; else  echo "$(R)Inconsistency APP should be afw$(NC)"; fi


	@ printf "$B Reifying constraint... $(NC)\n"

	gringo formula_to_automaton/$(LOGIC)/theory.lp $(PATH_INPUT).lp $(INSTANCE) $(TRANSLATE_FILES_$(ENV_APP)) --output=reify > $(PATH_OUT)/reified.lp 


	@if grep theory_atom $(PATH_OUT)/reified.lp -q; then\
		printf "$(G) Reification successfull $(NC)\n";\
	else \
		printf "$(R) Reification failed, theory was not reified\n";\
		exit 1;\
    fi;

	@ printf "$(B) Translating.... $(NC)\n"
	clingo $(PATH_OUT)/reified.lp ./formula_to_automaton/automata_$(LOGIC).lp -n 0 --outf=0 -V0 --out-atomf=%s. --warn=none | head -n1 | tr ". " ".\n"  > $(PATH_OUT)/automaton.lp

	@if [ -s $(PATH_OUT)/automaton.lp ]; then\
		printf "$(G) Translation to afw successfull $(NC)\n";\
	else \
		printf "$(R) Translation to afw failed\n";\
		exit 1;\
    fi;

run:

	@ printf " $BFinding filtered plans... $(NC)\n"
	rm -f $(PATH_OUT)/plan_h-$(HORIZON)_n-$(MODELS).txt
	echo $(RUN_FILES)
	echo $(RUN_ENV_FILES_$(ENV_APP))
	clingo $(PATH_OUT)/automaton.lp automata_run/run.lp env/$(ENV_APP)/glue.lp $(INSTANCE) $(EXTRA) $(RUN_ENV_FILES_$(ENV_APP)) -c horizon=$(HORIZON) -n $(MODELS) --stats | tee $(PATH_OUT)/plan_h-$(HORIZON)_n-$(MODELS).txt

translate-run:

	@ make translate CONSTRAINT=$(CONSTRAINT) LOGIC=$(LOGIC) INSTANCE=$(INSTANCE) ENV_APP=$(ENV_APP) TRANSLATE_FILES=$(TRANSLATE_FILES_$(APP))
	
	@ make run CONSTRAINT=$(CONSTRAINT) LOGIC=$(LOGIC) INSTANCE=$(INSTANCE) ENV_APP=$(ENV_APP) RUN_FILES=$(RUN_FILES) MODELS=$(MODELS)

generate-traces:

	@ printf " $BGenerating traces for automaton... $(NC)\n"

	clingo $(PATH_OUT)/automaton.lp automata_run/run.lp  automata_run/trace_generator.lp -c horizon=$(HORIZON)




######################  TELINGO ########################

translate-telingo:

	@if [ "$(APP)" = "telingo" ]; then echo ""; else  echo "$(R)Inconsistency APP should be telingo$(NC)"; fi

	rm -f ./$(PATH_OUT)/plan_h-$(HORIZON)_n-$(MODELS).txt
	(cd benchmarks/telingo ; python telingo/program_observer.py $(HORIZON) $(PATH_FROM_TELINGO)/$(PATH_OUT)/translation.lp $(PATH_FROM_TELINGO)/env/$(ENV_APP)/telingo_choices.lp  $(PATH_FROM_TELINGO)/$(PATH_INPUT).lp)
	@printf "$(G) Translation of telingo successfull $(NC)\n";

translate-run-telingo:

	@ make translate-telingo CONSTRAINT=$(CONSTRAINT) LOGIC=$(LOGIC) INSTANCE=$(INSTANCE) ENV_APP=$(ENV_APP)
	clingo ./$(PATH_OUT)/translation.lp  $(INSTANCE) $(RUN_FILES) -n $(MODELS) -c horizon=$(HORIZON) --stats | tee $(PATH_OUT)/telingo_plan_h-$(HORIZON)_n-$(MODELS).txt


######################  DFA ########################


translate-dfa:
	
	@if [ "$(APP)" = "dfa" ]; then echo ""; else  echo "$(R)Inconsistency APP should be dfa$(NC)"; fi

	python ./pyutils/transformers.py dfa $(PATH_OUT)/dfa_automata.lp ./$(PATH_INPUT).lp
	@printf "$(G) Translation from ldlf 2 nfa successfull $(NC)\n";

translate-run-dfa:

	@ make translate-dfa CONSTRAINT=$(CONSTRAINT) LOGIC=$(LOGIC) INSTANCE=$(INSTANCE) ENV_APP=$(ENV_APP) APP=$(APP)

	rm -f $(PATH_OUT)/plan_h-$(HORIZON)_n-$(MODELS).txt

	clingo $(PATH_OUT)/dfa_automata.lp automata_run/run.lp $(INSTANCE) $(EXTRA) $(RUN_ENV_FILES_$(ENV_APP)) -c horizon=$(HORIZON) -n $(MODELS) --stats | tee $(PATH_OUT)/plan_h-$(HORIZON)_n-$(MODELS).txt


######################  NFA ########################


translate-nfa:
	
	@if [ "$(APP)" = "nfa" ]; then echo ""; else  echo "$(R)Inconsistency APP should be nfa$(NC)"; fi

	@ make translate APP=afw CONSTRAINT=$(CONSTRAINT) LOGIC=$(LOGIC) INSTANCE=$(INSTANCE) ENV_APP=$(ENV_APP) TRANSLATE_FILES=$(TRANSLATE_FILES_$(APP))

	python ./pyutils/transformers.py nfa $(PATH_OUT)/nfa_automata.lp ./outputs/$(ENV_APP)/afw/$(LOGIC)/$(CONSTRAINT)/$(NAME_INSTANCE)/automaton.lp
	@printf "$(G) Translation from ldlf 2 nfa successfull $(NC)\n";

translate-run-nfa:

	@ make translate-nfa CONSTRAINT=$(CONSTRAINT) LOGIC=$(LOGIC) INSTANCE=$(INSTANCE) ENV_APP=$(ENV_APP) APP=$(APP)

	rm -f $(PATH_OUT)/plan_h-$(HORIZON)_n-$(MODELS).txt

	clingo $(PATH_OUT)/nfa_automata.lp automata_run/run.lp $(INSTANCE) $(EXTRA) $(RUN_ENV_FILES_$(ENV_APP)) env/$(ENV_APP)/glue.lp -c horizon=$(HORIZON) -n $(MODELS) --stats | tee $(PATH_OUT)/plan_h-$(HORIZON)_n-$(MODELS).txt


######################  NFA ########################


# translate-nfa:
	
# 	@if [ "$(APP)" = "nfa" ]; then echo ""; else  echo "$(R)Inconsistency APP should be nfa$(NC)"; fi

# 	@ make translate APP=afw CONSTRAINT=$(CONSTRAINT) LOGIC=$(LOGIC) INSTANCE=$(INSTANCE) ENV_APP=$(ENV_APP) TRANSLATE_FILES=$(TRANSLATE_FILES_$(APP))

# 	clingo ./outputs/$(ENV_APP)/afw/$(LOGIC)/$(CONSTRAINT)/$(NAME_INSTANCE)/automaton.lp ./afw2nfa/afw2nfa.lp -n 0 --outf=0 -V0 --out-atomf=%s____ --warn=none | head -n1 | sed $$'s/____/.\\\n/g' | sed $$'s/_nfa//g' > $(PATH_OUT)/nfa_automata.lp

# 	@printf "$(G) Translation from afw 2 nfa successfull $(NC)\n";


# translate-run-nfa:

# 	@ make translate-nfa CONSTRAINT=$(CONSTRAINT) LOGIC=$(LOGIC) INSTANCE=$(INSTANCE) ENV_APP=$(ENV_APP) APP=$(APP)

# 	clingo $(PATH_OUT)/nfa_automata.lp automata_run/run.lp $(INSTANCE) $(EXTRA) $(RUN_ENV_FILES_$(ENV_APP)) env/$(ENV_APP)/glue.lp -c horizon=$(HORIZON) -n $(MODELS) --stats | tee $(PATH_OUT)/plan_h-$(HORIZON)_n-$(MODELS).txt
