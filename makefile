R=`tput setaf 1`
G=`tput setaf 2`
Y=`tput setaf 3`
B=`tput setaf 4`
NC=`tput sgr0`

$(eval APP ?= asprilo)
$(eval LOGIC ?= tel)
$(eval BASE_INSTANCE = $(basename $(notdir $(INSTANCE))))
$(eval BASE_OUT = ./outputs/$(APP)/$(LOGIC)/$(CONSTRAINT)/$(BASE_INSTANCE))
ZSH_RESULT:=$(shell mkdir -p $(BASE_OUT))


tests:
	@ echo "$(B)Running 'del' tests...$(NC)"
	@ python -m unittest tests.del_test
	@ echo "$(B)Running 'tel' tests...$(NC)"
	@ python -m unittest tests.tel_test

run-asprilo:

	@ make translate CONSTRAINT=$(CONSTRAINT) LOGIC=$(LOGIC) INSTANCE=$(INSTANCE)

	@ echo " $BFinding plans... $(NC)"

	# @ clingo ./outputs/asprilo/$(LOGIC)/$(CONSTRAINT)/automaton.lp automata_run/run.lp env/asprilo/glue.lp $(INSTANCE) env/asprilo/asprilo-abstraction-encodings/encodings/torsten/md/{action-MD.lp,goal-MD.lp,output-M.lp} env/asprilo/asprilo-abstraction-encodings/asprilo/misc/augment-md-to-m.lp -c horizon=$(HORIZON) --stats | tee ./outputs/asprilo/$(LOGIC)/$(CONSTRAINT)/plan.txt
	@ clingo $(BASE_OUT)/automaton.lp automata_run/run.lp env/asprilo/glue.lp $(INSTANCE) env/asprilo/asprilo-abstraction-encodings/encodings/torsten/md/action-MD.lp env/asprilo/asprilo-abstraction-encodings/encodings/torsten/md/goal-MD.lp env/asprilo/asprilo-abstraction-encodings/encodings/torsten/md/output-M.lp env/asprilo/asprilo-abstraction-encodings/asprilo/misc/augment-md-to-m.lp -c horizon=$(HORIZON) --stats | tee ./outputs/asprilo/$(LOGIC)/$(CONSTRAINT)/plan.txt

viz-asprilo:
	sed -n "4,5p" ./outputs/asprilo/$(LOGIC)/$(CONSTRAINT)/plan.txt | viz

stats:
	@ echo " $B $(BASE_OUT) $(NC)"

	tail -32 ./outputs/$(APP)/$(LOGIC)/$(CONSTRAINT)/plan.txt

translate:

	$(eval BASE_INPUT = env/$(APP)/temporal_constraints/$(LOGIC)/$(CONSTRAINT))
	@ echo "$B Reifying constraint... $(NC)"

	@if [ $(APP) = "asprilo" ]; then\
		gringo formula_to_automaton/$(LOGIC)/theory.lp $(BASE_INPUT).lp $(INSTANCE) env/asprilo/asprilo-abstraction-encodings/asprilo-encodings/input.lp --output=reify > $(BASE_OUT)/reified.lp ;\
	else \
		gringo formula_to_automaton/$(LOGIC)/theory.lp $(BASE_INPUT).lp --output=reify > $(BASE_OUT)/reified.lp ;\
    fi;


	@if grep theory_atom $(BASE_OUT)/reified.lp -q; then\
		echo "$(G) Reification successfull $(NC)";\
	else \
		echo "$(R) Reification failed, theory was not reified";\
		exit 1;\
    fi;

	@ echo "$(B) Translating.... $(NC)"
	@ clingo $(BASE_OUT)/reified.lp ./formula_to_automaton/automata_$(LOGIC).lp -n 0 --outf=0 -V0 --out-atomf=%s. --warn=none | head -n1 | tr ". " ".\n"  > $(BASE_OUT)/automaton.lp

	@if [ -s $(BASE_OUT)/automaton.lp ]; then\
		echo "$(G) Reification successfull $(NC)";\
	else \
		echo "$(R) Reification failed, theory was not reified";\
		exit 1;\
    fi;