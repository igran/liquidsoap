(*****************************************************************************

  Liquidsoap, a programmable audio stream generator.
  Copyright 2003-2013 Savonet team

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

open Stdlib

module Img = Image.RGBA32
module GU = Gstreamer_utils

let init () = GU.init ()

let render_text ?font ?size ?color text =
  init ();
  let font = Option.default "Helvetica" font in
  let size = Option.default 10 size in
  let color = Option.default 0xffffffff color in
  let font = Printf.sprintf "%s %d" font size in
  (* We have to hack because displaying text in front of a transparent
     background doesn't show anything... *)
  let pipeline = Printf.sprintf "videotestsrc pattern=green ! textoverlay font-desc=\"%s\" text=\"%s\" color=0x%x xpad=0 ypad=0 auto-resize=false ! alpha method=\"green\"" font text color in
  let img = GU.render_image pipeline in
  img

let () =
  Decoder.text_decoders#register "GStreamer"
    ~sdoc:"GStreamer syntesis of text."
    (fun ?font ?size ?color s ->
      let img = render_text ?font ?size ?color s in
      Some img)