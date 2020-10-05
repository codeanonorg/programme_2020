(**
   Code de la conférence 1 :
   Diviser pour régner, Tetris et programmation récursive

   ======================================================

   Arthur Correnson (CodeAnon 2020)
*)

(** puissances de 2 *)
let pow2 n = 1 lsl n

(** division par 2 *)
let div2 n = n lsr 1

(** Calcul des sous-carrés de taille k à partir de
    la positions (i, j) dans un carré de côté 2k.

    Retourne également, pour chaque sous carrés, la posisition du
    pixel le plus au centre du carré parent. *)
let sub_squares (i, j) k = [
  ((i, j), (i + k - 1, j + k - 1));
  ((i, j + k), (i + k - 1, j + k));
  ((i + k, j + k), (i + k, j +k));
  ((i + k, j), (i+ k, j + k - 1))
]

(** Test si un pixel et dans un carré de position (i, j) et de côté k *)
let in_square (i, j) k (x, y) =
  (i <= x) && (x < i + k) && (j <= y) && (y < j + k)


(** Résout le puzzle pour un carré de taille 2^n dont le pixel en (x, y)
    doit rester vide *)
let puzzle n x y =
  let k = pow2 n in
  let mat = Array.make_matrix k k 0 in
  let cnt = ref 0 in

  let new_color () = incr cnt; !cnt in

  let set (i, j) c = mat.(i).(j) <- c in

  let fill (i, j) c =
    set (i, j) c;
    set (i, j+1) c;
    set (i+1, j+1) c;
    set (i+1, j) c
  in

  let rec solve s p k cc =
    let c = new_color () in
    let k' = div2 k in
    if k' = 1 then (fill s c; set p cc)
    else List.iter (fun (s', p') ->
        if in_square s' k' p
        then solve s' p k' cc
        else solve s' p' k' c) (sub_squares s k')
  in
  solve (0, 0) (x, y) k 0;
  mat

(** Affichage de la matrice avec couleurs.
    Le pixel en (x, y) sera distinguable. *)
let pp a (x, y) =
  Array.iteri (fun i a ->
      Array.iteri (fun j v ->
          let code = string_of_int (v mod 15) in
          if (i, j) = (x, y) then Printf.printf "!!"
          else Printf.printf "\027[48;5;%sm  \027[0m" code
        ) a; print_newline ()
    ) a; print_newline ()

(** test du puzzle pour k = 5 *)
let k = 5
let (x, y) = 13, 9
let _ = pp (puzzle k x y) (x, y)