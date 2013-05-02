module C :
sig
  type 'a typ
  type 'a ptr
  type 'a array
  type +'a structure
  type 'a union

  exception Unsupported of string
  exception IncompleteType

  val sizeof : 'a typ -> int

  module Type :
  sig
    open Unsigned

    type 'a t = 'a typ
    type 'a f

    val void  : unit t
    val char : char t
    val float : float t
    val double : float t
    val int   : int t
    val nativeint : nativeint t
    val int8_t : int t
    val short : int t
    val int16_t : int t
    val int32_t : int32 t
    val int64_t : int64 t
    val uchar : Uchar.t t
    val uint8_t : Uint8.t t
    val uint16_t : Uint16.t t
    val uint32_t : Uint32.t t
    val uint64_t : Uint64.t t
    val size_t : Size_t.t t
    val ushort : UShort.t t
    val uint : UInt.t t
    val ulong : ULong.t t
    val ullong : ULLong.t t

    val string : string t

    val array : int -> 'a t -> 'a array t
    val ptr : 'a t -> 'a ptr t
    val ( @-> ) : 'a t -> 'b f -> ('a -> 'b) f

    val returning : 'a t -> 'a f
    val funptr : ('a -> 'b) f -> ('a -> 'b) t
  end

  module Ptr :
  sig
    type 'a t = 'a ptr

    val null : unit ptr
    val (!) : 'a t -> 'a
    val (:=) : 'a t -> 'a -> unit
    val (+) : 'a t -> int -> 'a t
    val (-) : 'a t -> int -> 'a t
    val diff : 'a t -> 'a t -> int
    val from_voidp : 'a typ -> unit ptr -> 'a ptr
    val to_voidp : _ ptr -> unit ptr
    val make : 'a typ -> 'a -> 'a ptr
    val allocate : 'a typ -> 'a ptr
  end

  module Array :
  sig
    type 'a t = 'a array

    val get : 'a t -> int -> 'a
    val set : 'a t -> int -> 'a -> unit
    val unsafe_get : 'a t -> int -> 'a
    val unsafe_set : 'a t -> int -> 'a -> unit
    val length : 'a t -> int
    val start : 'a t -> 'a ptr
    val from_ptr : 'a ptr -> int -> 'a t
    val make : 'a typ -> ?initial:'a -> int -> 'a t
  end

  module Struct :
  sig
    type 's t = 's structure
    type ('a, -'s) field
        
    val tag : string -> 's structure typ
    val ( *:* ) : 's structure typ -> 'a typ -> ('a, 's) field
    val seal : 's structure typ -> unit

    val make : 's structure typ -> 's structure
    val setf : 's structure -> ('a, 's) field -> 'a -> unit
    val getf : 's structure -> ('a, 's) field -> 'a
    val (@.) : 's structure -> ('a, 's) field -> 'a ptr
    val (|->) : 's structure ptr -> ('a, 's) field -> 'a ptr
    val addr : 's structure -> 's structure ptr
  end

  module Union :
  sig
    type 's t = 's union
    type ('a, -'s) field
        
    val tag : string -> 's union typ
    val ( *:* ) : 's union typ -> 'a typ -> ('a, 's) field
    val seal : 's union typ -> unit

    val make : 's union typ -> 's union
    val setf : 's union -> ('a, 's) field -> 'a -> unit
    val getf : 's union -> ('a, 's) field -> 'a
    val (@.) : 's union -> ('a, 's) field -> 'a ptr
    val (|->) : 's union ptr -> ('a, 's) field -> 'a ptr
    val addr : 's union -> 's union ptr
  end

  val foreign : ?from:Dl.library -> string -> ('a -> 'b) Type.f -> ('a -> 'b)
  val foreign_value : ?from:Dl.library -> string -> 'a Type.t -> 'a ptr
end
