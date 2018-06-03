SoundManager = {
  sources = {}
}

-- To-do:
--    Perhaps be called on every update to loop through unused sources and delete them for performance reasons (?)

-- Create and play a source.
function SoundManager:createAndPlay(source, tag, loop, soundType)
  SoundManager:create(source, tag, loop, soundType)
  SoundManager:play(tag)
end    

-- Create a source. If the tag already exists, the current source will be killed and overwritten.
-- @param source The filepath, File, Decoder or SoundData to the audio that you want to add.
-- @param tag The tag assigned to the audio.
-- @param loop Whether or not the audio will loop.
-- @param soundType The sound type you want to use. If left empty, static will be used by default.
function SoundManager:create(source, tag, loop, soundType)
  if soundType then
    src = love.audio.newSource(source, soundType) -- you should use "static" for sounds, and "stream" for bgm
  else
    src = love.audio.newSource(source, "static")
  end
  
  if loop then src:setLooping(loop) end
  
  if SoundManager.sources[tag] then
    SoundManager.sources[tag]:stop()
    SoundManager.sources[tag]:release()
  end
  
  SoundManager.sources[tag] = src
end    

-- Plays a source by its tag.
-- @param tag The tag assigned to the source.
function SoundManager:play(tag)
  if SoundManager.sources[tag] then
    SoundManager.sources[tag]:play()
  end
end  

-- Stops a source by its tag and cleans it up, freeing it from memory.
-- @param tag The tag assigned to the source.
function SoundManager:stop(tag)
  if SoundManager.sources[tag] then
    SoundManager.sources[tag]:stop()
  end
end  

-- Pauses a source by its tag.
-- @param tag The tag assigned to the source.
function SoundManager:pause(tag)
  if SoundManager.sources[tag] then
    SoundManager.sources[tag]:pause()
  end
end  

-- Sets a sources pitch by its tag.
-- @param tag The tag assigned to the source.
function SoundManager:setPitch(tag, pitch)
  if SoundManager.sources[tag] then
    SoundManager.sources[tag]:setPitch(pitch)
  end
end  


