require 'os'
require 'paths' 

--file location on hdfs
hdfsOutFile = opt.HDFSoutput

--file location on local disk 
localOutFile = opt.outFile

--copy from local disk to hdfs
print('Transferring feature file from local disk to HDFS')
os.execute('hdfs dfs -copyFromLocal ' .. localOutFile .. ' ' .. hdfsOutFile)

--clean up, remove files (data, features)  on local disk
print('Removing feature, data, cache')
os.execute('rm -f ' .. opt.outFile)
os.execute('rm -f ' .. opt.data)
os.execute('rm -rf ' .. opt.cache)
