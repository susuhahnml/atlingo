% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Theory:
% %     Defines the syntax for the formulas
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

#theory tel {
    formula_body  {
        &   : 7, unary;         % prefix for keywords
        ~   : 5, unary;         % negation
        >   : 5, unary;         % next
        >:  : 5, unary;         % weak next
        >?  : 5, unary;         % eventually+
        >*  : 5, unary;         % always+
        &   : 3, binary, left;  % and
        |   : 2, binary, left;  % or
        >?  : 4, binary, left;  % until
        >*  : 4, binary, left   % release
    };
    show_term {/ : 1, binary, left};
    &tel/0 : formula_body, body;
    &show/0 : show_term, directive
}.