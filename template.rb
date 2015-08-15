#use_debug false
use_synth :tb303
use_bpm 145
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# A basic song outline. You can feed it riffs, fills, whatever you want.
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# Outline the song structure
#
define :song do |intro, verse, chorus, outro|

  intro.call

  4.times { verse.call }

  chorus.call

  4.times { verse.call }

  outro.call
end

# Main Synth
#
in_thread do
  use_synth :supersaw
  use_synth_defaults amp: 0.4, cutoff: 80

  # Setup the separate sections
  #
  intro = -> {}

  verse = -> {}

  solo = -> {}

  chorus = -> {}

  outro = -> {}

  # Send the sections to the song.
  # You can wrap this part in FX.
  # You can wrap the FX in more FX.
  #
  #with_fx :echo do
  #  with_fx :distortion do
  #    song(intro,verse,chorus,outro)
  #  end
  #end

  song(intro,verse,chorus,outro)
end

# Rythym Synth

in_thread do
  use_synth :tri
  use_synth_defaults

  intro = -> {}

  verse = -> {}

  chorus = -> {}

  outro = -> {}

  
  song(intro,verse,chorus,outro)
  
end

# Bass
in_thread do
  use_synth :subpulse

  intro = -> {}

  verse = -> {}

  chorus = -> {}

  outro = -> {}

  song(intro,verse,chorus,outro)
end


# Drums

in_thread do

  use_synth :fm
  use_synth_defaults divisor: 1.6666, attack: 0.0, depth: 1500, sustain: 0.05, release: 0.0

  ll = -> { play :a, sustain: 0.1; sleep 0.75 }
  l  = -> { play :a, sustain: 0.1; sleep 0.5  }
  s  = -> { play :a;               sleep 0.25 }
  r  = -> { play :r;               sleep 1.0    }

  intro = -> { [r,r,r,r,r,r,r,r].map(&:call) }

  verse = -> {  }

  chorus = -> { 4.times { sample :loop_amen, rate: 0.94; sleep 4 } }

  outro = -> { sleep 8 }


  song(intro,verse,chorus,outro)
end