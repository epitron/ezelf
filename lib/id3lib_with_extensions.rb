require 'id3lib'

module ID3Lib
    module Accessors

        # album_artist (:TPE2)
        #   - used by iTunes
        def album_artist()       frame_text(:TPE2) end
        def album_artist=(v) set_frame_text(:TPE2, v) end

        # composer (:TCOM)
        #   - used by EasyTag
        #   - used by Amarok
        def composer()       frame_text(:TCOM) end
        def composer=(v) set_frame_text(:TCOM, v) end

        # original_artist (:TOPE)
        #   - used by EasyTag
        def original_artist()       frame_text(:TOPE) end
        def original_artist=(v) set_frame_text(:TOPE, v) end

    end
end
