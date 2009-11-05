(*****************************************************************************

  Liquidsoap, a programmable audio stream generator.
  Copyright 2003-2009 Savonet team

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details, fully stated in the COPYING
  file at the root of the liquidsoap distribution.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

 *****************************************************************************)

type pos = (Lexing.position * Lexing.position)
val print_single_pos : pos -> string
val print_pos : ?prefix:string -> pos -> string

type variance = Covariant | Contravariant | Invariant

type ground = Unit | Bool | Int | String | Float
val print_ground : ground -> string

type constr = Num | Ord | Getter of ground | Dtools | Fixed
type constraints = constr list
val print_constr : constr -> string

type t = { pos : pos option; mutable level : int; mutable descr : descr; }
and constructed = { name : string ; params : (variance*t) list }
and descr =
  | Constr of constructed
  | Ground of ground
  | List of t
  | Product of t * t
  | Zero | Succ of t | Variable
  | Arrow of (bool * string * t) list * t
  | EVar of int * constraints
  | UVar of int * constraints
  | Link of t
val make : ?pos:pos option -> ?level:int -> descr -> t
val dummy : t
val print : t -> string

exception Occur_check of t*t
val occur_check : t -> t -> unit

exception Unsatisfied_constraint of constr*t
val bind : t -> t -> unit
val deref : t -> t
val instantiate : level:int -> t -> t
val generalize : level:int -> t -> unit

type trace_item = Item of t*t | Flip
exception Error of trace_item list
val ( <: ) : t -> t -> unit
val ( >: ) : t -> t -> unit

val fresh_evar : level:int -> pos:pos option -> t
