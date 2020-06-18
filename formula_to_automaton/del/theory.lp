% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Theory:
% %     Defines the syntax for the formulas
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#theory del {
    formula_body  {
        &   : 7, unary;         % prefix for keywords
        ~   : 5, unary;         % negation
        ?   : 4, unary;         % check
        *   : 3, unary;         % kleene star
        +   : 2, binary, left;  % choice
        ;;  : 1, binary, left;  % sequence
        .>? : 0, binary, right; % diamond (eventually)
        .>* : 0, binary, right  % box (always)
    };
    show_term {/ : 1, binary, left};
    &del/0 : formula_body, body;
    &show/0 : show_term, directive
}.

