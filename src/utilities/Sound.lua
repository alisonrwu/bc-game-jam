Sound = {
  sources = {}
}

-- To-do:
--    Perhaps be called on every update to loop through unused sources and delete them for performance reasons (?)

-- Create and play a source.
function Sound:createAndPlay(source, tag, loop, soundType)
  Sound:create(source, tag, loop, soundType)
  Sound:play(tag)
end    

-- Create a source. If the tag already exists, the current source will be killed and overwritten.
-- @param source The filepath, File, Decoder or SoundData to the audio that you want to add.
-- @param tag The tag assigned to the audio.
-- @param loop Whether or not the audio will loop.
-- @param soundType The sound type you want to use. If left empty, static will be used by default.
function Sound:create(source, tag, loop, soundType)
  if soundType then
    src = love.audio.newSource(source, soundType) -- you should use "static" for sounds, and "stream" for bgm
  else
    src = love.audio.newSource(source, "static")
  end
  
  if loop then src:setLooping(loop) end
  
  if Sound.sources[tag] then
    Sound.sources[tag]:stop()
    Sound.sources[tag]:release()
  end
  
  Sound.sources[tag] = src
end    

-- Plays a source by its tag.
-- @param tag The tag assigned to the source.
function Sound:play(tag)
  if Sound.sources[tag] then
    Sound.sources[tag]:play()
  end
end  

-- Stops a source by its tag and cleans it up, freeing it from memory.
-- @param tag The tag assigned to the source.
function Sound:stop(tag)
  if Sound.sources[tag] then
    Sound.sources[tag]:stop()
  end
end  

-- Pauses a source by its tag.
-- @param tag The tag assigned to the source.
function Sound:pause(tag)
  if Sound.sources[tag] then
    Sound.sources[tag]:pause()
  end
end  

-- Sets a sources pitch by its tag.
-- @param tag The tag assigned to the source.
function Sound:setPitch(tag, pitch)
  if Sound.sources[tag] then
    Sound.sources[tag]:setPitch(pitch)
  end
end  


