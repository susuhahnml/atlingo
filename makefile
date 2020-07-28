R=`tput setaf 1`
G=`tput setaf 2`
Y=`tput setaf 3`
B=`tput setaf 4`
NC=`tput sgr0`

$(eval APP ?= asprilo)
$(eval LOGIC ?= tel)
$(eval NAME_INSTANCE = $(basename $(notdir $(INSTANCE))))
$(eval PATH_OUT = ./outputs/$(APP)/$(LOGIC)/$(CONSTRAINT)/$(NAME_INSTANCE))
ZSH_RESULT:=$(shell mkdir -p $(PATH_OUT))

clean:
	rm -rf outputs/*

translate:

	$(eval PATH_INPUT = env/$(APP)/temporal_constraints/$(LOGIC)/$(CONSTRAINT))
	@ echo "$B Reifying constraint... $(NC)"

	gringo formula_to_automaton/$(LOGIC)/theory.lp $(PATH_INPUT).lp $(INSTANCE) $(TRANSLATE_FILES) --output=reify > $(PATH_OUT)/reified.lp 


	@if grep theory_atom $(PATH_OUT)/reified.lp -q; then\
		echo "$(G) Reification successfull $(NC)";\
	else \
		echo "$(R) Reification failed, theory was not reified";\
		exit 1;\
    fi;

	@ echo "$(B) Translating.... $(NC)"
	clingo $(PATH_OUT)/reified.lp ./formula_to_automaton/automata_$(LOGIC).lp -n 0 --outf=0 -V0 --out-atomf=%s. --warn=none | head -n1 | tr ". " ".\n"  > $(PATH_OUT)/automaton.lp

	@if [ -s $(PATH_OUT)/automaton.lp ]; then\
		echo "$(G) Translation successfull $(NC)";\
	else \
		echo "$(R) Translation failed";\
		exit 1;\
    fi;

run:

	@ echo " $BFinding filtered plans... $(NC)"

	clingo $(PATH_OUT)/automaton.lp automata_run/run.lp env/$(APP)/glue.lp $(INSTANCE) $(RUN_FILES) -c horizon=$(HORIZON) --stats | tee ./outputs/$(APP)/$(LOGIC)/$(CONSTRAINT)/plan.txt

generate-traces:

	@ echo " $BGenerating traces for automaton... $(NC)"

	clingo $(PATH_OUT)/automaton.lp automata_run/run.lp  automata_run/trace_generator.lp -c horizon=$(HORIZON)


translate-run:

	@ make translate CONSTRAINT=$(CONSTRAINT) LOGIC=$(LOGIC) INSTANCE=$(INSTANCE) APP=$(APP)TRANSLATE_FILES=$(TRANSLATE_FILES)
	
	@ make run CONSTRAINT=$(CONSTRAINT) LOGIC=$(LOGIC) INSTANCE=$(INSTANCE) APP=$(APP)TRANSLATE_FILES=$(RUN_FILES)


viz-automaton:
	@echo "$B Computing visualization for automaton in $(PATH_OUT)/automaton.lp ... $(NC)"

	@python scripts/viz.py $(LOGIC) $(PATH_OUT)/automaton.lp

tests:
	@ echo "$(B)Running 'del' tests...$(NC)"
	@ python -m unittest tests.del_test
	@ echo "$(B)Running 'tel' tests...$(NC)"
	@ python -m unittest tests.tel_test


stats:
	tail -32 ./outputs/$(APP)/$(LOGIC)/$(CONSTRAINT)/plan.txt

######################  ASPRILO ########################

run-asprilo:

	@ make run CONSTRAINT=$(CONSTRAINT) LOGIC=$(LOGIC) INSTANCE=$(INSTANCE) APP=asprilo RUN_FILES="env/asprilo/asprilo-abstraction-encodings/encodings/torsten/md/action-MD.lp env/asprilo/asprilo-abstraction-encodings/encodings/torsten/md/goal-MD.lp env/asprilo/asprilo-abstraction-encodings/encodings/torsten/md/output-M.lp env/asprilo/asprilo-abstraction-encodings/asprilo/misc/augment-md-to-m.lp"

translate-asprilo:

	@ make translate CONSTRAINT=$(CONSTRAINT) LOGIC=$(LOGIC) INSTANCE=$(INSTANCE) APP=asprilo  TRANSLATE_FILES="env/asprilo/asprilo-abstraction-encodings/asprilo-encodings/input.lp"

translate-run-asprilo:

	@ make translate-asprilo CONSTRAINT=$(CONSTRAINT) LOGIC=$(LOGIC) INSTANCE=$(INSTANCE) APP=$(APP)
	
	@ make run-asprilo CONSTRAINT=$(CONSTRAINT) LOGIC=$(LOGIC) INSTANCE=$(INSTANCE) APP=$(APP)

viz-asprilo:
	sed -n "4,5p" ./outputs/asprilo/$(LOGIC)/$(CONSTRAINT)/plan.txt | viz
