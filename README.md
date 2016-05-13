# Resnet-Feature-Extractor
This is a complete pipeline (from HDFS to HDFS)




# Params desc[the order matters]:

./featureExtractor.sh 

/path/to/data/on/hdfs/paths/p*

/path/to/data/on/computron/local.tsv

/path/to/caches/for/faster/access/on/local/dir

/path/to/feature_vecs/on/computron/features.tsv

/path/to/final/destination/of/features.tsv

model [resnet-101]

number of GPUs

batch size (only go up till 500, for 8 Tesla k-80s)



# Help:

./featureExtractor.sh -help


# Example: 

./featureExtractor.sh 

/hdfs_data/shared/dataset/listing_image_paths_hdfs/paths/p* 

/base/dir/datasets/local_paths.tsv 

/base/dir/local_paths_cache

/base/dir/feature_vecs/feature_vec.tsv 

/hdfs_data/shared/image_features/feature_vec_hdfs.tsv

resnet-101 

8

100



#Adding new models

Please look at resnet-model.lua, and make the changes there by providing the {web location of the new model} and location you want it to be stored on your machine.



