
:- not &del{
   ? alive ;;
   ? ~loaded ;;
    * &true .>*
    ( 
        ? (?load .>* ~shoot)  ;;
        ? (?shoot.>* ~load)  ;;

        ? (?shoot ;; ?loaded ;; &true .>* ~alive) ;;
        ? (?shoot ;; &true .>* ~loaded) ;;

        ? (?load ;; &true .>* loaded) ;;

        ? (? ~alive ;; &true .>* ~alive) ;;
        ? (? alive ;; ? ~shoot + ? ~loaded ;; &true .>* alive) ;;
        ? (? ~loaded ;; ? ~load  ;; &true .>* ~loaded);;
        ? (?( &true .>* &false) .>* ~alive)
    )

    .>? &true
}.
