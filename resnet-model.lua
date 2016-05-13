require 'nn'
require 'optim'
require 'cunn'
require 'cudnn'

resModel = opt.model

--dir for models
if not paths.dirp(basedir .. '/' .. 'weights') then 
  paths.mkdir(basedir .. '/' .. 'weights')
end

-- download a resnet model if not there 
if resModel == 'resnet-101' then
  if not paths.filep(basedir .. '/weights/' .. resModel .. '.t7') then 
    local resnet_model = 'http://torch7.s3-website-us-east-1.amazonaws.com/data/resnet-101.t7' 
    os.execute('wget --output-document ' .. basedir .. '/weights/resnet-101.t7 ' .. resnet_model)
  end

else error("unknown model, see if it is in the given options for model") end


function getPretrainedModel(nGPU)
  
  local res = paths.concat(basedir .. '/weights' .. '/' .. opt.model .. '.t7')
  
  local inputModel = torch.load(res)
  
  --remove the last layer 
  inputModel.modules[#inputModel.modules] = nil 

  local model = modelParallel(inputModel, nGPU)

  model:evaluate()
  
  return model
end

--make the model parallelizable
function modelParallel(net,nGPU)

  if nGPU > 1 then
    local gpus = torch.range(1,nGPU):totable()
    local fastest,benchmark = cudnn.fastest, cudnn.benchmark

    local dpt = nn.DataParallelTable(1, true, true)
        :add(net, gpus)
        :threads(function ()
          local cudnn = require 'cudnn'
          cudnn.fastest, cudnn.benchmark = fastest, benchmark
    end)
    dpt.gradInput = nil
 
    net = dpt:cuda()

  end

  return net
end

model = getPretrainedModel(opt.nGPU)

model:cuda()

collectgarbage()
