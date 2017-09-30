SoundManager = {
  musicTag = ""
}
        
-- Plays music by looping it and preventing it from playing once every frame.
-- @param music The path to the music that you want to play.
-- @param tag The tag assigned to the music.
function SoundManager:playMusic(music, tag)
    if tag ~= SoundManager.musicTag then
        SoundManager:stopSound(SoundManager.musicTag)
        TEsound.playLooping(music, tag)
        SoundManager.musicTag = tag
    end 
end

-- Stops a sound and cleans it up, freeing it from memory.
-- @param tag The tag assigned to the sound.
function SoundManager:stopSound(tag)
    TEsound.stop(tag)
    TEsound.cleanup(tag)
end    


