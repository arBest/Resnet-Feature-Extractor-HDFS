--Copies dataset from hdfs to computron 
require 'os'
require 'paths'

--file location on hdfs 
hdfsInFile = opt.HDFSinput

--file location on local disk 
localInFile = opt.data

print('Transferring data from HDFS to local disk')

os.execute('hdfs dfs -cat ' .. hdfsInFile .. ' > ' .. localInFile)

