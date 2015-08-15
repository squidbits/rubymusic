#########       #
#       #
#  uno  #   #
#       #
#################
        #       #
    #   #  oun  #
        #       #
#       #########

#use_debug false
use_synth :tb303
use_bpm 128

define :song do |intro, verse, chorus, outro|
  intro.call
  4.times { verse.call }
  chorus.call
  4.times { verse.call }
  outro.call
end

# Main Synth

in_thread do
  use_synth :supersaw
  use_synth_defaults amp: 0.4, cutoff: 80

  intro = -> {
    4.times { play_pattern_timed([:e5,:r,:e5,:r, :r,:r,:e5,:r ], [0.25]) }
  }

  verse = -> {
    4.times { play_pattern_timed([:e5,:b4,:e5,:b4, :r,:r,:r,:r, ], [0.25]) }
    2.times { play_pattern_timed([:e5,:b4,:e5,:b4, :r,:r,:e5,:r ], [0.25]) }
    2.times { play_pattern_timed([:e5,:b5,:e5,:b5, :e5,:b5,:e5,:b5 ], [0.25]) }
  }

  solo = -> {
    4.times { play_pattern_timed([:e5,:es5,:e5,:es5, :e5,:es5,:e5,:es5], [0.25]) }
    2.times { play_pattern_timed([:e5,:g5,:e5,:g5, :e5,:g5,:e5,:g5 ], [0.25]) }
    2.times { play_pattern_timed([:e5,:b5,:e5,:b5, :e5,:b5,:e5,:b5 ], [0.25]) }
  }

  chorus = -> {
    2.times do
      play_chord([ :d5, :a4, :d4 ]); sleep 4
    end
    2.times do
      play_chord([ :e4, :b5, :e5 ]); sleep 4
    end
  }

  outro = -> {
    4.times { play_pattern_timed([:e5,:r,:e5,:r, :r,:r,:e5,:r ], [0.25]) }
  }

  with_fx :distortion, distort: 0.92, mix: 0.7, amp: 0.4, bits: 2  do
    with_fx :echo, phase: 0.75 do
      song(intro,verse,chorus,outro)
    end
  end
end

# Rythym Synth

in_thread do
  use_synth :tri
  use_synth_defaults

  intro = -> { sleep 8 }

  verse = -> {
    play chord_degree( :i, :e4, :major ); sleep 4
    play chord_degree( :i, :e4, :minor ); sleep 4
    play chord_degree( :i, :a4, :minor ); sleep 4
    play chord_degree( :i, :b4, :minor ); sleep 4
  }

  chorus = -> {
    4.times do
      sleep 8
    end
  }

  outro = -> { sleep 8 }

  with_fx :reverb do
    song(intro,verse,chorus,outro)
  end
end

# Bass
in_thread do
  use_synth :subpulse

  intro = -> { sleep 8 }

  verse = -> {
    4.times do
      play_pattern_timed([:r,:e2,:r,:e2,:r,:e2,:r,:e2], [0.25])
    end
    2.times do
      play_pattern_timed([:r,:a2,:r,:a2,:r,:a2,:r,:a2], [0.25])
    end
    2.times do
      play_pattern_timed([:r,:b2,:r,:b2,:r,:b2,:r,:b2], [0.25])
    end
  }

  chorus = -> {
    4.times do
      play_pattern_timed([:d2,:r,:r,:r,:d2,:r,:r,:r], [0.25])
    end

    4.times do
      play_pattern_timed([:e3,:r,:r,:r,:e3,:r,:r,:r], [0.25])
    end
  }

  outro = -> { sleep 8 }

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

  intro = -> { sleep 4; [l,s,l,ll,l,s,l,ll].map(&:call) }

  verse = -> { [l,s,l,ll,l,s,l,ll].map(&:call) }

  chorus = -> { 4.times { sample :loop_amen, rate: 0.94; sleep 4 } }

  outro = -> { sleep 8 }


  song(intro,verse,chorus,outro)
end
