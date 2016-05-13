local M = { }

function M.parse(arg)

    local basedir = paths.cwd()
    
    local cmd = torch.CmdLine()
    cmd:text()
    cmd:text('Extract resnet-101 Features')
    cmd:text()
    cmd:text('Options:')
    ------------ General options --------------------
    cmd:option('-HDFSinput',
               '/data/shared/image_info/listing_image_paths/shoes_single/paths/p*','File of tab separated "image_id path_to_image_on_hdfs" ') 
    
    cmd:option('-data',
               '/home/arajanna/resnet-101-feature-extractor/datasets/shoes.tsv','File of tab separated "image_id path_to_image_on_disk"')
    cmd:option('-backend',     'cudnn', 'Options: cudnn | cunn')
    --cmd:option('-cache', basedir ..  '/caches/' .. 'shoes' ,'caching image metadata')
    cmd:option('-cache', '/home/arajanna/resnet-101-feature-extractor/shoes' ,'caching image metadata')
    cmd:option('-manualSeed',    4, 'Manually set RNG seed')
    cmd:option('-outFile',   '/home/arajanna/resnet-101-feature-extractor/feature_vecs/shoesTest.tsv', 'File to write (image_id \t json encoded vgg feature vector) on disk')
    
    cmd:option('-HDFSoutput',   '/data/shared/image_features/shoesTest.tsv', 'File to write (image_id \t json encoded vgg feature vector) on hdfs')
 
    ------------- GPU settings -----------------------
    cmd:option('-GPU',     1, 'Default gpu')
    cmd:option('-nGPU',    8, 'number of gpus')

    ------------- Data options ------------------------
    cmd:option('-model',       'resnet-101',   'resnet architcture')
    cmd:option('-batchSize',        500, 'number of data loading threads to initialize')
    cmd:option('-nThreads',        20, 'number of data loading threads to initialize')
    cmd:text()

 
    local opt = cmd:parse(arg or {})
    return opt
end

return M
