require 'xlua'
require 'json'
require 'os'
require 'paths'

if not paths.filep(opt.outFile) then 
  os.execute('touch ' .. opt.outFile)
end 

--feature file on local disk 
file = io.open(opt.outFile,'w')

function extract()
   cutorch.synchronize()

   for i=1, nExtract/opt.batchSize do -- nExtract is set in data.lua
      collectgarbage()
      xlua.progress(i, nExtract/opt.batchSize)
      local indexStart = (i-1) * opt.batchSize + 1
      local indexEnd = (indexStart + opt.batchSize - 1)
      --#donkeys depends upon the number of threads
      --2 steps 
      --1) extractLoader-load images of gpuBatch size through #threads/donkeys specified by user
      --2) extractBatch-Take the above images from one thread at a time
      --called from data.lua
      donkeys:addjob(
         --function called from donkey.lua
         function()
            local inputs, ids = extractLoader:get(indexStart, indexEnd)
            return inputs, ids  --where inputs are tensors 
         end,
         -- callback that is run in the main thread once the work is done
         extractBatch
      )
   end

   donkeys:synchronize()
   cutorch.synchronize()

end 

local inputs = torch.CudaTensor()

function jsonStringFromCudaTensor(c)
  t = {}
  for i = 1,c:size(1) do
    t[i] = c[i]
  end
  return json.encode(t)
end

function extractBatch(inputsCPU, idsCPU)
   inputs:resize(inputsCPU:size()):copy(inputsCPU)

   local outputs = model:forward(inputs)

   collectgarbage()

   for i = 1,outputs:size(1) do
      local jsonString = jsonStringFromCudaTensor(outputs[i])
      local id = idsCPU[i]
      file:write(id.."\t"..jsonString.."\n")
      file:flush()
   end

   collectgarbage()
   cutorch.synchronize()
end
