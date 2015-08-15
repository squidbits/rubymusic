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
define :song do |intro, intro_2, verse, chorus, outro|

  4.times { intro.call }

  4.times { intro_2.call }

  4.times { verse.call }

  chorus.call

  4.times { verse.call }

  outro.call
end

# Main Synth

in_thread do
  use_synth :tri
  use_synth_defaults

  intro = -> { sleep 4 }

  intro_2 = -> {}

  verse = -> {}

  chorus = -> {}

  outro = -> {}


  song(intro,intro_2,verse,chorus,outro)

end

# Ryhtym Synth
#
in_thread do
  use_synth :square
  use_synth_defaults amp: 0.4, cutoff: 100

  # Setup the separate sections
  #
  intro = -> { sleep 4 }

  intro_2 = -> { sleep 2 }

  verse = -> do
    e = -> { play chord :e4, "minor"; sleep 0.25 }
    b = -> { play chord :b3, "minor"; sleep 0.25 }

             8.times { play_pattern_timed [ e,e,e,e, e,e,e,e, b,b,b,b, b,b,b,b  ], [0.25] }
  end

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

  with_fx :distortion, distort: 0.75, amp: 1 do
    
    song(intro,intro_2,verse,chorus,outro)
    
  end
end

# Bass
in_thread do
  use_synth :subpulse
  use_synth_defaults amp: 2

  intro = -> { play_pattern_timed [ :e2,:e2,:e2,:e2, :b1,:b1,:b1,:b1 ], [0.5] }

  intro_2 = -> { sample :bass_dnb_f; sleep 2 }

  verse = -> { play_pattern_timed [:e2,:e2,:e2,:e2, :e2,:e2,:e2,:e2, :b1,:b1,:b1,:b1, :b1,:b1,:b1,:b1],[0.5] }

  chorus = -> {}

  outro  = -> {}

  song(intro,intro_2,verse,chorus,outro)
end


# Drums

in_thread do

  use_synth :saw
  use_synth_defaults divisor: 1.6666, attack: 0.0, depth: 1500, sustain: 0.05, release: 0.0

  # Defin the indiivudal drums here
  kick = -> { sample :drum_bass_hard; sleep 0.25 }
  clap = -> { sample :drum_snare_hard; sleep 0.25 }
  cym  = -> { sample :drum_cymbal_soft; sleep 0.25 }
  r = -> { sleep 0.25 }

  # Define the sections
  intro = -> { sample :loop_amen, rate: 1.060; sleep 4 }

  intro_2 = -> { sleep 2 ; }

  verse = -> do

    in_thread(name: :kick) do
      
      4.times do 
        [kick,r,r,r, r,kick,kick,r, r,r,kick,r, r,r,r,r, r,r,kick,r, r,r,r,r, r,r,r,r, r,r,r,r, ].map(&:call)
        [kick,r,r,r, r,kick,kick,r, r,r,kick,r, r,r,r,r, r,r,kick,r, r,r,r,r, kick,r,kick,r, kick,kick,kick,kick, ].map(&:call)
      end

    end

    in_thread(name: :clap) do
      8.times { [r,r,r,r, r,r,r,r, clap,r,r,r, r,r,r,r, r,r,r,r, r,r,r,r, clap,r,r,r, r,r,r,r, ].map(&:call) }
    end

    in_thread(name: :cymbal) do
      4.times do
        [cym,r,r,r, cym,r,cym,cym, cym,r,r,r, cym,r,r,r, cym,r,r,r, cym,r,r,r, cym,r,r,r, cym,r,r,r, ].map(&:call)
        [cym,r,r,r, cym,r,r,r, cym,r,r,r, cym,r,r,r, cym,r,r,r, cym,r,r,r, cym,r,r,r, cym,r,cym,r, ].map(&:call)
      end
    end

  end

  chorus = -> do
    in_thread(name: :kick) do
      
      4.times do
        [kick,r,r,r, kick,r,r,r, kick,r,r,r, kick,r,r,r, kick,r,r,r, kick,r,r,r, kick,r,r,r, kick,r,r,r,  ].map(&:call)
      end
    end
  end

  outro = -> { sleep 8 }


  song(intro,intro_2,verse,chorus,outro)
end