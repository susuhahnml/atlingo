R=`tput setaf 1`
G=`tput setaf 2`
Y=`tput setaf 3`
B=`tput setaf 4`
NC=`tput sgr0`

$(eval ENV_APP ?= asprilo)
$(eval APP ?= afw)
$(eval LOGIC ?= del)
$(eval MODELS ?= 1)
$(eval FORCE_TRANSLATE ?= 0)
$(eval NAME_INSTANCE = $(basename $(notdir $(INSTANCE))))
$(eval PATH_OUT = ./outputs/$(ENV_APP)/$(APP)/$(LOGIC)/$(CONSTRAINT)/$(NAME_INSTANCE))
$(eval PATH_TO_TELINGO = benchmarks/telingo)
$(eval PATH_FROM_TELINGO = ../..)
$(eval PATH_INPUT = env/$(ENV_APP)/temporal_constraints/$(LOGIC)/$(CONSTRAINT))
ZSH_RESULT:=$(shell mkdir -p $(PATH_OUT))
$(eval EXTRA = $(PATH_INPUT).extra.lp)

# ------- Files needed for each app
$(eval RUN_APP_FILES_afw = automata_run/run.lp env/$(ENV_APP)/glue.lp)
# $(eval RUN_APP_FILES_telingo = env/elevator/encoding.lp )
$(eval RUN_APP_FILES_dfa-mso = automata_run/run.lp)
$(eval RUN_APP_FILES_dfa-stm = automata_run/run.lp)
$(eval RUN_APP_FILES_nfa = automata_run/run.lp)


# ------- Files needed for each env
$(eval RUN_ENV_FILES_asprilo = env/asprilo/asprilo-abstraction-encodings/encodings/torsten/md/action-MD.lp env/asprilo/asprilo-abstraction-encodings/encodings/torsten/md/goal-MD.lp env/asprilo/asprilo-abstraction-encodings/encodings/torsten/md/output-M.lp env/asprilo/asprilo-abstraction-encodings/asprilo/misc/augment-md-to-m.lp $(RUN_FILES))
$(eval RUN_ENV_FILES_elevator = env/elevator/encoding.lp $(RUN_FILES))
$(eval RUN_ENV_FILES_test = $(RUN_FILES))
$(eval RUN_ENV_FILES_nc = $(RUN_FILES))

$(eval TRANSLATE_FILES_asprilo = env/asprilo/asprilo-abstraction-encodings/asprilo-encodings/input.lp $(TRANSLATE_FILES))
$(eval TRANSLATE_FILES_elevator = $(TRANSLATE_FILES))
$(eval TRANSLATE_FILES_test = $(TRANSLATE_FILES))

ifeq ("$(wildcard $(EXTRA))","")
    $(eval EXTRA = )
endif

clean:
	rm -rf outputs/*
	(cd benchmarks ; make clean)


viz:
	@ printf "$BVisualizing APP=$(APP) ENV=$(ENV_APP) CONSTRAINT=$(CONSTRAINT)$ INSTANCE=$(NAME_INSTANCE) HORIZON=$(HORIZON) $(NC)\n"

	python scripts/viz.py --app=$(APP) --env_app=$(ENV_APP) --instance=$(NAME_INSTANCE) --constraint=$(CONSTRAINT) --instance_path=$(INSTANCE) --latex --labels
	
	@ printf "$(G)PNG and latex saved in $(PATH_OUT) $(NC)\n";\

	@ printf "$BCompiling latex...$(NC)\n"

	pdflatex -halt-on-error -output-directory $(PATH_OUT) $(PATH_OUT)/$(APP)_automata.tex > /dev/null 2>&1


	open $(PATH_OUT)/$(APP)_automata.pdf

tests:
	@ printf "$(B)Running 'del' tests...$(NC)"
	@ python -m unittest tests.del_test
	@ printf "$(B)Running 'tel' tests...$(NC)"
	@ python -m unittest tests.tel_test


stats:
	tail -32 $(PATH_OUT)/plan_h-$(HORIZON)_n-$(MODELS).txt

translate:

	@ printf "$BTranslating APP=$(APP) ENV=$(ENV_APP) CONSTRAINT=$(CONSTRAINT)$ INSTANCE=$(NAME_INSTANCE) HORIZON=$(HORIZON) $(NC)\n"

	@ make translate-$(APP) 

	@if [ -s $(PATH_OUT)/$(APP)_automata.lp ]; then\
		printf "$(G)Translation to $(APP)  successfull $(NC)\n";\
	else \
		printf "$(R) Translation to $(APP) failed no output automata\n";\
		exit 1;\
    fi;


run:

	@ printf "$BRunning APP=$(APP) ENV=$(ENV_APP) CONSTRAINT=$(CONSTRAINT)$ INSTANCE=$(NAME_INSTANCE) HORIZON=$(HORIZON) $(NC)\n"

	@rm -f $(PATH_OUT)/plan_h-$(HORIZON)_n-$(MODELS).txt

	clingo $(PATH_OUT)/$(APP)_automata.lp $(INSTANCE) $(RUN_APP_FILES_$(APP)) $(RUN_ENV_FILES_$(ENV_APP)) $(EXTRA) -c horizon=$(HORIZON) -n $(MODELS) --stats | tee $(PATH_OUT)/plan_h-$(HORIZON)_n-$(MODELS).txt

	@printf "$(G)Run of $(APP) successfull $(NC)\n";

translate-run:

	@if [ "$(APP)" = "nc" ]; then\
		echo "$(Y)No constrain option$(NC)";\
		clingo --stats $(INSTANCE) $(RUN_ENV_FILES_$(ENV_APP)) -c horizon=$(HORIZON) -n $(MODELS);\
		exit 1;\
	fi
	@if [ "$(FORCE_TRANSLATE)" = "1" ]; then \
		make translate;\
	elif [ "$(APP)" = "telingo" ]; then\
		make translate;\
	else\
		if [ -s $(PATH_OUT)/$(APP)_automata.lp ]; then\
			echo "$(Y)Skipping translation$(NC)";\
		else\
			echo "$(Y)Making translation since file is missing$(NC)";\
			make translate;\
		fi;\
	fi

	@ make translate
	
	@ make run

######################  AFW ########################

translate-afw:

	@if [ "$(APP)" = "afw" ]; then echo ""; else  echo "$(R)Inconsistency APP should be afw$(NC)"; fi

	@ printf "$BReifying constraint... $(NC)\n"

	gringo formula_to_automaton/$(LOGIC)/theory.lp $(PATH_INPUT).lp $(INSTANCE) $(TRANSLATE_FILES_$(ENV_APP)) --output=reify > $(PATH_OUT)/reified.lp 


	@if grep theory_atom $(PATH_OUT)/reified.lp -q; then\
		printf "$(G)Reification successfull $(NC)\n";\
	else \
		printf "$(R)Reification failed, theory was not reified\n";\
		exit 1;\
    fi;

	@ printf "$(B)Translating.... $(NC)\n"
	clingo $(PATH_OUT)/reified.lp ./formula_to_automaton/automata_$(LOGIC).lp -n 0 --outf=0 -V0 --out-atomf=%s. --warn=none | head -n1 | tr ". " ".\n"  > $(PATH_OUT)/afw_automata.lp

generate-traces:

	@ printf "$BGenerating traces for automaton... $(NC)\n"

	clingo $(PATH_OUT)/afw_automata.lp automata_run/run.lp  automata_run/trace_generator.lp -c horizon=$(HORIZON)


######################  TELINGO ########################

translate-telingo:

	(cd benchmarks/telingo ; python telingo/program_observer.py $(HORIZON) $(PATH_FROM_TELINGO)/$(PATH_OUT)/telingo_automata.lp $(PATH_FROM_TELINGO)/env/$(ENV_APP)/telingo_choices.lp  $(PATH_FROM_TELINGO)/$(PATH_INPUT).lp)


######################  DFA ########################


translate-dfa-mso:
	

	python ./scripts/translater.py --input=ldlf --app=dfa-mso --out-file=$(PATH_OUT)/dfa-mso_automata.lp --in-files='./$(PATH_INPUT).lp $(TRANSLATE_FILES_$(ENV_APP))'

	@printf "$(G) Translation from ldlf 2 dfa successfull $(NC)\n";

translate-dfa-stm:
	

	python ./scripts/translater.py --input=ldlf --app=dfa-stm --out-file=$(PATH_OUT)/dfa-stm_automata.lp --in-files="./$(PATH_INPUT).lp $(TRANSLATE_FILES_$(ENV_APP))"
	@printf "$(G) Translation from ldlf 2 dfa successfull $(NC)\n";

######################  NFA ########################


translate-nfa:
	
	@ make translate-afw APP=afw CONSTRAINT=$(CONSTRAINT) LOGIC=$(LOGIC) INSTANCE=$(INSTANCE) ENV_APP=$(ENV_APP) TRANSLATE_FILES=$(TRANSLATE_FILES_$(APP))

	python ./scripts/translater.py --input=afw --app=nfa --out-file=$(PATH_OUT)/nfa_automata.lp --in-files=./outputs/$(ENV_APP)/afw/$(LOGIC)/$(CONSTRAINT)/$(NAME_INSTANCE)/afw_automata.lp

