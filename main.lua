require 'torch'
require 'paths'
require 'xlua'
require 'nn'

--[[
	Generate resnet-101 features 
--]]

local opts = paths.dofile('opts.lua')

basedir = paths.cwd();

opt = opts.parse(arg)

torch.setdefaulttensortype('torch.FloatTensor')

if not paths.dirp(opt.cache) then
	os.execute('mkdir -p ' .. opt.cache)
end

paths.dofile('hdfsIn.lua') -- copy from hdfs to disk

paths.dofile('data.lua')
paths.dofile('resnet-model.lua')
paths.dofile('extract.lua')

--generate features 
extract()
print('Feature extraction completed')

--once the job is completed, then transfer to hdfs, clean up 
paths.dofile('hdfsOut.lua') 

print('Job done')

